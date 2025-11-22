{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  fontconfig,
  freetype,
  pkg-config,
  boost,
  libjpeg,
  md4c,
  gitMinimal,
  libepoxy,
  gtk3,
  ninja,
  writableTmpDirAsHomeHook,
  imgui,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "reaimgui";
  version = "0.10.0.2";

  src = fetchFromGitHub {
    owner = "cfillion";
    repo = "reaimgui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6s60fQ7NsMAbtoGUCogje2p1Pf3LuPVmwQvNAMOR260=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "b_lto=true" "b_lto=false" \
      --replace-fail "werror=true" "werror=false"
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    fontconfig
    freetype
    boost
    libjpeg
    md4c
    gitMinimal
    libepoxy
    gtk3
    imgui
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" false)
  ];

  installPhase = ''
    mkdir -p $out/UserPlugins
    install -Dm755 reaper_imgui-x86_64.so $out/UserPlugins

    mkdir -p $out/Data
    cp reaper_imgui_doc.html $out/Data

    mkdir -p $out/Scripts
    cp imgui.py $out/Scripts
    cp /build/source/shims/imgui.lua $out/Scripts
  '';

  meta = {
    description = "ReaScript binding and REAPER backend for the Dear ImGui toolkit";
    homepage = "https://github.com/cfillion/reaimgui";
    platforms = lib.platforms.linux;
    license = [
      lib.licenses.lgpl3
      lib.licenses.gpl3
    ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
