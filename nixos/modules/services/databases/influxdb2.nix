{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    attrNames
    attrValues
    count
    escapeShellArg
    filterAttrs
    flatten
    flip
    getExe
    hasAttr
    hasInfix
    listToAttrs
    literalExpression
    mapAttrsToList
    mkEnableOption
    mkPackageOption
    mkIf
    lib.mkOption
    nameValuePair
    lib.optional
    subtractLists
    types
    unique
    ;

  format = pkgs.formats.json { };
  cfg = config.services.influxdb2;
  configFile = format.generate "config.json" cfg.settings;

  validPermissions = [
    "authorizations"
    "buckets"
    "dashboards"
    "orgs"
    "tasks"
    "telegrafs"
    "users"
    "variables"
    "secrets"
    "labels"
    "views"
    "documents"
    "notificationRules"
    "notificationEndpoints"
    "checks"
    "dbrp"
    "annotations"
    "sources"
    "scrapers"
    "notebooks"
    "remotes"
    "replications"
  ];

  # Determines whether at least one active api token is defined
  anyAuthDefined = flip any (lib.attrValues cfg.provision.organizations) (
    o: o.present && flip any (lib.attrValues o.auths) (a: a.present && a.tokenFile != null)
  );

  provisionState = pkgs.writeText "provision_state.json" (
    builtins.toJSON {
      inherit (cfg.provision) organizations users;
    }
  );

  influxHost = "http://${
    escapeShellArg (
      if
        !hasAttr "http-bind-address" cfg.settings || hasInfix "0.0.0.0" cfg.settings.http-bind-address
      then
        "localhost:8086"
      else
        cfg.settings.http-bind-address
    )
  }";

  waitUntilServiceIsReady = pkgs.writeShellScript "wait-until-service-is-ready" ''
    set -euo pipefail
    export INFLUX_HOST=${influxHost}
    count=0
    while ! influx ping &>/dev/null; do
      if [ "$count" -eq 300 ]; then
        echo "Tried for 30 seconds, giving up..."
        exit 1
      fi

      if ! kill -0 "$MAINPID"; then
        echo "Main server died, giving up..."
        exit 1
      fi

      sleep 0.1
      count=$((count++))
    done
  '';

  provisioningScript = pkgs.writeShellScript "post-start-provision" ''
    set -euo pipefail
    export INFLUX_HOST=${influxHost}

    # Do the initial database setup. Pass /dev/null as configs-path to
    # avoid saving the token as the active config.
    if test -e "$STATE_DIRECTORY/.first_startup"; then
      influx setup \
        --configs-path /dev/null \
        --org ${lib.escapeShellArg cfg.provision.initialSetup.organization} \
        --bucket ${lib.escapeShellArg cfg.provision.initialSetup.bucket} \
        --username ${lib.escapeShellArg cfg.provision.initialSetup.username} \
        --password "$(< "$CREDENTIALS_DIRECTORY/admin-password")" \
        --token "$(< "$CREDENTIALS_DIRECTORY/admin-token")" \
        --retention ${toString cfg.provision.initialSetup.retention}s \
        --force >/dev/null

      rm -f "$STATE_DIRECTORY/.first_startup"
    fi

    provision_result=$(${getExe pkgs.influxdb2-provision} ${provisionState} "$INFLUX_HOST" "$(< "$CREDENTIALS_DIRECTORY/admin-token")")
    if [[ "$(jq '[.auths[] | select(.action == "created")] | length' <<< "$provision_result")" -gt 0 ]]; then
      echo "Created at least one new token, queueing service restart so we can manipulate secrets"
      touch "$STATE_DIRECTORY/.needs_restart"
    fi
  '';

  restarterScript = pkgs.writeShellScript "post-start-restarter" ''
    set -euo pipefail
    if test -e "$STATE_DIRECTORY/.needs_restart"; then
      rm -f "$STATE_DIRECTORY/.needs_restart"
      /run/current-system/systemd/bin/systemctl restart influxdb2
    fi
  '';

  organizationSubmodule = types.submodule (
    organizationSubmod:
    let
      org = organizationSubmod.config._module.args.name;
    in
    {
      options = {
        present = lib.mkOption {
          description = "Whether to ensure that this organization is present or absent.";
          type = lib.types.bool;
          default = true;
        };

        description = lib.mkOption {
          description = "Optional description for the organization.";
          default = null;
          type = lib.types.nullOr lib.types.str;
        };

        buckets = lib.mkOption {
          description = "Buckets to provision in this organization.";
          default = { };
          type = lib.types.attrsOf (
            types.submodule (
              bucketSubmod:
              let
                bucket = bucketSubmod.config._module.args.name;
              in
              {
                options = {
                  present = lib.mkOption {
                    description = "Whether to ensure that this bucket is present or absent.";
                    type = lib.types.bool;
                    default = true;
                  };

                  description = lib.mkOption {
                    description = "Optional description for the bucket.";
                    default = null;
                    type = lib.types.nullOr lib.types.str;
                  };

                  retention = lib.mkOption {
                    type = lib.types.ints.unsigned;
                    default = 0;
                    description = "The duration in seconds for which the bucket will retain data (0 is infinite).";
                  };
                };
              }
            )
          );
        };

        auths = lib.mkOption {
          description = "API tokens to provision for the user in this organization.";
          default = { };
          type = lib.types.attrsOf (
            types.submodule (
              authSubmod:
              let
                auth = authSubmod.config._module.args.name;
              in
              {
                options = {
                  id = lib.mkOption {
                    description = "A unique identifier for this authentication token. Since influx doesn't store names for tokens, this will be hashed and appended to the description to identify the token.";
                    readOnly = true;
                    default = builtins.substring 0 32 (builtins.hashString "sha256" "${org}:${auth}");
                    defaultText = "<a hash derived from org and name>";
                    type = lib.types.str;
                  };

                  present = lib.mkOption {
                    description = "Whether to ensure that this user is present or absent.";
                    type = lib.types.bool;
                    default = true;
                  };

                  description = lib.mkOption {
                    description = ''
                      Optional description for the API token.
                      Note that the actual token will always be created with a descriptionregardless
                      of whether this is given or not. The name is always added plus a unique suffix
                      to later identify the token to track whether it has already been created.
                    '';
                    default = null;
                    type = lib.types.nullOr lib.types.str;
                  };

                  tokenFile = lib.mkOption {
                    type = lib.types.nullOr lib.types.path;
                    default = null;
                    description = "The token value. If not given, influx will automatically generate one.";
                  };

                  operator = lib.mkOption {
                    description = "Grants all permissions in all organizations.";
                    default = false;
                    type = lib.types.bool;
                  };

                  allAccess = lib.mkOption {
                    description = "Grants all permissions in the associated organization.";
                    default = false;
                    type = lib.types.bool;
                  };

                  readPermissions = lib.mkOption {
                    description = ''
                      The read permissions to include for this token. Access is usually granted only
                      for resources in the associated organization.

                      Available permissions are `authorizations`, `buckets`, `dashboards`,
                      `orgs`, `tasks`, `telegrafs`, `users`, `variables`, `secrets`, `labels`, `views`,
                      `documents`, `notificationRules`, `notificationEndpoints`, `checks`, `dbrp`,
                      `annotations`, `sources`, `scrapers`, `notebooks`, `remotes`, `replications`.

                      Refer to `influx auth create --help` for a full list with descriptions.

                      `buckets` grants read access to all associated buckets. Use `readBuckets` to define
                      more granular access permissions.
                    '';
                    default = [ ];
                    type = lib.types.listOf (types.enum validPermissions);
                  };

                  writePermissions = lib.mkOption {
                    description = ''
                      The read permissions to include for this token. Access is usually granted only
                      for resources in the associated organization.

                      Available permissions are `authorizations`, `buckets`, `dashboards`,
                      `orgs`, `tasks`, `telegrafs`, `users`, `variables`, `secrets`, `labels`, `views`,
                      `documents`, `notificationRules`, `notificationEndpoints`, `checks`, `dbrp`,
                      `annotations`, `sources`, `scrapers`, `notebooks`, `remotes`, `replications`.

                      Refer to `influx auth create --help` for a full list with descriptions.

                      `buckets` grants write access to all associated buckets. Use `writeBuckets` to define
                      more granular access permissions.
                    '';
                    default = [ ];
                    type = lib.types.listOf (types.enum validPermissions);
                  };

                  readBuckets = lib.mkOption {
                    description = "The organization's buckets which should be allowed to be read";
                    default = [ ];
                    type = lib.types.listOf lib.types.str;
                  };

                  writeBuckets = lib.mkOption {
                    description = "The organization's buckets which should be allowed to be written";
                    default = [ ];
                    type = lib.types.listOf lib.types.str;
                  };
                };
              }
            )
          );
        };
      };
    }
  );
