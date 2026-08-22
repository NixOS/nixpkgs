{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.i18n.spellcheck = {
    enable = lib.mkEnableOption "additional packages for spellchecking";
  };

  config = lib.mkIf config.i18n.spellcheck.enable {
    environment.systemPackages = [
      pkgs.hunspellWithDicts
      (
        dicts:
        lib.remove null (
          lib.map (
            locale:
            let
              attr = lib.head (lib.splitString "." locale);
            in
            dicts."${attr}-large" or dicts.${attr} or null
          ) config.i18n.supportedLocales
        )
      )
    ];
  };
}
