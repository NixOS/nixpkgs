{
  stdenv,
  lib,
  python3,
  openssl,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "librandombytes";
  version = "20240318";

  src = fetchzip {
    url = "https://randombytes.cr.yp.to/librandombytes-${finalAttrs.version}.tar.gz";
    hash = "sha256-LE8iWw7FxckPREyqefgKtslD6CPDsL7VsfHScQ6JmLs=";
  };

  patches = [ ./environment-variable-tools.patch ];

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  __structuredAttrs = true;

  # NOTE: librandombytes uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  configurePlatforms = [ ];

  # NOTE: the librandombytes library has required specific CFLAGS defined:
  # https://randombytes.cr.yp.to/librandombytes-20240318/compilers/default.html
  # - `-O` (alias `-O1`) safe optimization
  # - `-Qunused-arguments` suppress clang warning
  # the default "fortify" hardening sets -O2, -D_FORTIFY_SOURCE=2:
  # since librandombytes uses -O1, we disable the fortify hardening, and then manually re-enable -D_FORTIFY_SOURCE.
  hardeningDisable = [ "fortify" ];
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]
    ++ [
      "-D_FORTIFY_SOURCE=2"
      "-O1"
    ]
  );

  nativeBuildInputs = [ python3 ];

  buildInputs = [ openssl ];

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id "$out/lib/librandombytes-kernel.1.dylib" "$out/lib/librandombytes-kernel.1.dylib"
    install_name_tool -change "librandombytes-kernel.1.dylib" "$out/lib/librandombytes-kernel.1.dylib" "$out/bin/randombytes-info"
  '';

  meta = {
    homepage = "https://randombytes.cr.yp.to/";
    description = "A simple API for applications generating fresh randomness";
    changelog = "https://randombytes.cr.yp.to/download.html";
    license = with lib.licenses; [
      # Upstream specifies the public domain licenses with the terms here https://cr.yp.to/spdx.html
      publicDomain
      cc0
      bsd0
      mit
      mit0
    ];
    maintainers = with lib.maintainers; [
      kiike
      imadnyc
      jleightcap
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "armv7a-linux"
      "aarch64-linux"
      # Cannot support 32 bit MIPS because options in libcpucycles only supports mips64: https://cpucycles.cr.yp.to/libcpucycles-20240318/cpucycles/options.html
      "mips64-linux"
      "mips64el-linux"
      # powerpc-linux (32 bits) is supported by upstream project but not by nix
      "powerpc64-linux"
      "powerpc64le-linux"
      "riscv32-linux"
      "riscv64-linux"
      "s390x-linux"
      # Upstream package supports sparc, but nix does not
    ] ++ lib.platforms.darwin; # Work on MacOS X mentioned: https://randombytes.cr.yp.to/download.html
  };
})
