{
  lib,
  stdenv,
  fetchgit,
  boost,
  cmake,
  cmark,
  cryptopp,
  immer,
  kdePackages,
  lager,
  libkazv,
  nlohmann_json,
  pkg-config,
  qt6,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kazv";
  version = "0.6.0";

  # Heavily mirrored. Click "Clone" at https://iron.lily-is.land/diffusion/K/ to see all mirrors
  src = fetchgit {
    url = "https://iron.lily-is.land/diffusion/K/kazv.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7o6xUt/cryOg71/R33VBGpubskqlm9eYGSTyoGderDA=";
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
