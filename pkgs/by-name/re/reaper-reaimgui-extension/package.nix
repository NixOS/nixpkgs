{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  pkg-config,
  gitMinimal,
  boost,
  fontconfig,
  freetype,
  libjpeg,
  gtest,
  gtk3,
  libepoxy,
  md4c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reaper-reaimgui-extension";
  version = "0.10.0.5";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "cfillion";
    repo = "reaimgui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qFY5Yc7Nl3h9ay3AsBQYXSxHLAZ8C+f+ZkfOlA93TcU=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gitMinimal
  ];

  buildInputs = [
    boost
    fontconfig
    freetype
    libjpeg
    gtest
    gtk3
    libepoxy
    md4c
  ];

  mesonFlags = [
    "-Db_lto=false" # plugin needed to handle lto object -> undefined reference to ...
    "-Dwerror=false"
    "-Dresource_path=${placeholder "out"}"
  ];

  meta = {
    description = "ReaScript binding for Dear ImGui";
    longDescription = ''
      ReaImGui is a ReaScript binding and REAPER backend for the Dear ImGui
      toolkit. It adds ReaScript API functions for creating GPU-rendered
      GUI interfaces.
    '';
    homepage = "https://codeberg.org/cfillion/reaimgui";
    changelog = "https://codeberg.org/cfillion/reaimgui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ treierxyz ];
  };
})
