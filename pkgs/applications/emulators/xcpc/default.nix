{ lib, stdenv, fetchurl, pkg-config, glib, libXaw, libX11, libXext
  , libDSKSupport ? true, libdsk
  , motifSupport ? false, lesstif
}:

stdenv.mkDerivation rec {
  version = "20070122";
  pname = "xcpc";

  src = fetchurl {
    url = "mirror://sourceforge/xcpc/${pname}-${version}.tar.gz";
    sha256 = "0hxsbhmyzyyrlidgg0q8izw55q0z40xrynw5a1c3frdnihj9jf7n";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib libdsk libXaw libX11 libXext ]
    ++ lib.optional libDSKSupport libdsk
    ++ lib.optional motifSupport lesstif;

  meta = with lib; {
    description = "A portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = "https://www.xcpc-emulator.net";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
