{ lib, ... }:
{

  name = "qemu-vm-store";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes = {
    sharedWritable = {
      virtualisation.writableStore = true;
    };

    sharedReadOnly = {
      virtualisation.writableStore = false;
    };

    imageWritable = {
      virtualisation.useNixStoreImage = true;
      virtualisation.writableStore = true;
    };

    imageReadOnly = {
      virtualisation.useNixStoreImage = true;
      virtualisation.writableStore = false;
    };

    fullDisk = {
      virtualisation.useBootLoader = true;
    };
  };

  testScript = ''
    build_derivation = """
      nix-build --option substitute false -E 'derivation {
        name = "t";
        builder = "/bin/sh";
        args = ["-c" "echo something > $out"];
        system = builtins.currentSystem;
        preferLocalBuild = true;
      }'
    """

    start_all()

    with subtest("Nix Store is writable"):
      sharedWritable.succeed(build_derivation)
      imageWritable.succeed(build_derivation)
      fullDisk.succeed(build_derivation)

    with subtest("Nix Store is read only"):
      sharedReadOnly.fail(build_derivation)
      imageReadOnly.fail(build_derivation)

    # Checking whether the fs type is 9P is just a proxy to test whether the
    # Nix Store is shared. If we switch to a different technology (e.g.
    # virtiofs) for sharing, we need to adjust these tests.

    with subtest("Nix store is shared from the host via 9P"):
      sharedWritable.succeed("findmnt --kernel --type 9P /nix/.ro-store")
      sharedReadOnly.succeed("findmnt --kernel --type 9P /nix/.ro-store")

    with subtest("Nix store is not shared via 9P"):
      imageWritable.fail("findmnt --kernel --type 9P /nix/.ro-store")
      imageReadOnly.fail("findmnt --kernel --type 9P /nix/.ro-store")

    with subtest("Nix store is not mounted separately"):
      rootDevice = fullDisk.succeed("stat -c %d /")
      nixStoreDevice = fullDisk.succeed("stat -c %d /nix/store")
      assert rootDevice == nixStoreDevice, "Nix store is mounted separately from the root fs"
  '';

}
