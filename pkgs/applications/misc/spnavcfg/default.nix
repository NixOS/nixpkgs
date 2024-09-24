{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libspnav,
  qtbase,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "spnavcfg";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    fetchLFS = true;
    sha256 = "sha256-P3JYhZnaCxzJETwC4g5m4xAGBk28/Va7Z/ybqwacIaA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/FreeSpacenav/spnavcfg/commit/fd9aa10fb8e19a257398757943b3d8e79906e583.patch";
      hash = "sha256-XKEyLAFrA4qRU3zkBozblb/fKtLKsaItze0xv1uLnq0=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    libspnav
  ];

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Interactive configuration GUI for space navigator input devices";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
    mainProgram = "spnavcfg";
  };
}
