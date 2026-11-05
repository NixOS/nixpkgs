{ lib, ... }:

{
  name = "qemu-vm-store-compression";

  defaults = { pkgs, ... }: {
    nix.enable = true;
    environment = {
      systemPackages = [ pkgs.erofs-utils ];
      etc."erofs-compression-payload".text = lib.concatStrings (
        lib.replicate 8192 "EROFS store image compression fixture\n"
      );
    };
    virtualisation = {
      useNixStoreImage = true;
      memorySize = 512;
    };
  };

  nodes =
    lib.genAttrs
      [
        "lz4"
        "lz4hc"
        "lzma"
        "deflate"
        "libdeflate"
      ]
      (algorithm: {
        boot.kernelPatches = lib.optionals (algorithm == "lzma") [
          {
            name = "erofs-lzma";
            patch = null;
            structuredExtraConfig.EROFS_FS_ZIP_LZMA = lib.kernel.yes;
          }
        ];
        virtualisation = {
          nixStoreImageCompression = algorithm;
          writableStore = false;
        };
      })
    // {
      zstd.virtualisation = {
        writableStore = true;
        nixStoreImageCompression.zstd = {
          level = 6;
          dictionarySize = 65536;
        };
      };
    };

  testScript = ''
    import re

    build_derivation = """
      nix-build --option substitute false -E 'derivation {
        name = "compression-test";
        builder = "/bin/sh";
        args = ["-c" "echo something > $out"];
        system = builtins.currentSystem;
        preferLocalBuild = true;
      }'
    """

    for machine in (lz4, lz4hc, lzma, deflate, libdeflate, zstd):
        with subtest(f"{machine.name}: compressed store is readable"):
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("findmnt --kernel --type erofs /nix/.ro-store")
            machine.succeed("test -x /run/current-system/sw/bin/bash")

        with subtest(f"{machine.name}: store payload is compressed"):
            path = machine.succeed("readlink -f /etc/erofs-compression-payload").strip()
            inode = machine.succeed(
                f"dump.erofs --path={path.removeprefix('/nix/store')} /dev/disk/by-label/nix-store"
            )
            sizes = re.search(r"^Size: (\d+)\s+On-disk size: (\d+)", inode, re.MULTILINE)
            assert sizes is not None, inode
            logical_size, on_disk_size = map(int, sizes.groups())
            assert on_disk_size < logical_size, inode

        if machine is zstd:
            with subtest("Writable overlay on a compressed store"):
                machine.succeed(build_derivation)
        else:
            with subtest(f"{machine.name}: read-only compressed store"):
                machine.fail(build_derivation)

        machine.shutdown()
  '';
}
