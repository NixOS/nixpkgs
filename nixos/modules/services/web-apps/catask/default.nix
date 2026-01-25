{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.catask;
  configFormat = pkgs.formats.json { };
  defaultConfig = builtins.fromJSON (builtins.readFile ./config.example.json);
  python = (
    pkgs.python3.withPackages (
      python-pkgs: with python-pkgs; [
        flask
        gunicorn
        markupsafe
        pillow
        python-dotenv
        psycopg
        humanize
        mistune
        bleach
        pathlib2
        flask-babel
        flask-compress
        requests
        yoyo-migrations
        ago
        lupa
        authlib
        sentry-sdk
        mastodon-py
      ]
    )
  );
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    getExe
    literalExpression
    types
    ;
in
{
  options = {
    services.catask = {
      enable = lib.mkEnableOption "catask";

      package = lib.mkPackageOption pkgs "catask" { };

      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to start catask automatically.
        '';
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Address to listen on.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        description = ''
          Which port catask will use.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the catask port in the firewall.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "catask";
        description = ''
          User account under which catask runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "catask";
        description = ''
          Group account under which catask runs.
        '';
      };

      dotenvPath = lib.mkOption {
        type = lib.types.str;
        example = "\${config.sops.templates.\"cataskenv\".path}";
        description = ''
          Path to the .env file for catask.
          Since it includes secrets, it's recommended to generate it using something like sops.

          See <https://codeberg.org/catask-org/catask/src/branch/main/.env.example> and  <https://docs.catask.org/getting-started/installation/bare-metal/#post-install>
        '';
      };

      workDir = lib.mkOption {
        type = lib.types.str;
        description = ''
          Path to the working directory, where the config file and catask will be linked into and used to store emojis and alike.

          See <https://codeberg.org/catask-org/catask/src/branch/main/constants.py>
        '';
        default = "/var/lib/catask";
      };

      configPath = lib.mkOption {
        type = lib.types.str;
        description = ''
          Use this if you need to provide your own config file instead of generating it with nix, such as for including secrets with sops.

          If set to anything but "/etc/catask/config.json", services.catask.settings will have no effect.
        '';
        default = "/etc/catask/config.json";
      };

      settings = mkOption {
        type = configFormat.type;
        description = ''
          Configuration for catask. The attributes are serialized to JSON in config.json.

          See <https://codeberg.org/catask-org/catask/src/branch/main/config.example.json>
        '';
        default = defaultConfig;
        apply = lib.recursiveUpdate defaultConfig;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.catask = {
      description = "catask server";
      path = [
        python
      ];
      serviceConfig = {
        # Currently Catask does not let you override config or mutable paths, so this very cursed script is needed
        ExecStartPre = pkgs.writeScript "catask-server-setup" ''
          #!${pkgs.runtimeShell}

          mkdir -p "${cfg.workDir}"
          chown ${cfg.user}:${cfg.group} "${cfg.workDir}"
          cd "${cfg.workDir}"
          for i in ${cfg.package}/share/catask/*
          do
            if [ "$i" = "${cfg.package}/share/catask/static" ]; then
                mkdir -p "${cfg.workDir}/static"
                cp -R --update=none "$i/" "${cfg.workDir}/"
                chown -R ${cfg.user}:${cfg.group} "${cfg.workDir}/static"
            else
                ln -sf "$i" "${cfg.workDir}/"
            fi;
          done

          ln -sf "${cfg.dotenvPath}" "${cfg.workDir}/.env"
          cp --update=all "${cfg.configPath}" "${cfg.workDir}/config.json"
          chmod 744 "${cfg.workDir}/config.json"
        '';
        ExecStart = pkgs.writeScript "catask-server" ''
          #!${pkgs.runtimeShell}
          cd "${cfg.workDir}"
          if [ -e "${cfg.workDir}/db-created" ]; then
            echo
          else
            echo initializing db
            ${python}/bin/flask init-db
            touch "${cfg.workDir}/db-created"
          fi;
          ${python}/bin/gunicorn -w 4 app:app --bind ${cfg.listenAddress}:${toString cfg.port}
        '';
        User = cfg.user;
        Group = cfg.group;
        CacheDirectory = "catask";
        StateDirectory = "catask";
        RuntimeDirectory = "catask";
        WorkingDirectory = cfg.workDir;
        ReadWritePaths = [ cfg.workDir ];
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    environment.etc = {
      "catask/config.json".source = configFormat.generate "config.json" cfg.settings;
    };

    users.users = lib.optionalAttrs (cfg.user == "catask") {
      catask = {
        home = "${cfg.workDir}";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = lib.optionalAttrs (cfg.group == "catask") {
      catask = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "catask" ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = lib.optionalAttrs (cfg.user == "catask") true;
        }
      ];
    };
  };

  meta.maintainers = [ lib.maintainers.luNeder ];
}
