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
      default = true;
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

  toLua = x:
    if builtins.isString x then ''"${x}"''
    else if builtins.isBool x then boolToString x
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

  mucOpts = { ... }: {
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
        type = types.enum [ true false "admin" "local" ];
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
          Timout after which the room is destroyed or unlocked if not
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

      vcard_muc = mkOption {
        type = types.bool;
        default = true;
      description = "Adds the ability to set vCard for Multi User Chat rooms";
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

  uploadHttpOpts = { ... }: {
    options = {
      domain = mkOption {
        type = types.nullOr types.str;
        description = "Domain name for the http-upload service";
      };
      uploadFileSizeLimit = mkOption {
        type = types.str;
        default = "50 * 1024 * 1024";
        description = "Maximum file size, in bytes. Defaults to 50MB.";
      };
      uploadExpireAfter = mkOption {
        type = types.str;
        default = "60 * 60 * 24 * 7";
        description = "Max age of a file before it gets deleted, in seconds.";
      };
      userQuota = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 1234;
        description = ''
          Maximum size of all uploaded files per user, in bytes. There
          will be no quota if this option is set to null.
        '';
      };
      httpUploadPath = mkOption {
        type = types.str;
        description = ''
          Directory where the uploaded files will be stored. By
          default, uploaded files are put in a sub-directory of the
          default Prosody storage path (usually /var/lib/prosody).
        '';
        default = "/var/lib/prosody";
      };
    };
  };

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
          You can explicitely decide to ignore this standard if you
          know what you are doing by setting this option to false.

          [1] https://xmpp.org/extensions/xep-0423.html
        '';
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
        type = types.path;
        description = "Directory where Prosody stores its data";
        default = "/var/lib/prosody";
      };

      disco_items = mkOption {
        type = types.listOf (types.submodule discoOpts);
        default = [];
        description = "List of discoverable items you want to advertise.";
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

      # HTTP server-related options
      httpPorts = mkOption {
        type = types.listOf types.int;
        description = "Listening HTTP ports list for this service.";
        default = [ 5280 ];
      };

      httpInterfaces = mkOption {
        type = types.listOf types.str;
        default = [ "*" "::" ];
        description = "Interfaces on which the HTTP server will listen on.";
      };

      httpsPorts = mkOption {
        type = types.listOf types.int;
        description = "Listening HTTPS ports list for this service.";
        default = [ 5281 ];
      };

      httpsInterfaces = mkOption {
        type = types.listOf types.str;
        default = [ "*" "::" ];
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

      uploadHttp = mkOption {
        description = ''
          Configures the Prosody builtin HTTP server to handle user uploads.
        '';
        type = types.nullOr (types.submodule uploadHttpOpts);
        default = null;
        example = {
          domain = "uploads.my-xmpp-example-host.org";
        };
      };

      muc = mkOption {
        type = types.listOf (types.submodule mucOpts);
        default = [ ];
        example = [ {
          domain = "conference.my-xmpp-example-host.org";
        } ];
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
        default = [];
        example = [ "admin1@example.com" "admin2@example.com" ];
        description = "List of administrators of the current host";
      };

      authentication = mkOption {
        type = types.enum [ "internal_plain" "internal_hashed" "cyrus" "anonymous" ];
        default = "internal_hashed";
        example = "internal_plain";
        description = "Authentication mechanism used for logins.";
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

    assertions = let
      genericErrMsg = ''

          Having a server not XEP-0423-compliant might make your XMPP
          experience terrible. See the NixOS manual for further
          informations.

          If you know what you're doing, you can disable this warning by
          setting config.services.prosody.xmppComplianceSuite to false.
      '';
      errors = [
        { assertion = (builtins.length cfg.muc > 0) || !cfg.xmppComplianceSuite;
          message = ''
            You need to setup at least a MUC domain to comply with
            XEP-0423.
          '' + genericErrMsg;}
        { assertion = cfg.uploadHttp != null || !cfg.xmppComplianceSuite;
          message = ''
            You need to setup the uploadHttp module through
            config.services.prosody.uploadHttp to comply with
            XEP-0423.
          '' + genericErrMsg;}
      ];
    in errors;

    environment.systemPackages = [ cfg.package ];

    environment.etc."prosody/prosody.cfg.lua".text =
      let
        httpDiscoItems = if (cfg.uploadHttp != null)
            then [{ url = cfg.uploadHttp.domain; description = "HTTP upload endpoint";}]
            else [];
        mucDiscoItems = builtins.foldl'
            (acc: muc: [{ url = muc.domain; description = "${muc.domain} MUC endpoint";}] ++ acc)
            []
            cfg.muc;
        discoItems = cfg.disco_items ++ httpDiscoItems ++ mucDiscoItems;
      in ''

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

        ${ lib.concatStringsSep "\n  " (lib.mapAttrsToList
          (name: val: optionalString val "${toLua name};")
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
            modules_enabled = { "muc_mam"; ${optionalString muc.vcard_muc ''"vcard_muc";'' } }
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
      };
    };

  };
  meta.doc = ./prosody.xml;
}
