{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.networking.netplan;
  networkdEnabled = (config.networking.useNetworkd || config.systemd.network.enable);
  networkmanagerEnabled = config.networking.networkmanager.enable;
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
    warnings = lib.optionals (cfg.enable && !(networkdEnabled || networkmanagerEnabled)) [
      "You enabled the netplan-configure service, but you haven't enabled a backend for it. It's likely you want to enable either networkd or NetworkManager."
    ];
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
    systemd = {
      packages = [ cfg.package ];
      services.netplan-configure.wantedBy = mkIf cfg.enable [ "sysinit.target" ];
      tmpfiles.settings."netplan"."/run/netplan".d = {
        user = "root";
        group = "root";
        mode = "0700";
      };
    };
  };
}