in
{
  options = {
    services.influxdb2 = {
      enable = lib.mkEnableOption "the influxdb2 server";

      package = lib.mkPackageOption pkgs "influxdb2" { };

      settings = lib.mkOption {
        default = { };
        description = ''configuration options for influxdb2, see <https://docs.influxdata.com/influxdb/v2.0/reference/config-options> for details.'';
        type = format.type;
      };

      provision = {
        enable = lib.mkEnableOption "initial database setup and provisioning";

        initialSetup = {
          organization = lib.mkOption {
            type = lib.types.str;
            example = "main";
            description = "Primary organization name";
          };

          bucket = lib.mkOption {
            type = lib.types.str;
            example = "example";
            description = "Primary bucket name";
          };

          username = lib.mkOption {
            type = lib.types.str;
            default = "admin";
            description = "Primary username";
          };

          retention = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = 0;
            description = "The duration in seconds for which the bucket will retain data (0 is infinite).";
          };

          passwordFile = lib.mkOption {
            type = lib.types.path;
            description = "Password for primary user. Don't use a file from the nix store!";
          };

          tokenFile = lib.mkOption {
            type = lib.types.path;
            description = "API Token to set for the admin user. Don't use a file from the nix store!";
          };
        };

        organizations = lib.mkOption {
          description = "Organizations to provision.";
          example = lib.literalExpression ''
            {
              myorg = {
                description = "My organization";
                buckets.mybucket = {
                  description = "My bucket";
                  retention = 31536000; # 1 year
                };
                auths.mytoken = {
                  readBuckets = ["mybucket"];
                  tokenFile = "/run/secrets/mytoken";
                };
              };
            }
          '';
          default = { };
          type = lib.types.attrsOf organizationSubmodule;
        };

        users = lib.mkOption {
          description = "Users to provision.";
          default = { };
          example = lib.literalExpression ''
            {
              # admin = {}; /* The initialSetup.username will automatically be added. */
              myuser.passwordFile = "/run/secrets/myuser_password";
            }
          '';
          type = lib.types.attrsOf (
            types.submodule (
              userSubmod:
              let
                user = userSubmod.config._module.args.name;
                org = userSubmod.config.org;
              in
              {
                options = {
                  present = lib.mkOption {
                    description = "Whether to ensure that this user is present or absent.";
                    type = lib.types.bool;
                    default = true;
                  };

                  passwordFile = lib.mkOption {
                    description = "Password for the user. If unset, the user will not be able to log in until a password is set by an operator! Don't use a file from the nix store!";
                    default = null;
                    type = lib.types.nullOr lib.types.path;
                  };
                };
              }
            )
          );
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      [
        {
          assertion = !(hasAttr "bolt-path" cfg.settings) && !(hasAttr "engine-path" cfg.settings);
          message = "services.influxdb2.config: bolt-path and engine-path should not be set as they are managed by systemd";
        }
      ]
      ++ flatten (
        flip mapAttrsToList cfg.provision.organizations (
          orgName: org:
          flip mapAttrsToList org.auths (
            authName: auth: [
              {
                assertion =
                  1 == count (x: x) [
                    auth.operator
                    auth.allAccess
                    (
                      auth.readPermissions != [ ]
                      || auth.writePermissions != [ ]
                      || auth.readBuckets != [ ]
                      || auth.writeBuckets != [ ]
                    )
                  ];
                message = "influxdb2: provision.organizations.${orgName}.auths.${authName}: The `operator` and `allAccess` options are mutually exclusive with each other and the granular permission settings.";
              }
              (
                let
                  unknownBuckets = subtractLists (attrNames org.buckets) auth.readBuckets;
                in
                {
                  assertion = unknownBuckets == [ ];
                  message = "influxdb2: provision.organizations.${orgName}.auths.${authName}: Refers to invalid buckets in readBuckets: ${toString unknownBuckets}";
                }
              )
              (
                let
                  unknownBuckets = subtractLists (attrNames org.buckets) auth.writeBuckets;
                in
                {
                  assertion = unknownBuckets == [ ];
                  message = "influxdb2: provision.organizations.${orgName}.auths.${authName}: Refers to invalid buckets in writeBuckets: ${toString unknownBuckets}";
                }
              )
            ]
          )
        )
      );

    services.influxdb2.provision = lib.mkIf cfg.provision.enable {
      organizations.${cfg.provision.initialSetup.organization} = {
        buckets.${cfg.provision.initialSetup.bucket} = {
          inherit (cfg.provision.initialSetup) retention;
        };
      };
      users.${cfg.provision.initialSetup.username} = {
        inherit (cfg.provision.initialSetup) passwordFile;
      };
    };

    systemd.services.influxdb2 = {
      description = "InfluxDB is an open-source, distributed, time series database";
      documentation = [ "https://docs.influxdata.com/influxdb/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        INFLUXD_CONFIG_PATH = configFile;
        ZONEINFO = "${pkgs.tzdata}/share/zoneinfo";
      };
      serviceConfig = {
        Type = "exec"; # When credentials are used with systemd before v257 this is necessary to make the service start reliably (see systemd/systemd#33953)
        ExecStart = "${cfg.package}/bin/influxd --bolt-path \${STATE_DIRECTORY}/influxd.bolt --engine-path \${STATE_DIRECTORY}/engine";
        StateDirectory = "influxdb2";
        User = "influxdb2";
        Group = "influxdb2";
        CapabilityBoundingSet = "";
        SystemCallFilter = "@system-service";
        LimitNOFILE = 65536;
        KillMode = "control-group";
        Restart = "on-failure";
        LoadCredential = lib.mkIf cfg.provision.enable [
          "admin-password:${cfg.provision.initialSetup.passwordFile}"
          "admin-token:${cfg.provision.initialSetup.tokenFile}"
        ];

        ExecStartPost =
          [
            waitUntilServiceIsReady
          ]
          ++ (lib.optionals cfg.provision.enable (
            [ provisioningScript ]
            ++
              # Only the restarter runs with elevated privileges
              lib.optional anyAuthDefined "+${restarterScript}"
          ));
      };

      path = [
        pkgs.influxdb2-cli
        pkgs.jq
      ];

      # Mark if this is the first startup so postStart can do the initial setup.
      # Also extract any token secret mappings and apply them if this isn't the first start.
      preStart =
        let
          tokenPaths = listToAttrs (
            flatten
              # For all organizations
              (
                flip mapAttrsToList cfg.provision.organizations
                  # For each contained token that has a token file
                  (
                    _: org:
                    flip mapAttrsToList (lib.filterAttrs (_: x: x.tokenFile != null) org.auths)
                      # Collect id -> tokenFile for the mapping
                      (_: auth: nameValuePair auth.id auth.tokenFile)
                  )
              )
          );
          tokenMappings = pkgs.writeText "token_mappings.json" (builtins.toJSON tokenPaths);
        in
        mkIf cfg.provision.enable ''
          if ! test -e "$STATE_DIRECTORY/influxd.bolt"; then
            touch "$STATE_DIRECTORY/.first_startup"
          else
            # Manipulate provisioned api tokens if necessary
            ${getExe pkgs.influxdb2-token-manipulator} "$STATE_DIRECTORY/influxd.bolt" ${tokenMappings}
          fi
        '';
    };

    users.extraUsers.influxdb2 = {
      isSystemUser = true;
      group = "influxdb2";
    };

    users.extraGroups.influxdb2 = { };
  };

  meta.maintainers = with lib.maintainers; [
    nickcao
    oddlama
  ];
}
