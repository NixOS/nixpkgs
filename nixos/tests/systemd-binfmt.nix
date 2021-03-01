# Teach the kernel how to run armv7l and aarch64-linux binaries,
# and run GNU Hello for these architectures.
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd-binfmt";
  machine = {
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
})
