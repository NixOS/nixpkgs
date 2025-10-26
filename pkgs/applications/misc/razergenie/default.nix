{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  qt6,
  cmake,
}:

let
  libopenrazer = stdenv.mkDerivation (finalAttrs: {
    pname = "libopenrazer";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "z3ntu";
      repo = "libopenrazer";
      tag = "v${finalAttrs.version}";
      hash = "sha256-2RH4mevJS5HaEkb5lDNwoMaMNACXJGUVA5RWSYSsakI=";
    };

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qttools
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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "z3ntu";
    repo = "RazerGenie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TxW6IUHmEaNdJPeEGwo57a3EGH6MMyitVTmzStVmZjc=";
  };

  postUnpack = ''ln -s ${libopenrazer} libopenrazer'';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libopenrazer
  ];

  meta = {
    homepage = "https://github.com/z3ntu/RazerGenie";
    description = "Qt application for configuring your Razer devices under GNU/Linux";
    mainProgram = "razergenie";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      f4814n
    ];
    platforms = lib.platforms.linux;
  };
})
