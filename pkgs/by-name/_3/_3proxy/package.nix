{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3proxy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "3proxy";
    repo = "3proxy";
    tag = finalAttrs.version;
    sha256 = "sha256-hLxafFU6nJ3I3NT3R24LPD7PBmQ1IZEbrVqvfmMZHIM=";
  };

  # They use 'install -s', that calls the native strip instead of the cross.
  # Don't strip binary on install, we strip it on fixup phase anyway.
  postPatch = ''
    substituteInPlace Makefile.Linux \
      --replace-fail "(INSTALL_BIN) -s" "(INSTALL_BIN)" \
      --replace-fail "/usr" ""
  '';

  makeFlags = [
    "-f Makefile.Linux"
    "INSTALL=install"
    "DESTDIR=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  postInstall = ''
    rm -fr $out/var
  '';

  # common.c:208:9: error: initialization of 'int (*)(struct pollfd *, unsigned int,  int)' from incompatible pointer type 'int (*)(struct pollfd *, nfds_t,  int)' {aka 'int (*)(struct pollfd *, long unsigned int,  int)'}
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  passthru.tests = {
    smoke-test = nixosTests._3proxy;
  };

  meta = {
    description = "Tiny free proxy server";
    homepage = "https://github.com/3proxy/3proxy";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ misuzu ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "3proxy" finalAttrs.version;
  };
})
