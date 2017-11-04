{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixborg;
  productionCfg = pkgs.writeText "production.cfg" ''
    NIXBORG_BOT_NAME = '${cfg.botName}'
    NIXBORG_REPO = '${cfg.repo}'
    NIXBORG_PR_REPO = '${cfg.prRepo}'
    NIXBORG_PUBLIC_URL = '${cfg.publicUrl}'
    NIXBORG_REPO_DIR = '${cfg.dataDir}/repositories'
    NIXBORG_NIXEXPR_PATH = '${cfg.nixexprPath}'
    NIXBORG_HYDRA_PROJECT = '${cfg.hydraProject}'
    NIXBORG_GITHUB_TOKEN = '${cfg.githubToken}'
    NIXBORG_GITHUB_SECRET = '${cfg.githubSecret}'
    NIXBORG_GITHUB_WRITE_COMMENTS = True
    NIXBORG_RECEIVER_KEY = '${cfg.receiver.key}'
    NIXBORG_RECEIVER_URL = '${cfg.receiverURL}'
  '';
in {
  options = {
    services.nixborg = {
      enable = mkEnableOption "nixborg";

      botName = mkOption {
        type = types.str;
        description = "The bot's github user account name.";
        default = "nixborg";
      };

      githubToken = mkOption {
        type = types.str;
        description = "The bot's github user account token.";
        example = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      };

      githubSecret = mkOption {
        type = types.str;
        description = "The github webhook's secret key used for autheticating webhooks";
        example = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      };

      repo = mkOption {
        type = types.str;
        description = "The github repository to check for PRs.";
        example = "nixos/nixpkgs";
      };

      prRepo = mkOption {
        type = types.str;
        description = "The github repository to push the PRs to.";
        example = "nixos/nixpkgs-pr";
      };

      publicUrl = mkOption {
        type = types.str;
        description = "The public URL the bot is reachable at (Github hook endpoint).";
        example = "https://nixborg.nixos.org";
      };

      dataDir = mkOption {
        type = types.path;
        description = "The directory the repositories are stored in.";
        default = "/var/lib/nixborg";
      };

      nixexprPath = mkOption {
        type = types.str;
        description = "Path to the nix expression to test.";
        default = "nixos/release-combined.nix";
      };

      hydraProject = mkOption {
        type = types.str;
        description = "Hydra project to create the jobsets in.";
        default = "nixos";
      };

      receiverURL = mkOption {
        type = types.str;
        description = "URL to the Hydra server running the receiver.";
        default = "https://hydra.example.com";
      };

      receiver = {
        enable = mkEnableOption "nixborg receiver for jobset creation on hydra";
        listenAddr = mkOption {
          type = types.str;
          description = "Address for the receiver to listen on.";
          default = "127.0.0.1";
        };
        port = mkOption {
          type = types.int;
          description = "Port for the receiver to listen on.";
          default = 7000;
        };
        key = mkOption {
          type = types.str;
          description = "PSK to be used for HMAC authentication of the bot with the receiver";
        };
      };
    };
  };

  config = let
    env = pkgs.python3.buildEnv.override {
      extraLibs = [ pkgs.nixborg.server ];
    };
    uwsgi = pkgs.uwsgi.override { plugins = [ "python3" ]; };
    uwsgienv = uwsgi.python3.buildEnv.override {
      extraLibs = [ pkgs.nixborg.server uwsgi ];
    };
    nixborgUwsgi = pkgs.writeText "uwsgi.json" (builtins.toJSON {
      uwsgi = {
        plugins = [ "python3" ];
        pythonpath = "${uwsgienv}/${uwsgi.python3.sitePackages}";
        uid = "nixborg";
        socket = "/run/nixborg/uwsgi.socket";
        chown-socket = "nixborg:nginx";
        chmod-socket = 770;
        chdir = "${cfg.dataDir}";
        mount = "/=nixborg:app";
        env = "NIXBORG_SETTINGS=${productionCfg}";
        manage-script-name = true;
        master = true;
        processes = 4;
        stats = "/run/nixborg/stats.socket";
        no-orphans = true;
        vacuum = true;
        logger = "syslog";
      };
    });
  in mkMerge [
    (mkIf cfg.enable {
      users.extraUsers.nixborg = {
        createHome = true;
        home = cfg.dataDir;
      };

      services.redis.enable = true;

      systemd.tmpfiles.rules = [
        "d /run/nixborg 0755 nixborg nogroup -"
      ];

      systemd.services.nixborg = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "notify";
          Restart = "on-failure";
          KillSignal = "SIGQUIT";
          StandardError = "syslog";
          NotifyAccess = "all";
          ExecStart = "${uwsgi}/bin/uwsgi --json ${nixborgUwsgi}";
          PrivateDevices = "yes";
          PrivateTmp = "yes";
          ProtectSystem = "full";
          ProtectHome = "yes";
          NoNewPrivileges = "yes";
          ReadWritePaths = "/run/nixborg /var/lib/nixborg";
        };
      };

      systemd.services.nixborg-workers = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${env}/bin/celery -A nixborg.celery worker -E -l INFO
        '';
        path = [ pkgs.git pkgs.hydra ];
        environment = {
          FLASK_APP = "nixborg";
          NIXBORG_SETTINGS = productionCfg;
        };

        serviceConfig = {
          User = "nixborg";
          Group = "nogroup";
        };
      };
    })
    (mkIf cfg.receiver.enable {
      users.extraUsers.nixborg-receiver = { extraGroups = [ "hydra" ]; };
      services.postgresql.identMap = ''
        hydra-users nixborg-receiver hydra
      '';

      systemd.services.nixborg-receiver = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.hydra ];
        environment = {
          NIXBORG_RECEIVER_PORT = toString cfg.receiver.port;
          NIXBORG_RECEIVER_ADDRESS = cfg.receiver.listenAddr;
          NIXBORG_RECEIVER_KEY = cfg.receiver.key;
        } // config.systemd.services.hydra-evaluator.environment;

        serviceConfig = {
          User = "nixborg-receiver";
          Group = "hydra";
          ExecStart = "${pkgs.nixborg.receiver}/bin/nixborg-receiver";
          Restart = "always";
        };
      };
    })
  ];
}
