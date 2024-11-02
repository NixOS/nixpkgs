# Teach the kernel how to run armv7l and aarch64-linux binaries,
# and run GNU Hello for these architectures.

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  expectArgv0 = xpkgs: xpkgs.runCommandCC "expect-argv0" {
    src = pkgs.writeText "expect-argv0.c" ''
      #include <stdio.h>
      #include <string.h>

      int main(int argc, char **argv) {
        fprintf(stderr, "Our argv[0] is %s\n", argv[0]);

        if (strcmp(argv[0], argv[1])) {
          fprintf(stderr, "ERROR: argv[0] is %s, should be %s\n", argv[0], argv[1]);
          return 1;
        }

        return 0;
      }
    '';
  } ''
    $CC -o $out $src
  '';
in {
  basic = makeTest {
    name = "systemd-binfmt";
    nodes.machine = {
      boot.binfmt.emulatedSystems = [
        "armv7l-linux"
        "aarch64-linux"
      ];
    };

    testScript = let
      helloArmv7l = pkgs.pkgsCross.armv7l-hf-multiplatform.hello;
      helloAarch64 = pkgs.pkgsCross.aarch64-multiplatform.hello;
    in ''
      machine.start()

      assert "world" in machine.succeed(
          "${helloArmv7l}/bin/hello"
      )

      assert "world" in machine.succeed(
          "${helloAarch64}/bin/hello"
      )
    '';
  };

  preserveArgvZero = makeTest {
    name = "systemd-binfmt-preserve-argv0";
    nodes.machine = {
      boot.binfmt.emulatedSystems = [
        "aarch64-linux"
      ];
    };
    testScript = let
      testAarch64 = expectArgv0 pkgs.pkgsCross.aarch64-multiplatform;
    in ''
      machine.start()
      machine.succeed("exec -a meow ${testAarch64} meow")
    '';
  };

  ldPreload = makeTest {
    name = "systemd-binfmt-ld-preload";
    nodes.machine = {
      boot.binfmt.emulatedSystems = [
        "aarch64-linux"
      ];
    };
    testScript = let
      helloAarch64 = pkgs.pkgsCross.aarch64-multiplatform.hello;
      libredirectAarch64 = pkgs.pkgsCross.aarch64-multiplatform.libredirect;
    in ''
      machine.start()

      assert "error" not in machine.succeed(
          "LD_PRELOAD='${libredirectAarch64}/lib/libredirect.so' ${helloAarch64}/bin/hello 2>&1"
      ).lower()
    '';
  };

  chroot = makeTest {
    name = "systemd-binfmt-chroot";
    nodes.machine = { pkgs, lib, ... }: {
      boot.binfmt.emulatedSystems = [
        "aarch64-linux" "wasm32-wasi"
      ];
      boot.binfmt.preferStaticEmulators = true;

      environment.systemPackages = [
        (pkgs.writeShellScriptBin "test-chroot" ''
          set -euo pipefail
          mkdir -p /tmp/chroot
          cp ${lib.getExe' pkgs.pkgsCross.aarch64-multiplatform.pkgsStatic.busybox "busybox"} /tmp/chroot/busybox
          cp ${lib.getExe pkgs.pkgsCross.wasi32.yaml2json} /tmp/chroot/yaml2json # wasi binaries that build are hard to come by
          chroot /tmp/chroot /busybox uname -m | grep aarch64
          echo 42 | chroot /tmp/chroot /yaml2json | grep 42
        '')
      ];
    };
    testScript = ''
      machine.start()
      machine.succeed("test-chroot")
    '';
  };
}
