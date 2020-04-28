# to run these tests:
# nix-build nixpkgs/lib/tests/teams.nix
# If it builds, all tests passed
{ pkgs ? import ../.. {} }:

let
  inherit (pkgs) lib;
  inherit (lib) types;

  teamModule = { config, ... }: {
    options = {
      scope = lib.mkOption {
        type = types.str;
      };
      members = lib.mkOption {
        type = types.listOf (types.submodule
          (import ./maintainer-module.nix { inherit lib; })
        );
        default = [];
      };
    };
  };

  checkTeam = team: uncheckedAttrs:
  let
      prefix = [ "lib" "maintainer-team" team ];
      checkedAttrs = (lib.modules.evalModules {
        inherit prefix;
        modules = [
          teamModule
          {
            _file = toString ../../maintainers/team-list.nix;
            config = uncheckedAttrs;
          }
        ];
      }).config;
  in checkedAttrs;

  checkedTeams = lib.mapAttrs checkTeam lib.teams;
in pkgs.writeTextDir "maintainer-teams.json" (builtins.toJSON checkedTeams)
