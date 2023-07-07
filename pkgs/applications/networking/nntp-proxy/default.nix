{ lib, stdenv, fetchFromGitHub, libconfig, pkg-config, libevent, openssl, libxcrypt }:

stdenv.mkDerivation {
  pname = "nntp-proxy";
  version = "2014-01-06";

  src = fetchFromGitHub {
    owner = "nieluj";
    repo = "nntp-proxy";
    rev = "0358e7ad6c4676f90ac5074320b16e1461b0011a";
    sha256 = "0jwxh71am83fbnq9mn06jl06rq8qybm506js79xmmc3xbk5pqvy4";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libconfig libevent openssl libxcrypt ];

  installFlags = [ "INSTALL_DIR=$(out)/bin/" ];

  prePatch = ''
    mkdir -p $out/bin
    substituteInPlace Makefile \
      --replace /usr/bin/install $(type -P install) \
      --replace gcc cc
  '';

  meta = {
    description = "Simple NNTP proxy with SSL support";
    homepage = "https://github.com/nieluj/nntp-proxy";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.fadenb ];
    platforms = lib.platforms.all;
  };
}
