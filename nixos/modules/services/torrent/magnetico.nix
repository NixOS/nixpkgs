{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.magnetico;

  dataDir = "/var/lib/magnetico";

  credFile = with cfg.web;
    if credentialsFile != null
      then credentialsFile
      else pkgs.writeText "magnetico-credentials"
        (concatStrings (mapAttrsToList
          (user: hash: "${user}:${hash}\n")
          cfg.web.credentials));

  # default options in magneticod/main.go
  dbURI = concatStrings
    [ "sqlite3://${dataDir}/database.sqlite3"
      "?_journal_mode=WAL"
      "&_busy_timeout=3000"
      "&_foreign_keys=true"
    ];

  crawlerArgs = with cfg.crawler; escapeShellArgs
    ([ "--database=${dbURI}"
       "--indexer-addr=${address}:${toString port}"
       "--indexer-max-neighbors=${toString maxNeighbors}"
       "--leech-max-n=${toString maxLeeches}"
     ] ++ extraOptions);

  webArgs = with cfg.web; escapeShellArgs
    ([ "--database=${dbURI}"
       (if (cfg.web.credentialsFile != null || cfg.web.credentials != { })
         then "--credentials=${toString credFile}"
         else "--no-auth")
       "--addr=${address}:${toString port}"
     ] ++ extraOptions);

in {

  ###### interface

  options.services.magnetico = {
    enable = mkEnableOption (lib.mdDoc "Magnetico, Bittorrent DHT crawler");

    crawler.address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "1.2.3.4";
      description = lib.mdDoc ''
        Address to be used for indexing DHT nodes.
      '';
    };

    crawler.port = mkOption {
      type = types.port;
      default = 0;
      description = lib.mdDoc ''
        Port to be used for indexing DHT nodes.
        This port should be added to
        {option}`networking.firewall.allowedTCPPorts`.
      '';
    };

    crawler.maxNeighbors = mkOption {
      type = types.ints.positive;
      default = 1000;
      description = lib.mdDoc ''
        Maximum number of simultaneous neighbors of an indexer.
        Be careful changing this number: high values can very
        easily cause your network to be congested or even crash
        your router.
      '';
    };

    crawler.maxLeeches = mkOption {
      type = types.ints.positive;
      default = 200;
      description = lib.mdDoc ''
        Maximum number of simultaneous leeches.
      '';
    };

    crawler.extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra command line arguments to pass to magneticod.
      '';
    };

    web.address = mkOption {
      type = types.str;
      default = "localhost";
      example = "1.2.3.4";
      description = lib.mdDoc ''
        Address the web interface will listen to.
      '';
    };

    web.port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        Port the web interface will listen to.
      '';
    };

    web.credentials = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = lib.literalExpression ''
        {
          myuser = "$2y$12$YE01LZ8jrbQbx6c0s2hdZO71dSjn2p/O9XsYJpz.5968yCysUgiaG";
        }
      '';
      description = lib.mdDoc ''
        The credentials to access the web interface, in case authentication is
        enabled, in the format `username:hash`. If unset no
        authentication will be required.

        Usernames must start with a lowercase ([a-z]) ASCII character, might
        contain non-consecutive underscores except at the end, and consists of
        small-case a-z characters and digits 0-9.  The
        {command}`htpasswd` tool from the `apacheHttpd`
        package may be used to generate the hash:
        {command}`htpasswd -bnBC 12 username password`

        ::: {.warning}
        The hashes will be stored world-readable in the nix store.
        Consider using the `credentialsFile` option if you
        don't want this.
        :::
      '';
    };

    web.credentialsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        The path to the file holding the credentials to access the web
        interface. If unset no authentication will be required.

        The file must constain user names and password hashes in the format
        `username:hash `, one for each line.  Usernames must
        start with a lowecase ([a-z]) ASCII character, might contain
        non-consecutive underscores except at the end, and consists of
        small-case a-z characters and digits 0-9.
        The {command}`htpasswd` tool from the `apacheHttpd`
        package may be used to generate the hash:
        {command}`htpasswd -bnBC 12 username password`
      '';
    };

    web.extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra command line arguments to pass to magneticow.
      '';
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.users.magnetico = {
      description = "Magnetico daemons user";
      group = "magnetico";
      isSystemUser = true;
    };
    users.groups.magnetico = {};

    systemd.services.magneticod = {
      description = "Magnetico DHT crawler";
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];

      serviceConfig = {
        User      = "magnetico";
        Restart   = "on-failure";
        ExecStart = "${pkgs.magnetico}/bin/magneticod ${crawlerArgs}";
      };
    };

    systemd.services.magneticow = {
      description = "Magnetico web interface";
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" "magneticod.service"];

      serviceConfig = {
        User           = "magnetico";
        StateDirectory = "magnetico";
        Restart        = "on-failure";
        ExecStart      = "${pkgs.magnetico}/bin/magneticow ${webArgs}";
      };
    };

    assertions =
    [
      {
        assertion = cfg.web.credentialsFile == null || cfg.web.credentials == { };
        message = ''
          The options services.magnetico.web.credentialsFile and
          services.magnetico.web.credentials are mutually exclusives.
        '';
      }
    ];

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
