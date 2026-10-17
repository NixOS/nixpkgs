{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tack;
in
{
  options.programs.tack = {
    enable = lib.mkEnableOption "tack, flake-like toml nix pins";

    package = lib.mkPackageOption pkgs "tack" { };

    nixConfTokens = lib.mkEnableOption "tack reading access tokens from nix.conf (significantly improves comparison speed)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.sessionVariables = lib.mkIf cfg.nixConfTokens {
      TACK_NIX_CONF_TOKENS = "1";
    };
  };
}
