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
  package =
    cfg.package or (
      if (config.networking.enableIPv6 or false) then
        pkgs.stevenblack-blocklist-ipv6
      else
        pkgs.stevenblack-blocklist
    );
in
{
  options.networking.stevenblack = {
    enable = mkEnableOption "the stevenblack hosts file blocklist";

    # What I want: See https://github.com/NixOS/nixpkgs/pull/375424
    /*
      package = mkPackageOption pkgs "stevenblack-blocklist" {
        default =
          if (config.networking.enableIPv6 or false) then
            "stevenblack-blocklist-ipv6"
          else
            "stevenblack-blocklist";
        defaultText = lib.literalExpression ''
          if (config.networking.enableIPv6 or false) then
            pkgs.stevenblack-blocklist-ipv6
          else
            pkgs.stevenblack-blocklist
        '';
      };
    */

    package = mkPackageOption pkgs "stevenblack-blocklist" {
      default = null;
    };

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
    networking.hostFiles = map (x: "${getOutput x package}/hosts") ([ "ads" ] ++ cfg.block);
  };

  meta.maintainers = with maintainers; [
    moni
    artturin
    frontear
    pandapip1
  ];
}
