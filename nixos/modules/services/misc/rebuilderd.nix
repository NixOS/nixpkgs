{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption;
  cfg = config.services.rebuilderd;

  format = pkgs.formats.toml { };
  settings = lib.attrsets.filterAttrs (n: v: v != null) cfg.settings;
  configFile = format.generate "rebuilderd.conf" settings;
in
{
  options.services.rebuilderd = {
    enable = mkEnableOption "rebuilderd service for independent verification of binary packages";
    package = mkPackageOption pkgs "rebuilderd" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Configuration for rebuilderd (rebuilderd.conf)
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rebuilderd = {
      description = "Independent verification of binary packages";
      wantedBy = [ "multi-user.target" ];
      environment = {
        REBUILDERD_COOKIE_PATH = "/var/lib/rebuilderd/auth-cookie";
      };
      after = [
        "network.target"
      ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rebuilderd --config ${configFile}";
        DynamicUser = true;
        StateDirectory = "rebuilderd";
        WorkingDirectory = "/var/lib/rebuilderd";
      };
    };
  };
}
