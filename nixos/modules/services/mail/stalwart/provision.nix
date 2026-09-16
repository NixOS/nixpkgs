{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.stalwart.provision;
  stalwart = config.services.stalwart;
in
{
  options.services.stalwart.provision = {
    enable = lib.mkEnableOption "Stalwart Configuration Provisioning";
    url = lib.mkOption {
      type = lib.types.str;
      description = "The URL of the Stalwart instance to provision onto.";
    };

    singletons = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      description = "Singletons to configure.";
      example = {
        SystemSettings = {
          defaultHostname = "mail.example.com";
          defaultDomainId = "#mainDomain";
        };
      };
    };
    objects = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            reconcile = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Whether to use the `reconcile` operation instead of `upsert`, deleting objects in this set that are not explicitly defined.
                Read the [documentation](https://stalw.art/docs/management/cli/apply/#reconciling-to-exact-state) for more information.
              '';
              default = false;
            };

            match = lib.mkOption {
              type = lib.types.nullOr (lib.types.either (lib.types.listOf lib.types.str) lib.types.str);
              description = ''
                The fields to match on, a wildcard (`"*"`), or null.
                Read the [documentation](https://stalw.art/docs/management/cli/apply/#upsert) for more information.
              '';
              example = [ "name" ];
              default = null;
            };

            scope = lib.mkOption {
              type = lib.types.nullOr lib.types.attrs;
              description = ''
                Optional scope to restrict which objects this operation can affect.
                Should be a partial value of the object type.
                This is especially useful when `reconcile` is `true`, only objects that match the scope will be considered for deletion.
                Read the [documentation](https://stalw.art/docs/management/cli/apply/#scoping-an-operation-with-scope) for more information.
              '';
            };

            objects = lib.mkOption {
              type = lib.types.attrsOf lib.types.attrs;
              description = "The objects in the set. Attribute names define IDs that can be referenced with `#name` elsewhere where an ID is expected.";
            };
          };
        }
      );
      description = "Objects to configure.";
      example = {
        NetworkListener = {
          reconcile = false;
          match = [ "name" ];
          objects = {
            nl-mgmt = {
              name = "management";
              protocol = "http";
              bind = {
                "[::]:8080" = true;
              };
            };
            nl-inc = {
              name = "incoming";
              protocol = "submissions";
              bind = {
                "[::]:465" = true;
              };
              tlsImplicit = true;
            };
          };
        };
        Domain = {
          reconcile = true;
          match = [ "name" ];
          objects = {
            mainDomain = {
              name = "mail.example.com";
              certificateManagement."@type" = "Manual";
              dkimManagement."@type" = "Manual";
              dnsManagement."@type" = "Manual";
              subAddressing."@type" = "Enabled";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      variant = type: value: { "@type" = type; } // value;

      plans =
        lib.mapAttrsToList (
          name: value:
          variant "update" {
            object = name;
            value = value;
          }
        ) cfg.singletons
        ++ lib.mapAttrsToList (
          name: value:
          variant (if value.reconcile then "reconcile" else "upsert") {
            object = name;
            matchOn = value.match;
            value = value.objects;
          }
        ) cfg.objects;

      unsorted = lib.concatMapStringsSep "\n" builtins.toJSON plans;

      sorted =
        pkgs.runCommand "stalwart-provision.ndjson"
          {
            nativeBuildInputs = with pkgs.lua52Packages; [
              lua
              dkjson
            ];
          }
          ''
            gzip -d ${stalwart.package.src}/resources/schema/schema.json.gz -c > ./schema.json
            lua ${./provision-check-sort.lua} ${lib.escapeShellArg unsorted} $out ./schema.json
          '';
    in
    {
      assertions = [
        {
          assertion = stalwart.enable;
          message = "<option>services.stalwart.provision</option> requires <option>services.stalwart.enable</option> to be true";
        }
        {
          assertion = stalwart.admin.enable;
          message = "<option>services.stalwart.provision</option> requires <option>services.stalwart.admin.enable</option> to be true";
        }
        {
          assertion = lib.versionAtLeast stalwart.package.version "0.16";
          message = "<option>services.stalwart.provision</option> requires <option>services.stalwart.package</option> to be at least version 0.16";
        }
      ];

      systemd.services.stalwart-provision = {
        description = "Stalwart Configuration Provisioning";
        wantedBy = [ "multi-user.target" ];
        partOf = [ "stalwart.service" ];
        after = [ "stalwart.service" ];
        serviceConfig =
          let
            shortBashScript =
              script: "${lib.getExe pkgs.bash} -c ${lib.escapeShellArg (lib.strings.join " " script)}";
          in
          {
            Type = "oneshot";
            LoadCredential = [
              "password:${stalwart.admin.passwordFile}"
            ];

            # stalwart does not currently notify systemd that it has started
            # see https://github.com/stalwartlabs/stalwart/pull/2383
            ExecStartPre = shortBashScript [
              "until ${pkgs.curl}/bin/curl --fail ${lib.escapeShellArg cfg.url} &> /dev/null; do sleep 0.25; done"
            ];
            ExecStart = shortBashScript [
              "STALWART_PASSWORD=`cat $CREDENTIALS_DIRECTORY/password`"
              (lib.getExe pkgs.stalwart-cli)
              "--url ${lib.escapeShellArg cfg.url}"
              "--user ${lib.escapeShellArg stalwart.admin.username}"
              "apply"
              "--file ${sorted}"
            ];
          };
      };
    }
  );
  meta = {
    maintainers = with lib.maintainers; [
      hexstella
    ];
    # meta.doc omitted, shares the main stalwart module documentation
  };
}
