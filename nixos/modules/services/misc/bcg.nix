{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bcg;
  configFile = (pkgs.formats.yaml { }).generate "bcg.conf.yaml" (
    lib.filterAttrsRecursive (n: v: v != null) {
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
      enable = lib.mkEnableOption "BigClown gateway";
      package = lib.mkPackageOption pkgs [ "python3Packages" "bcg" ] { };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = [ "/run/keys/bcg.env" ];
        description = ''
          File to load as environment file. Environment variables from this file
          will be interpolated into the config file using envsubst with this
          syntax: `$ENVIRONMENT` or `''${VARIABLE}`.
          This is useful to avoid putting secrets into the nix store.
        '';
      };
      verbose = lib.mkOption {
        type = lib.types.enum [
          "CRITICAL"
          "ERROR"
          "WARNING"
          "INFO"
          "DEBUG"
        ];
        default = "WARNING";
        description = "Verbosity level.";
      };
      device = lib.mkOption {
        type = lib.types.str;
        description = "Device name to configure gateway to use.";
      };
      name = lib.mkOption {
        type = with lib.types; nullOr str;
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
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Host where MQTT server is running.";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 1883;
          description = "Port of MQTT server.";
        };
        username = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "MQTT server access username.";
        };
        password = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "MQTT server access password.";
        };
        cafile = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Certificate Authority file for MQTT server access.";
        };
        certfile = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Certificate file for MQTT server access.";
        };
        keyfile = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Key file for MQTT server access.";
        };
      };
      retainNodeMessages = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Specify that node messages should be retaied in MQTT broker.";
      };
      qosNodeMessages = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Set the guarantee of MQTT message delivery.";
      };
      baseTopicPrefix = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Topic prefix added to all MQTT messages.";
      };
      automaticRemoveKitFromNames = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically remove kits.";
      };
      automaticRenameKitNodes = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically rename kit's nodes.";
      };
      automaticRenameGenericNodes = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically rename generic nodes.";
      };
      automaticRenameNodes = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically rename all nodes.";
      };
      rename = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        description = "Rename nodes to different name.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python3Packages.bcg
      python3Packages.bch
    ];

    systemd.services.bcg =
      let
        envConfig = cfg.environmentFiles != [ ];
        finalConfig = if envConfig then "\${RUNTIME_DIRECTORY}/bcg.config.yaml" else configFile;
      in
      {
        description = "BigClown Gateway";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "network-online.target"
        ]
        ++ lib.optional config.services.mosquitto.enable "mosquitto.service";
        after = [ "network-online.target" ];
        preStart = lib.mkIf envConfig ''
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
