{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
  testing ? import ../lib/testing-python.nix { inherit system pkgs; },
}:
let
  secretInStore = pkgs.writeText "topsecret" "iamasecret";
  testWithCompressor =
    compressor:
    testing.makeTest {
      name = "initrd-secrets-${compressor}";

      meta = {
        maintainers = [ ];
        broken = pkgs.stdenv.hostPlatform.isAarch64;
      };

      nodes.machine =
        { ... }:
        {
          virtualisation.useBootLoader = true;
          boot.initrd.secretPaths = {
            "/test" = {
              source = secretInStore;
              intermediateSecretsDir = false;
            };

            # This should *not* need to be copied in postMountCommands
            "/run/keys/test1".source = secretInStore;

            "/run/keys/test2".generateSecretCommand = pkgs.writeShellScript "copy-secret" ''
              cp ${secretInStore} "$out"
            '';
          };
          boot.initrd.extraSecretsHook = ''
            mkdir -p etc/secrets
            cp ${secretInStore} etc/secrets/test2
          '';
          boot.initrd.postMountCommands = ''
            cp /test /mnt-root/secret-from-initramfs-1
            cp /etc/secrets/test2 /mnt-root/secret-from-initramfs-2
          '';
          boot.initrd.compressor = compressor;
          # zstd compression is only supported from 5.9 onwards. Remove when 5.10 becomes default.
          boot.kernelPackages = pkgs.linuxPackages_latest;
        };

      testScript = ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        machine.succeed(
            "cmp ${secretInStore} /secret-from-initramfs-1",
            "cmp ${secretInStore} /secret-from-initramfs-2",
            "cmp ${secretInStore} /run/keys/test1",
            "cmp ${secretInStore} /run/keys/test2",
        )
      '';
    };
in
lib.flip lib.genAttrs testWithCompressor [
  "cat"
  "gzip"
  "bzip2"
  "xz"
  "lzma"
  "lzop"
  "pigz"
  "pixz"
  "zstd"
]
