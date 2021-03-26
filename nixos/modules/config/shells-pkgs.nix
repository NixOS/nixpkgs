{ config, pkgs, lib, ... }:
with lib;
let
  lsMod = m: with types; listOf submodule m;
  inherit (attrsets) nameValuePair mapAttrs;
  attrFIelds = mapAttrs (n: v: n);
  inherit (builtins) filter;
  phases = [ "shellInit" "promptInit" "loginShellInit" "interactiveShellInit" ];
  shells = [ "bash" "fish" "zsh" ];

  sh_phaseModule = sh: phase:
    let
      outputName = phase + "_" + sh;
      getPlugin = attrset.attrByPath [ outputName ] null;
      plugins = builtins.filter (p: null != (getPlugin p)) cfg;
    in
      {
        options = {
          environment.shellPkgs = mkOption {
            type = lsMod {
              options = nameValuePair outputName (
                mkOption {
                  type = with types; nullOr path;
                  default = null;
                  description = ''
                    Path to a script that will be added to ${sh}.${phase}.
                  '';
                }
              );
            };
          };
          programs."${sh}".shellPkgs = mkOption {
            type = lsMod {
              options = nameValuePair outputName (
                mkOption {
                  type = with types; nullOr path;
                  default = null;
                  description = ''
                    Path to a script that will be added to ${sh}.${phase}.
                  '';
                }
              );
            };
          };
        };

        config.programs."${sh}" = mkMerge [
          {
            shellPkgs = filter (p: null != p."${outputName}") config.environment.shellPkgs;
          }
        ] ++ (
          map
            (p: nameValuePair phase "source ${p."${outputName}"}")
            config.programs."${sh}".shellPkgs
        );
      };
  shModule = sh: let
    outputNames = map (phase: phase + "_" + sh) phases;
  in
    {
      imports = map (sh_phaseModule sh) phases;
      options.programs."${sh}".shellPkgs = mkOption {
        default = [];
        description = ''
          A list of packages that will be added to the various phases of ${sh}.
        '';
        type =
          lsMod { freeformType = with types; oneOf [ package (submodule {}) ]; };
      };
      config.assertions = map (
        p: {
          assertion =
            (lists.intersect outputNames (filter (f: null != (p."${f}"or null)) (attrFields p))) != [];
          message = ''
            ${toString p} must have at least one of ${strings.concatStringSep " , " outputNames} outputs.
          '';
        }
      ) config.programs."${sh}".shellPkgs;
    };

in
{
  imports = map shModule shells;
  options.environment.shellPkgs = mkOption {
    default = [];
    description = ''
      A list of packages that will be added to the various phases of various shells.
    '';
    type =
      lsMod { freeformType = with types; oneOf [ package (submodule {}) ]; };
  };
}
