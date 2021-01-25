{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.environment.shellPkgs;
  lsMod = m: with types; listOf submodule m;
  nvp = attrsets.nameValuePair;
  phases = [ "shellInit" "promptInit" "loginShellInit" "interactiveShellInit" ];
  shells = [ "bash" "fish" "zsh" ];

  shModule = sh: phase:
    let
      phase_sh = phase + "_" + sh;
      getPlugin = attrset.attrByPath [ phase_sh ] null;
      plugins = builtins.filter (p: null != (getPlugin p)) cfg;
    in {
      options.environment.shellPkgs = mkOption {
        type = lsMod {
          options = nvp phase_sh (mkOption {
            type = with types; nullOr path;
            default = null;
            description = ''
              Path to a script that will be added to ${sh}.${phase}.
            '';
          });
        };
      };

      config.programs = nvp sh (nvp phase (mkMerge (map (p: "source '${getPlugin p}'\n") plugins)));
    };

in {
  imports = lists.concatMap
    (f: map f phases)
    (map shModule shells);
  options.environment.shellPkgs = mkOption {
    default = [ ];
    description = ''
      A list of packages that will be added to the various phases of various shells.
    '';
    type =
      lsMod { freeformType = with types; oneOf [ package (submodule { }) ]; };
  };
}
