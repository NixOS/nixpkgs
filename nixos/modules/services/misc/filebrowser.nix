{ config, pkgs, lib, ... }: {
  options = {
    services.filebrowser = {
      dataDir = lib.mkOption {
        default = "/var/lib/filebrowser";
        description = "Directory where Filebrowser stores its data files";
        type = lib.types.str;
      };

      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable and start the filebrowser service. Note that no users, rules, or other
          configuration options will be initially set up. Stop the service and run the command
          'filebrowser-service-tool' in your terminal to set these up.
        '';
        type = lib.types.bool;
      };

      group = lib.mkOption {
        default = "filebrowser";
        description = "Group under which Filebrowser runs";
        type = lib.types.str;
      };

      openFirewall = lib.mkOption {
        default = false;
        description = "Open ports in firewall for Filebrowser web interface";
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "filebrowser" { };

      # Eventually I'd like to add all of the `filebrowser config set` options here,
      # along with having a `services.filebrowser.settings.users` that fully models
      # the users as well, but the nature of how filebrowser stores its config inside
      # a mutable database makes that kinda difficult. I went down the rabbit hole a
      # few times but kept coming up with mostly-correct solutions but wasn't satisfied
      # with releasing that. For now, I'll keep the scope of supported settings small,
      # get those right, and provide a tool to allow the user to mutate the database.
      settings = lib.mkOption {
        default = { };
        description = "application specific settings";
        type = lib.types.submodule {
          options = {
            address = lib.mkOption {
              default = "0.0.0.0";
              description = "address to listen on";
              type = lib.types.str;
            };

            port = lib.mkOption {
              default = 5983;
              description = "port to listen on";
              type = lib.types.port;
            };
          };
        };
      };

      user = lib.mkOption {
        default = "filebrowser";
        description = "User under which Filebrowser runs";
        type = lib.types.str;
      };
    };
  };

  config = let
    cfg = config.services.filebrowser;

    cmd =
      "${cfg.package}/bin/filebrowser --config='${cfg.dataDir}/config.json' --database='${cfg.dataDir}/database.boltdb'";

    # This `preamble` should be included before working with filebrowser or its data files
    preamble = ''
      # create the `config.json` file if it doesn't exist, and either way, make sure permissions
      # are correct in case use of `sudo` or something mangled them
      if [ ! -f '${cfg.dataDir}/config.json' ] ; then
        echo "{}" > '${cfg.dataDir}/config.json' || exit $?
      fi
      chown ${cfg.user}:${cfg.group} '${cfg.dataDir}/config.json' || exit $?
      chmod 600 '${cfg.dataDir}/config.json' || exit $?

      # create the `database.boltdb` file if it doesn't exist, and either way, make sure permissions
      # are correct in case use of `sudo` or something mangled them
      if [ ! -f '${cfg.dataDir}/database.boltdb' ] ; then
        ${cmd} config init 2>&1 >/dev/null || exit $?
      fi
      chown ${cfg.user}:${cfg.group} '${cfg.dataDir}/database.boltdb' || exit $?
      chmod 600 '${cfg.dataDir}/database.boltdb' || exit $?
    '';

  in lib.mkIf cfg.enable {

    # `filebrowser-service-tool` is a helper command to make it much easier to correctly
    # update, add, and remove settings, users, rules, etc, in the filebrowser db. Eventually,
    # I'd like this to go away once we've correctly modeled the full set of parameters.
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "filebrowser-service-tool" ''
        if systemctl is-active --quiet filebrowser.service ; then
          echo "'filebrowser.service' needs to be stopped before using this tool"
          exit 1
        fi

        ${preamble}

        exec ${cmd} "$@"
      '')
    ];

    networking.firewall =
      lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };

    systemd.services.filebrowser = {
      after = [ "network.target" ];
      description = "Filebrowser Service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Group = cfg.group;
        Restart = "on-failure";
        Type = "simple";
        User = cfg.user;

        ExecStart = pkgs.writeShellScript "filebrowser-exec-start.sh" ''
          ${preamble}

          ${cmd} config set --address=${cfg.settings.address} || exit $?
          ${cmd} config set --port=${
            builtins.toString cfg.settings.port
          } || exit $?

          exec ${cmd}
        '';
      };

    };

    systemd.tmpfiles.rules =
      [ "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -" ];

    users.groups.filebrowser = lib.mkIf (cfg.group == "filebrowser") { };

    users.users.filebrowser = lib.mkIf (cfg.user == "filebrowser") {
      group = cfg.group;
      home = cfg.dataDir;
      isSystemUser = true;
    };

  };
}
