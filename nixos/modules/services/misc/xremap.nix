{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xremap;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.xremap = {
    enable = lib.mkEnableOption "xremap, key remapper for X11 and Wayland";

    # TODO: use this option to decide which package is used
    package = lib.mkPackageOption pkgs "xremap" { };

    # settings = lib.mkOption
    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    systemd.services.xremap = {
      description = "xremap, key remapper for X11 and Wayland";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${settingsFormat.generate "xremap" cfg.settings}";
        Restart = "always";

        DynamicUser = true;
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];
      };
    };
  };
}
