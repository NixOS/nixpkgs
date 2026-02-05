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

stdenv.mkDerivation (finalAttrs: {
  pname = "libfakekey";
  version = "0.3";

  src = fetchgit {
    url = "https://git.yoctoproject.org/libfakekey";
    tag = finalAttrs.version;
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

  meta = {
    description = "X virtual keyboard library";
    homepage = "https://www.yoctoproject.org/tools-resources/projects/matchbox";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
