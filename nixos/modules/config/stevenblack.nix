{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getOutput
    maintainers
    mkEnableOption
    mkIf
    lib.mkOption
    mkPackageOption
    types
    ;

  cfg = config.networking.stevenblack;
in
{
  options.networking.stevenblack = {
    enable = lib.mkEnableOption "the stevenblack hosts file blocklist";

    package = lib.mkPackageOption pkgs "stevenblack-blocklist" { };

    block = lib.mkOption {
      type = lib.types.listOf (
        types.enum [
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
    networking.hostFiles = map (x: "${getOutput x cfg.package}/hosts") ([ "ads" ] ++ cfg.block);
  };

  meta.maintainers = with lib.maintainers; [
    moni
    artturin
    frontear
  ];
}
