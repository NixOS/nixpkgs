{ stdenv, fetchFromGitHub, libconfig, pkgconfig, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "nntp-proxy";
  version = "2014-01-06";

  src = fetchFromGitHub {
    owner = "nieluj";
    repo = "nntp-proxy";
    rev = "0358e7ad6c4676f90ac5074320b16e1461b0011a";
    sha256 = "0jwxh71am83fbnq9mn06jl06rq8qybm506js79xmmc3xbk5pqvy4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libconfig libevent openssl ];

  installFlags = [ "INSTALL_DIR=$(out)/bin/" ];

  prePatch = ''
    mkdir -p $out/bin
    substituteInPlace Makefile \
      --replace /usr/bin/install $(type -P install) \
      --replace gcc cc
  '';

  meta = {
    description = "Simple NNTP proxy with SSL support";
    homepage = https://github.com/nieluj/nntp-proxy;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
