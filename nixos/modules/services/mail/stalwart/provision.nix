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
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the user that will be used to apply configuration.";
    };
    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the password for the user that will be used to apply configuration.";
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
    extraPlans = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "Extra raw plan entries to apply. See the [documentation](https://stalw.art/docs/management/cli/apply/) for reference.";
      example = [
        {
          "@type" = "upsert";
          object = "Domain";
          matchOn = [ "name" ];
          value = {
            mainDomain = {
              name = "mail.example.com";
              certificateManagement."@type" = "Manual";
              dkimManagement."@type" = "Manual";
              dnsManagement."@type" = "Manual";
              subAddressing."@type" = "Enabled";
            };
          };
        }
        {
          "@type" = "update";
          object = "SystemSettings";
          value = {
            defaultHostname = "mail.example.com";
            defaultDomainId = "#mainDomain";
          };
        }
      ];
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
        ) cfg.objects
        ++ cfg.extraPlans;

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
          assertion = cfg.enable -> stalwart.enable;
          message = "<option>services.stalwart.provision</option> requires <option>services.stalwart.enable</option> to be true";
        }
        {
          assertion = lib.versionAtLeast stalwart.package.version "0.16";
          message = "<option>services.stalwart.provision</option> requires <option>services.stalwart.package</option> to be at least version 0.16";
        }
        {
          assertion = !lib.isStorePath cfg.passwordFile;
          message = ''
            <option>services.stalwart.provision.passwordFile</option> points to a file in the Nix store.
            You should use a quoted absolute path to prevent this.
          '';
        }
      ];

      systemd.services.stalwart-provision = {
        description = "Stalwart Configuration Provisioning";
        wantedBy = [ "multi-user.target" ];
        partOf = [ "stalwart.service" ];
        after = [ "stalwart.service" ];
        serviceConfig =
          let
            shortBashScript = script: "${pkgs.bash}/bin/bash -c ${lib.escapeShellArg script}";
          in
          {
            Type = "oneshot";
            LoadCredential = [
              "password:${cfg.passwordFile}"
            ];

            # stalwart does not currently notify systemd that it has started
            # see https://github.com/stalwartlabs/stalwart/pull/2383
            ExecStartPre = shortBashScript "until ${pkgs.curl}/bin/curl --fail ${lib.escapeShellArg cfg.url} &> /dev/null; do sleep 0.25; done";
            ExecStart = shortBashScript "${pkgs.stalwart-cli}/bin/stalwart-cli --url ${lib.escapeShellArg cfg.url} --user ${lib.escapeShellArg cfg.username} --password `cat $CREDENTIALS_DIRECTORY/password` apply --file ${sorted}";
          };
      };
    }
  );
  meta = {
    maintainers = with lib.maintainers; [
      hexstella
    ];
  };
}
