{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sylkserver;
in
{
  options.services.sylkserver = {
    enable = mkEnableOption "SIP/WebRTC Application Server";

    package = mkOption {
      default = pkgs.sylkserver;
      defaultText = "pkgs.sylkserver";
      type = types.package;
      description = "
        Sylk server package to use.
      ";
    };

    configDir = mkOption {
      type = types.path;
      default = "/etc/sylkserver";
      description = ''
        Path that contains all the configuration files.

        See <link
        xlink:href="https://github.com/AGProjects/sylkserver/"/>
        for a configuration examples.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sylkserver = {
      description = "Sylk server service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        DynamicUser = true;
        Environment = [
          # Disable i/o buffering on Python
          "PYTHONUNBUFFERED=yes"
          "HOME=%S/sylkserver"
        ];
        ExecStart = ''
          ${cfg.package}/bin/sylk-server \
            --no-fork \
            --runtime-dir=$RUNTIME_DIRECTORY \
            --config-dir=${cfg.configDir}
        '';
        PrivateTmp = true;
        Restart = "on-abnormal";
        RuntimeDirectory = "sylkserver";
        StateDirectory = "sylkserver";
        WorkingDirectory = "%S/sylkserver";
      };
    };
  };
}
