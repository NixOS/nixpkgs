{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.prosody;

  sslOpts = { ... }: {

    options = {

      # TODO: require attribute
      key = mkOption {
        type = types.str;
        description = "Path to the key file";
      };

      # TODO: require attribute
      cert = mkOption {
        type = types.str;
        description = "Path to the certificate file";
      };
    };
  };

  moduleOpts = {

    roster = mkOption {
      default = true;
      description = "Allow users to have a roster";
    };

    saslauth = mkOption {
      default = true;
      description = "Authentication for clients and servers. Recommended if you want to log in.";
    };

    tls = mkOption {
      default = true;
      description = "Add support for secure TLS on c2s/s2s connections";
    };

    dialback = mkOption {
      default = true;
      description = "s2s dialback support";
    };

    disco = mkOption {
      default = true;
      description = "Service discovery";
    };

    legacyauth = mkOption {
      default = true;
      description = "Legacy authentication. Only used by some old clients and bots";
    };

    version = mkOption {
      default = true;
      description = "Replies to server version requests";
    };

    uptime = mkOption {
      default = true;
      description = "Report how long server has been running";
    };

    time = mkOption {
      default = true;
      description = "Let others know the time here on this server";
    };

    ping = mkOption {
      default = true;
      description = "Replies to XMPP pings with pongs";
    };

    console = mkOption {
      default = false;
      description = "telnet to port 5582";
    };

    bosh = mkOption {
      default = false;
      description = "Enable BOSH clients, aka 'Jabber over HTTP'";
    };

    httpserver = mkOption {
      default = false;
      description = "Serve static files from a directory over HTTP";
    };

    websocket = mkOption {
      default = false;
      description = "Enable WebSocket support";
    };

  };

  createSSLOptsStr = o:
    if o ? key && o ? cert then
      ''ssl = { key = "${o.key}"; certificate = "${o.cert}"; };''
    else "";

  vHostOpts = { ... }: {

    options = {

      # TODO: require attribute
      domain = mkOption {
        type = types.str;
        description = "Domain name";
      };

      enabled = mkOption {
        default = false;
        description = "Whether to enable the virtual host";
      };

      ssl = mkOption {
        description = "Paths to SSL files";
        default = null;
        options = [ sslOpts ];
      };

      extraConfig = mkOption {
        default = '''';
        description = "Additional virtual host specific configuration";
      };

    };

  };

in

{

  ###### interface

  options = {

    services.prosody = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the prosody server";
      };

      allowRegistration = mkOption {
        default = false;
        description = "Allow account creation";
      };

      modules = moduleOpts;

      extraModules = mkOption {
        description = "Enable custom modules";
        default = [];
      };

      virtualHosts = mkOption {

        description = "Define the virtual hosts";

        type = with types; loaOf (submodule vHostOpts);

        example = {
          myhost = {
            domain = "my-xmpp-example-host.org";
            enabled = true;
          };
        };

        default = {
          localhost = {
            domain = "localhost";
            enabled = true;
          };
        };

      };

      ssl = mkOption {
        description = "Paths to SSL files";
        default = null;
        options = [ sslOpts ];
      };

      admins = mkOption {
        description = "List of administrators of the current host";
        example = [ "admin1@example.com" "admin2@example.com" ];
        default = [];
      };

      extraConfig = mkOption {
        type = types.lines;
        default = '''';
        description = "Additional prosody configuration";
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.prosody ];

    environment.etc."prosody/prosody.cfg.lua".text = ''

      pidfile = "/var/lib/prosody/prosody.pid"


      log = "*syslog"

      data_path = "/var/lib/prosody"

      allow_registration = ${boolToString cfg.allowRegistration};

      ${ optionalString cfg.modules.console "console_enabled = true;" }

      ${ optionalString  (cfg.ssl != null) (createSSLOptsStr cfg.ssl) }

      admins = { ${lib.concatStringsSep ", " (map (n: "\"${n}\"") cfg.admins) } };

      modules_enabled = {

        ${ lib.concatStringsSep "\n\ \ " (lib.mapAttrsToList
          (name: val: optionalString val ''"${name}";'')
        cfg.modules) }

        ${ optionalString cfg.allowRegistration "\"register\"\;" }

        ${ lib.concatStringsSep "\n" (map (x: "\"${x}\";") cfg.extraModules)}

        "posix";
      };

      ${ cfg.extraConfig }

      ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: ''
        VirtualHost "${v.domain}"
          enabled = ${boolToString v.enabled};
          ${ optionalString (v.ssl != null) (createSSLOptsStr v.ssl) }
          ${ v.extraConfig }
        '') cfg.virtualHosts) }
    '';

    users.extraUsers.prosody = {
      uid = config.ids.uids.prosody;
      description = "Prosody user";
      createHome = true;
      group = "prosody";
      home = "/var/lib/prosody";
    };

    users.extraGroups.prosody = {
      gid = config.ids.gids.prosody;
    };

    systemd.services.prosody = {

      description = "Prosody XMPP server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "prosody";
        PIDFile = "/var/lib/prosody/prosody.pid";
        ExecStart = "${pkgs.prosody}/bin/prosodyctl start";
      };

    };

  };

}
