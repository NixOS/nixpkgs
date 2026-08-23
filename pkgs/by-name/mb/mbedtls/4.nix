{
  lib,
  stdenv,
  callPackage,
}:

callPackage ./generic.nix {
  version = "4.2.0";
  hash = "sha256-Xz5W5zYPNlASPyc1/Sz2O1LONdxpUkg1hgzKdax/3ag=";

  patches = [
    # Fixes the build with GCC 14 on aarch64.
    #
    # See:
    # * <https://github.com/openwrt/openwrt/pull/15479>
    # * <https://github.com/Mbed-TLS/mbedtls/issues/9003>
    ./0001-fix-gcc14-build.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    # Fixes build with GCC 15.3 on 32-bit platforms.
    # See: https://github.com/Mbed-TLS/mbedtls/pull/10793
    # Manually forward-ported to v4
    ./fix-gcc153-32bit-v4.patch
  ];
}
