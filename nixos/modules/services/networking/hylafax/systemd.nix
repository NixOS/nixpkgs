{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (lib)
    concatLines
    escapeShellArgs
    mkIf
    mkMerge
    optional
    ;
  inherit (lib.cli) toCommandLine;

  optionFormat = optionName: {
    option = "-${optionName}";
    sep = null;
    explicitBool = false;
  };

  cfg = config.services.hylafax;
  mapModems = lib.forEach (lib.attrValues cfg.modems);

  mkSpoolCmd =
    prefix: program: posArg: options:
    let
      start = "${prefix}${cfg.package}/spool/bin/${program}";
      optionsList = toCommandLine optionFormat ({ q = cfg.spoolAreaPath; } // options);
      posArgList = optional (posArg != null) posArg;
    in
    "${start} ${escapeShellArgs (optionsList ++ posArgList)}";

  mkConfigFile =
    name: conf:
    # creates hylafax config file,
    # makes sure "Include" is listed *first*
    let
      mkLines = lib.flip lib.pipe [
        (lib.mapAttrsToList (key: map (val: "${key}: ${val}")))
        lib.concatLists
      ];
      include = mkLines { Include = conf.Include or [ ]; };
      other = mkLines (conf // { Include = [ ]; });
    in
    pkgs.writeText "hylafax-config${name}" (concatLines (include ++ other));

  globalConfigPath = mkConfigFile "" cfg.faxqConfig;

  modemConfigPath =
    let
      mkModemConfigFile =
        { config, name, ... }: mkConfigFile ".${name}" (cfg.commonModemConfig // config);
      mkLine =
        { name, type, ... }@modem:
        ''
          # check if modem config file exists:
          test -f "${cfg.package}/spool/config/${type}"
          ln \
            --symbolic \
            --no-target-directory \
            "${mkModemConfigFile modem}" \
            "$out/config.${name}"
        '';
    in
    pkgs.runCommand "hylafax-config-modems" { }
      ''mkdir --parents "$out/" ${concatLines (mapModems mkLine)}'';

  setupSpoolScript = pkgs.replaceVarsWith {
    name = "hylafax-setup-spool.sh";
    src = ./spool.sh;
    isExecutable = true;
    replacements = {
      faxuser = "uucp";
      faxgroup = "uucp";
      lockPath = "/var/lock";
      inherit globalConfigPath modemConfigPath;
      inherit (cfg) package spoolAreaPath userAccessFile;
      inherit (pkgs) runtimeShell;
    };
  };

  waitFaxqScript = pkgs.replaceVarsWith {
    # This script checks the modems status files
    # and waits until all modems report readiness.
    name = "hylafax-faxq-wait-start.sh";
    src = ./faxq-wait.sh;
    isExecutable = true;
    replacements = {
      timeoutSec = toString 10;
      inherit (cfg) spoolAreaPath;
      inherit (pkgs) runtimeShell;
    };
  };

  sockets.hylafax-hfaxd = {
    description = "HylaFAX server socket";
    documentation = [ "man:hfaxd(8)" ];
    wantedBy = [ "multi-user.target" ];
    listenStreams = [ "127.0.0.1:4559" ];
    socketConfig.FreeBind = true;
    socketConfig.Accept = true;
  };

  paths.hylafax-faxq = {
    description = "HylaFAX queue manager sendq watch";
    documentation = [
      "man:faxq(8)"
      "man:sendq(5)"
    ];
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathExistsGlob = [ "${cfg.spoolAreaPath}/sendq/q*" ];
  };

  timers = mkMerge [
    (mkIf (cfg.faxcron.enable.frequency != null) { hylafax-faxcron.timerConfig.Persistent = true; })
    (mkIf (cfg.faxqclean.enable.frequency != null) { hylafax-faxqclean.timerConfig.Persistent = true; })
  ];

  hardenService =
    # Add some common systemd service hardening settings,
    # but allow each service (here) to override
    # settings by explicitly setting those to `null`.
    # More hardening would be nice but makes
    # customizing hylafax setups very difficult.
    # If at all, it should only be added along
    # with some options to customize it.
    let
      hardening = {
        PrivateDevices = true; # breaks /dev/tty...
        PrivateNetwork = true;
        PrivateTmp = true;
        #ProtectClock = true;  # breaks /dev/tty... (why?)
        ProtectControlGroups = true;
        #ProtectHome = true;  # breaks custom spool dirs
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        #ProtectSystem = "strict";  # breaks custom spool dirs
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
      filter = key: value: (value != null) || !(lib.hasAttr key hardening);
      apply = service: lib.filterAttrs filter (hardening // (service.serviceConfig or { }));
    in
    service: service // { serviceConfig = apply service; };

  services.hylafax-spool = {
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
    serviceConfig.ExecStop = "${setupSpoolScript}";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.Type = "oneshot";
    unitConfig.RequiresMountsFor = [ cfg.spoolAreaPath ];
  };

  services.hylafax-faxq = {
    description = "HylaFAX queue manager";
    documentation = [ "man:faxq(8)" ];
    requires = [ "hylafax-spool.service" ];
    after = [ "hylafax-spool.service" ];
    wants = mapModems ({ name, ... }: "hylafax-faxgetty@${name}.service");
    wantedBy = mkIf cfg.autostart [ "multi-user.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.ExecStart = mkSpoolCmd "" "faxq" null { };
    # This delays the "readiness" of this service until
    # all modems are initialized (or a timeout is reached).
    # Otherwise, sending a fax with the fax service
    # stopped will always yield a failed send attempt:
    # The fax service is started when the job is created with
    # `sendfax`, but modems need some time to initialize.
    serviceConfig.ExecStartPost = [ "${waitFaxqScript}" ];
    # faxquit fails if the pipe is already gone
    # (e.g. the service is already stopping)
    serviceConfig.ExecStop = mkSpoolCmd "-" "faxquit" null { };
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
    serviceConfig.ExecStart = mkSpoolCmd "" "hfaxd" null {
      d = true;
      I = true;
    };
    unitConfig.RequiresMountsFor = [ cfg.userAccessFile ];
    # disable some systemd hardening settings
    serviceConfig.PrivateDevices = null;
    serviceConfig.PrivateNetwork = null;
  };

  services.hylafax-faxcron = rec {
    description = "HylaFAX spool area maintenance";
    documentation = [ "man:faxcron(8)" ];
    after = [ "hylafax-spool.service" ];
    requires = [ "hylafax-spool.service" ];
    wantedBy = mkIf cfg.faxcron.enable.spoolInit requires;
    startAt = mkIf (cfg.faxcron.enable.frequency != null) cfg.faxcron.enable.frequency;
    serviceConfig.ExecStart = mkSpoolCmd "" "faxcron" null {
      info = cfg.faxcron.infoDays;
      log = cfg.faxcron.logDays;
      rcv = cfg.faxcron.rcvDays;
    };
  };

  services.hylafax-faxqclean = rec {
    description = "HylaFAX spool area queue cleaner";
    documentation = [ "man:faxqclean(8)" ];
    after = [ "hylafax-spool.service" ];
    requires = [ "hylafax-spool.service" ];
    wantedBy = mkIf cfg.faxqclean.enable.spoolInit requires;
    startAt = mkIf (cfg.faxqclean.enable.frequency != null) cfg.faxqclean.enable.frequency;
    serviceConfig.ExecStart = mkSpoolCmd "" "faxqclean" null {
      v = true;
      a = cfg.faxqclean.archiving != "never";
      A = cfg.faxqclean.archiving == "always";
      j = 60 * cfg.faxqclean.doneqMinutes;
      d = 60 * cfg.faxqclean.docqMinutes;
    };
  };

  mkFaxgettyService =
    { name, ... }:
    lib.nameValuePair "hylafax-faxgetty@${name}" rec {
      description = "HylaFAX faxgetty for %I";
      documentation = [ "man:faxgetty(8)" ];
      bindsTo = [ "dev-%i.device" ];
      requires = [ "hylafax-spool.service" ];
      after = bindsTo ++ requires;
      before = [
        "hylafax-faxq.service"
        "getty.target"
      ];
      unitConfig.StopWhenUnneeded = true;
      unitConfig.AssertFileNotEmpty = "${cfg.spoolAreaPath}/etc/config.%I";
      serviceConfig.UtmpIdentifier = "%I";
      serviceConfig.TTYPath = "/dev/%I";
      serviceConfig.Restart = "always";
      serviceConfig.KillMode = "process";
      serviceConfig.IgnoreSIGPIPE = false;
      serviceConfig.ExecStart = mkSpoolCmd "-" "faxgetty" "/dev/%I" { };
      # faxquit fails if the pipe is already gone
      # (e.g. the service is already stopping)
      serviceConfig.ExecStop = mkSpoolCmd "-" "faxquit" "%I" { };
      # disable some systemd hardening settings
      serviceConfig.PrivateDevices = null;
      serviceConfig.RestrictRealtime = null;
    };

  modemServices = lib.listToAttrs (mapModems mkFaxgettyService);

in

{
  config.systemd = mkIf cfg.enable {
    inherit sockets timers paths;
    services = lib.mapAttrs (lib.const hardenService) (services // modemServices);
  };
}
