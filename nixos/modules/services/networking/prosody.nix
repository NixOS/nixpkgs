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

      # TODO: rename to certificate to match the prosody config
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
    # Generally required
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

    # Not essential, but recommended
    carbons = mkOption {
      type = types.bool;
      default = true;
      description = "Keep multiple clients in sync";
    };

    pep = mkOption {
      type = types.bool;
      default = true;
      description = "Enables users to publish their mood, activity, playing music and more";
    };

    private = mkOption {
      type = types.bool;
      default = true;
      description = "Private XML storage (for room bookmarks, etc.)";
    };

    blocklist = mkOption {
      type = types.bool;
      default = true;
      description = "Allow users to block communications with other users";
    };

    vcard = mkOption {
      type = types.bool;
      default = true;
      description = "Allow users to set vCards";
    };

    # Nice to have
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

    register = mkOption {
      type = types.bool;
      default = true;
      description = "Allow users to register on this server using a client and change passwords";
    };

    mam = mkOption {
      type = types.bool;
      default = false;
      description = "Store messages in an archive and allow users to access it";
    };

    # Admin interfaces
    admin_adhoc = mkOption {
      type = types.bool;
      default = true;
      description = "Allows administration via an XMPP client that supports ad-hoc commands";
    };

    admin_telnet = mkOption {
      type = types.bool;
      default = false;
      description = "Opens telnet console interface on localhost port 5582";
    };

    # HTTP modules
    bosh = mkOption {
      type = types.bool;
      default = false;
      description = "Enable BOSH clients, aka 'Jabber over HTTP'";
    };

    websocket = mkOption {
      type = types.bool;
      default = false;
      description = "Enable WebSocket support";
    };

    http_files = mkOption {
      type = types.bool;
      default = false;
      description = "Serve static files from a directory over HTTP";
    };

    # Other specific functionality
    limits = mkOption {
      type = types.bool;
      default = false;
      description = "Enable bandwidth limiting for XMPP connections";
    };

    groups = mkOption {
      type = types.bool;
      default = false;
      description = "Shared roster support";
    };

    server_contact_info = mkOption {
      type = types.bool;
      default = false;
      description = "Publish contact information for this service";
    };

    announce = mkOption {
      type = types.bool;
      default = false;
      description = "Send announcement to all online users";
    };

    welcome = mkOption {
      type = types.bool;
      default = false;
      description = "Welcome users who register accounts";
    };

    watchregistrations = mkOption {
      type = types.bool;
      default = false;
      description = "Alert admins of registrations";
    };

    motd = mkOption {
      type = types.bool;
      default = false;
      description = "Send a message to users when they log in";
    };

    legacyauth = mkOption {
      type = types.bool;
      default = false;
      description = "Legacy authentication. Only used by some old clients and bots";
    };

    proxy65 = mkOption {
      type = types.bool;
      default = false;
      description = "Enables a file transfer proxy service which clients behind NAT can use";
    };

  };

  toLua = x:
    if builtins.isString x then ''"${x}"''
    else if builtins.isBool x then (if x == true then "true" else "false")
    else if builtins.isInt x then toString x
    else if builtins.isList x then ''{ ${lib.concatStringsSep ", " (map (n: toLua n) x) } }''
    else throw "Invalid Lua value";

  createSSLOptsStr = o: ''
    ssl = {
      cafile = "/etc/ssl/certs/ca-bundle.crt";
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

      package = mkOption {
        type = types.package;
        description = "Prosody package to use";
        default = pkgs.prosody;
        defaultText = "pkgs.prosody";
        example = literalExample ''
          pkgs.prosody.override {
            withExtraLibs = [ pkgs.luaPackages.lpty ];
            withCommunityModules = [ "auth_external" ];
          };
        '';
      };

      dataDir = mkOption {
        type = types.string;
        description = "Directory where Prosody stores its data";
        default = "/var/lib/prosody";
      };

      user = mkOption {
        type = types.str;
        default = "prosody";
        description = "User account under which prosody runs.";
      };

      group = mkOption {
        type = types.str;
        default = "prosody";
        description = "Group account under which prosody runs.";
      };

      allowRegistration = mkOption {
        type = types.bool;
        default = false;
        description = "Allow account creation";
      };

      c2sRequireEncryption = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Force clients to use encrypted connections? This option will
          prevent clients from authenticating unless they are using encryption.
        '';
      };

      s2sRequireEncryption = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Force servers to use encrypted connections? This option will
          prevent servers from authenticating unless they are using encryption.
          Note that this is different from authentication.
        '';
      };

      s2sSecureAuth = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Force certificate authentication for server-to-server connections?
          This provides ideal security, but requires servers you communicate
          with to support encryption AND present valid, trusted certificates.
          For more information see https://prosody.im/doc/s2s#security
        '';
      };

      s2sInsecureDomains = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "insecure.example.com" ];
        description = ''
          Some servers have invalid or self-signed certificates. You can list
          remote domains here that will not be required to authenticate using
          certificates. They will be authenticated using DNS instead, even
          when s2s_secure_auth is enabled.
        '';
      };

      s2sSecureDomains = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "jabber.org" ];
        description = ''
          Even if you leave s2s_secure_auth disabled, you can still require valid
          certificates for some domains by specifying a list here.
        '';
      };


      modules = moduleOpts;

      extraModules = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Enable custom modules";
      };

      extraPluginPaths = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "Addtional path in which to look find plugins/modules";
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

    environment.systemPackages = [ cfg.package ];

    environment.etc."prosody/prosody.cfg.lua".text = ''

      pidfile = "/run/prosody/prosody.pid"

      log = "*syslog"

      data_path = "${cfg.dataDir}"
      plugin_paths = {
        ${lib.concatStringsSep ", " (map (n: "\"${n}\"") cfg.extraPluginPaths) }
      }

      ${ optionalString  (cfg.ssl != null) (createSSLOptsStr cfg.ssl) }

      admins = ${toLua cfg.admins}

      -- we already build with libevent, so we can just enable it for a more performant server
      use_libevent = true

      modules_enabled = {

        ${ lib.concatStringsSep "\n\ \ " (lib.mapAttrsToList
          (name: val: optionalString val "${toLua name};")
        cfg.modules) }
        ${ lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.package.communityModules)}
        ${ lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.extraModules)}
      };

      allow_registration = ${toLua cfg.allowRegistration}

      c2s_require_encryption = ${toLua cfg.c2sRequireEncryption}

      s2s_require_encryption = ${toLua cfg.s2sRequireEncryption}

      s2s_secure_auth = ${toLua cfg.s2sSecureAuth}

      s2s_insecure_domains = ${toLua cfg.s2sInsecureDomains}

      s2s_secure_domains = ${toLua cfg.s2sSecureDomains}


      ${ cfg.extraConfig }

      ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: ''
        VirtualHost "${v.domain}"
          enabled = ${boolToString v.enabled};
          ${ optionalString (v.ssl != null) (createSSLOptsStr v.ssl) }
          ${ v.extraConfig }
        '') cfg.virtualHosts) }
    '';

    users.users.prosody = mkIf (cfg.user == "prosody") {
      uid = config.ids.uids.prosody;
      description = "Prosody user";
      createHome = true;
      inherit (cfg) group;
      home = "${cfg.dataDir}";
    };

    users.groups.prosody = mkIf (cfg.group == "prosody") {
      gid = config.ids.gids.prosody;
    };

    systemd.services.prosody = {
      description = "Prosody XMPP server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."prosody/prosody.cfg.lua".source ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "forking";
        RuntimeDirectory = [ "prosody" ];
        PIDFile = "/run/prosody/prosody.pid";
        ExecStart = "${cfg.package}/bin/prosodyctl start";
      };
    };

  };

}
