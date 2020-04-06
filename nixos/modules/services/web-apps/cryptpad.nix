{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cryptpad;
in
{
  options.services.cryptpad = {
    enable = mkEnableOption "the Cryptpad service";

    package = mkOption {
      default = pkgs.cryptpad;
      defaultText = "pkgs.cryptpad";
      type = types.package;
      description = "
        Cryptpad package to use.
      ";
    };

    configFile = mkOption {
      type = types.path;
      default = "${cfg.package}/lib/node_modules/cryptpad/config/config.example.js";
      defaultText = "\${cfg.package}/lib/node_modules/cryptpad/config/config.example.js";
      description = ''
        Path to the JavaScript configuration file.

        See <link
        xlink:href="https://github.com/xwiki-labs/cryptpad/blob/master/config/config.example.js"/>
        for a configuration example.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cryptpad = {
      description = "Cryptpad Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        DynamicUser = true;
        Environment = [
          "CRYPTPAD_CONFIG=${cfg.configFile}"
          "HOME=%S/cryptpad"
        ];
        ExecStart = "${cfg.package}/bin/cryptpad";
        PrivateTmp = true;
        Restart = "always";
        StateDirectory = "cryptpad";
        WorkingDirectory = "%S/cryptpad";
      };
    };
  };
}
