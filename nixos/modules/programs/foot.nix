{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.foot;

  settingsFormat = pkgs.formats.iniWithGlobalSection { };
in
{
  options.programs.foot = {
    enable = lib.mkEnableOption "foot terminal emulator";

    package = lib.mkPackageOption pkgs "foot" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Configuration for foot terminal emulator. Further information can be found in foot's man page foot.ini(5).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/foot/foot.ini".text = lib.generators.toINIWithGlobalSection {
        mkKeyValue =
          with lib.generators;
          mkKeyValueDefault {
            mkValueString = (
              v:
              mkValueStringDefault { } (
                if v == true then
                  "yes"
                else if v == false then
                  "no"
                else
                  v
              )
            );
          } cfg.settings;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ linsui ];
  };
}
