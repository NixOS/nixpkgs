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
      wrapProgram "$out/bin/ioquake3" --add-flags "+set fs_basepath ${cfg.baseq3} +set fs_cdpath ${fsBasepath} +exec settings.cfg"
    '';
  };
in
{
  options.programs.ioquake3 = {
    enable = lib.mkEnableOption "ioquake3, an enhanced, cross-platform, open source engine for id Software's Quake 3";

    package = lib.mkPackageOption pkgs "ioquake3" { };

    baseq3 = lib.mkOption {
      type = with lib.types; (either package path);
      default = pkgs.symlinkJoin {
        name = "quake3-demo-content";
        paths = [
          pkgs.quake3demodata
          pkgs.quake3pointrelease
        ];
      };
      defaultText = "Freely redistributable Quake 3 demo data (`pak0`) plus the 1.32 point release files (`pak1`-`pak8`), merged together.";
      example = "/var/lib/quake3";
      description = ''
        Path to the directory containing the baseq3 files (pak*.pk3).

        Defaults to the freely redistributable demo data (pak0) merged
        with the 1.32 point release files (pak1-pak8), so the game runs
        out of the box without owning a retail copy.

        This value is passed directly as fs_basepath, so pak files are
        searched for in `''${baseq3}/baseq3/`, e.g. a value of
        `/var/lib/quake3` expects `/var/lib/quake3/baseq3/pak0.pk3` and
        so on. To use a full retail install instead, point this at the
        directory containing its `baseq3` folder.
      '';
    };

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
