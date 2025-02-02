{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.bcg;
  configFile = (pkgs.formats.yaml {}).generate "bcg.conf.yaml" (
    filterAttrsRecursive (n: v: v != null) {
      inherit (cfg) device name mqtt;
      retain_node_messages = cfg.retainNodeMessages;
      qos_node_messages = cfg.qosNodeMessages;
      base_topic_prefix = cfg.baseTopicPrefix;
      automatic_remove_kit_from_names = cfg.automaticRemoveKitFromNames;
      automatic_rename_kit_nodes = cfg.automaticRenameKitNodes;
      automatic_rename_generic_nodes = cfg.automaticRenameGenericNodes;
      automatic_rename_nodes = cfg.automaticRenameNodes;
    }
  );
in
{
  options = {
    services.bcg = {
      enable = mkEnableOption "BigClown gateway";
      package = mkPackageOption pkgs [ "python3Packages" "bcg" ] { };
      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        example = [ "/run/keys/bcg.env" ];
        description = ''
          File to load as environment file. Environment variables from this file
          will be interpolated into the config file using envsubst with this
          syntax: `$ENVIRONMENT` or `''${VARIABLE}`.
          This is useful to avoid putting secrets into the nix store.
        '';
      };
      verbose = mkOption {
        type = types.enum ["CRITICAL" "ERROR" "WARNING" "INFO" "DEBUG"];
        default = "WARNING";
        description = "Verbosity level.";
      };
      device = mkOption {
        type = types.str;
        description = "Device name to configure gateway to use.";
      };
      name = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Name for the device.

          Supported variables:
          * `{ip}` IP address
          * `{id}` The ID of the connected usb-dongle or core-module

          `null` can be used for automatic detection from gateway firmware.
        '';
      };
      mqtt = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host where MQTT server is running.";
        };
        port = mkOption {
          type = types.port;
          default = 1883;
          description = "Port of MQTT server.";
        };
        username = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "MQTT server access username.";
        };
        password = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "MQTT server access password.";
        };
        cafile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Certificate Authority file for MQTT server access.";
        };
        certfile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Certificate file for MQTT server access.";
        };
        keyfile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Key file for MQTT server access.";
        };
      };
      retainNodeMessages = mkOption {
        type = types.bool;
        default = false;
        description = "Specify that node messages should be retaied in MQTT broker.";
      };
      qosNodeMessages = mkOption {
        type = types.int;
        default = 1;
        description = "Set the guarantee of MQTT message delivery.";
      };
      baseTopicPrefix = mkOption {
        type = types.str;
        default = "";
        description = "Topic prefix added to all MQTT messages.";
      };
      automaticRemoveKitFromNames = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically remove kits.";
      };
      automaticRenameKitNodes = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically rename kit's nodes.";
      };
      automaticRenameGenericNodes = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically rename generic nodes.";
      };
      automaticRenameNodes = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically rename all nodes.";
      };
      rename = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Rename nodes to different name.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python3Packages.bcg
      python3Packages.bch
    ];

    systemd.services.bcg = let
      envConfig = cfg.environmentFiles != [];
      finalConfig = if envConfig
                    then "\${RUNTIME_DIRECTORY}/bcg.config.yaml"
                    else configFile;
    in {
      description = "BigClown Gateway";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ lib.optional config.services.mosquitto.enable "mosquitto.service";
      after = [ "network-online.target" ];
      preStart = mkIf envConfig ''
        umask 077
        ${pkgs.envsubst}/bin/envsubst -i "${configFile}" -o "${finalConfig}"
        '';
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${cfg.package}/bin/bcg -c ${finalConfig} -v ${cfg.verbose}";
        RuntimeDirectory = "bcg";
      };
    };
  };
}
