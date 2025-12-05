{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inherit (pkgs)
    cups-pk-helper
    libcupsfilters
    cups-filters
    xdg-utils
    ;

  cfg = config.services.printing;
  cups = cfg.package;

  polkitEnabled = config.security.polkit.enable;

  additionalBackends =
    pkgs.runCommand "additional-cups-backends"
      {
        preferLocalBuild = true;
      }
      ''
        mkdir -p $out
        if [ ! -e ${cups.out}/lib/cups/backend/smb ]; then
          mkdir -p $out/lib/cups/backend
          ln -sv ${pkgs.samba}/bin/smbspool $out/lib/cups/backend/smb
        fi

        # Provide support for printing via HTTPS.
        if [ ! -e ${cups.out}/lib/cups/backend/https ]; then
          mkdir -p $out/lib/cups/backend
          ln -sv ${cups.out}/lib/cups/backend/ipp $out/lib/cups/backend/https
        fi
      '';

  # Here we can enable additional backends, filters, etc. that are not
  # part of CUPS itself, e.g. the SMB backend is part of Samba.  Since
  # we can't update ${cups.out}/lib/cups itself, we create a symlink tree
  # here and add the additional programs.  The ServerBin directive in
  # cups-files.conf tells cupsd to use this tree.
  bindir = pkgs.buildEnv {
    name = "cups-progs";
    paths = [
      cups.out
      additionalBackends
      libcupsfilters
      cups-filters
      pkgs.ghostscript
    ]
    ++ lib.optional cfg.browsed.enable cfg.browsed.package
    ++ cfg.drivers;
    pathsToLink = [
      "/lib"
      "/share/cups"
      "/bin"
    ];
    postBuild = cfg.bindirCmds;
    ignoreCollisions = true;
  };

  writeConf =
    name: text:
    pkgs.writeTextFile {
      inherit name text;
      destination = "/etc/cups/${name}";
    };

  cupsFilesFile = writeConf "cups-files.conf" ''
    SystemGroup root wheel lpadmin

    ServerBin ${bindir}/lib/cups
    DataDir ${bindir}/share/cups
    DocumentRoot ${cups.out}/share/doc/cups

    AccessLog syslog
    ErrorLog syslog
    PageLog syslog

    TempDir ${cfg.tempDir}

    SetEnv PATH /var/lib/cups/path/lib/cups/filter:/var/lib/cups/path/bin

    # User and group used to run external programs, including
    # those that actually send the job to the printer.  Note that
    # Udev sets the group of printer devices to `lp', so we want
    # these programs to run as `lp' as well.
    User cups
    Group lp

    ${cfg.extraFilesConf}
  '';

  cupsdFile = writeConf "cupsd.conf" ''
    ${concatMapStrings (addr: ''
      Listen ${addr}
    '') cfg.listenAddresses}
    Listen /run/cups/cups.sock

    DefaultShared ${if cfg.defaultShared then "Yes" else "No"}

    Browsing ${if cfg.browsing then "Yes" else "No"}

    WebInterface ${if cfg.webInterface then "Yes" else "No"}

    LogLevel ${cfg.logLevel}

    ${cfg.extraConf}
  '';

  browsedFile = writeConf "cups-browsed.conf" cfg.browsedConf;

  rootdir = pkgs.buildEnv {
    name = "cups-progs";
    paths = [
      cupsFilesFile
      cupsdFile
      (writeConf "client.conf" cfg.clientConf)
      (writeConf "snmp.conf" cfg.snmpConf)
    ]
    ++ optional cfg.browsed.enable browsedFile
    ++ cfg.drivers;
    pathsToLink = [ "/etc/cups" ];
    ignoreCollisions = true;
  };

  filterGutenprint = filter (pkg: pkg.meta.isGutenprint or false == true);
  containsGutenprint = pkgs: length (filterGutenprint pkgs) > 0;
  getGutenprint = pkgs: head (filterGutenprint pkgs);

  parsePorts =
    addresses:
    let
      splitAddress = addr: strings.splitString ":" addr;
      extractPort = addr: builtins.foldl' (a: b: b) "" (splitAddress addr);
    in
    builtins.map (address: strings.toInt (extractPort address)) addresses;

in

{

  imports = [
    (mkChangedOptionModule [ "services" "printing" "gutenprint" ] [ "services" "printing" "drivers" ] (
      config:
      let
        enabled = getAttrFromPath [ "services" "printing" "gutenprint" ] config;
      in
      if enabled then [ pkgs.gutenprint ] else [ ]
    ))
    (mkRemovedOptionModule [ "services" "printing" "cupsFilesConf" ] "")
    (mkRemovedOptionModule [ "services" "printing" "cupsdConf" ] "")
  ];

  ###### interface

  options = {
    services.printing = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable printing support through the CUPS daemon.
        '';
      };

      package = lib.mkPackageOption pkgs "cups" { };

      stateless = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, all state directories relating to CUPS will be removed on
          startup of the service.
        '';
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set, CUPS is socket-activated; that is,
          instead of having it permanently running as a daemon,
          systemd will start it on the first incoming connection.
        '';
      };

      listenAddresses = mkOption {
        type = types.listOf types.str;
        default = [ "localhost:631" ];
        example = [ "*:631" ];
        description = ''
          A list of addresses and ports on which to listen.
        '';
      };

      allowFrom = mkOption {
        type = types.listOf types.str;
        default = [ "localhost" ];
        example = [ "all" ];
        apply = concatMapStringsSep "\n" (x: "Allow ${x}");
        description = ''
          From which hosts to allow unconditional access.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for TCP ports specified in
          listenAddresses option.
        '';
      };

      bindirCmds = mkOption {
        type = types.lines;
        internal = true;
        default = "";
        description = ''
          Additional commands executed while creating the directory
          containing the CUPS server binaries.
        '';
      };

      defaultShared = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Specifies whether local printers are shared by default.
        '';
      };

      browsing = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Specifies whether shared printers are advertised.
        '';
      };

      webInterface = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Specifies whether the web interface is enabled.
        '';
      };

      logLevel = mkOption {
        type = types.str;
        default = "info";
        example = "debug";
        description = ''
          Specifies the cupsd logging verbosity.
        '';
      };

      extraFilesConf = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra contents of the configuration file of the CUPS daemon
          ({file}`cups-files.conf`).
        '';
      };

      extraConf = mkOption {
        type = types.lines;
        default = "";
        example = ''
          BrowsePoll cups.example.com
          MaxCopies 42
        '';
        description = ''
          Extra contents of the configuration file of the CUPS daemon
          ({file}`cupsd.conf`).
        '';
      };

      clientConf = mkOption {
        type = types.lines;
        default = "";
        example = ''
          ServerName server.example.com
          Encryption Never
        '';
        description = ''
          The contents of the client configuration.
          ({file}`client.conf`)
        '';
      };

      browsed.enable = mkOption {
        type = types.bool;
        default = config.services.avahi.enable;
        defaultText = literalExpression "config.services.avahi.enable";
        description = ''
          Whether to enable the CUPS Remote Printer Discovery (browsed) daemon.
        '';
      };

      browsed.package = lib.mkPackageOption pkgs "cups-browsed" { };

      browsedConf = mkOption {
        type = types.lines;
        default = "";
        example = ''
          BrowsePoll cups.example.com
        '';
        description = ''
          The contents of the configuration. file of the CUPS Browsed daemon
          ({file}`cups-browsed.conf`)
        '';
      };

      snmpConf = mkOption {
        type = types.lines;
        default = ''
          Address @LOCAL
        '';
        description = ''
          The contents of {file}`/etc/cups/snmp.conf`. See "man
          cups-snmp.conf" for a complete description.
        '';
      };

      drivers = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExpression "with pkgs; [ gutenprint hplip splix ]";
        description = ''
          CUPS drivers to use. Drivers provided by CUPS, cups-filters,
          Ghostscript and Samba are added unconditionally. If this list contains
          Gutenprint (i.e. a derivation with
          `meta.isGutenprint = true`) the PPD files in
          {file}`/var/lib/cups/ppd` will be updated automatically
          to avoid errors due to incompatible versions.
        '';
      };

      tempDir = mkOption {
        type = types.path;
        default = "/tmp";
        example = "/tmp/cups";
        description = ''
          CUPSd temporary directory.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf config.services.printing.enable {

    users = {
      users.cups = {
        uid = config.ids.uids.cups;
        group = "lp";
        description = "CUPS printing services";
      };

      # It seems that groups provided for `SystemGroup` must exist
      groups.lpadmin = { };
    };

    # We need xdg-open (part of xdg-utils) for the desktop-file to proper open the users default-browser when opening "Manage Printing"
    # https://github.com/NixOS/nixpkgs/pull/237994#issuecomment-1597510969
    environment.systemPackages = [
      cups.out
      xdg-utils
    ]
    ++ optional polkitEnabled cups-pk-helper;
    environment.etc.cups.source = "/var/lib/cups";

    services.dbus.packages = [ cups.out ] ++ optional polkitEnabled cups-pk-helper;
    services.udev.packages = cfg.drivers;

    # Allow passwordless printer admin for members of wheel group
    security.polkit.extraConfig = mkIf polkitEnabled ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.opensuse.cupspkhelper.mechanism.all-edit" &&
              subject.isInGroup("wheel")){
              return polkit.Result.YES;
          }
      });
    '';

    # Cups uses libusb to talk to printers, and does not use the
    # linux kernel driver. If the driver is not in a black list, it
    # gets loaded, and then cups cannot access the printers.
    boot.blacklistedKernelModules = [ "usblp" ];

    # Some programs like print-manager rely on this value to get
    # printer test pages.
    environment.sessionVariables.CUPS_DATADIR = "${bindir}/share/cups";

    systemd.packages = [ cups.out ];

    systemd.sockets.cups = mkIf cfg.startWhenNeeded {
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        ""
        "/run/cups/cups.sock"
      ]
      ++ map (
        x: replaceStrings [ "localhost" ] [ "127.0.0.1" ] (removePrefix "*:" x)
      ) cfg.listenAddresses;
    };

    systemd.services.cups = {
      wantedBy = optionals (!cfg.startWhenNeeded) [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = [ "network.target" ];

      path = [ cups.out ];

      preStart =
        lib.optionalString cfg.stateless ''
          rm -rf /var/cache/cups /var/lib/cups /var/spool/cups
        ''
        + ''
          (umask 022 && mkdir -p /var/cache /var/lib /var/spool)
          (umask 077 && mkdir -p /var/cache/cups /var/spool/cups)
          (umask 022 && mkdir -p ${cfg.tempDir} /var/lib/cups)
          # While cups will automatically create self-signed certificates if accessed via TLS,
          # this directory to store the certificates needs to be created manually.
          (umask 077 && mkdir -p /var/lib/cups/ssl)

          # Backwards compatibility
          if [ ! -L /etc/cups ]; then
            mv /etc/cups/* /var/lib/cups
            rmdir /etc/cups
            ln -s /var/lib/cups /etc/cups
          fi
          # First, clean existing symlinks
          if [ -n "$(ls /var/lib/cups)" ]; then
            for i in /var/lib/cups/*; do
              [ -L "$i" ] && rm "$i"
            done
          fi
          # Then, populate it with static files
          cd ${rootdir}/etc/cups
          for i in *; do
            [ ! -e "/var/lib/cups/$i" ] && ln -s "${rootdir}/etc/cups/$i" "/var/lib/cups/$i"
          done

          #update path reference
          [ -L /var/lib/cups/path ] && \
            rm /var/lib/cups/path
          [ ! -e /var/lib/cups/path ] && \
            ln -s ${bindir} /var/lib/cups/path

          ${optionalString (containsGutenprint cfg.drivers) ''
            if [ -d /var/lib/cups/ppd ]; then
              ${getGutenprint cfg.drivers}/bin/cups-genppdupdate -x -p /var/lib/cups/ppd
            fi
          ''}
        '';

      serviceConfig.PrivateTmp = true;
    };

    systemd.services.cups-browsed = mkIf cfg.browsed.enable {
      description = "CUPS Remote Printer Discovery";

      wantedBy = [ "multi-user.target" ];
      wants = [ "avahi-daemon.service" ] ++ optional (!cfg.startWhenNeeded) "cups.service";
      bindsTo = [ "avahi-daemon.service" ] ++ optional (!cfg.startWhenNeeded) "cups.service";
      partOf = [ "avahi-daemon.service" ] ++ optional (!cfg.startWhenNeeded) "cups.service";
      after = [ "avahi-daemon.service" ] ++ optional (!cfg.startWhenNeeded) "cups.service";

      path = [ cups ];

      serviceConfig.ExecStart = "${cfg.browsed.package}/bin/cups-browsed";

      restartTriggers = [ browsedFile ];
    };

    services.printing.extraConf = ''
      DefaultAuthType Basic

      <Location />
        Order allow,deny
        ${cfg.allowFrom}
      </Location>

      <Location /admin>
        Order allow,deny
        ${cfg.allowFrom}
      </Location>

      <Location /admin/conf>
        AuthType Basic
        Require user @SYSTEM
        Order allow,deny
        ${cfg.allowFrom}
      </Location>

      <Policy default>
        <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job CUPS-Move-Job>
          Require user @OWNER @SYSTEM
          Order deny,allow
        </Limit>

        <Limit Pause-Printer Resume-Printer Set-Printer-Attributes Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After CUPS-Add-Printer CUPS-Delete-Printer CUPS-Add-Class CUPS-Delete-Class CUPS-Accept-Jobs CUPS-Reject-Jobs CUPS-Set-Default>
          AuthType Basic
          Require user @SYSTEM
          Order deny,allow
        </Limit>

        <Limit Cancel-Job CUPS-Authenticate-Job>
          Require user @OWNER @SYSTEM
          Order deny,allow
        </Limit>

        <Limit All>
          Order deny,allow
        </Limit>
      </Policy>
    '';

    security.pam.services.cups = { };

    networking.firewall =
      let
        listenPorts = parsePorts cfg.listenAddresses;
      in
      mkIf cfg.openFirewall {
        allowedTCPPorts = listenPorts;
      };

  };

  meta.maintainers = [ ];

}
