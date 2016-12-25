{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  usePythonPackages = pkgs.python3Packages;

  mkTestEnvVar = deps: name: { prepend ? "", append ? "" }: let
    contentFile = pkgs.stdenv.mkDerivation {
      name = "test-env-var-${name}";
      buildInputs = deps;
      buildCommand = "echo \"\$${name}\" > \"$out\"";
    };
  in "${name}=\"${prepend}$(< \"${contentFile}\")${append}\"";

  mkTestEnvVars = vars: deps:
    concatStringsSep " " (mapAttrsToList (mkTestEnvVar deps) vars);

  interpreter = usePythonPackages.python.interpreter;

  runTestPython = vars: deps: "${mkTestEnvVars vars deps} \"${interpreter}\"";

  defaultEnv = {
    PYTHONPATH.prepend = ".:";
    LD_LIBRARY_PATH = {};
    GI_TYPELIB_PATH = {};
  };

  extractTests = drv: dir: ''
    cp -Rd "${drv.overrideDerivation (const {
      phases = [ "unpackPhase" "patchPhase" "installPhase" ];
      installPhase = ''
        mkdir "$out"
        cp -Rd "${dir}" "$out/${dir}"
      '';
    })}/${dir}" .
  '';

  commonMachine = {
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
    fileSystems."/scratch" = {
      device = "/dev/vdb";
      fsType = "ext4";
      autoFormat = true;
    };
  };

  writeTestScript = commands: pkgs.writeScript "run-tests.sh" ''
    #!${pkgs.stdenv.shell} -e

    # Use the hosts temporary directory, because we have a tmpfs within the VM
    # and we don't want to increase the memory size of the VM for no reason.
    mkdir -p /scratch/tmp
    TMPDIR=/scratch/tmp
    export TMPDIR

    # Tests are put into the current working directory so let's make sure we are
    # actually using the additional disk instead of the tmpfs.
    cd /scratch

    ${commands}
  '';

in {
  /*
  blivet = makeTest rec {
    name = "blivet";
    meta.maintainers = [ pkgs.stdenv.lib.maintainers.aszlig ];

    machine = commonMachine;

    debugBlivet       = false;
    debugProgramCalls = false;

    blivetTestRunner = pkgs.writeText "run-blivet-tests.py" ''
      import sys
      import logging

      from unittest import TestLoader
      from unittest.runner import TextTestRunner

      ${pkgs.lib.optionalString debugProgramCalls ''
        blivet_program_log = logging.getLogger("program")
        blivet_program_log.setLevel(logging.DEBUG)
        blivet_program_log.addHandler(logging.StreamHandler(sys.stderr))
      ''}

      ${pkgs.lib.optionalString debugBlivet ''
        blivet_log = logging.getLogger("blivet")
        blivet_log.setLevel(logging.DEBUG)
        blivet_log.addHandler(logging.StreamHandler(sys.stderr))
      ''}

      runner = TextTestRunner(verbosity=2, failfast=False, buffer=False)
      result = runner.run(TestLoader().discover('tests/', pattern='*_test.py'))
      sys.exit(not result.wasSuccessful())
    '';

    blivetDeps = with usePythonPackages; [ blivet mock six ];

    blivetTest = writeTestScript ''
      ${extractTests usePythonPackages.blivet "tests"}
      ${runTestPython defaultEnv blivetDeps} "${blivetTestRunner}"
    '';

    testScript = ''
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("p
      ${runTestPython defaultEnv} "${blivetTestRunner}"
      ${blivetTest}");
      $machine->execute("rm -rf /tmp/xchg/bigtmp");
    '';
  };
  */

  libblockdev = makeTest rec {
    name = "libblockdev";
    meta.maintainers = [ pkgs.stdenv.lib.maintainers.aszlig ];

    machine = { config, pkgs, ... }: {
      imports = [ commonMachine ];
      environment.systemPackages = [
        # For generating test escrow certificates
        pkgs.nssTools
        # While libblockdev is linked against volume_key, the tests require
        # the 'volume_key' to be in PATH.
        pkgs.volume_key
      ];
    };

    testScript = ''
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("${writeTestScript ''
        ${runTestPython defaultEnv [ pkgs.libblockdev ]} \
          -m unittest discover -v -s ${pkgs.libblockdev.tests}/ -p '*_test.py'
      ''}");
    '';
  };
}
