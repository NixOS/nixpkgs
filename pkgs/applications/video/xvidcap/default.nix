{ lib
, stdenv
, fetchurl
, perlPackages
, pkg-config
, gtk2
, scrollkeeper
, libglade
, libXmu
, libX11
, libXext
, gettext
, lame
, libXfixes
, libXdamage
}:

stdenv.mkDerivation rec {
  pname = "xvidcap";
  version = "1.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/xvidcap/xvidcap-${version}.tar.gz";
    sha256 = "0p8rhpyhxgy37crf1xk1046z4p663jg7ww776jw92pld3s024ihm";
  };

  patches = [ ./xlib.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    scrollkeeper
    libglade
    libXmu
    gettext
    lame
    libXdamage
    libXfixes
    libXext
    libX11
  ] ++ (with perlPackages; [ perl XMLParser ]);

  # !!! don't know why this is necessary
  NIX_LDFLAGS = "-lXext -lX11 -lz -lgcc_s";

  meta = with lib; {
    description = "Screencast video catpuring tool";
    homepage = "http://xvidcap.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
