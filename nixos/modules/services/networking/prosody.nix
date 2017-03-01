{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.prosody;

  sslOpts = { ... }: {

    options = {

      key = mkOption {
        type = types.path;
        description = "Path to the key file.";
      };

      cert = mkOption {
        type = types.path;
        description = "Path to the certificate file.";
      };

      extraOptions = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra SSL configuration options.";
      };

    };
  };

  moduleOpts = {

    roster = mkOption {
      type = types.bool;
      default = true;
      description = "Allow users to have a roster";
    };

    saslauth = mkOption {
      type = types.bool;
      default = true;
      description = "Authentication for clients and servers. Recommended if you want to log in.";
    };

    tls = mkOption {
      type = types.bool;
      default = true;
      description = "Add support for secure TLS on c2s/s2s connections";
    };

    dialback = mkOption {
      type = types.bool;
      default = true;
      description = "s2s dialback support";
    };

    disco = mkOption {
      type = types.bool;
      default = true;
      description = "Service discovery";
    };

    legacyauth = mkOption {
      type = types.bool;
      default = true;
      description = "Legacy authentication. Only used by some old clients and bots";
    };

    version = mkOption {
      type = types.bool;
      default = true;
      description = "Replies to server version requests";
    };

    uptime = mkOption {
      type = types.bool;
      default = true;
      description = "Report how long server has been running";
    };

    time = mkOption {
      type = types.bool;
      default = true;
      description = "Let others know the time here on this server";
    };

    ping = mkOption {
      type = types.bool;
      default = true;
      description = "Replies to XMPP pings with pongs";
    };

    console = mkOption {
      type = types.bool;
      default = false;
      description = "telnet to port 5582";
    };

    bosh = mkOption {
      type = types.bool;
      default = false;
      description = "Enable BOSH clients, aka 'Jabber over HTTP'";
    };

    httpserver = mkOption {
      type = types.bool;
      default = false;
      description = "Serve static files from a directory over HTTP";
    };

    websocket = mkOption {
      type = types.bool;
      default = false;
      description = "Enable WebSocket support";
    };

  };

  toLua = x:
    if builtins.isString x then ''"${x}"''
    else if builtins.isBool x then toString x
    else if builtins.isInt x then toString x
    else throw "Invalid Lua value";

  createSSLOptsStr = o: ''
    ssl = {
      key = "${o.key}";
      certificate = "${o.cert}";
      ${concatStringsSep "\n" (mapAttrsToList (name: value: "${name} = ${toLua value};") o.extraOptions)}
    };
  '';

  vHostOpts = { ... }: {

    options = {

      # TODO: require attribute
      domain = mkOption {
        type = types.str;
        description = "Domain name";
      };

      enabled = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the virtual host";
      };

      ssl = mkOption {
        type = types.nullOr (types.submodule sslOpts);
        default = null;
        description = "Paths to SSL files";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
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
        type = types.bool;
        default = false;
        description = "Whether to enable the prosody server";
      };

      allowRegistration = mkOption {
        type = types.bool;
        default = false;
        description = "Allow account creation";
      };

      modules = moduleOpts;

      extraModules = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Enable custom modules";
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
        type = types.nullOr (types.submodule sslOpts);
        default = null;
        description = "Paths to SSL files";
      };

      admins = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "admin1@example.com" "admin2@example.com" ];
        description = "List of administrators of the current host";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
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
      restartTriggers = [ config.environment.etc."prosody/prosody.cfg.lua".source ];
      serviceConfig = {
        User = "prosody";
        Type = "forking";
        PIDFile = "/var/lib/prosody/prosody.pid";
        ExecStart = "${pkgs.prosody}/bin/prosodyctl start";
      };
    };

  };

}
