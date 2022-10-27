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
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "e16";
  version = "1.0.26";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/e16-${version}.tar.xz";
    hash = "sha256-1FJFE4z8UT5VYv0Ef9pqi5sYq8iIbrDPKaqcUFf9dwE=";
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

  passthru.updateScript = gitUpdater {
    url = "https://git.enlightenment.org/e16/e16";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://www.enlightenment.org/e16";
    description = "Enlightenment DR16 window manager";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
