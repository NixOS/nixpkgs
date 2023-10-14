{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkChangedOptionModule mkDefault mkEnableOption mkForce mkIf mkMerge mkOption mkRenamedOptionModule;
  inherit (lib) all any attrValues boolToString concatStringsSep filterAttrs genAttrs hasPrefix listToAttrs literalExpression mapAttrsToList mdDoc optionals optionalAttrs optionalString types unique;

  config' = config;
  cfg = config.services.prosody;

  luaType = with types; let
    valueType = nullOr (oneOf [
      bool
      int
      float
      str
      path
      (attrsOf valueType)
      (listOf valueType)
    ]) // {
      description = "Lua value";
    };
  in valueType;

  sslOption = mkOption {
    type = with types; nullOr (submodule {
      freeformType = luaType;
      options = {

        key = mkOption {
          type = types.str;
          description = mdDoc ''
            Path to your private key file.
          '';
        };

        certificate = mkOption {
          type = types.str;
          description = mdDoc ''
            Path to your certificate file.
          '';
        };

        cafile = mkOption {
          type = types.str;
          default = "/etc/ssl/certs/ca-bundle.crt";
          description = mdDoc ''
            Path to a file containing root certificates that you wish Prosody to trust.
          '';
        };

      };
    });
    default = null;
    description = mdDoc ''
      Advanced SSL/TLS configuration, as described by <https://prosody.im/doc/advanced_ssl_config>.

      ::: {.note}
      Prosody passes the contents of the `ssl` option from the config file almost directly to LuaSec, the
      library used for SSL/TLS support in Prosody. LuaSec accepts a range of options here, mostly things
      that it passes directly to OpenSSL. It is recommended to leave Prosody's defaults in most cases, unless
      you know what you are doing.
      You could easily reduce security or introduce unnecessary compatibility issues with clients and other servers!
      :::
    '';
  };

  componentsOption = mkOption {
    type = with types; attrsOf (submodule ({ name, config, ... }: {
      options = {
        module = mkOption {
          type = with types; nullOr str;
          default = null;
          description = mdDoc ''
            The name of the plugin you wish to use for the component if internal, or `null` if the
            component is an external component.
          '';
        };

        settings = mkOption {
          type = luaType;
          default = {};
          description = mdDoc ''
            Values specified here are applied to a specific component. Refer to <https://prosody.im/doc/components>
            for additional details.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = mdDoc ''
            Additional component specific configuration.
          '';
        };

      };

      config.settings = mkMerge [
        (mkIf (config.module == "http_upload") {
          http_upload_path = mkIf (config.module == "http_upload_path") cfg.dataDir;
        })
        (mkIf (config.module == "muc") {
          modules_enabled = [ "muc_mam" ];
        })
      ];
    }));
    default = { };
    description = mdDoc ''
      Components are extra services on a server which are available to clients, usually on a subdomain
      of the main server (such as mycomponent.example.com). Example components might be chatroom
      servers, user directories, or gateways to other protocols.

      See <https://prosody.im/doc/components> for details.
    '';
  };

  acmeHosts = unique (mapAttrsToList (domain: hostOpts: hostOpts.useACMEHost) (filterAttrs (_: v: v.useACMEHost != null) cfg.virtualHosts));
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "prosody" "allowRegistration" ] [ "services" "prosody" "settings" "allow_registration" ])
    (mkRenamedOptionModule [ "services" "prosody" "httpPorts" ] [ "services" "prosody" "settings" "http_ports" ])
    (mkRenamedOptionModule [ "services" "prosody" "httpInterfaces" ] [ "services" "prosody" "settings" "http_interfaces" ])
    (mkRenamedOptionModule [ "services" "prosody" "httpsPorts" ] [ "services" "prosody" "settings" "https_ports" ])
    (mkRenamedOptionModule [ "services" "prosody" "httpsInterfaces" ] [ "services" "prosody" "settings" "https_interfaces" ])
    (mkRenamedOptionModule [ "services" "prosody" "c2sRequireEncryption" ] [ "services" "prosody" "settings" "c2s_require_encryption" ])
    (mkRenamedOptionModule [ "services" "prosody" "s2sRequireEncryption" ] [ "services" "prosody" "settings" "s2s_require_encryption" ])
    (mkRenamedOptionModule [ "services" "prosody" "s2sSecureAuth" ] [ "services" "prosody" "settings" "s2s_secure_auth" ])
    (mkRenamedOptionModule [ "services" "prosody" "s2sInsecureDomains" ] [ "services" "prosody" "settings" "s2s_insecure_domains" ])
    (mkRenamedOptionModule [ "services" "prosody" "s2sSecureDomains" ] [ "services" "prosody" "settings" "s2s_secure_domains" ])
    (mkRenamedOptionModule [ "services" "prosody" "extraModules" ] [ "services" "prosody" "settings" "modules_enabled" ])
    (mkRenamedOptionModule [ "services" "prosody" "extraPluginPaths" ] [ "services" "prosody" "settings" "plugin_paths" ])
    (mkRenamedOptionModule [ "services" "prosody" "ssl" "key" ] [ "services" "prosody" "settings" "ssl" "key" ])
    (mkRenamedOptionModule [ "services" "prosody" "ssl" "cert" ] [ "services" "prosody" "settings" "ssl" "certificate" ])
    (mkRenamedOptionModule [ "services" "prosody" "ssl" "extraOptions" ] [ "services" "prosody" "settings" "ssl" ])
    (mkRenamedOptionModule [ "services" "prosody" "admins" ] [ "services" "prosody" "settings" "admins" ])
    (mkRenamedOptionModule [ "services" "prosody" "authentication" ] [ "services" "prosody" "settings" "authentication" ])
    (mkChangedOptionModule [ "services" "prosody" "disco_items" ] [ "services" "prosody" "settings" "disco_items" ] (config:
      map ({ url, description }: [ url description ]) config.services.prosody.disco_items
    ))
    (mkChangedOptionModule [ "services" "prosody" "uploadHttp" ] [ "services" "prosody" "components" ] (config:
      let
        cfg = config.services.prosody;
      in
      {
        ${cfg.uploadHttp.domain} = {
          module = "http_upload";
          # these values are to preserve compatibility with this module pre nixos 23.11
          settings = {
            http_upload_file_size_limit = cfg.uploadHttp.uploadFileSizeLimit or 50 * 1024 * 1024;
            http_upload_expire_after = cfg.uploadHttp.uploadExpireAfter or 60 * 60 * 24 * 7;
            http_upload_path = cfg.uploadHttp.httpUploadPath or "/var/lib/prosody";
          } // optionalAttrs (cfg.uploadHttp ? userQuota) {
            http_upload_quota = cfg.uploadHttp.userQuota;
          };
        };
      }
    ))
    (mkChangedOptionModule [ "services" "prosody" "muc" ] [ "services" "prosody" "components" ] (config:
      listToAttrs (map (muc: {
        name = muc.domain;
        value = {
          module = "muc";
          extraConfig = muc.extraConfig or "";
          # these values are to preserve compatibility with this module pre nixos 23.11
          settings = {
            modules_enabled = optionals (muc.vcard_muc or true) [ "vcard_muc" ];
            name = muc.name or "Prosody Chatrooms";
            restrict_room_creation = muc.restrictRoomCreation or "local";
            max_history_messages = muc.maxHistoryMessages or 20;
            muc_room_locking = muc.roomLocking or true;
            muc_room_lock_timeout = muc.roomLockTimeout or 300;
            muc_tombstones = muc.tombstones or true;
            muc_tombstone_expiry = muc.tombstoneExpiry or 2678400;
            muc_room_default_public = muc.roomDefaultPublic or true;
            muc_room_default_members_only = muc.roomDefaultMembersOnly or false;
            muc_room_default_moderated = muc.roomDefaultModerated or false;
            muc_room_default_public_jids = muc.roomDefaultPublicJids or false;
            muc_room_default_change_subject = muc.roomDefaultChangeSubject or false;
            muc_room_default_history_length = muc.roomDefaultHistoryLength or 20;
            muc_room_default_language = muc.roomDefaultLanguage or "en";
          };
        };
      }) config.services.prosody.muc)
    ))
  ];

  options.services.prosody = {
    enable = mkEnableOption "Prosody, the modern XMPP communication server";

    xmppComplianceSuite = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc ''
        The XEP-0423 defines a set of recommended XEPs to implement
        for a server. It's generally a good idea to implement this
        set of extensions if you want to provide your users with a
        good XMPP experience.

        This NixOS module aims to provide an "advanced server"
        experience as per defined in the [XEP-0423](https://xmpp.org/extensions/xep-0423.html) specification.

        Setting this option to `true` will prevent you from building a
        NixOS configuration which won't comply with this standard.
        You can explicitly decide to ignore this standard if you
        know what you are doing by setting this option to `false`.
      '';
    };

    package = mkOption {
      type = types.package;
      description = mdDoc "Prosody package to use.";
      default = pkgs.prosody;
      defaultText = literalExpression "pkgs.prosody";
      example = literalExpression ''
        pkgs.prosody.override {
          withExtraLibs = [ pkgs.luaPackages.lpty ];
          withCommunityModules = [ "auth_external" ];
        };
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/prosody";
      description = mdDoc ''
        The Prosody home directory used to store all data.

        ::: {.note}
        If left as the default value this directory will automatically be created
        before the Prosody server starts, otherwise you are responsible for
        ensuring the directory exists with appropriate ownership and permissions.
        :::
      '';
    };

    user = mkOption {
      type = types.str;
      default = "prosody";
      description = mdDoc ''
        User account under which Prosody runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the Prosody service starts.
        :::
      '';
    };

    group = mkOption {
      type = types.str;
      default = "prosody";
      description = mdDoc ''
        Group account under which Prosody runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the Prosody service starts.
        :::
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = mdDoc ''
        File which may contain secrets in the format of an EnvironmentFile as described
        by systemd.exec(5). Variables here can be used in the Prosody configuration
        file by prefixing the environment variable name with `ENV_` in the configuration.

        ::: {.note}
        Environment variables in this file should *not* begin with an `ENV_` prefix, only
        when referenced in the Prosody configuration file.
        :::
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Whether to automatically open ports specified by the following options:

        - {option}`services.prosody.settings.c2s_ports`
        - {option}`services.prosody.settings.s2s_ports`
        - {option}`services.prosody.settings.https_ports`
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = luaType;
        options = {

          modules_enabled = mkOption {
            type = with types; listOf str;
            apply = x: unique x;
            default = [];
            description = mdDoc ''
              List of modules to load for all virtual hosts.
            '';
          };

          modules_disabled = mkOption {
            type = with types; listOf str;
            apply = x: unique x;
            default = [];
            description = mdDoc ''
              Allows you to disable the loading of a list of modules for all virtual hosts
              if those modules are set in the global settings.
            '';
          };

          ssl = sslOption;

        };
      };
      default = {};
      description = mdDoc ''
        Values specified here are applied to the whole server, and are the default for all
        virtual hosts. Refer to <https://prosody.im/doc/configure> for additional details.

        ::: {.note}
        It's also possible to refer to environment variables (defined in
        [services.prosody.environmentFile](#opt-services.prosody.environmentFile)) using the
        syntax `"ENV_VARIABLE_NAME"` where the environment file contains a `VARIABLE_NAME` entry.
        :::
      '';
      example = literalExpression ''
        {
          modules_enabled = [ "turn_external" ];
          turn_external_host = "turn.example.com";
          turn_external_port = 3478;
          turn_external_secret = "ENV_TURN_EXTERNAL_SECRET";
        }
      '';
    };

    components = componentsOption;

    virtualHosts = let config' = config; in mkOption {
      type = with types; attrsOf (submodule ({ name, config, ... }: {
        options = {
          domain = mkOption {
            type = types.str;
            default = name;
            description = mdDoc "Domain name.";
          };

          useACMEHost = mkOption {
            type = with types; nullOr str;
            default = null;
            description = mdDoc ''
              A host of an existing Let's Encrypt certificate to use.

              ::: {.note}
              Note that this option does not create any certificates, nor it does add subdomains to existing
              ones – you will need to create them manually using [](#opt-security.acme.certs).
              :::
            '';
          };

          components = componentsOption;

          settings = mkOption {
            type = types.submodule {
              freeformType = luaType;
              options = {

                enabled = mkOption {
                  type = types.bool;
                  default = true;
                  description = mdDoc ''
                    Specifies whether this host is enabled or not. Disabled hosts are not loaded and
                    do not accept connections while Prosody is running.
                  '';
                };

                modules_enabled = mkOption {
                  type = with types; listOf str;
                  apply = x: unique x;
                  default = [];
                  description = mdDoc ''
                    List of modules to load for the virtual host.
                  '';
                };

                modules_disabled = mkOption {
                  type = with types; listOf str;
                  apply = x: unique x;
                  default = [];
                  description = mdDoc ''
                    Allows you to disable the loading of a list of modules for a particular host.
                  '';
                };

                ssl = sslOption;
              };
            };
            default = {};
            description = mdDoc ''
              Values specified here are applied to a specific virtual host and will override values set
              in the global [settings](#opt-services.prosody.settings) option. Refer to <https://prosody.im/doc/configure>
              for additional details.
            '';
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = mdDoc ''
              Additional virtual host specific configuration.
            '';
          };

          # options to preserve compatibility with this module pre nixos 23.11

          enabled = mkOption {
            type = with types; nullOr bool;
            default = null;
            description = mdDoc "Whether to enable the virtual host.";
          };

          ssl = mkOption {
            type = types.nullOr (types.submodule {
              options = {
                key = mkOption {
                  type = types.path;
                  description = lib.mdDoc "Path to the key file.";
                };

                cert = mkOption {
                  type = types.path;
                  description = lib.mdDoc "Path to the certificate file.";
                };

                extraOptions = mkOption {
                  type = types.attrs;
                  default = {};
                  description = lib.mdDoc "Extra SSL configuration options.";
                };
              };
            });
            default = null;
            description = mdDoc "Paths to SSL files.";
          };

        };

        config.settings = {
          ssl = mkMerge [
            (mkIf (config.ssl != null) ({
              key = config.ssl.key;
              certificate = config.ssl.cert;
            } // config.ssl.extraOptions))
            (mkIf (config.useACMEHost != null) {
              key = "${config'.security.acme.certs.${config.useACMEHost}.directory}/key.pem";
              certificate = "${config'.security.acme.certs.${config.useACMEHost}.directory}/fullchain.pem";
            })
          ];

          disco_items =
            mapAttrsToList (k: v: [ k "${k} HTTP upload endpoint" ]) (filterAttrs (k: v: v.module == "http_upload") config.components) ++
            mapAttrsToList (k: v: [ k "${k} MUC endpoint" ]) (filterAttrs (k: v: v.module == "muc") config.components)
          ;

          enabled = mkIf (config.enabled != null) config.enabled;
        };
      }));
      default = {
        localhost = { };
      };
      description = mdDoc ''
        A host in Prosody is a domain on which user accounts can be created. For example if you want your users to have addresses
        like `john.smith@example.com` then you need to add a host `example.com`.
      '';
      example = literalExpression ''
        {
          "example.net" = {
            useACMEHost = "example.net";
            settings = {
              admins = [ "admin1@example.net" "admin2@example.net" ];
              c2s_require_encryption = true;
              modules_enabled = [
                "announce"
              ];
            };
          };
        }
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = mdDoc ''
        Additional prosody configuration.
      '';
    };

    # options to preserve compatibility with this module pre nixos 23.11

    modules = mkOption {
      type = types.attrsOf types.bool;
      default = { };
      description = mdDoc ''
      '';
    };
  };

  config = mkIf cfg.enable {

    assertions =
      let
        checkForModule = mod: b: any (e: e.module == mod) (attrValues b.components);
        virtualHosts = filterAttrs (_: v: v.settings.enabled) cfg.virtualHosts;

        # ensure a given module (e.g. muc or http_upload) is applied or available to every virtual host
        mkAssertion = module: message: {
          assertion = cfg.xmppComplianceSuite -> checkForModule module cfg || all (checkForModule module) (attrValues virtualHosts);
          message = message + ''

            Having a server not XEP-0423-compliant might make your XMPP
            experience terrible. See the NixOS manual for further
            information.

            If you know what you're doing, you can disable this warning by
            setting config.services.prosody.xmppComplianceSuite to false.
          '';
        };
      in
      [
        (mkAssertion "muc" ''
          You need to setup at least a MUC domain to comply with
          XEP-0423
        '')

        (mkAssertion "http_upload" ''
          You need to setup the http_upload module through
          config.services.prosody.components to comply with
          XEP-0423.
        '')
      ];

    warnings =
      optionals (cfg.modules != { }) [ "The option `services.prosody.modules' has been and split into two separate options: `services.prosody.settings.modules_enabled' and `services.prosody.settings.modules_enabled'." ] ++
      mapAttrsToList (k: v: "The option `services.prosody.virtualHosts.${k}.enabled' has been renamed to `services.prosody.virtualHosts.${k}.settings.enabled'.") (filterAttrs (_: v: v.enabled != null) cfg.virtualHosts) ++
      mapAttrsToList (k: v: "The option `services.prosody.virtualHosts.${k}.ssl' has been renamed to `services.prosody.virtualHosts.${k}.settings.ssl'.") (filterAttrs (_: v: v.ssl != null) cfg.virtualHosts)
    ;

    services.prosody.settings = {
      log = mkDefault "*syslog";
      data_path = mkForce cfg.dataDir;
      network_backend = "event";
      pidfile = "/run/prosody/prosody.pid";

      authentication = mkDefault "internal_hashed";
      reload_modules = mkIf (acmeHosts != []) [ "tls" ];

      modules_enabled = [
        # required for compliance with https://compliance.conversations.im/about/
        "dialback"
        "disco"
        "roster"
        "saslauth"
        "tls"

        # not essential, but recommended
        "blocklist"
        "bookmarks"
        "carbons"
        "cloud_notify"
        "csi"
        "pep"
        "private"
        "vcard_legacy"

        # nice to have
        "mam"
        "ping"
        "register"
        "smacks"
        "time"
        "uptime"
        "version"

        # admin interfaces
        "admin_adhoc"
        "http_files"
        "proxy65"
      ] ++ cfg.package.communityModules
        ++ mapAttrsToList (k: _: k) (filterAttrs (_: v: v == true) cfg.modules);

      modules_disabled = mapAttrsToList (k: _: k) (filterAttrs (_: v: v == false) cfg.modules);

      disco_items =
        mapAttrsToList (k: v: [ k "${k} HTTP upload endpoint" ]) (filterAttrs (k: v: v.module == "http_upload") cfg.components) ++
        mapAttrsToList (k: v: [ k "${k} MUC endpoint" ]) (filterAttrs (k: v: v.module == "muc") cfg.components)
      ;

      # mod_tls configuration
      c2s_require_encryption = mkDefault true;
      s2s_require_encryption = mkDefault true;

      # upstream defaults - useful for `services.prosody.openFirewall` logic
      c2s_ports = mkDefault [ 5222 ];
      s2s_ports = mkDefault [ 5269 ];
      https_ports = mkDefault [ 5281 ];
      # TODO:
      # proxy65_ports = [ 5000 ];
    };

    environment.systemPackages = [ cfg.package ];
    environment.etc."prosody/prosody.cfg.lua".text =
      let
        toFormat = attrs: concatStringsSep "\n" (mapAttrsToList (k: v: ''${k} = ${toStr v}'') (filterAttrs (_: v: v != null) attrs));

        toStr = v:
          if builtins.isString v then
            # prosody will directly pass environment variables into its configuration file which have `ENV_` as a prefix
            if hasPrefix "ENV_" v then v else ''"${toString v}"''
          else if builtins.isBool v then boolToString v
          else if builtins.isInt v then toString v
          else if builtins.isList v then ''{ ${concatStringsSep ", " (map (n: toStr n) v)} }''
          else if builtins.isAttrs v then ''{ ${concatStringsSep ", " (mapAttrsToList (a: b: ''["${a}"] = ${toStr b}'') v)} }''
          else throw "Invalid Lua value";

        componentsToStr = components:
          concatStringsSep "\n" (
            mapAttrsToList (domain: component:
              ''
                Component "${domain}" ${optionalString (component.module != null) "\"${component.module}\""}
                ${toFormat component.settings}
                ${component.extraConfig}
              ''
            ) components
          );

        virtualHostsToStr = virtualHosts:
          concatStringsSep "\n" (
            mapAttrsToList (_: virtualHost:
              ''
                VirtualHost "${virtualHost.domain}"
                ${toFormat virtualHost.settings}
                ${virtualHost.extraConfig}

                ${componentsToStr virtualHost.components}
              ''
            ) virtualHosts
          );
      in
      ''
        ${toFormat cfg.settings}
        ${cfg.extraConfig}

        ${componentsToStr cfg.components}
        ${virtualHostsToStr cfg.virtualHosts}
      '';

    systemd.services.prosody = {
      description = "Prosody XMPP server";
      wantedBy = [ "multi-user.target" ];
      before = map (domain: "acme-${domain}.service") acmeHosts;
      after = [ "network-online.target" ] ++ map (domain: "acme-selfsigned-${domain}.service") acmeHosts;
      wants = [ "network-online.target" ] ++ map (domain: "acme-finished-${domain}.target") acmeHosts;

      restartTriggers = [ config.environment.etc."prosody/prosody.cfg.lua".source ];
      serviceConfig = mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          Type = "forking";
          PIDFile = cfg.settings.pidfile;
          ExecStart = "${cfg.package}/bin/prosodyctl start";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

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
          StateDirectoryMode = "0750";
        })
        (mkIf (cfg.settings.pidfile == "/run/prosody/prosody.pid") {
          RuntimeDirectory = [ "prosody" ];
        })
      ];
    };

    security.acme.certs = genAttrs acmeHosts (_: {
      reloadServices = [ "prosody.service" ];
    });

    networking.firewall = optionalAttrs cfg.openFirewall {
      allowedTCPPorts = cfg.settings.c2s_ports
        ++ cfg.settings.s2s_ports
        ++ cfg.settings.https_ports
        # TODO: cfg.settings.proxy65_ports
      ;
    };

    users.users.prosody = mkIf (cfg.user == "prosody") {
      uid = config.ids.uids.prosody;
      description = "Prosody user";
      inherit (cfg) group;
      home = cfg.dataDir;
    };

    users.groups.prosody = mkIf (cfg.group == "prosody") {
      gid = config.ids.gids.prosody;
    };
  };

  meta.doc = ./prosody.md;
}
