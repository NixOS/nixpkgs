{ lib
, stdenv
, fetchurl
, freetype
, fribidi
, libICE
, libSM
, libXaw
, libXext
, libXft
, libXinerama
, libXmu
, libXpm
, libXrandr
, libXrender
, libXt
, pkg-config
, xorgproto
}:

stdenv.mkDerivation rec {
  pname = "oroborus";
  version = "2.0.20";

  src = fetchurl {
    url = "mirror://debian/pool/main/o/oroborus/oroborus_${version}.tar.gz";
    hash = "sha256-UiClQLz2gSxnc/vlg9nqP1T0UsusVb7cqt66jDqae4k=a";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freetype
    fribidi
    libICE
    libSM
    libXaw
    libXext
    libXft
    libXinerama
    libXmu
    libXpm
    libXrandr
    libXrender
    libXt
    xorgproto
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: workspaces.o:src/keyboard.h:93: multiple definition of
  #     `NumLockMask'; client.o:src/keyboard.h:93: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    homepage = "https://web.archive.org/web/20191129172107/https://www.oroborus.org/";
    description = "A really minimalistic X window manager";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
