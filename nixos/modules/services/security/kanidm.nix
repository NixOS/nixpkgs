{ config, lib, options, pkgs, ... }:
let
  cfg = config.services.kanidm;
  settingsFormat = pkgs.formats.toml { };
  # Remove null values, so we can document optional values that don't end up in the generated TOML file.
  filterConfig = lib.converge (lib.filterAttrsRecursive (_: v: v != null));
  serverConfigFile = settingsFormat.generate "server.toml" (filterConfig cfg.serverSettings);
  clientConfigFile = settingsFormat.generate "kanidm-config.toml" (filterConfig cfg.clientSettings);
  unixConfigFile = settingsFormat.generate "kanidm-unixd.toml" (filterConfig cfg.unixSettings);
  certPaths = builtins.map builtins.dirOf [ cfg.serverSettings.tls_chain cfg.serverSettings.tls_key ];

  # Merge bind mount paths and remove paths where a prefix is already mounted.
  # This makes sure that if e.g. the tls_chain is in the nix store and /nix/store is already in the mount
  # paths, no new bind mount is added. Adding subpaths caused problems on ofborg.
  hasPrefixInList = list: newPath: lib.any (path: lib.hasPrefix (builtins.toString path) (builtins.toString newPath)) list;
  mergePaths = lib.foldl' (merged: newPath: let
      # If the new path is a prefix to some existing path, we need to filter it out
      filteredPaths = lib.filter (p: !lib.hasPrefix (builtins.toString newPath) (builtins.toString p)) merged;
      # If a prefix of the new path is already in the list, do not add it
      filteredNew = lib.optional (!hasPrefixInList filteredPaths newPath) newPath;
    in filteredPaths ++ filteredNew) [];

  defaultServiceConfig = {
    BindReadOnlyPaths = [
      "/nix/store"
      "-/etc/resolv.conf"
      "-/etc/nsswitch.conf"
      "-/etc/hosts"
      "-/etc/localtime"
    ];
    CapabilityBoundingSet = [];
    # ProtectClock= adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    # Implies ProtectSystem=strict, which re-mounts all paths
    # DynamicUser = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateNetwork = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    # Would re-mount paths ignored by temporary root
    #ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [ ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
    # Does not work well with the temporary root
    #UMask = "0066";
  };

