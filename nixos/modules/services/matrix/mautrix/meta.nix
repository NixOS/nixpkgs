{
  config,
  lib,
  pkgs,
  ...
}:
let
  nixosConfig = config;
  upperCfg = config.services.mautrix-meta;
  common = import ./common.nix { inherit lib pkgs; };

  metaName = name: "mautrix-meta-${name}";
  executableForMode = mode: if mode == "instagram" then "mautrix-instagram" else "mautrix-meta";
  instanceBase = name: {
    inherit nixosConfig name;
    serviceName = metaName name;
    registrationName = "meta";
    secretPrefix = "META";
  };

  enabledInstances = lib.filterAttrs (_: instance: instance.enable) upperCfg.instances;
in
{
  options.services.mautrix-meta = {
    package = lib.mkPackageOption pkgs "mautrix-meta" { };

    instances = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = common.mkBridgeOptions (
              instanceBase name
              // {
                bridgeCfg = config;
                description = "Mautrix-Meta, a Matrix <-> Facebook and Matrix <-> Instagram hybrid puppeting/relaybot bridge";
                packageOption = lib.mkOption {
                  type = lib.types.package;
                  default = upperCfg.package;
                  defaultText = lib.literalExpression "config.services.mautrix-meta.package";
                  description = "The Mautrix-Meta package to use for this instance.";
                };
                defaultDataDir = "/var/lib/${metaName name}";
                defaultDataDirText = lib.literalExpression ''"/var/lib/mautrix-meta-''${name}"'';
                allowRelativeDataDir = true;
                defaultSettings = {
                  homeserver.software = "standard";
                  network.mode = "";
                  bridge.permissions = { };
                  appservice = {
                    id = "";
                    port = 29319;
                    bot.username = "";
                  };
                  # Enable encryption by default to make the bridge more secure.
                  encryption = {
                    allow = true;
                    default = true;
                    require = true;
                    # Retain the legacy migration key: changing it makes existing databases unreadable.
                    # For new installations, override this with a random key via environmentFiles.
                    pickle_key = "mautrix.bridge.e2ee";
                    delete_keys = {
                      dont_store_outbound = true;
                      ratchet_on_decrypt = true;
                      delete_fully_used_on_decrypt = true;
                      delete_prev_on_new_session = true;
                      delete_on_device_delete = true;
                      periodically_delete_expired = true;
                      delete_outdated_inbound = true;
                    };
                    verification_levels = {
                      receive = "cross-signed-tofu";
                      send = "cross-signed-tofu";
                      share = "cross-signed-tofu";
                    };
                  };
                };
                settingsDescription = ''
                  {file}`config.yaml` configuration as a Nix attribute set.
                  Configuration options should match those described in the example configuration.
                  Get an example configuration by executing one of:
                    - `mautrix-meta -c example.yaml --generate-example-config`
                    - `mautrix-instagram -c example.yaml --generate-example-config`

                  Secret tokens should be specified using {option}`environmentFiles`
                  instead of this world-readable attribute set.
                '';
                settingsDefaultText = lib.literalMD ''
                  Default `sqlite3-fk-wal` database under `dataDir`, appservice listening on
                  `127.0.0.1` (port `29321` for `facebook`, `29320` for `instagram`, `29319`
                  otherwise), encryption enabled by default, and stdout logging.
                '';
              }
            );

            config.settings.homeserver = lib.mkIf config.enable (common.defaultHomeserverSettings nixosConfig);
          }
        )
      );
      description = ''
        Configuration of multiple `mautrix-meta` instances.
        `services.mautrix-meta.instances.facebook` and `services.mautrix-meta.instances.instagram`
        come preconfigured with `network.mode`, `appservice.id`, port, bot username,
        display name, and avatar.
      '';
      example = lib.literalExpression ''
        {
          facebook = {
            enable = true;
            settings = {
              homeserver.domain = "example.com";
              bridge.permissions."@admin:example.com" = "admin";
            };
          };

          instagram = {
            enable = true;
            settings = {
              homeserver.domain = "example.com";
              bridge.permissions."@admin:example.com" = "admin";
            };
          };

          messenger = {
            enable = true;
            settings = {
              network.mode = "messenger";
              homeserver.domain = "example.com";
              bridge.permissions."@admin:example.com" = "admin";
              appservice = {
                id = "messenger";
                bot = {
                  username = "messengerbot";
                  displayname = "Messenger bridge bot";
                  avatar = "mxc://maunium.net/ygtkteZsXnGJLJHRchUwYWak";
                };
              };
            };
          };
        }
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (enabledInstances != { }) (
      lib.mkMerge [
        (common.mkBridgesConfig (
          lib.mapAttrsToList (
            name: instanceCfg:
            instanceBase name
            // {
              bridgeCfg = instanceCfg;
              executable = executableForMode instanceCfg.settings.network.mode;
              description = "Mautrix-Meta bridge (${name})";
              optionPath = "services.mautrix-meta.instances.${name}";
              memoryDenyWriteExecute = true;
              extraAssertions = [
                {
                  assertion = builtins.elem instanceCfg.settings.network.mode [
                    "facebook"
                    "facebook-tor"
                    "messenger"
                    "instagram"
                  ];
                  message = ''
                    The option `services.mautrix-meta.instances.${name}.settings.network.mode` has to be set
                    to one of: facebook, facebook-tor, messenger, instagram.
                  '';
                }
                {
                  assertion = instanceCfg.settings.appservice.id or "" != "";
                  message = "The option `services.mautrix-meta.instances.${name}.settings.appservice.id` has to be set.";
                }
                {
                  assertion = instanceCfg.settings.appservice.bot.username or "" != "";
                  message = "The option `services.mautrix-meta.instances.${name}.settings.appservice.bot.username` has to be set.";
                }
                {
                  assertion = !(instanceCfg.settings ? bridge.disable_xma);
                  message = "services.mautrix-meta.instances.${name}: 'bridge.disable_xma' has been moved to 'network.disable_xma_always'.";
                }
                {
                  assertion = !(instanceCfg.settings ? bridge.displayname_template);
                  message = "services.mautrix-meta.instances.${name}: 'bridge.displayname_template' has been moved to 'network.displayname_template'.";
                }
                {
                  assertion = !(instanceCfg.settings ? meta);
                  message = "services.mautrix-meta.instances.${name}: 'meta' has been moved to 'network'.";
                }
              ];
            }
          ) enabledInstances
        ))
        {
          assertions = [
            {
              assertion =
                lib.length (
                  lib.unique (lib.mapAttrsToList (_: i: common.resolveDataDir i.dataDir) enabledInstances)
                ) == lib.length (builtins.attrNames enabledInstances);
              message = "services.mautrix-meta.instances must have separate data directories.";
            }
          ];
        }
      ]
    ))
    {
      services.mautrix-meta.instances =
        let
          inherit (lib.modules) mkDefault;
        in
        {
          instagram.settings = {
            network.mode = mkDefault "instagram";
            appservice = {
              id = mkDefault "instagram";
              port = mkDefault 29320;
              bot = {
                username = mkDefault "instagrambot";
                displayname = mkDefault "Instagram bridge bot";
                avatar = mkDefault "mxc://maunium.net/JxjlbZUlCPULEeHZSwleUXQv";
              };
              username_template = mkDefault "instagram_{{.}}";
            };
          };
          facebook.settings = {
            network.mode = mkDefault "facebook";
            appservice = {
              id = mkDefault "facebook";
              port = mkDefault 29321;
              bot = {
                username = mkDefault "facebookbot";
                displayname = mkDefault "Facebook bridge bot";
                avatar = mkDefault "mxc://maunium.net/ygtkteZsXnGJLJHRchUwYWak";
              };
              username_template = mkDefault "facebook_{{.}}";
            };
          };
        };
    }
  ];

  meta.maintainers = [ ];
}
