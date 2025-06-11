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
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.networking.stevenblack;
in
{
  options.networking.stevenblack = {
    enable = mkEnableOption "the stevenblack hosts file blocklist";

    package = mkPackageOption pkgs "stevenblack-blocklist" { };

    block = mkOption {
      type = types.listOf (
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

  config = mkIf cfg.enable {
    networking.hostFiles = map (x: "${getOutput x cfg.package}/hosts") ([ "ads" ] ++ cfg.block);
  };

  meta.maintainers = with maintainers; [
    moni
    artturin
    frontear
  ];
}
