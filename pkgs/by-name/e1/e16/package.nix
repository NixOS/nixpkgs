{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  freetype,
  imlib2,
  libSM,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXft,
  libXinerama,
  libXrandr,
  libpulseaudio,
  libsndfile,
  pango,
  perl,
  python3,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "e16";
  version = "1.0.31";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/e16-${version}.tar.xz";
    hash = "sha256-ZQTsIy/BiO/xUiCu+bc2n406F0unAinxyYLjVRfUSiQ=";
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
    python3
  ];

  postPatch = ''
    substituteInPlace scripts/e_gen_menu --replace "/usr/local:" "/run/current-system/sw:/usr/local:"
    substituteInPlace scripts/e_gen_menu --replace "'/opt'" "'/opt', '/run/current-system/sw'"
    substituteInPlace scripts/e_gen_menu --replace "'/.local'" "'/.nix-profile', '/.local'"
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
