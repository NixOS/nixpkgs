{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ladybird;
in
{
  options.programs.ladybird = {
    enable = lib.mkEnableOption "the Ladybird web browser";
    package = lib.mkPackageOption pkgs "ladybird" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    fonts.fontDir.enable = true;
  };

}
