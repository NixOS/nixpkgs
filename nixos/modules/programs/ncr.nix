{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ncr;
in
{
  options.programs.ncr = {
    enable = lib.mkEnableOption "NCR, a Nix configuration closure reporter";

    package = lib.mkPackageOption pkgs "ncr" { };

    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/user/nixconf";
      description = ''
        Default flake path or URL for NCR to report on.
        Sets the `NCR_FLAKE` environment variable.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.variables.NCR_FLAKE = lib.mkIf (cfg.flake != null) cfg.flake;
  };

  meta = {
    doc = ./ncr.md;
    maintainers = [ lib.maintainers.greyxp1 ];
  };
}
