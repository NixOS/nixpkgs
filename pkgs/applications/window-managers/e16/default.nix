{ lib
, stdenv
, fetchurl
, pkg-config
, freetype
, imlib2
, libSM
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXft
, libXinerama
, libXrandr
, libpulseaudio
, libsndfile
, pango
, perl
}:

stdenv.mkDerivation rec {
  pname = "e16";
  version = "1.0.23";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/e16-${version}.tar.xz";
    sha256 = "028rn1plggacsvdd035qnnph4xw8nya34mmjvvl7d4gqj9pj293f";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    freetype
    imlib2
    libSM
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXft
    libXinerama
    libXrandr
    libpulseaudio
    libsndfile
    pango
    perl
  ];

  postPatch = ''
    substituteInPlace scripts/e_gen_menu --replace "/usr/local:" "/run/current-system/sw:/usr/local:"
  '';

  meta = with lib; {
    homepage = "https://www.enlightenment.org/e16";
    description = "Enlightenment DR16 window manager";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
