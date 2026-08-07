{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.ioquake3;

  toIoquake3Value = value: if lib.isBool value then (if value then "1" else "0") else toString value;

  # Quake 3 is unable to read or execute long config files from the Nix store,
  # therefore we link it to /etc
  fsBasepath = "/etc/xdg/ioquake3";

  toIoquake3Config =
    settings:
    lib.concatStrings (
      lib.mapAttrsToList (name: value: ''seta ${name} "${toIoquake3Value value}"'' + "\n") settings
    );

  configFile = pkgs.writeText "ioquake3-settings.cfg" (toIoquake3Config cfg.settings);

  ioquake3Wrapped = pkgs.symlinkJoin {
    name = "ioquake3-wrapped";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/ioquake3" --add-flags  "+set fs_basepath ${fsBasepath} +exec settings.cfg"
    '';
  };
in
{
  options.programs.ioquake3 = {
    enable = lib.mkEnableOption "ioquake3, an enhanced, cross-platform, open source engine for id Software's Quake 3";

    package = lib.mkPackageOption pkgs "ioquake3" { };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.float
          lib.types.bool
        ]
      );
      default = { };
      example = lib.literalExpression ''
        {
          name = "Player";
          sensitivity = 5;
          r_fullscreen = true;
          cl_maxfps = 125;
        }
      '';
      description = ''
        ioquake3 configuration, written out as a cfg file that is loaded on
        startup via `+exec`. Keys are cvar names, values are the cvar
        values.

        See <https://ioquake3.org/help/players-guide/> for some available
        configuration options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ ioquake3Wrapped ];
      etc."xdg/ioquake3/baseq3/settings.cfg".source = configFile;
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ onny ];
  };
}
