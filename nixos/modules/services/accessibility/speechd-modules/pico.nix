{
  lib,
  pkgs,
  mkPackageOption,
  mkEnableOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule (
    { config, ... }:
    {
      options = {
        enable = mkEnableOption "Pico text to speech output module";
        package = mkPackageOption pkgs "picotts" { };
        lingwarePath = mkOption {
          type = lib.types.path;
          default = "${config.package}/share/pico/lang/";
          defaultText = lib.literalExpression ''"''${config.package}/share/pico/lang/"'';
          description = ''
            Path to the Pico lingware directory containing the `.bin`
            text-analysis and signal-generation resource files.

            Sets {var}`PicoLingwarePath`.
          '';
          example = "/etc/pico/lang/";
        };
        debug = mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable debug output.
          '';
          example = true;
        };
        extraConfig = mkExtraConfigOption { };
      };
    }
  );

  displayName = "SVOX Pico";
  binary = "sd_pico";
  confFile = "pico.conf";

  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/pico.conf".text = ''
        Debug ${if modCfg.debug then "1" else "0"}
        PicoLingwarePath "${modCfg.lingwarePath}"
      ''
      + "\n"
      + modCfg.extraConfig;
    };

  assertions =
    modCfg:
    lib.mapAttrsToList
      (directive: option: {
        assertion = !(lib.hasInfix directive modCfg.extraConfig);
        message = ''
          services.speechd.modules.pico.extraConfig contains an ${directive} directive.
          Use services.speechd.modules.pico.${option} instead.
        '';
      })
      {
        PicoLingwarePath = "lingwarePath";
      };

}
