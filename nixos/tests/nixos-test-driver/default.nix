# All tests that don't need a specific config go here.

{ pkgs, ... }:

let
  lib = pkgs.lib;
  machines = import ./machines.nix;
  mkTest =
    name:
    { script
    , nodes ? { inherit (machines) basic; }
    , enableOCR ? false
    }:
    import ../make-test-python.nix
      ({ pkgs, ... }: {
        inherit name nodes enableOCR;

        testScript = builtins.readFile (pkgs.runCommand "testScript.py"
          { preferLocalBuild = true; }
          ''
            cat ${./common.py} ${script} > $out
          '');

        testDriverEdit = import ./coverage-driver.nix;
      })
      { inherit pkgs; };

  combineCoverage = ps: pkgs.runCommand "coverage"
    {
      nativeBuildInputs = [ pkgs.python3Packages.coverage ];
      coverageFiles = map (p: "${p}/.coverage") ps;
      preferLocalBuild = true;
    }
    ''
      COVERAGE_RCFILE=${../../lib/test-driver/.coveragerc} coverage combine --keep $coverageFiles
      cp .coverage $out
    '';

  tests = lib.mapAttrs mkTest {
    low-level = { script = ./low_level.py; };
    systemd = { script = ./systemd.py; };
    files = { script = ./files.py; };
    power = { script = ./power.py; };
    polling-condition = { script = ./polling_condition.py; };
    driver = {
      nodes = { };
      script = ./driver.py;
    };
    tty = {
      nodes = { inherit (machines) tty; };
      script = ./tty.py;
    };
    ocr = {
      nodes = { inherit (machines) x11; };
      script = ./ocr.py;
      enableOCR = true;
    };
    networking = {
      nodes = { inherit (machines) client server; };
      script = ./networking.py;
    };
    x11 = {
      nodes = { inherit (machines) x11; };
      script = ./x11.py;
    };
  };

  combined = combineCoverage (lib.attrValues tests) // tests;
in

combined
