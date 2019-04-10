{ config, lib, pkgs, ... }:


let

  inherit (lib) mkIf mkMerge;
  inherit (lib) concatStringsSep optionalString;

  cfg = config.services.hylafax;
  mapModems = lib.flip map (lib.attrValues cfg.modems);

  mkConfigFile = name: conf:
    # creates hylafax config file,
    # makes sure "Include" is listed *first*
    let
      mkLines = conf:
        (lib.concatLists
        (lib.flip lib.mapAttrsToList conf
        (k: map (v: ''${k}: ${v}'')
      )));
      include = mkLines { Include = conf.Include or []; };
      other = mkLines ( conf // { Include = []; } );
    in
      pkgs.writeText ''hylafax-config${name}''
      (concatStringsSep "\n" (include ++ other));

  globalConfigPath = mkConfigFile "" cfg.faxqConfig;

  modemConfigPath =
    let
      mkModemConfigFile = { config, name, ... }:
        mkConfigFile ''.${name}''
        (cfg.commonModemConfig // config);
      mkLine = { name, type, ... }@modem: ''
        # check if modem config file exists:
        test -f "${pkgs.hylafaxplus}/spool/config/${type}"
        ln \
          --symbolic \
          --no-target-directory \
          "${mkModemConfigFile modem}" \
          "$out/config.${name}"
      '';
    in
      pkgs.runCommand "hylafax-config-modems" { preferLocalBuild = true; }
      ''mkdir --parents "$out/" ${concatStringsSep "\n" (mapModems mkLine)}'';

  setupSpoolScript = pkgs.substituteAll {
    name = "hylafax-setup-spool.sh";
    src = ./spool.sh;
    isExecutable = true;
    inherit (pkgs.stdenv) shell;
    hylafax = pkgs.hylafaxplus;
    faxuser = "uucp";
    faxgroup = "uucp";
    lockPath = "/var/lock";
    inherit globalConfigPath modemConfigPath;
    inherit (cfg) sendmailPath spoolAreaPath userAccessFile;
  };

  waitFaxqScript = pkgs.substituteAll {
    # This script checks the modems status files
    # and waits until all modems report readiness.
    name = "hylafax-faxq-wait-start.sh";
    src = ./faxq-wait.sh;
    isExecutable = true;
    timeoutSec = toString 10;
    inherit (pkgs.stdenv) shell;
    inherit (cfg) spoolAreaPath;
  };

  sockets."hylafax-hfaxd" = {
    description = "HylaFAX server socket";
    documentation = [ "man:hfaxd(8)" ];
    wantedBy = [ "multi-user.target" ];
    listenStreams = [ "127.0.0.1:4559" ];
    socketConfig.FreeBind = true;
    socketConfig.Accept = true;
  };

  paths."hylafax-faxq" = {
    description = "HylaFAX queue manager sendq watch";
    documentation = [ "man:faxq(8)" "man:sendq(5)" ];
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathExistsGlob = [ ''${cfg.spoolAreaPath}/sendq/q*'' ];
  };

  timers = mkMerge [
    (
      mkIf (cfg.faxcron.enable.frequency!=null)
      { "hylafax-faxcron".timerConfig.Persistent = true; }
    )
    (
      mkIf (cfg.faxqclean.enable.frequency!=null)
      { "hylafax-faxqclean".timerConfig.Persistent = true; }
    )
  ];

  hardenService =
    # Add some common systemd service hardening settings,
    # but allow each service (here) to override
    # settings by explicitely setting those to `null`.
    # More hardening would be nice but makes
    # customizing hylafax setups very difficult.
    # If at all, it should only be added along
    # with some options to customize it.
    let
      hardening = {
        PrivateDevices = true;  # breaks /dev/tty...
        PrivateNetwork = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        #ProtectHome = true;  # breaks custom spool dirs
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        #ProtectSystem = "strict";  # breaks custom spool dirs
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
      filter = key: value: (value != null) || ! (lib.hasAttr key hardening);
      apply = service: lib.filterAttrs filter (hardening // (service.serviceConfig or {}));
    in
      service: service // { serviceConfig = apply service; };

  services."hylafax-spool" = {
    description = "HylaFAX spool area preparation";
    documentation = [ "man:hylafax-server(4)" ];
    script = ''
      ${setupSpoolScript}
      cd "${cfg.spoolAreaPath}"
      ${cfg.spoolExtraInit}
      if ! test -f "${cfg.spoolAreaPath}/etc/hosts.hfaxd"
      then
        echo hosts.hfaxd is missing
        exit 1
      fi
    '';
    serviceConfig.ExecStop = ''${setupSpoolScript}'';
    serviceConfig.RemainAfterExit = true;
    serviceConfig.Type = "oneshot";
    unitConfig.RequiresMountsFor = [ cfg.spoolAreaPath ];
  };

  services."hylafax-faxq" = {
    description = "HylaFAX queue manager";
    documentation = [ "man:faxq(8)" ];
    requires = [ "hylafax-spool.service" ];
    after = [ "hylafax-spool.service" ];
    wants = mapModems ( { name, ... }: ''hylafax-faxgetty@${name}.service'' );
    wantedBy = mkIf cfg.autostart [ "multi-user.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.ExecStart = ''${pkgs.hylafaxplus}/spool/bin/faxq -q "${cfg.spoolAreaPath}"'';
    # This delays the "readiness" of this service until
    # all modems are initialized (or a timeout is reached).
    # Otherwise, sending a fax with the fax service
    # stopped will always yield a failed send attempt:
    # The fax service is started when the job is created with
    # `sendfax`, but modems need some time to initialize.
    serviceConfig.ExecStartPost = [ ''${waitFaxqScript}'' ];
    # faxquit fails if the pipe is already gone
    # (e.g. the service is already stopping)
    serviceConfig.ExecStop = ''-${pkgs.hylafaxplus}/spool/bin/faxquit -q "${cfg.spoolAreaPath}"'';
    # disable some systemd hardening settings
    serviceConfig.PrivateDevices = null;
    serviceConfig.RestrictRealtime = null;
  };

  services."hylafax-hfaxd@" = {
    description = "HylaFAX server";
    documentation = [ "man:hfaxd(8)" ];
    after = [ "hylafax-faxq.service" ];
    requires = [ "hylafax-faxq.service" ];
    serviceConfig.StandardInput = "socket";
    serviceConfig.StandardOutput = "socket";
    serviceConfig.ExecStart = ''${pkgs.hylafaxplus}/spool/bin/hfaxd -q "${cfg.spoolAreaPath}" -d -I'';
    unitConfig.RequiresMountsFor = [ cfg.userAccessFile ];
    # disable some systemd hardening settings
    serviceConfig.PrivateDevices = null;
    serviceConfig.PrivateNetwork = null;
  };

  services."hylafax-faxcron" = rec {
    description = "HylaFAX spool area maintenance";
    documentation = [ "man:faxcron(8)" ];
    after = [ "hylafax-spool.service" ];
    requires = [ "hylafax-spool.service" ];
    wantedBy = mkIf cfg.faxcron.enable.spoolInit requires;
    startAt = mkIf (cfg.faxcron.enable.frequency!=null) cfg.faxcron.enable.frequency;
    serviceConfig.ExecStart = concatStringsSep " " [
      ''${pkgs.hylafaxplus}/spool/bin/faxcron''
      ''-q "${cfg.spoolAreaPath}"''
      ''-info ${toString cfg.faxcron.infoDays}''
      ''-log  ${toString cfg.faxcron.logDays}''
      ''-rcv  ${toString cfg.faxcron.rcvDays}''
    ];
  };

  services."hylafax-faxqclean" = rec {
    description = "HylaFAX spool area queue cleaner";
    documentation = [ "man:faxqclean(8)" ];
    after = [ "hylafax-spool.service" ];
    requires = [ "hylafax-spool.service" ];
    wantedBy = mkIf cfg.faxqclean.enable.spoolInit requires;
    startAt = mkIf (cfg.faxqclean.enable.frequency!=null) cfg.faxqclean.enable.frequency;
    serviceConfig.ExecStart = concatStringsSep " " [
      ''${pkgs.hylafaxplus}/spool/bin/faxqclean''
      ''-q "${cfg.spoolAreaPath}"''
      ''-v''
      (optionalString (cfg.faxqclean.archiving!="never") ''-a'')
      (optionalString (cfg.faxqclean.archiving=="always")  ''-A'')
      ''-j ${toString (cfg.faxqclean.doneqMinutes*60)}''
      ''-d ${toString (cfg.faxqclean.docqMinutes*60)}''
    ];
  };

  mkFaxgettyService = { name, ... }:
    lib.nameValuePair ''hylafax-faxgetty@${name}'' rec {
      description = "HylaFAX faxgetty for %I";
      documentation = [ "man:faxgetty(8)" ];
      bindsTo = [ "dev-%i.device" ];
      requires = [ "hylafax-spool.service" ];
      after = bindsTo ++ requires;
      before = [ "hylafax-faxq.service" "getty.target" ];
      unitConfig.StopWhenUnneeded = true;
      unitConfig.AssertFileNotEmpty = ''${cfg.spoolAreaPath}/etc/config.%I'';
      serviceConfig.UtmpIdentifier = "%I";
      serviceConfig.TTYPath = "/dev/%I";
      serviceConfig.Restart = "always";
      serviceConfig.KillMode = "process";
      serviceConfig.IgnoreSIGPIPE = false;
      serviceConfig.ExecStart = ''-${pkgs.hylafaxplus}/spool/bin/faxgetty -q "${cfg.spoolAreaPath}" /dev/%I'';
      # faxquit fails if the pipe is already gone
      # (e.g. the service is already stopping)
      serviceConfig.ExecStop = ''-${pkgs.hylafaxplus}/spool/bin/faxquit -q "${cfg.spoolAreaPath}" %I'';
      # disable some systemd hardening settings
      serviceConfig.PrivateDevices = null;
      serviceConfig.RestrictRealtime = null;
    };

  modemServices =
    lib.listToAttrs (mapModems mkFaxgettyService);

in

{
  config.systemd = mkIf cfg.enable {
    inherit sockets timers paths;
    services = lib.mapAttrs (lib.const hardenService) (services // modemServices);
  };
}
