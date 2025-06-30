{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  qtbase,
  qttools,
  wrapQtAppsHook,
  cmake,
}:

let
  libopenrazer = stdenv.mkDerivation (finalAttrs: {
    pname = "libopenrazer";
    version = "0.3.0";

    src = fetchFromGitHub {
      owner = "z3ntu";
      repo = "libopenrazer";
      tag = "v${finalAttrs.version}";
      hash = "sha256-bU8Zsm/hM4HbPcoD191zwxU3x7f0i51evtVeD4jqw0U=";
    };

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
    ];

    buildInputs = [
      qtbase
      qttools
    ];

    dontWrapQtApps = true;

    meta = {
      homepage = "https://github.com/z3ntu/libopenrazer";
      description = "Qt wrapper around the D-Bus API from OpenRazer";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "razergenie";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "z3ntu";
    repo = "RazerGenie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kw7/Qf6L63PBuyq3TfgU2iGAKX0qLGiq6JgLnN+3tu4=";
  };

  postUnpack = ''ln -s ${libopenrazer} libopenrazer'';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    libopenrazer
  ];

  meta = {
    homepage = "https://github.com/z3ntu/RazerGenie";
    description = "Qt application for configuring your Razer devices under GNU/Linux";
    mainProgram = "razergenie";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      f4814n
      Mogria
    ];
    platforms = lib.platforms.linux;
  };
})
