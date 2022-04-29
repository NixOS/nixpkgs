{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, gettext
, which, xorg, libX11, libXext, libXinerama, libXpm, libXft, libXau, libXdmcp
, libXmu, libpng, libjpeg, expat, xorgproto, librsvg, freetype, fontconfig }:

stdenv.mkDerivation rec {
  pname = "jwm";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "joewing";
    repo = "jwm";
    rev = "v${version}";
    sha256 = "sha256-7CEL2ddlABM7SYjMVUs3pu0O+2cVsz04slsdUIbgZuM=";
  };

  nativeBuildInputs = [ pkg-config gettext which autoreconfHook ];

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
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
