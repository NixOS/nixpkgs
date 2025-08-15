{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
  testing ? import ../lib/testing-python.nix { inherit system pkgs; },
}:

let
  secret1InStore = pkgs.writeText "topsecret" "iamasecret1";
  secret2InStore = pkgs.writeText "topsecret" "iamasecret2";
in

testing.makeTest {
  name = "initrd-secrets-changing";

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;

      boot.loader.grub.device = "/dev/vda";

      boot.initrd.secrets = {
        "/test" = secret1InStore;
        "/run/test" = secret1InStore;
      };
      boot.initrd.systemd = {
        enable = true;
        services.copy-to-sysroot = {
          wantedBy = [ "initrd.target" ];
          after = [ "initrd-fs.target" ];
          script = ''
            cp /test /sysroot/secret-from-initramfs
          '';
        };
      };

      specialisation.secrets2System.configuration = {
        boot.initrd.secrets = lib.mkForce {
          "/test" = secret2InStore;
          "/run/test" = secret2InStore;
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    print(machine.succeed("cat /run/test"))
    machine.succeed(
        "cmp ${secret1InStore} /secret-from-initramfs",
        "cmp ${secret1InStore} /run/test",
    )
    # Select the second boot entry corresponding to the specialisation secrets2System.
    machine.succeed("grub-reboot 1")
    machine.shutdown()

    with subtest("Check that the specialisation's secrets are distinct despite identical kernels"):
        machine.wait_for_unit("multi-user.target")
        print(machine.succeed("cat /run/test"))
        machine.succeed(
            "cmp ${secret2InStore} /secret-from-initramfs",
            "cmp ${secret2InStore} /run/test",
        )
        machine.shutdown()
  '';
}
