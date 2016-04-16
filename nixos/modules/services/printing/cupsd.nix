{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) cups cups-pk-helper cups_filters gutenprint;

  cfg = config.services.printing;

  avahiEnabled = config.services.avahi.enable;
  polkitEnabled = config.security.polkit.enable;

  additionalBackends = pkgs.runCommand "additional-cups-backends" { }
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
  # cupsd.conf tells cupsd to use this tree.
  bindir = pkgs.buildEnv {
    name = "cups-progs";
    paths =
      [ cups additionalBackends cups_filters pkgs.ghostscript ]
      ++ optional cfg.gutenprint gutenprint
      ++ cfg.drivers;
    pathsToLink = [ "/lib/cups" "/share/cups" "/bin" ];
    postBuild = cfg.bindirCmds;
    ignoreCollisions = true;
  };

  writeConf = name: text: pkgs.writeTextFile {
    inherit name text;
    destination = "/etc/cups/${name}";
  };

  cupsFilesFile = writeConf "cups-files.conf" ''
    SystemGroup root wheel

    ServerBin ${bindir}/lib/cups
    DataDir ${bindir}/share/cups

    AccessLog syslog
    ErrorLog syslog
    PageLog syslog

    TempDir ${cfg.tempDir}

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
    Listen /var/run/cups/cups.sock

    SetEnv PATH ${bindir}/lib/cups/filter:${bindir}/bin

    DefaultShared ${if cfg.defaultShared then "Yes" else "No"}

    Browsing ${if cfg.browsing then "Yes" else "No"}

    WebInterface ${if cfg.webInterface then "Yes" else "No"}

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
    ] ++ optional avahiEnabled browsedFile
      ++ optional cfg.gutenprint gutenprint
      ++ cfg.drivers;
    pathsToLink = [ "/etc/cups" ];
    ignoreCollisions = true;
  };

in

{

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

      listenAddresses = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1:631" ];
        example = [ "*:631" ];
        description = ''
          A list of addresses and ports on which to listen.
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

      extraFilesConf = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra contents of the configuration file of the CUPS daemon
          (<filename>cups-files.conf</filename>).
        '';
      };

      extraConf = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            BrowsePoll cups.example.com
            LogLevel debug
          '';
        description = ''
          Extra contents of the configuration file of the CUPS daemon
          (<filename>cupsd.conf</filename>).
        '';
      };

      clientConf = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            ServerName server.example.com
            Encryption Never
          '';
        description = ''
          The contents of the client configuration.
          (<filename>client.conf</filename>)
        '';
      };

      browsedConf = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            BrowsePoll cups.example.com
          '';
        description = ''
          The contents of the configuration. file of the CUPS Browsed daemon
          (<filename>cups-browsed.conf</filename>)
        '';
      };

      snmpConf = mkOption {
        type = types.lines;
        default = ''
          Address @LOCAL
        '';
        description = ''
          The contents of <filename>/etc/cups/snmp.conf</filename>. See "man
          cups-snmp.conf" for a complete description.
        '';
      };

      gutenprint = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Gutenprint drivers for CUPS. This includes auto-updating
          Gutenprint PPD files.
        '';
      };

      drivers = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ pkgs.splix ]";
        description = ''
          CUPS drivers to use. Drivers provided by CUPS, cups-filters, Ghostscript
          and Samba are added unconditionally. For adding Gutenprint, see
          <literal>gutenprint</literal>.
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

    users.extraUsers = singleton
      { name = "cups";
        uid = config.ids.uids.cups;
        group = "lp";
        description = "CUPS printing services";
      };

    environment.systemPackages = [ cups ] ++ optional polkitEnabled cups-pk-helper;
    environment.etc."cups".source = "/var/lib/cups";

    services.dbus.packages = [ cups ] ++ optional polkitEnabled cups-pk-helper;

    # Cups uses libusb to talk to printers, and does not use the
    # linux kernel driver. If the driver is not in a black list, it
    # gets loaded, and then cups cannot access the printers.
    boot.blacklistedKernelModules = [ "usblp" ];

    systemd.packages = [ cups.out ];

    systemd.services.cups =
      { wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        after = [ "network.target" ];

        path = [ cups ];

        preStart =
          ''
            mkdir -m 0700 -p /var/cache/cups
            mkdir -m 0700 -p /var/spool/cups
            mkdir -m 0755 -p ${cfg.tempDir}

            mkdir -m 0755 -p /var/lib/cups
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
            ${optionalString cfg.gutenprint ''
              if [ -d /var/lib/cups/ppd ]; then
                ${gutenprint}/bin/cups-genppdupdate -p /var/lib/cups/ppd
              fi
            ''}
          '';
      };

    systemd.services.cups-browsed = mkIf avahiEnabled
      { description = "CUPS Remote Printer Discovery";

        wantedBy = [ "multi-user.target" ];
        wants = [ "cups.service" "avahi-daemon.service" ];
        bindsTo = [ "cups.service" "avahi-daemon.service" ];
        partOf = [ "cups.service" "avahi-daemon.service" ];
        after = [ "cups.service" "avahi-daemon.service" ];

        path = [ cups ];

        serviceConfig.ExecStart = "${cups_filters}/bin/cups-browsed";

        restartTriggers = [ browsedFile ];
      };

    services.printing.extraConf =
      ''
        LogLevel info

        DefaultAuthType Basic

        <Location />
          Order allow,deny
          Allow localhost
        </Location>

        <Location /admin>
          Order allow,deny
          Allow localhost
        </Location>

        <Location /admin/conf>
          AuthType Basic
          Require user @SYSTEM
          Order allow,deny
          Allow localhost
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

    security.pam.services.cups = {};

  };
}
