{
  lib,
  stdenv,
  fetchFromGitLab,
  boost,
  cmake,
  cmark,
  cryptopp,
  extra-cmake-modules,
  immer,
  kdePackages,
  lager,
  libkazv,
  nlohmann_json,
  olm,
  pkg-config,
  qt6,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kazv";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "lily-is.land";
    owner = "kazv";
    repo = "kazv";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-WBS7TJJw0t57V4+NxsG8V8q4UKQXB8kRpWocvNy1Eto=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    cmark
    cryptopp
    immer
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.knotifications
    lager
    libkazv
    nlohmann_json
    olm
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtwayland
    zug
  ];

  strictDeps = true;

  meta = {
    description = "Convergent matrix client and instant messaging app";
    homepage = "https://kazv.chat/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "kazv";
    platforms = lib.platforms.all;
  };
})
