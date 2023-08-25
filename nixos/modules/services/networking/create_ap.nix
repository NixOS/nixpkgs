{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.create_ap;
  makeConfigFile = pkgs.writeShellScript "make-create-ap-conf" ''
      set -euo pipefail

      create_ap_config_file=/run/create_ap/create_ap.conf
      rm -rf "$create_ap_config_file"
      cat > "$create_ap_config_file" <<EOF
      ${(generators.toKeyValue { } cfg.settings)}
      EOF
      ${concatMapStrings (script: "${script} \"$create_ap_config_file\"\n") (attrValues cfg.dynamicConfigScripts)}
  '';
in {
  options = {
    services.create_ap = {
      enable = mkEnableOption (lib.mdDoc "setup wifi hotspots using create_ap");
      settings = mkOption {
        type = with types; attrsOf (oneOf [ int bool str ]);
        default = {};
        description = lib.mdDoc ''
          Configuration for `create_ap`.
          See [upstream example configuration](https://raw.githubusercontent.com/lakinduakash/linux-wifi-hotspot/master/src/scripts/create_ap.conf)
          for supported values.
        '';
        example = {
          INTERNET_IFACE = "eth0";
          WIFI_IFACE = "wlan0";
          SSID = "My Wifi Hotspot";
          PASSPHRASE = "12345678";
        };
      };
      dynamicConfigScripts = mkOption {
        default = {};
        type = types.attrsOf types.path;
        example = literalExpression ''
          {
            exampleDynamicConfig = pkgs.writeShellScript "dynamic-config" '''
              CREATE_AP_CONFIG=$1

              cat >> "$CREATE_AP_CONFIG" << EOF
              # Add some dynamically generated statements here
              EOF
            ''';
          }
        '';
        description = mdDoc ''
          All of these scripts will be executed in lexicographical order before create_ap
          is started, right after the global segment was generated and may dynamically
          append global options to the generated configuration file.

          The first argument will point to the configuration file that you may append to.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd = {
      services.create_ap = {
        wantedBy = [ "multi-user.target" ];
        description = "Create AP Service";
        after = [ "network.target" ];
        preStart = lib.concatStringsSep "\n"  [ makeConfigFile ];
        serviceConfig = {
          ExecStart = "${pkgs.linux-wifi-hotspot}/bin/create_ap --config /run/create_ap/create_ap.conf";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RuntimeDirectory = "create_ap";
        };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
