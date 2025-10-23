# to run these tests:
# nix-build nixpkgs/lib/tests/teams.nix
# If it builds, all tests passed
{
  pkgs ? import ../.. { },
  lib ? pkgs.lib,
}:

let
  inherit (lib) types;

  teamModule =
    { config, ... }:
    {
      options = {
        shortName = lib.mkOption {
          type = types.str;
        };
        scope = lib.mkOption {
          type = types.str;
        };
        enableFeatureFreezePing = lib.mkOption {
          type = types.bool;
          default = false;
        };
        members = lib.mkOption {
          type = types.listOf (types.submodule (import ./maintainer-module.nix { inherit lib; }));
          default = [ ];
        };
        github = lib.mkOption {
          type = types.str;
          default = "";
        };
      };
    };

  checkTeam =
    team: uncheckedAttrs:
    let
      prefix = [
        "lib"
        "maintainer-team"
        team
      ];
      checkedAttrs =
        (lib.modules.evalModules {
          inherit prefix;
          modules = [
            teamModule
            {
              _file = toString ../../maintainers/team-list.nix;
              config = uncheckedAttrs;
            }
          ];
        }).config;
    in
    checkedAttrs;

  checkedTeams = lib.mapAttrs checkTeam lib.teams;
in
pkgs.writeTextDir "maintainer-teams.json" (builtins.toJSON checkedTeams)
