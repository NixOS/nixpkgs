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
    , skipTypeCheck ? false
    }:
    pkgs.testers.runNixOSTest
      ({ pkgs, ... }: {
        inherit name nodes enableOCR;

        testScript = builtins.readFile (pkgs.runCommand "testScript.py"
          { preferLocalBuild = true; }
          ''
            cat ${./common.py} ${script} > $out
          '');

        makeTestDriver = lib.mkForce (import ./coverage-driver.nix pkgs);
        inherit skipTypeCheck;
      });

  combineCoverage = ps: pkgs.runCommand "coverage"
    {
      nativeBuildInputs = [ pkgs.python3Packages.coverage ];
      coverageFiles = map (p: "${p}/.coverage") (lib.attrValues ps);
      passthru = ps;
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
    # TODO: typing the polling condition file is left as an exercise for people
    # who want to have fun with typing assertions to force mypy to learn about
    # the evolution of the types.
    polling-condition = { script = ./polling_condition.py; skipTypeCheck = true; };
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

  combined = combineCoverage tests;
in

combined
