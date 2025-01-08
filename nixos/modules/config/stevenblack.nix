{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.stevenblack;
in
{
  options.networking.stevenblack = {
    enable = lib.mkEnableOption "the stevenblack hosts file blocklist";

    package = lib.mkPackageOption pkgs "stevenblack-blocklist" { };

    block = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "fakenews"
          "gambling"
          "porn"
          "social"
        ]
      );
      default = [ ];
      description = "Additional blocklist extensions.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostFiles = map (x: "${lib.getOutput x cfg.package}/hosts") ([ "ads" ] ++ cfg.block);
  };

  meta.maintainers = with lib.maintainers; [
    moni
    artturin
    frontear
  ];
}
