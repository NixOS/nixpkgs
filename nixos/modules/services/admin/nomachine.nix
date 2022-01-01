{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.nxserver;

  settingsFmt = rec {
    type = with lib.types;
      (attrsOf (nullOr (oneOf [ str int bool attrs (listOf str) ])))
      // {
        description = "settings option";
      };

    format = value:
      lib.generators.toKeyValue
        {
          mkKeyValue = k: v:
            let
              default = lib.generators.mkKeyValueDefault { } " " k;
            in
            if lib.isAttrs v then
              "Section \"${k}\"\n" + (format v) + "EndSection"
            else if lib.isList v then
              default ''"${lib.concatStringsSep "," v}"''
            else if lib.isBool v then
              default (if v == true then 1 else 0)
            else if lib.isString v then
              default ''"${v}"''
            else
              default v;
        }
        value;

    generate = name: value:
      pkgs.writeText name (
        format value
      );
  };

  serverCfgFile = settingsFmt.generate "server.cfg" cfg.serverSettings;
  nodeCfgFile = settingsFmt.generate "node.cfg" cfg.nodeSettings;
in
{
  options.services.nxserver = with lib; {
    enable = mkEnableOption (lib.mdDoc ''the NoMachine remote desktop server'');

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open the configured port in the firewall.
      '';
    };

    package = mkOption {
      description = lib.mdDoc ''
        Package containing the nxserver package and configuration files.
      '';
      type = types.package;
      default = pkgs.nomachine;
      defaultText = lib.literalMD "pkgs.nomachine";
    };

    serverSettings = lib.mkOption {
      description = lib.mdDoc ''
        Settings for the NoMachine nxserver instance.
      '';

      default = { };
      example = {
        EnableDebug = true;
        SessionLogLevel = 6;
      };

      type = lib.types.submodule {
        freeformType = settingsFmt.type;

        options.EnableDebug = lib.mkEnableOption (lib.mdDoc ''debug output'');
        options.SessionLogLevel = lib.mkOption {
          type = lib.types.int;
          default = 6;
          example = 6;
          description = lib.mdDoc ''Debug output level'';
        };
      };
    };

    nodeSettings = lib.mkOption {
      description = lib.mdDoc ''
        Settings for the NoMachine nxnode instance.
      '';

      default = { };
      example = {
        EnableDebug = true;
        SessionLogLevel = 6;
      };

      type = lib.types.submodule {
        freeformType = settingsFmt.type;

        options.EnableDebug = lib.mkEnableOption (lib.mdDoc ''debug output'');
        options.SessionLogLevel = lib.mkOption {
          type = lib.types.int;
          default = 6;
          example = 6;
          description = lib.mdDoc ''Debug output level'';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = {
      "nx" = {
        group = "nx";
        isSystemUser = true;
        shell = "${cfg.package}/NX/etc/nxserver";
        home = "/var/lib/nxserver/nx";
      };
    };

    users.groups = {
      "nx" = { };
    };

    services.nxserver = {
      serverSettings = {
        ConfigFileVersion = "4.0";

        AvailableSessionTypes = lib.mkDefault [
          "unix-remote"
          "unix-console"
          "unix-default"
          "unix-application"
          "physical-desktop"
          "shadow"
        ];

        EnablePasswordDB = lib.mkDefault false;

        EnableFirewallConfiguration = lib.mkDefault false;

        Server = lib.mkDefault {
          Name = "Connection to localhost";
          Host = "127.0.0.1";
          Protocol = "NX";
          Port = 4000;
          Authentication = "password";
        };
      };

      nodeSettings = {
        ConfigFileVersion = "4.0";

        AvailableSessionTypes = lib.mkDefault [
          "unix-remote"
          "unix-console"
          "unix-default"
          "unix-application"
          "physical-desktop"
          "shadow"
        ];

        AudioInterface = lib.mkDefault "pulseaudio";

        EnableSmartcardSharing = lib.mkDefault true;
        EnableCUPSSupport = lib.mkDefault false;

        EnableEGLCapture = lib.mkDefault false;

        DisplayServerThreads = lib.mkDefault "auto";
        DisplayEncoderThreads = lib.mkDefault "auto";
        EnableDirectXSupport = lib.mkDefault false;
      };
    };

    security.pam.services.nx.text = ''
      # This is a default PAM configuration for NoMachine. It is based on
      # system's 'su' configuration and can be adjusted freely according
      # to administrative needs on the system.

      auth     include su
      account  include su
      password include su
      session  include su
    '';

    security.pam.services.nxlimits.text = ''
      # This is a default PAM configuration for NoMachine.
      # Used to obtain nx user and nxhtd user limits.

      session optional pam_limits.so
    '';

    environment.etc = {
      "NX/server/localhost/server.cfg" = {
        text = ''
          ServerRoot = "${cfg.package}/NX"'';
        mode = "644";
      };

      "NX/server/localhost/node.cfg" = {
        text = ''NodeRoot = "${cfg.package}/NX"'';
        mode = "644";
      };

      "NX/server/localhost/client.cfg" = {
        text = ''ClientRoot = "${cfg.package}/NX"'';
        mode = "644";
      };

      "NX/nxserver" = {
        source = "${cfg.package}/bin/nxserver";
        mode = "0755";
      };

      "NX/nxnode".source = "${cfg.package}/bin/nxnode";

      "NX/server.cfg".source = serverCfgFile;
      "NX/node.cfg".source = nodeCfgFile;
    };

    security.wrappers = {
      nxexec = {
        source = "${cfg.package}/NX/bin/nxexec.orig";
        owner = "root";
        group = "root";
        setuid = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.serverSettings.Server.Port ];

    systemd.services.nxserver = {
      description = "NoMachine Server daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" "network-online.target" "display-manager.service" ];
      wants = [ "network-online.target" ];
      bindsTo = [ "display-manager.service" ];
      restartTriggers = [ serverCfgFile nodeCfgFile ];

      serviceConfig = {
        User = "nx";
        Group = "nx";

        LogsDirectory = "nxserver";

        StateDirectory = [
          "nxserver"
          "nxserver/db"
          "nxserver/db/server"
          "nxserver/nx"
        ];

        RuntimeDirectory = [
          "nxserver"
          "nxserver/run"
          "nxserver/tmp"
          "nxserver/scripts"
        ];

        ExecStartPre =
          let
            preStartScript = ''
              set -euo pipefail

              # always update to current version of files
              cp ${cfg.package}/NX/etc.static/version /etc/NX/
              cp ${cfg.package}/NX/etc.static/update.cfg /etc/NX/

              if [ ! -f /etc/NX/usb.db ]; then
                cp ${cfg.package}/NX/etc.static/usb.db /etc/NX/
              fi

              # nx processes run as user "nx" need to write state and lock files to /etc/NX
              chown nx:nx /etc/NX

              # Almost all shell scripts in scripts/restriced need u+s and to be owned by root
              # Only symlinking the restricted folder does not work because of checks done by
              # nxexec (symlink is not a folder)
              cp -r ${cfg.package}/NX/scripts.static/* /run/nxserver/scripts/
              for i in /run/nxserver/scripts/restricted/*.sh; do
                file=$(basename "$i")
                if [ "$file" != "nxfunct.sh" ] && [ "$file" != "nxlogrotate.sh" ]; then
                  chown root:root "$i"
                  chmod u+s "$i"
                fi
              done

              # nxserver can only run after the previous commands

              if [ ! -f /etc/NX/uuid ]; then
                ${cfg.package}/NX/bin/nxkeygen -u > /etc/NX/uuid
              fi

              if [ ! -f /etc/NX/server.lic ]; then
                cp ${cfg.package}/NX/etc.static/server.lic.sample /etc/NX/
                /etc/NX/nxserver --validate
                mv /etc/NX/server.lic.sample /etc/NX/server.lic
                chown nx:root /etc/NX/server.lic
                chmod 0400 /etc/NX/server.lic
              fi

              if [ ! -f /etc/NX/node.lic ]; then
                cp ${cfg.package}/NX/etc.static/node.lic.sample /etc/NX/
                /etc/NX/nxnode --validate
                mv /etc/NX/node.lic.sample /etc/NX/node.lic
                chown nx:root /etc/NX/node.lic
                chmod 0400 /etc/NX/node.lic
                /etc/NX/nxserver --validatenode
              fi

              # This inits the database with the localhost_4000 display entry
              /etc/NX/nxserver --addtoredis

              if [ ! -f /etc/NX/keys/host/nx_host_rsa_key ]; then
                mkdir -p /etc/NX/keys/host
                ${cfg.package}/NX/bin/nxkeygen -k /etc/NX/keys/host/nx_host_rsa_key -c /etc/NX/keys/host/nx_host_rsa_key.crt
                chown -R nx:root /etc/NX/keys
                chmod 0400 /etc/NX/keys/host/nx_host_rsa_key
              fi
            '';
          in
          "+${pkgs.writeShellScript "nxserver-prestart" preStartScript}";
        ExecStart = "${cfg.package}/bin/nxserver --daemon";
        KillMode = "process";
        SuccessExitStatus = "0 SIGTERM";
        Restart = "always";
      };
    };
  };
}

