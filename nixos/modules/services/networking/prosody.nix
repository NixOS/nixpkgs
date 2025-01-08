{ config, lib, pkgs, ... }:

let
  cfg = config.services.prosody;

  sslOpts = { ... }: {

    options = {

      key = lib.mkOption {
        type = lib.types.path;
        description = "Path to the key file.";
      };

      # TODO: rename to certificate to match the prosody config
      cert = lib.mkOption {
        type = lib.types.path;
        description = "Path to the certificate file.";
      };

      extraOptions = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra SSL configuration options.";
      };

    };
  };

  discoOpts = {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
        description = "URL of the endpoint you want to make discoverable";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "A short description of the endpoint you want to advertise";
      };
    };
  };

  moduleOpts = {
    # Required for compliance with https://compliance.conversations.im/about/
    roster = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow users to have a roster";
    };

    saslauth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Authentication for clients and servers. Recommended if you want to log in.";
    };

    tls = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add support for secure TLS on c2s/s2s connections";
    };

    dialback = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "s2s dialback support";
    };

    disco = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Service discovery";
    };

    # Not essential, but recommended
    carbons = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Keep multiple clients in sync";
    };

    csi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Implements the CSI protocol that allows clients to report their active/inactive state to the server";
    };

    cloud_notify = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Push notifications to inform users of new messages or other pertinent information even when they have no XMPP clients online";
    };

    pep = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enables users to publish their mood, activity, playing music and more";
    };

    private = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Private XML storage (for room bookmarks, etc.)";
    };

    blocklist = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow users to block communications with other users";
    };

    vcard = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow users to set vCards";
    };

    vcard_legacy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Converts users profiles and Avatars between old and new formats";
    };

    bookmarks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allows interop between older clients that use XEP-0048: Bookmarks in its 1.0 version and recent clients which use it in PEP";
    };

    # Nice to have
    version = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Replies to server version requests";
    };

    uptime = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Report how long server has been running";
    };

    time = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Let others know the time here on this server";
    };

    ping = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Replies to XMPP pings with pongs";
    };

    register = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow users to register on this server using a client and change passwords";
    };

    mam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Store messages in an archive and allow users to access it";
    };

    smacks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow a client to resume a disconnected session, and prevent message loss";
    };

    # Admin interfaces
    admin_adhoc = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allows administration via an XMPP client that supports ad-hoc commands";
    };

    http_files = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Serve static files from a directory over HTTP";
    };

    proxy65 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enables a file transfer proxy service which clients behind NAT can use";
    };

    admin_telnet = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Opens telnet console interface on localhost port 5582";
    };

    # HTTP modules
    bosh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable BOSH clients, aka 'Jabber over HTTP'";
    };

    websocket = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable WebSocket support";
    };

    # Other specific functionality
    limits = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bandwidth limiting for XMPP connections";
    };

    groups = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Shared roster support";
    };

    server_contact_info = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Publish contact information for this service";
    };

    announce = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Send announcement to all online users";
    };

    welcome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Welcome users who register accounts";
    };

    watchregistrations = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Alert admins of registrations";
    };

    motd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Send a message to users when they log in";
    };

    legacyauth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Legacy authentication. Only used by some old clients and bots";
    };
  };

  toLua = x:
    if builtins.isString x then ''"${x}"''
    else if builtins.isBool x then lib.boolToString x
    else if builtins.isInt x then toString x
    else if builtins.isList x then "{ ${lib.concatMapStringsSep ", " toLua x} }"
    else throw "Invalid Lua value";

  settingsToLua = prefix: settings: lib.generators.toKeyValue {
    listsAsDuplicateKeys = false;
    mkKeyValue = k: lib.generators.mkKeyValueDefault {
      mkValueString = toLua;
    } " = " (prefix + k);
  } (lib.filterAttrs (k: v: v != null) settings);

  createSSLOptsStr = o: ''
    ssl = {
      cafile = "/etc/ssl/certs/ca-bundle.crt";
      key = "${o.key}";
      certificate = "${o.cert}";
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name} = ${toLua value};") o.extraOptions)}
    };
  '';

  mucOpts = { ... }: {
    options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name of the MUC";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name to return in service discovery responses for the MUC service itself";
        default = "Prosody Chatrooms";
      };
      restrictRoomCreation = lib.mkOption {
        type = lib.types.enum [ true false "admin" "local" ];
        default = false;
        description = "Restrict room creation to server admins";
      };
      maxHistoryMessages = lib.mkOption {
        type = lib.types.int;
        default = 20;
        description = "Specifies a limit on what each room can be configured to keep";
      };
      roomLocking = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enables room locking, which means that a room must be
          configured before it can be used. Locked rooms are invisible
          and cannot be entered by anyone but the creator
        '';
      };
      roomLockTimeout = lib.mkOption {
        type = lib.types.int;
        default = 300;
        description = ''
          Timeout after which the room is destroyed or unlocked if not
          configured, in seconds
       '';
      };
      tombstones = lib.mkOption {
        type = lib.types.bool;
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
      tombstoneExpiry = lib.mkOption {
        type = lib.types.int;
        default = 2678400;
        description = ''
          This settings controls how long a tombstone is considered
          valid. It defaults to 31 days. After this time, the room in
          question can be created again.
        '';
      };

      vcard_muc = lib.mkOption {
        type = lib.types.bool;
        default = true;
      description = "Adds the ability to set vCard for Multi User Chat rooms";
      };

      # Extra parameters. Defaulting to prosody default values.
      # Adding them explicitly to make them visible from the options
      # documentation.
      #
      # See https://prosody.im/doc/modules/mod_muc for more details.
      roomDefaultPublic = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "If set, the MUC rooms will be public by default.";
      };
      roomDefaultMembersOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If set, the MUC rooms will only be accessible to the members by default.";
      };
      roomDefaultModerated = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If set, the MUC rooms will be moderated by default.";
      };
      roomDefaultPublicJids = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If set, the MUC rooms will display the public JIDs by default.";
      };
      roomDefaultChangeSubject = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If set, the rooms will display the public JIDs by default.";
      };
      roomDefaultHistoryLength = lib.mkOption {
        type = lib.types.int;
        default = 20;
        description = "Number of history message sent to participants by default.";
      };
      roomDefaultLanguage = lib.mkOption {
        type = lib.types.str;
        default = "en";
        description = "Default room language.";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional MUC specific configuration";
      };
    };
  };

  uploadHttpOpts = { ... }: {
    options = {
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Domain name for the http-upload service";
      };
      uploadFileSizeLimit = lib.mkOption {
        type = lib.types.str;
        default = "50 * 1024 * 1024";
        description = "Maximum file size, in bytes. Defaults to 50MB.";
      };
      uploadExpireAfter = lib.mkOption {
        type = lib.types.str;
        default = "60 * 60 * 24 * 7";
        description = "Max age of a file before it gets deleted, in seconds.";
      };
      userQuota = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 1234;
        description = ''
          Maximum size of all uploaded files per user, in bytes. There
          will be no quota if this option is set to null.
        '';
      };
      httpUploadPath = lib.mkOption {
        type = lib.types.str;
        description = ''
          Directory where the uploaded files will be stored when the http_upload module is used.
          By default, uploaded files are put in a sub-directory of the default Prosody storage path (usually /var/lib/prosody).
        '';
        default = "/var/lib/prosody";
      };
    };
  };

  httpFileShareOpts = { ... }: {
    freeformType = with lib.types;
      let atom = oneOf [ int bool str (listOf atom) ]; in
      attrsOf (nullOr atom) // {
        description = "int, bool, string or list of them";
      };
    options.domain = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "Domain name for a http_file_share service.";
    };
  };

  vHostOpts = { ... }: {

    options = {

      # TODO: require attribute
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name";
      };

      enabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the virtual host";
      };

      ssl = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule sslOpts);
        default = null;
        description = "Paths to SSL files";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
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

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the prosody server";
      };

      xmppComplianceSuite = lib.mkOption {
        type = lib.types.bool;
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

      package = lib.mkPackageOption pkgs "prosody" {
        example = ''
          pkgs.prosody.override {
            withExtraLibs = [ pkgs.luaPackages.lpty ];
            withCommunityModules = [ "auth_external" ];
          };
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/prosody";
        description = ''
          The prosody home directory used to store all data. If left as the default value
          this directory will automatically be created before the prosody server starts, otherwise
          you are responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      disco_items = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule discoOpts);
        default = [];
        description = "List of discoverable items you want to advertise.";
      };

      user = lib.mkOption {
        type = lib.types.str;
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

      group = lib.mkOption {
        type = lib.types.str;
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

      allowRegistration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow account creation";
      };

      # HTTP server-related options
      httpPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        description = "Listening HTTP ports list for this service.";
        default = [ 5280 ];
      };

      httpInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "*" "::" ];
        description = "Interfaces on which the HTTP server will listen on.";
      };

      httpsPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        description = "Listening HTTPS ports list for this service.";
        default = [ 5281 ];
      };

      httpsInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "*" "::" ];
        description = "Interfaces on which the HTTPS server will listen on.";
      };

      c2sRequireEncryption = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Force clients to use encrypted connections? This option will
          prevent clients from authenticating unless they are using encryption.
        '';
      };

      s2sRequireEncryption = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Force servers to use encrypted connections? This option will
          prevent servers from authenticating unless they are using encryption.
          Note that this is different from authentication.
        '';
      };

      s2sSecureAuth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Force certificate authentication for server-to-server connections?
          This provides ideal security, but requires servers you communicate
          with to support encryption AND present valid, trusted certificates.
          For more information see https://prosody.im/doc/s2s#security
        '';
      };

      s2sInsecureDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "insecure.example.com" ];
        description = ''
          Some servers have invalid or self-signed certificates. You can list
          remote domains here that will not be required to authenticate using
          certificates. They will be authenticated using DNS instead, even
          when s2s_secure_auth is enabled.
        '';
      };

      s2sSecureDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "jabber.org" ];
        description = ''
          Even if you leave s2s_secure_auth disabled, you can still require valid
          certificates for some domains by specifying a list here.
        '';
      };


      modules = moduleOpts;

      extraModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Enable custom modules";
      };

      extraPluginPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = "Additional path in which to look find plugins/modules";
      };

      uploadHttp = lib.mkOption {
        description = ''
          Configures the old Prosody builtin HTTP server to handle user uploads.
        '';
        type = lib.types.nullOr (lib.types.submodule uploadHttpOpts);
        default = null;
        example = {
          domain = "uploads.my-xmpp-example-host.org";
        };
      };

      httpFileShare = lib.mkOption {
        description = ''
          Configures the http_file_share module to handle user uploads.
        '';
        type = lib.types.nullOr (lib.types.submodule httpFileShareOpts);
        default = null;
        example = {
          domain = "uploads.my-xmpp-example-host.org";
        };
      };

      muc = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule mucOpts);
        default = [ ];
        example = [ {
          domain = "conference.my-xmpp-example-host.org";
        } ];
        description = "Multi User Chat (MUC) configuration";
      };

      virtualHosts = lib.mkOption {

        description = "Define the virtual hosts";

        type = with lib.types; attrsOf (submodule vHostOpts);

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

      ssl = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule sslOpts);
        default = null;
        description = "Paths to SSL files";
      };

      admins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "admin1@example.com" "admin2@example.com" ];
        description = "List of administrators of the current host";
      };

      authentication = lib.mkOption {
        type = lib.types.enum [ "internal_plain" "internal_hashed" "cyrus" "anonymous" ];
        default = "internal_hashed";
        example = "internal_plain";
        description = "Authentication mechanism used for logins.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional prosody configuration";
      };

      log = lib.mkOption {
        type = lib.types.lines;
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


  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = let
      genericErrMsg = ''

          Having a server not XEP-0423-compliant might make your XMPP
          experience terrible. See the NixOS manual for further
          information.

          If you know what you're doing, you can disable this warning by
          setting config.services.prosody.xmppComplianceSuite to false.
      '';
      errors = [
        { assertion = (builtins.length cfg.muc > 0) || !cfg.xmppComplianceSuite;
          message = ''
            You need to setup at least a MUC domain to comply with
            XEP-0423.
          '' + genericErrMsg;}
        { assertion = cfg.uploadHttp != null || cfg.httpFileShare != null || !cfg.xmppComplianceSuite;
          message = ''
            You need to setup the http_upload or http_file_share modules through config.services.prosody.uploadHttp
            or config.services.prosody.httpFileShare to comply with XEP-0423.
          '' + genericErrMsg;}
      ];
    in errors;

    environment.systemPackages = [ cfg.package ];

    environment.etc."prosody/prosody.cfg.lua".text =
      let
        httpDiscoItems = lib.optional (cfg.uploadHttp != null) {
          url = cfg.uploadHttp.domain; description = "HTTP upload endpoint";
        } ++ lib.optional (cfg.httpFileShare != null) {
          url = cfg.httpFileShare.domain; description = "HTTP file share endpoint";
        };
        mucDiscoItems = builtins.foldl'
            (acc: muc: [{ url = muc.domain; description = "${muc.domain} MUC endpoint";}] ++ acc)
            []
            cfg.muc;
        discoItems = cfg.disco_items ++ httpDiscoItems ++ mucDiscoItems;
      in ''

      pidfile = "/run/prosody/prosody.pid"

      log = ${cfg.log}

      data_path = "${cfg.dataDir}"
      plugin_paths = {
        ${lib.concatStringsSep ", " (map (n: "\"${n}\"") cfg.extraPluginPaths) }
      }

      ${ lib.optionalString  (cfg.ssl != null) (createSSLOptsStr cfg.ssl) }

      admins = ${toLua cfg.admins}

      modules_enabled = {

        ${ lib.concatStringsSep "\n  " (lib.mapAttrsToList
          (name: val: lib.optionalString val "${toLua name};")
        cfg.modules) }
        ${ lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.package.communityModules)}
        ${ lib.concatStringsSep "\n" (map (x: "${toLua x};") cfg.extraModules)}
      };

      disco_items = {
      ${ lib.concatStringsSep "\n" (builtins.map (x: ''{ "${x.url}", "${x.description}"};'') discoItems)}
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

      ${ cfg.extraConfig }

      ${lib.concatMapStrings (muc: ''
        Component ${toLua muc.domain} "muc"
            modules_enabled = { "muc_mam"; ${lib.optionalString muc.vcard_muc ''"vcard_muc";'' } }
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
            ${ muc.extraConfig }
        '') cfg.muc}

      ${ lib.optionalString (cfg.uploadHttp != null) ''
        Component ${toLua cfg.uploadHttp.domain} "http_upload"
            http_upload_file_size_limit = ${cfg.uploadHttp.uploadFileSizeLimit}
            http_upload_expire_after = ${cfg.uploadHttp.uploadExpireAfter}
            ${lib.optionalString (cfg.uploadHttp.userQuota != null) "http_upload_quota = ${toLua cfg.uploadHttp.userQuota}"}
            http_upload_path = ${toLua cfg.uploadHttp.httpUploadPath}
      ''}

      ${lib.optionalString (cfg.httpFileShare != null) ''
        Component ${toLua cfg.httpFileShare.domain} "http_file_share"
        ${settingsToLua "  http_file_share_" (cfg.httpFileShare // { domain = null; })}
      ''}

      ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: ''
        VirtualHost "${v.domain}"
          enabled = ${lib.boolToString v.enabled};
          ${ lib.optionalString (v.ssl != null) (createSSLOptsStr v.ssl) }
          ${ v.extraConfig }
        '') cfg.virtualHosts) }
    '';

    users.users.prosody = lib.mkIf (cfg.user == "prosody") {
      uid = config.ids.uids.prosody;
      description = "Prosody user";
      inherit (cfg) group;
      home = cfg.dataDir;
    };

    users.groups.prosody = lib.mkIf (cfg.group == "prosody") {
      gid = config.ids.gids.prosody;
    };

    systemd.services.prosody = {
      description = "Prosody XMPP server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."prosody/prosody.cfg.lua".source ];
      serviceConfig = lib.mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          Type = "forking";
          RuntimeDirectory = [ "prosody" ];
          PIDFile = "/run/prosody/prosody.pid";
          ExecStart = "${cfg.package}/bin/prosodyctl start";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

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
        (lib.mkIf (cfg.dataDir == "/var/lib/prosody") {
          StateDirectory = "prosody";
        })
      ];
    };

  };

  meta.doc = ./prosody.md;
}
