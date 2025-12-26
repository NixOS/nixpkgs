{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.prosody;

  sslOpts = _: {
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
        default = { };
        description = "Extra SSL configuration options.";
      };
    };
  };

  discoOpts = {
    options = {
      url = mkOption {
        type = types.str;
        description = "URL of the endpoint you want to make discoverable";
      };
      description = mkOption {
        type = types.str;
        description = "A short description of the endpoint you want to advertise";
      };
    };
  };

  moduleOpts = {
    # Required for compliance with https://compliance.conversations.im/about/
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

    csi = mkOption {
      type = types.bool;
      default = true;
      description = "Implements the CSI protocol that allows clients to report their active/inactive state to the server";
    };

    cloud_notify = mkOption {
      type = types.bool;
      default = true;
      description = "Push notifications to inform users of new messages or other pertinent information even when they have no XMPP clients online";
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
      default = false;
      description = "Allow users to set vCards";
    };

    vcard_legacy = mkOption {
      type = types.bool;
      default = true;
      description = "Converts users profiles and Avatars between old and new formats";
    };

    bookmarks = mkOption {
      type = types.bool;
      default = true;
      description = "Allows interop between older clients that use XEP-0048: Bookmarks in its 1.0 version and recent clients which use it in PEP";
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
      default = true;
      description = "Store messages in an archive and allow users to access it";
    };

    smacks = mkOption {
      type = types.bool;
      default = true;
      description = "Allow a client to resume a disconnected session, and prevent message loss";
    };

    # Admin interfaces
    admin_adhoc = mkOption {
      type = types.bool;
      default = true;
      description = "Allows administration via an XMPP client that supports ad-hoc commands";
    };

    http_files = mkOption {
      type = types.bool;
      default = false;
      description = "Serve static files from a directory over HTTP";
    };

    proxy65 = mkOption {
      type = types.bool;
      default = true;
      description = "Enables a file transfer proxy service which clients behind NAT can use";
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
  };

  toLua =
    x:
    if builtins.isString x then
      ''"${x}"''
    else if builtins.isBool x then
      boolToString x
    else if builtins.isInt x then
      toString x
    else if builtins.isList x then
      "{ ${lib.concatMapStringsSep ", " toLua x} }"
    else
      throw "Invalid Lua value";

  settingsToLua =
    prefix: settings:
    generators.toKeyValue {
      listsAsDuplicateKeys = false;
      mkKeyValue =
        k:
        generators.mkKeyValueDefault {
          mkValueString = toLua;
        } " = " (prefix + k);
    } (filterAttrs (k: v: v != null) settings);

  createSSLOptsStr = o: ''
    ssl = {
      cafile = "/etc/ssl/certs/ca-bundle.crt";
      key = "${o.key}";
      certificate = "${o.cert}";
      ${concatStringsSep "\n" (
        mapAttrsToList (name: value: "${name} = ${toLua value};") o.extraOptions
      )}
    };
  '';

  mucOpts = _: {
    options = {
      domain = mkOption {
        type = types.str;
        description = "Domain name of the MUC";
      };
      name = mkOption {
        type = types.str;
        description = "The name to return in service discovery responses for the MUC service itself";
        default = "Prosody Chatrooms";
      };
      restrictRoomCreation = mkOption {
        type = types.enum [
          true
          false
          "admin"
          "local"
        ];
        default = false;
        description = "Restrict room creation to server admins";
      };
      maxHistoryMessages = mkOption {
        type = types.int;
        default = 20;
        description = "Specifies a limit on what each room can be configured to keep";
      };
      roomLocking = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables room locking, which means that a room must be
          configured before it can be used. Locked rooms are invisible
          and cannot be entered by anyone but the creator
        '';
      };
      roomLockTimeout = mkOption {
        type = types.int;
        default = 300;
        description = ''
          Timeout after which the room is destroyed or unlocked if not
          configured, in seconds
        '';
      };
      tombstones = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When a room is destroyed, it leaves behind a tombstone which
          prevents the room being entered or recreated. It also allows
          anyone who was not in the room at the time it was destroyed
          to learn about it, and to update their bookmarks. Tombstones
          prevents the case where someone could recreate a previously
          semi-anonymous room in order to learn the real JIDs of those
          who often join there.
        '';
      };
      tombstoneExpiry = mkOption {
        type = types.int;
        default = 2678400;
        description = ''
          This settings controls how long a tombstone is considered
          valid. It defaults to 31 days. After this time, the room in
          question can be created again.
        '';
      };
      allowners_muc = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Add module allowners, any user in chat is able to
          kick other. Useful in jitsi-meet to kick ghosts.
        '';
      };
      moderation = mkOption {
        type = types.bool;
        default = false;
        description = "Allow rooms to be moderated";
      };

      # Extra parameters. Defaulting to prosody default values.
      # Adding them explicitly to make them visible from the options
      # documentation.
      #
      # See https://prosody.im/doc/modules/mod_muc for more details.
      roomDefaultPublic = mkOption {
        type = types.bool;
        default = true;
        description = "If set, the MUC rooms will be public by default.";
      };
      roomDefaultMembersOnly = mkOption {
        type = types.bool;
        default = false;
        description = "If set, the MUC rooms will only be accessible to the members by default.";
      };
      roomDefaultModerated = mkOption {
        type = types.bool;
        default = false;
        description = "If set, the MUC rooms will be moderated by default.";
      };
      roomDefaultPublicJids = mkOption {
        type = types.bool;
        default = false;
        description = "If set, the MUC rooms will display the public JIDs by default.";
      };
      roomDefaultChangeSubject = mkOption {
        type = types.bool;
        default = false;
        description = "If set, the rooms will display the public JIDs by default.";
      };
      roomDefaultHistoryLength = mkOption {
        type = types.int;
        default = 20;
        description = "Number of history message sent to participants by default.";
      };
      roomDefaultLanguage = mkOption {
        type = types.str;
        default = "en";
        description = "Default room language.";
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional MUC specific configuration";
      };
    };
  };

  httpFileShareOpts =
    { config, options, ... }:
    {
      freeformType =
        with types;
        let
          atom = oneOf [
            int
            bool
            str
            (listOf atom)
          ];
        in
        attrsOf (nullOr atom)
        // {
          description = "int, bool, string or list of them";
        };
      options = {
        domain = mkOption {
          type = with types; nullOr str;
          description = "Domain name for a http_file_share service.";
        };
        http_host = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            To avoid an additional DNS record and certificate, you may set this option to your primary domain (e.g. "example.com")
            or use a reverse proxy to handle the HTTP for that domain.
          '';
        };
        http_external_url = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "External URL in case Prosody sits behind a reverse proxy.";
        };
        size_limit = mkOption {
          type = types.int;
          default = 10 * 1024 * 1024;
          defaultText = "10 * 1024 * 1024";
          description = "Maximum file size, in bytes.";
        };
        expires_after = mkOption {
          type = types.str;
          default = "1 week";
          description = "Max age of a file before it gets deleted.";
        };
        daily_quota = mkOption {
          type = types.nullOr types.int;
          default = 10 * config.size_limit;
          defaultText = lib.literalExpression "10 * ${options.size_limit}";
          example = "100*1024*1024";
          description = ''
            Maximum size of daily uploaded files per user, in bytes.
          '';
        };
      };
    };

  vHostOpts = _: {
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

  configFile =
    let
      httpDiscoItems = optional (cfg.httpFileShare != null) {
        url = cfg.httpFileShare.domain;
        description = "HTTP file share endpoint";
      };
      mucDiscoItems = builtins.foldl' (
        acc: muc:
        [
          {
            url = muc.domain;
            description = "${muc.domain} MUC endpoint";
          }
        ]
        ++ acc
      ) [ ] cfg.muc;
      discoItems = cfg.disco_items ++ httpDiscoItems ++ mucDiscoItems;
    in
    pkgs.writeText "prosody.cfg.lua" ''
      pidfile = "/run/prosody/prosody.pid"

      log = ${cfg.log}

      data_path = "${cfg.dataDir}"
      plugin_paths = {
        ${lib.concatStringsSep ", " (map (n: "\"${n}\"") cfg.extraPluginPaths)}
      }

      ${optionalString (cfg.ssl != null) (createSSLOptsStr cfg.ssl)}

      admins = ${toLua cfg.admins}

      modules_enabled = {
        "admin_shell";  -- for prosodyctl
        ${lib.concatStringsSep "\n  " (
          lib.mapAttrsToList (name: val: optionalString val "${toLua name};") cfg.modules
        )}
        ${lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.package.communityModules)}
        ${lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.extraModules)}
      };

      disco_items = {
      ${lib.concatStringsSep "\n" (builtins.map (x: ''{ "${x.url}", "${x.description}"};'') discoItems)}
      };

      allow_registration = ${toLua cfg.allowRegistration}

      c2s_require_encryption = ${toLua cfg.c2sRequireEncryption}

      s2s_require_encryption = ${toLua cfg.s2sRequireEncryption}
      s2s_secure_auth = ${toLua cfg.s2sSecureAuth}
      s2s_insecure_domains = ${toLua cfg.s2sInsecureDomains}
      s2s_secure_domains = ${toLua cfg.s2sSecureDomains}

      authentication = ${toLua cfg.authentication}

      http_interfaces = ${toLua cfg.httpInterfaces}
      https_interfaces = ${toLua cfg.httpsInterfaces}

      http_ports = ${toLua cfg.httpPorts}
      https_ports = ${toLua cfg.httpsPorts}

      mime_types_file = "${pkgs.mailcap}/etc/mime.types"

      ${cfg.extraConfig}

      ${lib.concatMapStrings (muc: ''
        Component ${toLua muc.domain} "muc"
            modules_enabled = {${optionalString cfg.modules.mam ''"muc_mam",''}${optionalString muc.allowners_muc ''"muc_allowners",''}${optionalString muc.moderation ''"muc_moderation",''} }
            name = ${toLua muc.name}
            restrict_room_creation = ${toLua muc.restrictRoomCreation}
            max_history_messages = ${toLua muc.maxHistoryMessages}
            muc_room_locking = ${toLua muc.roomLocking}
            muc_room_lock_timeout = ${toLua muc.roomLockTimeout}
            muc_tombstones = ${toLua muc.tombstones}
            muc_tombstone_expiry = ${toLua muc.tombstoneExpiry}
            muc_room_default_public = ${toLua muc.roomDefaultPublic}
            muc_room_default_members_only = ${toLua muc.roomDefaultMembersOnly}
            muc_room_default_moderated = ${toLua muc.roomDefaultModerated}
            muc_room_default_public_jids = ${toLua muc.roomDefaultPublicJids}
            muc_room_default_change_subject = ${toLua muc.roomDefaultChangeSubject}
            muc_room_default_history_length = ${toLua muc.roomDefaultHistoryLength}
            muc_room_default_language = ${toLua muc.roomDefaultLanguage}
            ${muc.extraConfig}
      '') cfg.muc}

      ${lib.optionalString (cfg.httpFileShare != null) ''
        Component ${toLua cfg.httpFileShare.domain} "http_file_share"
          modules_disabled = { "s2s" }
        ${lib.optionalString (cfg.httpFileShare.http_host != null) ''
          http_host = "${cfg.httpFileShare.http_host}"
        ''}
        ${lib.optionalString (cfg.httpFileShare.http_external_url != null) ''
          http_external_url = "${cfg.httpFileShare.http_external_url}"
        ''}
        ${settingsToLua "  http_file_share_" (
          cfg.httpFileShare
          // {
            domain = null;
            http_host = null;
            http_external_url = null;
          }
        )}
      ''}

      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: ''
          VirtualHost "${v.domain}"
            enabled = ${boolToString v.enabled};
            ${optionalString (v.ssl != null) (createSSLOptsStr v.ssl)}
            ${v.extraConfig}
        '') cfg.virtualHosts
      )}
    '';
