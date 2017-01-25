{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixbot;
  pyramidIni = ''
    ###
    # app configuration
    # http://docs.pylonsproject.org/projects/pyramid/en/1.7-branch/narr/environment.html
    ###

    [app:main]
    use = egg:nixbot

    nixbot.github_token = ${cfg.githubToken}
    nixbot.bot_name = ${cfg.botName}
    nixbot.repo = ${cfg.repo}
    nixbot.pr_repo = ${cfg.prRepo}
    nixbot.hydra_jobsets_repo = ${cfg.hydraJobsetsRepo}
    nixbot.github_secret = justnotsorandom
    nixbot.public_url = ${cfg.publicUrl}
    nixbot.repo_dir = ${cfg.repoDir}

    pyramid.reload_templates = false
    pyramid.debug_authorization = false
    pyramid.debug_notfound = false
    pyramid.debug_routematch = false
    pyramid.default_locale_name = en

    # By default, the toolbar only appears for clients from IP addresses
    # '127.0.0.1' and '::1'.
    # debugtoolbar.hosts = 127.0.0.1 ::1

    ###
    # wsgi server configuration
    ###

    [server:main]
    use = egg:waitress#main
    host = 0.0.0.0
    port = 6543

    ###
    # logging configuration
    # http://docs.pylonsproject.org/projects/pyramid/en/1.7-branch/narr/logging.html
    ###

    [loggers]
    keys = root, nixbot

    [handlers]
    keys = console

    [formatters]
    keys = generic

    [logger_root]
    level = INFO
    handlers = console

    [logger_nixbot]
    level = INFO
    handlers =
    qualname = nixbot

    [handler_console]
    class = StreamHandler
    args = (sys.stderr,)
    level = NOTSET
    formatter = generic

    [formatter_generic]
    format = %(asctime)s %(levelname)-5.5s [%(name)s:%(lineno)s][%(threadName)s] %(message)s
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

      prRepo = mkOption {
        type = types.str;
        description = "The github repository to push the testing branches to.";
        example = "nixos/nixpkgs-pr";
      };

      hydraJobsetsRepo = mkOption {
        type = types.str;
        description = "The github repository to push the hydra jobset definitions to.";
        example = "nixos/hydra-jobsets";
      };

      publicUrl = mkOption {
        type = types.str;
        description = "The public URL the bot is reachable at (Github hook endpoint).";
        example = "https://nixbot.nixos.org";
      };

      repoDir = mkOption {
        type = types.path;
        description = "The directory the repositories are stored in.";
        default = "/var/lib/nixbot";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.nixbot = {
      createHome = true;
      home = cfg.repoDir;
    };

    systemd.services.nixbot = let
      env = pkgs.python3.buildEnv.override {
        extraLibs = [ pkgs.nixbot ];
      };
    in {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${env}/bin/pserve ${pkgs.writeText "production.ini" pyramidIni}
      '';

      serviceConfig = {
        User = "nixbot";
        Group = "nogroup";
        PermissionsStartOnly = true;
      };
    };
  };
}
