{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixbot;
  productionCfg = pkgs.writeText "production.cfg" ''
    NIXBOT_BOT_NAME = '${cfg.botName}'
    NIXBOT_REPO = '${cfg.repo}'
    NIXBOT_PUBLIC_URL = '${cfg.publicUrl}'
    NIXBOT_REPO_DIR = '${cfg.dataDir}/repositories'
    NIXBOT_GITHUB_TOKEN = '${cfg.githubToken}'
    NIXBOT_GITHUB_SECRET = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    NIXBOT_GITHUB_WRITE_COMMENTS = True
  '';
in {
  options = {
    services.nixbot = {
      enable = mkEnableOption "nixbot";

      botName = mkOption {
        type = types.str;
        description = "The bot's github user account name.";
        default = "nixbot";
      };

      githubToken = mkOption {
        type = types.str;
        description = "The bot's github user account token.";
        example = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      };

      repo = mkOption {
        type = types.str;
        description = "The github repository to check for PRs.";
        example = "nixos/nixpkgs";
      };

      publicUrl = mkOption {
        type = types.str;
        description = "The public URL the bot is reachable at (Github hook endpoint).";
        example = "https://nixbot.nixos.org";
      };

      dataDir = mkOption {
        type = types.path;
        description = "The directory the repositories are stored in.";
        default = "/var/lib/nixbot";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.nixbot = {
      createHome = true;
      home = cfg.dataDir;
    };

    services.redis.enable = true;

    systemd.services.nixbot = let
      env = pkgs.python3.buildEnv.override {
        extraLibs = [ pkgs.nixbot ];
      };
    in {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${env}/bin/python -m flask run
      '';
      environment = {
        NIXBOT_SETTINGS = productionCfg;
        FLASK_APP = "nixbot";
      };

      serviceConfig = {
        User = "nixbot";
        Group = "nogroup";
      };
    };

    services.postgresql.identMap = ''
      hydra-users nixbot hydra
    '';

    systemd.services.nixbot-workers = let
      env = pkgs.python3.buildEnv.override {
        extraLibs = [ pkgs.nixbot ];
      };
    in {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${env}/bin/celery -A nixbot.celery worker -E -l INFO
      '';
      path = [ pkgs.git pkgs.hydra ];
      environment = {
        FLASK_APP = "nixbot";
        NIXBOT_SETTINGS = productionCfg;
      } // config.systemd.services.hydra-evaluator.environment;

      serviceConfig = {
        User = "nixbot";
        Group = "nogroup";
      };
    };
  };
}
