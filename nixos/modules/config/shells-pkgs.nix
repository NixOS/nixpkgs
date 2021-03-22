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
      phase_sh = phase + "_" + sh;
      getPlugin = attrset.attrByPath [ phase_sh ] null;
      plugins = builtins.filter (p: null != (getPlugin p)) cfg;
    in
      {
        options = {
          environment.shellPkgs = mkOption {
            type = lsMod {
              options = nameValuePair phase_sh (
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
              options = nameValuePair phase_sh (
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
            shellPkgs = filter (p: p?"${phase_sh}") config.environment.shellPkgs;
          }
        ] ++ (
          map
            (p: nameValuePair phase "source ${p."${phase_sh}"}")
            config.programs."${sh}".shellPkgs
        );
      };
  shModule = sh: let
    phases_sh = map (phase: phase + "_" + sh) phases;
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
            (lists.intersect phases_sh (attrFields config.programs."${sh}".shellPkgs)) != [];
          message = ''
            ${toString p} must have at least one of ${strings.concatStringSep " , " phases_sh} attribute
          '';
        }
      );
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
