{config, lib, ...}:
let
  shells = [ "bash" "zsh" "fish" ];
  phaseDesc = {
    interactiveShellInit = "during interactive shell initialisation";
    loginShellInit = "during login shell initialisation";
    promptInit = "to initialise the prompt";
    shellInit = "during shell initialisation";
  };
  phases = lib.attrsets.mapAttrsToList (n: v: n) phaseDesc;

  inherit (lib) types mkOption mkIf mkMerge;
  inherit (lib.lists) concatMap;
  shPkgsFn = sh: phase: {config,...}: {
    options."${sh}_${phase}" = mkOption {
      description = ''
        File to be sourced by ${sh} ${phaseDesc.${phase}}.
      '';
      type = with types; nullOr path;
      default = null;
    };
  };
  shPkgs = {config,...}:{
    imports = concatMap
      (f: map f phases)
      (map shPkgsFn shells);
  };

  cfg = config.environment.shellFiles;
  mkPhase =
    sh: phase: map (mod: { "${phase}" =
      mkIf (null != mod."${sh}_${phase}") "source ${mod."${sh}_${phase}"}";
    }) cfg;
  mkSh = sh: mkMerge (concatMap (mkPhase sh) phases);
in {
  options.environment.shellFiles = mkOption {
    description = ''
      Files to be sourced by various initialization shell scripts.
    '';
    type = with types;listOf (submodule shPkgs);
    default = [];
  };
  config.programs = {
    bash = mkSh "bash";
    fish = mkSh "fish";
    # TODO: integration with zplugin
    zsh = mkSh "zsh";
  };
}
