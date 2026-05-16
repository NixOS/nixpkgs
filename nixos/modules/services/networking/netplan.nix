{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.networking.netplan;
in
{
  options = {
    networking.netplan = {
      install = mkEnableOption "Whether to install the netplan package";
      enable = mkEnableOption "Whether to enable the netplan-configure service at boot";
      package = lib.mkPackageOption pkgs "netplan" { };
      configFiles = mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = ''
          {
            "10-example.yaml" = \'\'
               ---
               network:
                 version: 2
                 dummy-devices:
                   example:
                     addresses: ["fd00::feed:cafe/32"]
               \'\'
          }
        '';
        description = "Netplan YAML configuration files to write under /etc/netplan/";
      };
    };
  };

  config = mkIf cfg.install {
    environment = {
      systemPackages = [ cfg.package ];
      etc = builtins.listToAttrs (
        builtins.map (key: {
          name = "netplan/" + key;
          value = {
            text = cfg.configFiles."${key}";
            user = "root";
            group = "root";
            mode = "0600";
          };
        }) (pkgs.lib.attrNames cfg.configFiles)
      );
    };
    systemd.packages = [ cfg.package ];
    systemd.services.netplan-configure.wantedBy = mkIf cfg.enable [ "sysinit.target" ];
  };
}