in
{
  options.services.kanidm = {
    enableClient = lib.mkEnableOption (lib.mdDoc "the Kanidm client");
    enableServer = lib.mkEnableOption (lib.mdDoc "the Kanidm server");
    enablePam = lib.mkEnableOption (lib.mdDoc "the Kanidm PAM and NSS integration");

    package = lib.mkPackageOption pkgs "kanidm" {};

    serverSettings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          bindaddress = lib.mkOption {
            description = lib.mdDoc "Address/port combination the webserver binds to.";
            example = "[::1]:8443";
            type = lib.types.str;
          };
          # Should be optional but toml does not accept null
          ldapbindaddress = lib.mkOption {
            description = lib.mdDoc ''
              Address and port the LDAP server is bound to. Setting this to `null` disables the LDAP interface.
            '';
            example = "[::1]:636";
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
          origin = lib.mkOption {
            description = lib.mdDoc "The origin of your Kanidm instance. Must have https as protocol.";
            example = "https://idm.example.org";
            type = lib.types.strMatching "^https://.*";
          };
          domain = lib.mkOption {
            description = lib.mdDoc ''
              The `domain` that Kanidm manages. Must be below or equal to the domain
              specified in `serverSettings.origin`.
              This can be left at `null`, only if your instance has the role `ReadOnlyReplica`.
              While it is possible to change the domain later on, it requires extra steps!
              Please consider the warnings and execute the steps described
              [in the documentation](https://kanidm.github.io/kanidm/stable/administrivia.html#rename-the-domain).
            '';
            example = "example.org";
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
          db_path = lib.mkOption {
            description = lib.mdDoc "Path to Kanidm database.";
            default = "/var/lib/kanidm/kanidm.db";
            readOnly = true;
            type = lib.types.path;
          };
          tls_chain = lib.mkOption {
            description = lib.mdDoc "TLS chain in pem format.";
            type = lib.types.path;
          };
          tls_key = lib.mkOption {
            description = lib.mdDoc "TLS key in pem format.";
            type = lib.types.path;
          };
          log_level = lib.mkOption {
            description = lib.mdDoc "Log level of the server.";
            default = "info";
            type = lib.types.enum [ "info" "debug" "trace" ];
          };
          role = lib.mkOption {
            description = lib.mdDoc "The role of this server. This affects the replication relationship and thereby available features.";
            default = "WriteReplica";
            type = lib.types.enum [ "WriteReplica" "WriteReplicaNoUI" "ReadOnlyReplica" ];
          };
        };
      };
      default = { };
      description = lib.mdDoc ''
        Settings for Kanidm, see
        [the documentation](https://kanidm.github.io/kanidm/stable/server_configuration.html)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/server.toml)
        for possible values.
      '';
    };

    clientSettings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options.uri = lib.mkOption {
          description = lib.mdDoc "Address of the Kanidm server.";
          example = "http://127.0.0.1:8080";
          type = lib.types.str;
        };
      };
      description = lib.mdDoc ''
        Configure Kanidm clients, needed for the PAM daemon. See
        [the documentation](https://kanidm.github.io/kanidm/stable/client_tools.html#kanidm-configuration)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/config)
        for possible values.
      '';
    };

    unixSettings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options.pam_allowed_login_groups = lib.mkOption {
          description = lib.mdDoc "Kanidm groups that are allowed to login using PAM.";
          example = "my_pam_group";
          type = lib.types.listOf lib.types.str;
        };
      };
      description = lib.mdDoc ''
        Configure Kanidm unix daemon.
        See [the documentation](https://kanidm.github.io/kanidm/stable/integrations/pam_and_nsswitch.html#the-unix-daemon)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/unixd)
        for possible values.
      '';
    };
  };

  config = lib.mkIf (cfg.enableClient || cfg.enableServer || cfg.enablePam) {
    assertions =
      [
        {
          assertion = !cfg.enableServer || ((cfg.serverSettings.tls_chain or null) == null) || (!lib.isStorePath cfg.serverSettings.tls_chain);
          message = ''
            <option>services.kanidm.serverSettings.tls_chain</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
        }
        {
          assertion = !cfg.enableServer || ((cfg.serverSettings.tls_key or null) == null) || (!lib.isStorePath cfg.serverSettings.tls_key);
          message = ''
            <option>services.kanidm.serverSettings.tls_key</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
        }
        {
          assertion = !cfg.enableClient || options.services.kanidm.clientSettings.isDefined;
          message = ''
            <option>services.kanidm.clientSettings</option> needs to be configured
            if the client is enabled.
          '';
        }
        {
          assertion = !cfg.enablePam || options.services.kanidm.clientSettings.isDefined;
          message = ''
            <option>services.kanidm.clientSettings</option> needs to be configured
            for the PAM daemon to connect to the Kanidm server.
          '';
        }
        {
          assertion = !cfg.enableServer || (cfg.serverSettings.domain == null
            -> cfg.serverSettings.role == "WriteReplica" || cfg.serverSettings.role == "WriteReplicaNoUI");
          message = ''
            <option>services.kanidm.serverSettings.domain</option> can only be set if this instance
            is not a ReadOnlyReplica. Otherwise the db would inherit it from
            the instance it follows.
          '';
        }
      ];

    environment.systemPackages = lib.mkIf cfg.enableClient [ cfg.package ];

    systemd.services.kanidm = lib.mkIf cfg.enableServer {
      description = "kanidm identity management daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = lib.mkMerge [
        # Merge paths and ignore existing prefixes needs to sidestep mkMerge
        (defaultServiceConfig // {
          BindReadOnlyPaths = mergePaths (defaultServiceConfig.BindReadOnlyPaths ++ certPaths);
        })
        {
          StateDirectory = "kanidm";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "kanidmd";
          ExecStart = "${cfg.package}/bin/kanidmd server -c ${serverConfigFile}";
          User = "kanidm";
          Group = "kanidm";

          BindPaths = [
            # To create the socket
            "/run/kanidmd:/run/kanidmd"
          ];

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          # This would otherwise override the CAP_NET_BIND_SERVICE capability.
          PrivateUsers = lib.mkForce false;
          # Port needs to be exposed to the host network
          PrivateNetwork = lib.mkForce false;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          TemporaryFileSystem = "/:ro";
        }
      ];
      environment.RUST_LOG = "info";
    };

    systemd.services.kanidm-unixd = lib.mkIf cfg.enablePam {
      description = "Kanidm PAM daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ unixConfigFile clientConfigFile ];
      serviceConfig = lib.mkMerge [
        defaultServiceConfig
        {
          CacheDirectory = "kanidm-unixd";
          CacheDirectoryMode = "0700";
          RuntimeDirectory = "kanidm-unixd";
          ExecStart = "${cfg.package}/bin/kanidm_unixd";
          User = "kanidm-unixd";
          Group = "kanidm-unixd";

          BindReadOnlyPaths = [
            "-/etc/kanidm"
            "-/etc/static/kanidm"
            "-/etc/ssl"
            "-/etc/static/ssl"
            "-/etc/passwd"
            "-/etc/group"
          ];
          BindPaths = [
            # To create the socket
            "/run/kanidm-unixd:/var/run/kanidm-unixd"
          ];
          # Needs to connect to kanidmd
          PrivateNetwork = lib.mkForce false;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          TemporaryFileSystem = "/:ro";
        }
      ];
      environment.RUST_LOG = "info";
    };

    systemd.services.kanidm-unixd-tasks = lib.mkIf cfg.enablePam {
      description = "Kanidm PAM home management daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "kanidm-unixd.service" ];
      partOf = [ "kanidm-unixd.service" ];
      restartTriggers = [ unixConfigFile clientConfigFile ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/kanidm_unixd_tasks";

        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
          "-/etc/kanidm"
          "-/etc/static/kanidm"
        ];
        BindPaths = [
          # To manage home directories
          "/home"
          # To connect to kanidm-unixd
          "/run/kanidm-unixd:/var/run/kanidm-unixd"
        ];
        # CAP_DAC_OVERRIDE is needed to ignore ownership of unixd socket
        CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_FOWNER" "CAP_DAC_OVERRIDE" "CAP_DAC_READ_SEARCH" ];
        IPAddressDeny = "any";
        # Need access to users
        PrivateUsers = false;
        # Need access to home directories
        ProtectHome = false;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        TemporaryFileSystem = "/:ro";
        Restart = "on-failure";
      };
      environment.RUST_LOG = "info";
    };

    # These paths are hardcoded
    environment.etc = lib.mkMerge [
      (lib.mkIf cfg.enableServer {
        "kanidm/server.toml".source = serverConfigFile;
      })
      (lib.mkIf options.services.kanidm.clientSettings.isDefined {
        "kanidm/config".source = clientConfigFile;
      })
      (lib.mkIf cfg.enablePam {
        "kanidm/unixd".source = unixConfigFile;
      })
    ];

    system.nssModules = lib.mkIf cfg.enablePam [ cfg.package ];

    system.nssDatabases.group = lib.optional cfg.enablePam "kanidm";
    system.nssDatabases.passwd = lib.optional cfg.enablePam "kanidm";

    users.groups = lib.mkMerge [
      (lib.mkIf cfg.enableServer {
        kanidm = { };
      })
      (lib.mkIf cfg.enablePam {
        kanidm-unixd = { };
      })
    ];
    users.users = lib.mkMerge [
      (lib.mkIf cfg.enableServer {
        kanidm = {
          description = "Kanidm server";
          isSystemUser = true;
          group = "kanidm";
          packages = [ cfg.package ];
        };
      })
      (lib.mkIf cfg.enablePam {
        kanidm-unixd = {
          description = "Kanidm PAM daemon";
          isSystemUser = true;
          group = "kanidm-unixd";
        };
      })
    ];
  };

  meta.maintainers = with lib.maintainers; [ erictapen Flakebi ];
  meta.buildDocsInSandbox = false;
}