in
{
  options = {
    services.prosody = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the prosody server";
      };

      checkConfig = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Check the configuration file with `prosodyctl check config`";
      };

      xmppComplianceSuite = mkOption {
        type = types.bool;
        default = true;
        description = ''
          The XEP-0423 defines a set of recommended XEPs to implement
          for a server. It's generally a good idea to implement this
          set of extensions if you want to provide your users with a
          good XMPP experience.

          This NixOS module aims to provide a "advanced server"
          experience as per defined in the XEP-0423[1] specification.

          Setting this option to true will prevent you from building a
          NixOS configuration which won't comply with this standard.
          You can explicitly decide to ignore this standard if you
          know what you are doing by setting this option to false.

          [1] https://xmpp.org/extensions/xep-0423.html
        '';
      };

      package = mkPackageOption pkgs "prosody" {
        example = ''
          pkgs.prosody.override {
            withExtraLibs = [ pkgs.luaPackages.lpty ];
            withCommunityModules = [ "auth_external" ];
          };
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/prosody";
        description = ''
          The prosody home directory used to store all data. If left as the default value
          this directory will automatically be created before the prosody server starts, otherwise
          you are responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      disco_items = mkOption {
        type = types.listOf (types.submodule discoOpts);
        default = [ ];
        description = "List of discoverable items you want to advertise.";
      };

      user = mkOption {
        type = types.str;
        default = "prosody";
        description = ''
          User account under which prosody runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the prosody service starts.
          :::
        '';
      };

      group = mkOption {
        type = types.str;
        default = "prosody";
        description = ''
          Group account under which prosody runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the group exists before the prosody service starts.
          :::
        '';
      };

      allowRegistration = mkOption {
        type = types.bool;
        default = false;
        description = "Allow account creation";
      };

      # HTTP server-related options
      httpPorts = mkOption {
        type = types.listOf types.port;
        description = "Listening HTTP ports list for this service.";
        default = [ 5280 ];
      };

      httpInterfaces = mkOption {
        type = types.listOf types.str;
        default = [
          "*"
          "::"
        ];
        description = "Interfaces on which the HTTP server will listen on.";
      };

      httpsPorts = mkOption {
        type = types.listOf types.port;
        description = "Listening HTTPS ports list for this service.";
        default = [ 5281 ];
      };

      httpsInterfaces = mkOption {
        type = types.listOf types.str;
        default = [
          "*"
          "::"
        ];
        description = "Interfaces on which the HTTPS server will listen on.";
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
          For more information see <https://prosody.im/doc/s2s#security>
        '';
      };

      s2sInsecureDomains = mkOption {
        type = types.listOf types.str;
        default = [ ];
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
        default = [ ];
        example = [ "jabber.org" ];
        description = ''
          Even if you leave s2s_secure_auth disabled, you can still require valid
          certificates for some domains by specifying a list here.
        '';
      };

      modules = moduleOpts;

      extraModules = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Enable custom modules";
      };

      extraPluginPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "Additional path in which to look find plugins/modules";
      };

      httpFileShare = mkOption {
        description = ''
          Configures the http_file_share module to handle user uploads.

          See <https://prosody.im/doc/modules/mod_http_file_share> for a full list of options.
        '';
        type = types.nullOr (types.submodule httpFileShareOpts);
        default = null;
        example = {
          domain = "uploads.my-xmpp-example-host.org";
        };
      };

      muc = mkOption {
        type = types.listOf (types.submodule mucOpts);
        default = [ ];
        example = [
          {
            domain = "conference.my-xmpp-example-host.org";
          }
        ];
        description = "Multi User Chat (MUC) configuration";
      };

      virtualHosts = mkOption {

        description = "Define the virtual hosts";

        type = with types; attrsOf (submodule vHostOpts);

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
        default = [ ];
        example = [
          "admin1@example.com"
          "admin2@example.com"
        ];
        description = "List of administrators of the current host";
      };

      authentication = mkOption {
        type = types.enum [
          "internal_plain"
          "internal_hashed"
          "cyrus"
          "anonymous"
        ];
        default = "internal_hashed";
        example = "internal_plain";
        description = "Authentication mechanism used for logins.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional prosody configuration

          The generated file is processed by `envsubst` to allow secrets to be passed securely via environment variables.
        '';
      };

      log = mkOption {
        type = types.lines;
        default = ''"*syslog"'';
        description = "Logging configuration. See [](https://prosody.im/doc/logging) for more details";
        example = ''
          {
            { min = "warn"; to = "*syslog"; };
          }
        '';
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "prosody" "uploadHttp" ]
      "mod_http_upload has been obsoloted and been replaced by mod_http_file_share which can be configured with httpFileShare options."
    )
  ];

  config = mkIf cfg.enable {
    assertions =
      let
        genericErrMsg = ''

          Having a server not XEP-0423-compliant might make your XMPP
          experience terrible. See the NixOS manual for further
          information.

          If you know what you're doing, you can disable this warning by
          setting config.services.prosody.xmppComplianceSuite to false.
        '';
        errors = [
          {
            assertion = (builtins.length cfg.muc > 0) || !cfg.xmppComplianceSuite;
            message = ''
              You need to setup at least a MUC domain to comply with
              XEP-0423.
            ''
            + genericErrMsg;
          }
          {
            assertion = cfg.httpFileShare != null || !cfg.xmppComplianceSuite;
            message = ''
              You need to setup http_file_share modules through config.services.prosody.httpFileShare to comply with XEP-0423.
            ''
            + genericErrMsg;
          }
        ];
      in
      errors;

    environment.systemPackages = [ cfg.package ];

    # prevent error if not all certs are configured by the user
    environment.etc."prosody/certs/.dummy".text = "";

    environment.etc."prosody/prosody.cfg.lua".source =
      if cfg.checkConfig then
        pkgs.runCommandLocal "prosody.cfg.lua"
          {
            nativeBuildInputs = [ cfg.package ];
          }
          ''
            cp ${configFile} prosody.cfg.lua
            # Replace the hardcoded path to cacerts with one that is accessible in the build sandbox
            sed 's|/etc/ssl/certs/ca-bundle.crt|${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt|' -i prosody.cfg.lua
            # For some reason prosody hard fails to "find" certificates when this directory does not exist
            mkdir certs
            prosodyctl --config ./prosody.cfg.lua check config
            cp prosody.cfg.lua $out
          ''
      else
        configFile;

    users.users.prosody = mkIf (cfg.user == "prosody") {
      uid = config.ids.uids.prosody;
      description = "Prosody user";
      inherit (cfg) group;
      home = cfg.dataDir;
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
      preStart = ''
        ${pkgs.envsubst}/bin/envsubst -i ${
          config.environment.etc."prosody/prosody.cfg.lua".source
        } -o /run/prosody/prosody.cfg.lua
      '';
      serviceConfig = mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          Type = "simple";
          RuntimeDirectory = "prosody";
          PIDFile = "/run/prosody/prosody.pid";
          Environment = "PROSODY_CONFIG=/run/prosody/prosody.cfg.lua";
          ExecStart = "${lib.getExe cfg.package} -F";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-abnormal";

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        }
        (mkIf (cfg.dataDir == "/var/lib/prosody") {
          StateDirectory = "prosody";
        })
      ];
    };
  };

  meta.doc = ./prosody.md;
}
