{
  lib,
  stdenv,
  fetchgit,
  automake,
  autoconf,
  libtool,
  libX11,
  libXi,
  libXtst,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation rec {
  pname = "libfakekey";
  version = "0.3";

  src = fetchgit {
    url = "https://git.yoctoproject.org/libfakekey";
    tag = version;
    hash = "sha256-QNJlxZ9uNwNgFWm9qRJdPfusx7dXHZajjFH7wDhpgcs=";
  };

  configureScript = "./autogen.sh";

  nativeBuildInputs = [
    automake
    autoconf
    pkg-config
    libtool
  ];

  buildInputs = [
    libX11
    libXi
    libXtst
    xorgproto
  ];

  NIX_LDFLAGS = "-lX11";

  meta = with lib; {
    description = "X virtual keyboard library";
    homepage = "https://www.yoctoproject.org/tools-resources/projects/matchbox";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
