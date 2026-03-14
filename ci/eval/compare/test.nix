{
  pkgs ? import ../../.. {
    config = { };
    overlays = [ ];
  },
  lib ? pkgs.lib,
}:
let
  fun = import ./maintainers.nix { inherit lib; };

  mockPkgs =
    {
      packages ? [ ],
      modules ? [ ],
      githubTeams ? true,
    }:
    lib.updateManyAttrsByPath
      (lib.imap0 (i: p: {
        path = p;
        update = _: {
          meta.maintainersPosition.file = lib.concatStringsSep "/" p;
          meta.nonTeamMaintainers = [ { githubId = i; } ];
          meta.teams =
            if githubTeams then [ { githubId = i + 100; } ] else [ { members = [ { githubId = i + 100; } ]; } ];
        };
      }) packages)
      {
        nixos =
          { }:
          {
            config.meta.maintainers = lib.listToAttrs (
              lib.imap0 (i: m: lib.nameValuePair m [ { githubId = i; } ]) modules
            );
            config.meta.teams = lib.listToAttrs (
              lib.imap0 (
                i: m:
                lib.nameValuePair m (
                  if githubTeams then [ { githubId = i + 100; } ] else [ { members = [ { githubId = i + 100; } ]; } ]
                )
              ) modules
            );
          };
      };

  tests = {
    testEmpty = {
      expr = fun {
        pkgs = mockPkgs { };
        changedFiles = [ ];
        affectedAttrPaths = [ ];
      };
      expected = {
        packages = [ ];
        teams = { };
        users = { };
      };
    };
    testNonExistentAffected = {
      expr = fun {
        pkgs = mockPkgs { };
        changedFiles = [ "a" ];
        affectedAttrPaths = [ [ "b" ] ];
      };
      expected = {
        packages = [ ];
        teams = { };
        users = { };
      };
    };
    testIrrelevantAffected = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "b" ] ];
        };
        changedFiles = [ "a" ];
        affectedAttrPaths = [ [ "b" ] ];
      };
      expected = {
        packages = [ ];
        teams = { };
        users = { };
      };
    };
    testRelevantAffected = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "b" ] ];
        };
        # Also tests that subpaths work
        changedFiles = [ "b/c" ];
        affectedAttrPaths = [ [ "b" ] ];
      };
      expected = {
        packages = [ [ "b" ] ];
        teams."100" = [
          { attrPath = [ "b" ]; }
        ];
        users."0" = [
          { attrPath = [ "b" ]; }
        ];
      };
    };
    testRelevantAffectedNonGitHub = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "b" ] ];
          githubTeams = false;
        };
        changedFiles = [ "b/c" ];
        affectedAttrPaths = [ [ "b" ] ];
      };
      expected = {
        packages = [ [ "b" ] ];
        teams = { };
        users."0" = [
          { attrPath = [ "b" ]; }
        ];
        users."100" = [
          { attrPath = [ "b" ]; }
        ];
      };
    };
    testByNameChanged = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "hello" ] ];
        };
        changedFiles = [ "pkgs/by-name/he/hello/sources.json" ];
        affectedAttrPaths = [ ];
      };
      expected = {
        packages = [ [ "hello" ] ];
        teams."100" = [
          { attrPath = [ "hello" ]; }
        ];
        users."0" = [
          { attrPath = [ "hello" ]; }
        ];
      };
    };
    testByNameReadmeChanged = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "hello" ] ];
        };
        changedFiles = [ "pkgs/by-name/README.md" ];
        affectedAttrPaths = [ ];
      };
      expected = {
        packages = [ ];
        teams = { };
        users = { };
      };
    };
    testNoDuplicates = {
      expr = fun {
        pkgs = mockPkgs {
          packages = [ [ "hello" ] ];
        };
        changedFiles = [
          "hello"
          "pkgs/by-name/he/hello/sources.json"
        ];
        affectedAttrPaths = [ [ "hello" ] ];
      };
      expected = {
        packages = [ [ "hello" ] ];
        teams."100" = [
          { attrPath = [ "hello" ]; }
        ];
        users."0" = [
          { attrPath = [ "hello" ]; }
        ];
      };
    };
    testModuleMaintainers = {
      expr = fun {
        pkgs = mockPkgs {
          modules = [ "a" ];
        };
        changedFiles = [ "a" ];
        affectedAttrPaths = [ ];
      };
      expected = {
        packages = [ ];
        teams."100" = [
          { file = "a"; }
        ];
        users."0" = [
          { file = "a"; }
        ];
      };
    };
    testModuleMaintainersNonGithub = {
      expr = fun {
        pkgs = mockPkgs {
          modules = [ "a" ];
          githubTeams = false;
        };
        changedFiles = [ "a" ];
        affectedAttrPaths = [ ];
      };
      expected = {
        packages = [ ];
        teams = { };
        users."100" = [
          { file = "a"; }
        ];
        users."0" = [
          { file = "a"; }
        ];
      };
    };
  };
in
{
  result = lib.runTests tests;
}
