{ lib, stdenv, fetchFromGitHub, pkg-config, automake, autoconf, gettext
, which, xorg, libX11, libXext, libXinerama, libXpm, libXft, libXau, libXdmcp
, libXmu, libpng, libjpeg, expat, xorgproto, librsvg, freetype, fontconfig, pango
, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "jwm";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "joewing";
    repo = "jwm";
    rev = "v${version}";
    sha256 = "sha256-rvuz2Pmon3XBqRMgDwZNrQlWDyLNSK30JPmmQTlN+Rs=";
  };

  nativeBuildInputs = [ pkg-config gettext which automake autoconf ];

  buildInputs = [
    libX11
    libXext
    libXinerama
    libXpm
    libXft
    xorg.libXrender
    libXau
    libXdmcp
    libXmu
    libpng
    libjpeg
    expat
    xorgproto
    librsvg
    freetype
    fontconfig
    pango
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    inherit pname version;
    rev-prefix = "v";
  };

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
