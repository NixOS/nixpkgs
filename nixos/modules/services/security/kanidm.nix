{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib)
    any
    attrNames
    attrValues
    concatLines
    concatLists
    converge
    filter
    filterAttrs
    filterAttrsRecursive
    flip
    foldl'
    getExe
    hasInfix
    hasPrefix
    isStorePath
    last
    mapAttrsToList
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    optionalString
    splitString
    subtractLists
    types
    unique
    ;

  cfg = config.services.kanidm;
  settingsFormat = pkgs.formats.toml { };
  # Remove null values, so we can document optional values that don't end up in the generated TOML file.
  filterConfig = converge (filterAttrsRecursive (_: v: v != null));
  serverConfigFile = settingsFormat.generate "server.toml" (filterConfig cfg.serverSettings);
  clientConfigFile = settingsFormat.generate "kanidm-config.toml" (filterConfig cfg.clientSettings);
  unixConfigFile = settingsFormat.generate "kanidm-unixd.toml" (filterConfig cfg.unixSettings);
  certPaths = builtins.map builtins.dirOf [
    cfg.serverSettings.tls_chain
    cfg.serverSettings.tls_key
  ];

  # Merge bind mount paths and remove paths where a prefix is already mounted.
  # This makes sure that if e.g. the tls_chain is in the nix store and /nix/store is already in the mount
  # paths, no new bind mount is added. Adding subpaths caused problems on ofborg.
  hasPrefixInList =
    list: newPath: any (path: hasPrefix (builtins.toString path) (builtins.toString newPath)) list;
  mergePaths = foldl' (
    merged: newPath:
    let
      # If the new path is a prefix to some existing path, we need to filter it out
      filteredPaths = filter (p: !hasPrefix (builtins.toString newPath) (builtins.toString p)) merged;
      # If a prefix of the new path is already in the list, do not add it
      filteredNew = optional (!hasPrefixInList filteredPaths newPath) newPath;
    in
    filteredPaths ++ filteredNew
  ) [ ];

  defaultServiceConfig = {
    # Setting the type to notify enables additional healthchecks, ensuring units
    # after and requiring kanidm-* wait for it to complete startup
    Type = "notify";
    BindReadOnlyPaths = [
      "/nix/store"
      # For healthcheck notifications
      "/run/systemd/notify"
      "-/etc/resolv.conf"
      "-/etc/nsswitch.conf"
      "-/etc/hosts"
      "-/etc/localtime"
    ];
    CapabilityBoundingSet = [ ];
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
    SystemCallFilter = [
      "@system-service"
      "~@privileged @resources @setuid @keyring"
    ];
    # Does not work well with the temporary root
    #UMask = "0066";
  };

  mkPresentOption =
    what:
    mkOption {
      description = "Whether to ensure that this ${what} is present or absent.";
      type = types.bool;
      default = true;
    };

  filterPresent = filterAttrs (_: v: v.present);

  provisionStateJson = pkgs.writeText "provision-state.json" (
    builtins.toJSON { inherit (cfg.provision) groups persons systems; }
  );

  # Only recover the admin account if a password should explicitly be provisioned
  # for the account. Otherwise it is not needed for provisioning.
  maybeRecoverAdmin = optionalString (cfg.provision.adminPasswordFile != null) ''
    KANIDM_ADMIN_PASSWORD=$(< ${cfg.provision.adminPasswordFile})
    # We always reset the admin account password if a desired password was specified.
    if ! KANIDM_RECOVER_ACCOUNT_PASSWORD=$KANIDM_ADMIN_PASSWORD ${cfg.package}/bin/kanidmd recover-account -c ${serverConfigFile} admin --from-environment >/dev/null; then
      echo "Failed to recover admin account" >&2
      exit 1
    fi
  '';

  # Recover the idm_admin account. If a password should explicitly be provisioned
  # for the account we set it, otherwise we generate a new one because it is required
  # for provisioning.
  recoverIdmAdmin =
    if cfg.provision.idmAdminPasswordFile != null then
      ''
        KANIDM_IDM_ADMIN_PASSWORD=$(< ${cfg.provision.idmAdminPasswordFile})
        # We always reset the idm_admin account password if a desired password was specified.
        if ! KANIDM_RECOVER_ACCOUNT_PASSWORD=$KANIDM_IDM_ADMIN_PASSWORD ${cfg.package}/bin/kanidmd recover-account -c ${serverConfigFile} idm_admin --from-environment >/dev/null; then
          echo "Failed to recover idm_admin account" >&2
          exit 1
        fi
      ''
    else
      ''
        # Recover idm_admin account
        if ! recover_out=$(${cfg.package}/bin/kanidmd recover-account -c ${serverConfigFile} idm_admin -o json); then
          echo "$recover_out" >&2
          echo "kanidm provision: Failed to recover admin account" >&2
          exit 1
        fi
        if ! KANIDM_IDM_ADMIN_PASSWORD=$(grep '{"password' <<< "$recover_out" | ${getExe pkgs.jq} -r .password); then
          echo "$recover_out" >&2
          echo "kanidm provision: Failed to parse password for idm_admin account" >&2
          exit 1
        fi
      '';

  postStartScript = pkgs.writeShellScript "post-start" ''
    set -euo pipefail

    # Wait for the kanidm server to come online
    count=0
    while ! ${getExe pkgs.curl} -L --silent --max-time 1 --connect-timeout 1 --fail \
       ${optionalString cfg.provision.acceptInvalidCerts "--insecure"} \
       ${cfg.provision.instanceUrl} >/dev/null
    do
      sleep 1
      if [[ "$count" -eq 30 ]]; then
        echo "Tried for at least 30 seconds, giving up..."
        exit 1
      fi
      count=$((count++))
    done

    ${recoverIdmAdmin}
    ${maybeRecoverAdmin}

    KANIDM_PROVISION_IDM_ADMIN_TOKEN=$KANIDM_IDM_ADMIN_PASSWORD \
      ${getExe pkgs.kanidm-provision} \
        ${optionalString (!cfg.provision.autoRemove) "--no-auto-remove"} \
        ${optionalString cfg.provision.acceptInvalidCerts "--accept-invalid-certs"} \
        --url "${cfg.provision.instanceUrl}" \
        --state ${provisionStateJson}
  '';

  serverPort =
    # ipv6:
    if hasInfix "]:" cfg.serverSettings.bindaddress then
      last (splitString "]:" cfg.serverSettings.bindaddress)
    else
    # ipv4:
    if hasInfix "." cfg.serverSettings.bindaddress then
      last (splitString ":" cfg.serverSettings.bindaddress)
    # default is 8443
    else
      "8443";
