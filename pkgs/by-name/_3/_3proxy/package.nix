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
    repo = pname;
    rev = version;
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
