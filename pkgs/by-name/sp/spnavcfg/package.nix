{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libspnav,
  libX11,

  # Qt6 support is close: https://github.com/FreeSpacenav/spnavcfg/issues/43
  libsForQt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spnavcfg";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spnavcfg";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchLFS = true;
    hash = "sha256-P3JYhZnaCxzJETwC4g5m4xAGBk28/Va7Z/ybqwacIaA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/FreeSpacenav/spnavcfg/commit/fd9aa10fb8e19a257398757943b3d8e79906e583.patch";
      hash = "sha256-XKEyLAFrA4qRU3zkBozblb/fKtLKsaItze0xv1uLnq0=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libspnav
    libX11
  ];

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Interactive configuration GUI for space navigator input devices";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
    mainProgram = "spnavcfg";
  };
})