in
{
  options.services.kanidm = {
    enableClient = mkEnableOption "the Kanidm client";
    enableServer = mkEnableOption "the Kanidm server";
    enablePam = mkEnableOption "the Kanidm PAM and NSS integration";

    package = mkPackageOption pkgs "kanidm" { };

    serverSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          bindaddress = mkOption {
            description = "Address/port combination the webserver binds to.";
            example = "[::1]:8443";
            type = types.str;
          };
          # Should be optional but toml does not accept null
          ldapbindaddress = mkOption {
            description = ''
              Address and port the LDAP server is bound to. Setting this to `null` disables the LDAP interface.
            '';
            example = "[::1]:636";
            default = null;
            type = types.nullOr types.str;
          };
          origin = mkOption {
            description = "The origin of your Kanidm instance. Must have https as protocol.";
            example = "https://idm.example.org";
            type = types.strMatching "^https://.*";
          };
          domain = mkOption {
            description = ''
              The `domain` that Kanidm manages. Must be below or equal to the domain
              specified in `serverSettings.origin`.
              This can be left at `null`, only if your instance has the role `ReadOnlyReplica`.
              While it is possible to change the domain later on, it requires extra steps!
              Please consider the warnings and execute the steps described
              [in the documentation](https://kanidm.github.io/kanidm/stable/administrivia.html#rename-the-domain).
            '';
            example = "example.org";
            default = null;
            type = types.nullOr types.str;
          };
          db_path = mkOption {
            description = "Path to Kanidm database.";
            default = "/var/lib/kanidm/kanidm.db";
            readOnly = true;
            type = types.path;
          };
          tls_chain = mkOption {
            description = "TLS chain in pem format.";
            type = types.path;
          };
          tls_key = mkOption {
            description = "TLS key in pem format.";
            type = types.path;
          };
          log_level = mkOption {
            description = "Log level of the server.";
            default = "info";
            type = types.enum [
              "info"
              "debug"
              "trace"
            ];
          };
          role = mkOption {
            description = "The role of this server. This affects the replication relationship and thereby available features.";
            default = "WriteReplica";
            type = types.enum [
              "WriteReplica"
              "WriteReplicaNoUI"
              "ReadOnlyReplica"
            ];
          };
          online_backup = {
            path = mkOption {
              description = "Path to the output directory for backups.";
              type = types.path;
              default = "/var/lib/kanidm/backups";
            };
            schedule = mkOption {
              description = "The schedule for backups in cron format.";
              type = types.str;
              default = "00 22 * * *";
            };
            versions = mkOption {
              description = ''
                Number of backups to keep.

                The default is set to `0`, in order to disable backups by default.
              '';
              type = types.ints.unsigned;
              default = 0;
              example = 7;
            };
          };
        };
      };
      default = { };
      description = ''
        Settings for Kanidm, see
        [the documentation](https://kanidm.github.io/kanidm/stable/server_configuration.html)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/server.toml)
        for possible values.
      '';
    };

    clientSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options.uri = mkOption {
          description = "Address of the Kanidm server.";
          example = "http://127.0.0.1:8080";
          type = types.str;
        };
      };
      description = ''
        Configure Kanidm clients, needed for the PAM daemon. See
        [the documentation](https://kanidm.github.io/kanidm/stable/client_tools.html#kanidm-configuration)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/config)
        for possible values.
      '';
    };

    unixSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          pam_allowed_login_groups = mkOption {
            description = "Kanidm groups that are allowed to login using PAM.";
            example = "my_pam_group";
            type = types.listOf types.str;
          };
          hsm_pin_path = mkOption {
            description = "Path to a HSM pin.";
            default = "/var/cache/kanidm-unixd/hsm-pin";
            type = types.path;
          };
        };
      };
      description = ''
        Configure Kanidm unix daemon.
        See [the documentation](https://kanidm.github.io/kanidm/stable/integrations/pam_and_nsswitch.html#the-unix-daemon)
        and [example configuration](https://github.com/kanidm/kanidm/blob/master/examples/unixd)
        for possible values.
      '';
    };

    provision = {
      enable = mkEnableOption "provisioning of groups, users and oauth2 resource servers";

      instanceUrl = mkOption {
        description = "The instance url to which the provisioning tool should connect.";
        default = "https://localhost:${serverPort}";
        defaultText = ''"https://localhost:<port from serverSettings.bindaddress>"'';
        type = types.str;
      };

      acceptInvalidCerts = mkOption {
        description = ''
          Whether to allow invalid certificates when provisioning the target instance.
          By default this is only allowed when the instanceUrl is localhost. This is
          dangerous when used with an external URL.
        '';
        type = types.bool;
        default = hasPrefix "https://localhost:" cfg.provision.instanceUrl;
        defaultText = ''hasPrefix "https://localhost:" cfg.provision.instanceUrl'';
      };

      adminPasswordFile = mkOption {
        description = "Path to a file containing the admin password for kanidm. Do NOT use a file from the nix store here!";
        example = "/run/secrets/kanidm-admin-password";
        default = null;
        type = types.nullOr types.path;
      };

      idmAdminPasswordFile = mkOption {
        description = ''
          Path to a file containing the idm admin password for kanidm. Do NOT use a file from the nix store here!
          If this is not given but provisioning is enabled, the idm_admin password will be reset on each restart.
        '';
        example = "/run/secrets/kanidm-idm-admin-password";
        default = null;
        type = types.nullOr types.path;
      };

      autoRemove = mkOption {
        description = ''
          Determines whether deleting an entity in this provisioning config should automatically
          cause them to be removed from kanidm, too. This works because the provisioning tool tracks
          all entities it has ever created. If this is set to false, you need to explicitly specify
          `present = false` to delete an entity.
        '';
        type = types.bool;
        default = true;
      };

      groups = mkOption {
        description = "Provisioning of kanidm groups";
        default = { };
        type = types.attrsOf (
          types.submodule (groupSubmod: {
            options = {
              present = mkPresentOption "group";

              members = mkOption {
                description = "List of kanidm entities (persons, groups, ...) which are part of this group.";
                type = types.listOf types.str;
                apply = unique;
                default = [ ];
              };
            };
            config.members = concatLists (
              flip mapAttrsToList cfg.provision.persons (
                person: personCfg:
                optional (
                  personCfg.present && builtins.elem groupSubmod.config._module.args.name personCfg.groups
                ) person
              )
            );
          })
        );
      };

      persons = mkOption {
        description = "Provisioning of kanidm persons";
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              present = mkPresentOption "person";

              displayName = mkOption {
                description = "Display name";
                type = types.str;
                example = "My User";
              };

              legalName = mkOption {
                description = "Full legal name";
                type = types.nullOr types.str;
                example = "Jane Doe";
                default = null;
              };

              mailAddresses = mkOption {
                description = "Mail addresses. First given address is considered the primary address.";
                type = types.listOf types.str;
                example = [ "jane.doe@example.com" ];
                default = [ ];
              };

              groups = mkOption {
                description = "List of groups this person should belong to.";
                type = types.listOf types.str;
                apply = unique;
                default = [ ];
              };
            };
          }
        );
      };

      systems.oauth2 = mkOption {
        description = "Provisioning of oauth2 resource servers";
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              present = mkPresentOption "oauth2 resource server";

              public = mkOption {
                description = "Whether this is a public client (enforces PKCE, doesn't use a basic secret)";
                type = types.bool;
                default = false;
              };

              displayName = mkOption {
                description = "Display name";
                type = types.str;
                example = "Some Service";
              };

              originUrl = mkOption {
                description = "The origin URL of the service. OAuth2 redirects will only be allowed to sites under this origin. Must end with a slash.";
                type =
                  let
                    originStrType = types.strMatching ".*://.*/$";
                  in
                  types.either originStrType (types.nonEmptyListOf originStrType);
                example = "https://someservice.example.com/";
              };

              originLanding = mkOption {
                description = "When redirecting from the Kanidm Apps Listing page, some linked applications may need to land on a specific page to trigger oauth2/oidc interactions.";
                type = types.str;
                example = "https://someservice.example.com/home";
              };

              basicSecretFile = mkOption {
                description = ''
                  The basic secret to use for this service. If null, the random secret generated
                  by kanidm will not be touched. Do NOT use a path from the nix store here!
                '';
                type = types.nullOr types.path;
                example = "/run/secrets/some-oauth2-basic-secret";
                default = null;
              };

              enableLocalhostRedirects = mkOption {
                description = "Allow localhost redirects. Only for public clients.";
                type = types.bool;
                default = false;
              };

              enableLegacyCrypto = mkOption {
                description = "Enable legacy crypto on this client. Allows JWT signing algorthms like RS256.";
                type = types.bool;
                default = false;
              };

              allowInsecureClientDisablePkce = mkOption {
                description = ''
                  Disable PKCE on this oauth2 resource server to work around insecure clients
                  that may not support it. You should request the client to enable PKCE!
                  Only for non-public clients.
                '';
                type = types.bool;
                default = false;
              };

              preferShortUsername = mkOption {
                description = "Use 'name' instead of 'spn' in the preferred_username claim";
                type = types.bool;
                default = false;
              };

              scopeMaps = mkOption {
                description = ''
                  Maps kanidm groups to returned oauth scopes.
                  See [Scope Relations](https://kanidm.github.io/kanidm/stable/integrations/oauth2.html#scope-relationships) for more information.
                '';
                type = types.attrsOf (types.listOf types.str);
                default = { };
              };

              supplementaryScopeMaps = mkOption {
                description = ''
                  Maps kanidm groups to additionally returned oauth scopes.
                  See [Scope Relations](https://kanidm.github.io/kanidm/stable/integrations/oauth2.html#scope-relationships) for more information.
                '';
                type = types.attrsOf (types.listOf types.str);
                default = { };
              };

              removeOrphanedClaimMaps = mkOption {
                description = "Whether claim maps not specified here but present in kanidm should be removed from kanidm.";
                type = types.bool;
                default = true;
              };

              claimMaps = mkOption {
                description = ''
                  Adds additional claims (and values) based on which kanidm groups an authenticating party belongs to.
                  See [Claim Maps](https://kanidm.github.io/kanidm/master/integrations/oauth2.html#custom-claim-maps) for more information.
                '';
                default = { };
                type = types.attrsOf (
                  types.submodule {
                    options = {
                      joinType = mkOption {
                        description = ''
                          Determines how multiple values are joined to create the claim value.
                          See [Claim Maps](https://kanidm.github.io/kanidm/master/integrations/oauth2.html#custom-claim-maps) for more information.
                        '';
                        type = types.enum [
                          "array"
                          "csv"
                          "ssv"
                        ];
                        default = "array";
                      };

                      valuesByGroup = mkOption {
                        description = "Maps kanidm groups to values for the claim.";
                        default = { };
                        type = types.attrsOf (types.listOf types.str);
                      };
                    };
                  }
                );
              };
            };
          }
        );
      };
    };
  };

  config = mkIf (cfg.enableClient || cfg.enableServer || cfg.enablePam) {
    assertions =
      let
        entityList =
          type: attrs: flip mapAttrsToList (filterPresent attrs) (name: _: { inherit type name; });
        entities =
          entityList "group" cfg.provision.groups
          ++ entityList "person" cfg.provision.persons
          ++ entityList "oauth2" cfg.provision.systems.oauth2;

        # Accumulate entities by name. Track corresponding entity types for later duplicate check.
        entitiesByName = foldl' (
          acc: { type, name }: acc // { ${name} = (acc.${name} or [ ]) ++ [ type ]; }
        ) { } entities;

        assertGroupsKnown =
          opt: groups:
          let
            knownGroups = attrNames (filterPresent cfg.provision.groups);
            unknownGroups = subtractLists knownGroups groups;
          in
          {
            assertion = (cfg.enableServer && cfg.provision.enable) -> unknownGroups == [ ];
            message = "${opt} refers to unknown groups: ${toString unknownGroups}";
          };

        assertEntitiesKnown =
          opt: entities:
          let
            unknownEntities = subtractLists (attrNames entitiesByName) entities;
          in
          {
            assertion = (cfg.enableServer && cfg.provision.enable) -> unknownEntities == [ ];
            message = "${opt} refers to unknown entities: ${toString unknownEntities}";
          };
      in
      [
        {
          assertion =
            !cfg.enableServer
            || ((cfg.serverSettings.tls_chain or null) == null)
            || (!isStorePath cfg.serverSettings.tls_chain);
          message = ''
            <option>services.kanidm.serverSettings.tls_chain</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
        }
        {
          assertion =
            !cfg.enableServer
            || ((cfg.serverSettings.tls_key or null) == null)
            || (!isStorePath cfg.serverSettings.tls_key);
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
          assertion =
            !cfg.enableServer
            || (
              cfg.serverSettings.domain == null
              -> cfg.serverSettings.role == "WriteReplica" || cfg.serverSettings.role == "WriteReplicaNoUI"
            );
          message = ''
            <option>services.kanidm.serverSettings.domain</option> can only be set if this instance
            is not a ReadOnlyReplica. Otherwise the db would inherit it from
            the instance it follows.
          '';
        }
        {
          assertion = cfg.provision.enable -> cfg.enableServer;
          message = "<option>services.kanidm.provision</option> requires <option>services.kanidm.enableServer</option> to be true";
        }
        # If any secret is provisioned, the kanidm package must have some required patches applied to it
        {
          assertion =
            (
              cfg.provision.enable
              && (
                cfg.provision.adminPasswordFile != null
                || cfg.provision.idmAdminPasswordFile != null
                || any (x: x.basicSecretFile != null) (attrValues (filterPresent cfg.provision.systems.oauth2))
              )
            )
            -> cfg.package.enableSecretProvisioning;
          message = ''
            Specifying an admin account password or oauth2 basicSecretFile requires kanidm to be built with the secret provisioning patches.
            You may want to set `services.kanidm.package = pkgs.kanidm.withSecretProvisioning;`.
          '';
        }
        # Entity names must be globally unique:
        (
          let
            # Filter all names that occurred in more than one entity type.
            duplicateNames = filterAttrs (_: v: builtins.length v > 1) entitiesByName;
          in
          {
            assertion = cfg.provision.enable -> duplicateNames == { };
            message = ''
              services.kanidm.provision requires all entity names (group, person, oauth2, ...) to be unique!
              ${concatLines (
                mapAttrsToList (name: xs: "  - '${name}' used as: ${toString xs}") duplicateNames
              )}'';
          }
        )
      ]
      ++ flip mapAttrsToList (filterPresent cfg.provision.persons) (
        person: personCfg:
        assertGroupsKnown "services.kanidm.provision.persons.${person}.groups" personCfg.groups
      )
      ++ flip mapAttrsToList (filterPresent cfg.provision.groups) (
        group: groupCfg:
        assertEntitiesKnown "services.kanidm.provision.groups.${group}.members" groupCfg.members
      )
      ++ concatLists (
        flip mapAttrsToList (filterPresent cfg.provision.systems.oauth2) (
          oauth2: oauth2Cfg:
          [
            (assertGroupsKnown "services.kanidm.provision.systems.oauth2.${oauth2}.scopeMaps" (
              attrNames oauth2Cfg.scopeMaps
            ))
            (assertGroupsKnown "services.kanidm.provision.systems.oauth2.${oauth2}.supplementaryScopeMaps" (
              attrNames oauth2Cfg.supplementaryScopeMaps
            ))
          ]
          ++ concatLists (
            flip mapAttrsToList oauth2Cfg.claimMaps (
              claim: claimCfg: [
                (assertGroupsKnown "services.kanidm.provision.systems.oauth2.${oauth2}.claimMaps.${claim}.valuesByGroup" (
                  attrNames claimCfg.valuesByGroup
                ))
                # At least one group must map to a value in each claim map
                {
                  assertion =
                    (cfg.provision.enable && cfg.enableServer)
                    -> any (xs: xs != [ ]) (attrValues claimCfg.valuesByGroup);
                  message = "services.kanidm.provision.systems.oauth2.${oauth2}.claimMaps.${claim} does not specify any values for any group";
                }
                # Public clients cannot define a basic secret
                {
                  assertion =
                    (cfg.provision.enable && cfg.enableServer && oauth2Cfg.public) -> oauth2Cfg.basicSecretFile == null;
                  message = "services.kanidm.provision.systems.oauth2.${oauth2} is a public client and thus cannot specify a basic secret";
                }
                # Public clients cannot disable PKCE
                {
                  assertion =
                    (cfg.provision.enable && cfg.enableServer && oauth2Cfg.public)
                    -> !oauth2Cfg.allowInsecureClientDisablePkce;
                  message = "services.kanidm.provision.systems.oauth2.${oauth2} is a public client and thus cannot disable PKCE";
                }
                # Non-public clients cannot enable localhost redirects
                {
                  assertion =
                    (cfg.provision.enable && cfg.enableServer && !oauth2Cfg.public)
                    -> !oauth2Cfg.enableLocalhostRedirects;
                  message = "services.kanidm.provision.systems.oauth2.${oauth2} is a non-public client and thus cannot enable localhost redirects";
                }
              ]
            )
          )
        )
      );

    environment.systemPackages = mkIf cfg.enableClient [ cfg.package ];

    systemd.tmpfiles.settings."10-kanidm" = {
      ${cfg.serverSettings.online_backup.path}.d = {
        mode = "0700";
        user = "kanidm";
        group = "kanidm";
      };
    };

    systemd.services.kanidm = mkIf cfg.enableServer {
      description = "kanidm identity management daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = mkMerge [
        # Merge paths and ignore existing prefixes needs to sidestep mkMerge
        (
          defaultServiceConfig
          // {
            BindReadOnlyPaths = mergePaths (defaultServiceConfig.BindReadOnlyPaths ++ certPaths);
          }
        )
        {
          StateDirectory = "kanidm";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "kanidmd";
          ExecStart = "${cfg.package}/bin/kanidmd server -c ${serverConfigFile}";
          ExecStartPost = mkIf cfg.provision.enable postStartScript;
          User = "kanidm";
          Group = "kanidm";

          BindPaths = [
            # To create the socket
            "/run/kanidmd:/run/kanidmd"
            # To store backups
            cfg.serverSettings.online_backup.path
          ];

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          # This would otherwise override the CAP_NET_BIND_SERVICE capability.
          PrivateUsers = mkForce false;
          # Port needs to be exposed to the host network
          PrivateNetwork = mkForce false;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          TemporaryFileSystem = "/:ro";
        }
      ];
      environment.RUST_LOG = "info";
    };

    systemd.services.kanidm-unixd = mkIf cfg.enablePam {
      description = "Kanidm PAM daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [
        unixConfigFile
        clientConfigFile
      ];
      serviceConfig = mkMerge [
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
          PrivateNetwork = mkForce false;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          TemporaryFileSystem = "/:ro";
        }
      ];
      environment.RUST_LOG = "info";
    };

    systemd.services.kanidm-unixd-tasks = mkIf cfg.enablePam {
      description = "Kanidm PAM home management daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "kanidm-unixd.service"
      ];
      partOf = [ "kanidm-unixd.service" ];
      restartTriggers = [
        unixConfigFile
        clientConfigFile
      ];
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
        CapabilityBoundingSet = [
          "CAP_CHOWN"
          "CAP_FOWNER"
          "CAP_DAC_OVERRIDE"
          "CAP_DAC_READ_SEARCH"
        ];
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
    environment.etc = mkMerge [
      (mkIf cfg.enableServer { "kanidm/server.toml".source = serverConfigFile; })
      (mkIf options.services.kanidm.clientSettings.isDefined {
        "kanidm/config".source = clientConfigFile;
      })
      (mkIf cfg.enablePam { "kanidm/unixd".source = unixConfigFile; })
    ];

    system.nssModules = mkIf cfg.enablePam [ cfg.package ];

    system.nssDatabases.group = optional cfg.enablePam "kanidm";
    system.nssDatabases.passwd = optional cfg.enablePam "kanidm";

    users.groups = mkMerge [
      (mkIf cfg.enableServer { kanidm = { }; })
      (mkIf cfg.enablePam { kanidm-unixd = { }; })
    ];
    users.users = mkMerge [
      (mkIf cfg.enableServer {
        kanidm = {
          description = "Kanidm server";
          isSystemUser = true;
          group = "kanidm";
          packages = [ cfg.package ];
        };
      })
      (mkIf cfg.enablePam {
        kanidm-unixd = {
          description = "Kanidm PAM daemon";
          isSystemUser = true;
          group = "kanidm-unixd";
        };
      })
    ];
  };

  meta.maintainers = with lib.maintainers; [
    erictapen
    Flakebi
    oddlama
  ];
  meta.buildDocsInSandbox = false;
}
