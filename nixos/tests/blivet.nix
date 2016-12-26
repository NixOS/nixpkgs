{ system ? builtins.currentSystem, debug ? false }:

let
  inherit (import ../lib/testing.nix { inherit system; }) pkgs makeTest;
  inherit (pkgs) lib;

  mkCommonTest = name: attrs@{ package, ... }: let
    pythonTestRunner = pkgs.writeText "run-python-tests.py" ''
      import sys
      import logging

      from unittest import TestLoader
      from unittest.runner import TextTestRunner

      ${attrs.extraCode or ""}

      testdir = '${package.tests}/tests/'
      sys.path.insert(0, '${package.tests}')
      runner = TextTestRunner(verbosity=2, failfast=False, buffer=False)
      result = runner.run(TestLoader().discover(testdir, pattern='*_test.py'))
      sys.exit(not result.wasSuccessful())
    '';

    testRunner = let
      testVars = [ "PYTHONPATH" "GI_TYPELIB_PATH" ];
      varsRe = lib.concatStringsSep "|" testVars;
      testEnv = pkgs.runCommand "test-env" {
        buildInputs = lib.singleton package ++ (attrs.extraDeps or []);
      } "set | sed -nr -e '/^(${varsRe})/s/^/export /p' > \"$out\"";
      interpreter = pkgs.python3Packages.python.interpreter;
    in pkgs.writeScript "run-tests.sh" ''
      #!${pkgs.stdenv.shell} -e

      # Use the hosts temporary directory, because we have a tmpfs within
      # the VM and we don't want to increase the memory size of the VM for
      # no reason.
      mkdir -p /scratch/tmp
      TMPDIR=/scratch/tmp
      export TMPDIR

      # Tests are put into the current working directory so let's make sure
      # we are actually using the additional disk instead of the tmpfs.
      cd /scratch

      source ${lib.escapeShellArg testEnv}
      exec ${lib.escapeShellArg pkgs.python3Packages.python.interpreter} \
        ${lib.escapeShellArg pythonTestRunner}
    '';

  in makeTest {
    inherit name;

    machine = {
      boot.kernelModules = [
        "dm-bufio"
        "dm-cache"
        "dm-cache-cleaner"
        "dm-cache-mq"
        "dm-mirror"
        "dm-multipath"
        "dm-persistent-data"
        "dm-raid"
        "dm-snapshot"
        "dm-thin-pool"
        "zram"
      ];
      boot.supportedFilesystems = [ "btrfs" "jfs" "reiserfs" "xfs" ];
      virtualisation.memorySize = 768;
      virtualisation.emptyDiskImages = [ 10240 ];
      environment.systemPackages = attrs.extraSystemDeps or [];
      fileSystems."/scratch" = {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };
    };

    testScript = ''
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("${testRunner}");
    '';

    meta.maintainers = [ pkgs.stdenv.lib.maintainers.aszlig ];
  };

in {
  blivet = mkCommonTest "blivet" rec {
    package = pkgs.python3Packages.blivet;
    extraDeps = [ pkgs.python3Packages.mock ];
    extraCode = lib.optionalString debug ''
      blivet_program_log = logging.getLogger("program")
      blivet_program_log.setLevel(logging.DEBUG)
      blivet_program_log.addHandler(logging.StreamHandler(sys.stderr))

      blivet_log = logging.getLogger("blivet")
      blivet_log.setLevel(logging.DEBUG)
      blivet_log.addHandler(logging.StreamHandler(sys.stderr))
    '';
  };

  libblockdev = mkCommonTest "libblockdev" rec {
    package = pkgs.libblockdev;
    extraSystemDeps = [
      # For generating test escrow certificates
      pkgs.nssTools
      # While libblockdev is linked against volume_key,
      # the tests require the 'volume_key' to be in PATH.
      pkgs.volume_key
    ];
  };
}
