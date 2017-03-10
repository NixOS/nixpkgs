{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pumpio;
  dataDir = "/var/lib/pump.io";
  user = "pumpio";

  configOptions = {
    driver = if cfg.driver == "disk" then null else cfg.driver;
    params = ({ } //
    (if cfg.driver == "disk" then {
      dir = dataDir;
     } else { }) //
    (if cfg.driver == "mongodb" || cfg.driver == "redis" then {
       host = cfg.dbHost;
       port = cfg.dbPort;
       dbname = cfg.dbName;
       dbuser = cfg.dbUser;
       dbpass = cfg.dbPassword;
     } else { }) //
    (if cfg.driver == "memcached" then {
       host = cfg.dbHost;
       port = cfg.dbPort;
     } else { }) //
     cfg.driverParams);

    secret = cfg.secret;

    address = cfg.address;
    port = cfg.port;

    noweb = false;
    urlPort = cfg.urlPort;
    hostname = cfg.hostname;
    favicon = cfg.favicon;

    site = cfg.site;
    owner = cfg.owner;
    ownerURL = cfg.ownerURL;

    key = cfg.sslKey;
    cert = cfg.sslCert;
    bounce = false;

    spamhost = cfg.spamHost;
    spamclientid = cfg.spamClientId;
    spamclientsecret = cfg.spamClientSecret;

    requireEmail = cfg.requireEmail;
    smtpserver = cfg.smtpHost;
    smtpport = cfg.smtpPort;
    smtpuser = cfg.smtpUser;
    smtppass = cfg.smtpPassword;
    smtpusessl = cfg.smtpUseSSL;
    smtpfrom = cfg.smtpFrom;

    nologger = false;
    enableUploads = cfg.enableUploads;
    datadir = dataDir;
    debugClient = false;
    firehose = cfg.firehose;
    disableRegistration = cfg.disableRegistration;
  } //
  (if cfg.port < 1024 then {
    serverUser = user;  # have pump.io listen then drop privileges
   } else { }) //
  cfg.extraConfig;

in

{
  options = {

    services.pumpio = {

      enable = mkEnableOption "Pump.io social streams server";

      secret = mkOption {
        type = types.str;
        example = "my dog has fleas";
        description = ''
          A session-generating secret, server-wide password.  Warning:
          this is stored in cleartext in the Nix store!
        '';
      };

      site = mkOption {
        type = types.str;
        example = "Awesome Sauce";
        description = "Name of the server";
      };

      owner = mkOption {
        type = types.str;
        default = "";
        example = "Awesome Inc.";
        description = "Name of owning entity, if you want to link to it.";
      };

      ownerURL = mkOption {
        type = types.str;
        default = "";
        example = "https://pump.io";
        description = "URL of owning entity, if you want to link to it.";
      };

      address = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Web server listen address.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 31337;
        description = ''
          Port to listen on. Defaults to 31337, which is suitable for
          running behind a reverse proxy. For a standalone server,
          use 443.
        '';
      };

      hostname = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The hostname of the server, used for generating
          URLs. Defaults to "localhost" which doesn't do much for you.
        '';
      };

      urlPort = mkOption {
        type = types.int;
        default = 443;
        description = ''
          Port to use for generating URLs. This basically has to be
          either 80 or 443 because the host-meta and Webfinger
          protocols don't make any provision for HTTP/HTTPS servers
          running on other ports.
        '';
      };

      favicon = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Local filesystem path to the favicon.ico file to use. This
          will be served as "/favicon.ico" by the server.
        '';
      };

      enableUploads = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If you want to disable file uploads, set this to false. Uploaded files will be stored
          in ${dataDir}/uploads.
        '';
      };

      sslKey = mkOption {
        type = types.path;
        example = "${dataDir}/myserver.key";
        default = "";
        description = ''
          The path to the server certificate private key. The
          certificate is required, but it can be self-signed.
        '';
      };

      sslCert = mkOption {
        type = types.path;
        example = "${dataDir}/myserver.crt";
        default = "";
        description = ''
          The path to the server certificate. The certificate is
          required, but it can be self-signed.
        '';
      };

      firehose = mkOption {
        type = types.str;
        default = "ofirehose.com";
        description = ''
          Firehose host running the ofirehose software. Defaults to
          "ofirehose.com". Public notices will be ping this firehose
          server and from there go out to search engines and the
          world. If you want to disconnect from the public web, set
          this to something falsy.
        '';
      };

      disableRegistration = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Disables registering new users on the site through the Web
          or the API.
        '';
      };

      requireEmail = mkOption {
        type = types.bool;
        default = false;
        description = "Require an e-mail address to register.";
      };

      extraConfig = mkOption {
        default = { };
        description = ''
          Extra configuration options which are serialized to json and added
          to the pump.io.json config file.
        '';
      };

      driver = mkOption {
        type = types.enum [ "mongodb" "disk" "lrucache" "memcached" "redis" ];
        default = "mongodb";
        description = "Type of database. Corresponds to a nodejs databank driver.";
      };

      driverParams = mkOption {
        default = { };
        description = "Extra parameters for the driver.";
      };

      dbHost = mkOption {
        type = types.str;
        default = "localhost";
        description = "The database host to connect to.";
      };

      dbPort = mkOption {
        type = types.int;
        default = 27017;
        description = "The port that the database is listening on.";
      };

      dbName = mkOption {
        type = types.str;
        default = "pumpio";
        description = "The name of the database to use.";
      };

      dbUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The username. Defaults to null, meaning no authentication.
        '';
      };

      dbPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The password corresponding to dbUser.  Warning: this is
          stored in cleartext in the Nix store!
        '';
      };

      smtpHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "localhost";
        description = ''
          Server to use for sending transactional email. If it's not
          set up, no email is sent and features like password recovery
          and email notification won't work.
        '';
      };

      smtpPort = mkOption {
        type = types.int;
        default = 25;
        description = ''
          Port to connect to on SMTP server.
        '';
      };

      smtpUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Username to use to connect to SMTP server. Might not be
          necessary for some servers.
        '';
      };

      smtpPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password to use to connect to SMTP server. Might not be
          necessary for some servers.  Warning: this is stored in
          cleartext in the Nix store!
        '';
      };

      smtpUseSSL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Only use SSL with the SMTP server. By default, a SSL
          connection is negotiated using TLS. You may need to change
          the smtpPort value if you set this.
        '';
      };

      smtpFrom = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Email address to use in the "From:" header of outgoing
          notifications. Defaults to 'no-reply@' plus the site
          hostname.
        '';
      };

      spamHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Host running activityspam software to use to test updates
          for spam.
        '';
      };
      spamClientId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "OAuth pair for spam server.";
      };
      spamClientSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          OAuth pair for spam server.  Warning: this is
          stored in cleartext in the Nix store!
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    systemd.services."pump.io" =
      { description = "pump.io social network stream server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          mkdir -p ${dataDir}/uploads
          chown pumpio:pumpio ${dataDir}/uploads
          chmod 770 ${dataDir}/uploads
        '';

        serviceConfig.ExecStart = "${pkgs.pumpio}/bin/pump -c /etc/pump.io.json";
        PermissionsStartOnly = true;
        serviceConfig.User = if cfg.port < 1024 then "root" else user;
        serviceConfig.Group = user;
      };

      environment.etc."pump.io.json" = {
        mode = "0440";
        gid = config.ids.gids.pumpio;
        text = builtins.toJSON configOptions;
      };

      users.extraGroups.pumpio.gid = config.ids.gids.pumpio;
      users.extraUsers.pumpio = {
        group = "pumpio";
        uid = config.ids.uids.pumpio;
        description = "Pump.io user";
        home = dataDir;
        createHome = true;
      };
  };
}
