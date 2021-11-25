{ config, pkgs, lib, ... }:
let
  cfg = config.environment.shellPkgs;
  cfgSh = sh: config.programs."${sh}".shellPkgs;
  inherit (builtins) filter;
  inherit (lib) types mkOption;
  lsMod = m: with types; listOf submodule m;
  shPkgBaseType = lsMod { freeformType = with types; oneOf [ package (submodule { }) ]; };
  assertOutputsArePresent = outputNames: map (p: {
    assertion = lib.lists.any (x: (p."${x}" or null) != null) outputNames;
    message = ''
      ${p.pname or p.name or (builtins.toJSON p)} must have at least one of ${strings.concatStringSep " , " outputNames} outputs.
    '';
  });


  modByShAndPhase = sh: phase:
    let
      outputName = phase + "_" + sh;
      o.shellPkgs = mkOption {
        type = lsMod {
          options."${outputName}" = mkOption {
            type = with types; nullOr path;
            default = null;
            description = ''
              Path to a script that will be added to programs.${sh}.${phase}.
            '';
          };
        };
      };
      sourced = pkgs.runCommand outputName
        {
          files = map (p: p."${outputName}") (cfgSh sh);
        } "cat $files > $out";
    in
    {
      options = {
        environment = o;
        programs."${sh}" = o;
      };
      config.environment.shellPkgsOutputs = [ outputName ];
      config.programs."${sh}" = {
        shellPkgs = filter (p: null != (p."${outputName}"or null)) cfg;
        "${phase}" = "source ${sourced}";
      };
    };


  modByPhasesAndSh = phases: sh:
    let
      outputNames = map (phase: phase + "_" + sh) phases;
    in
    {
      imports = map (modByShAndPhase sh) phases;
      options.programs."${sh}".shellPkgs = mkOption {
        default = [ ];
        description = ''
          A list of packages that will be added to the various phases of ${sh}.
        '';
        type = shPkgBaseType // {
          description = "A list of packages with outputs for the phases of ${sh}.";
        };
      };
      config.assertions = assertOutputsArePresent outputNames (cfgSh sh);
    };

in

{
  imports =
    map (modByPhasesAndSh [ "shellInit" "promptInit" "loginShellInit" "interactiveShellInit" ])
      [ "bash" "fish" "zsh" ];

  options.environment = {
    shellPkgs = mkOption {
      default = [ ];
      description = ''
        A list of packages that will be added to the various phases of various shells.
      '';
      type = shPkgBaseType // {
        description = "A list of packages with outputs for the phases of various shells.";
      };
    };

    shellPkgsOutputs = mkOption {
      internal = true;
      type = with types; listOf string;
      description = "A list of build outputs taken in consideration for environment.shellPkgs";
    };
  };

  config.assertions = assertOutputsArePresent config.environment.shellPkgsOutputs cfg;
}
