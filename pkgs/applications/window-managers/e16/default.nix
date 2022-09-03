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
  version = "1.0.25";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/e16-${version}.tar.xz";
    hash = "sha256-rUtDaBa4vvC3gO7QSkFrphWuVOmbtkH+pRujQDaUOek=";
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
    inherit pname version;
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
