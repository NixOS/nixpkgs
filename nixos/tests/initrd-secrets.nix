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
          boot.initrd.secrets = {
            "/test" = secretInStore;

            # This should *not* need to be copied
            "/run/test" = secretInStore;
          };
          boot.initrd.systemd = {
            enable = true;
            tmpfiles.settings."00-copy-secret" = {
              "/sysroot/secret-from-initramfs".C.argument = "/test";
            };
          };
          boot.initrd.compressor = compressor;
          # zstd compression is only supported from 5.9 onwards. Remove when 5.10 becomes default.
          boot.kernelPackages = pkgs.linuxPackages_latest;
        };

      testScript = ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        machine.succeed(
            "cmp ${secretInStore} /secret-from-initramfs",
            "cmp ${secretInStore} /run/test",
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
