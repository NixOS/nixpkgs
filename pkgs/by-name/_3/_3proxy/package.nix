{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "3proxy";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "3proxy";
    repo = "3proxy";
    tag = version;
    sha256 = "sha256-uy6flZ1a7o02pr5O0pgl9zCjh8mE9W5JxotJeBMB16A=";
  };

  # They use 'install -s', that calls the native strip instead of the cross.
  # Don't strip binary on install, we strip it on fixup phase anyway.
  postPatch = ''
    substituteInPlace Makefile.Linux \
      --replace "(INSTALL_BIN) -s" "(INSTALL_BIN)" \
      --replace "/usr" ""
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
  };
}
