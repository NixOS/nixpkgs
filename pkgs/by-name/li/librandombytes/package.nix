{ stdenv
, lib
, python3
, openssl
, fetchzip
}:
stdenv.mkDerivation (prev: {
  pname = "librandombytes";
  version = "20240318";

  src = fetchzip {
    url = "https://randombytes.cr.yp.to/librandombytes-${prev.version}.tar.gz";
    hash = "sha256-LE8iWw7FxckPREyqefgKtslD6CPDsL7VsfHScQ6JmLs=";
  };

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

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
  env.NIX_CFLAGS_COMPILE = toString
    (lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]
      ++ [ "-D_FORTIFY_SOURCE=2" "-O1" ]);

  patches = [ ./environment-variable-tools.patch ];

  nativeBuildInputs = [
    openssl
    python3
  ];

  buildInputs = [ openssl ];

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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
})
