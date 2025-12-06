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
  gtest,
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
    gtest
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/UserPlugins
    install -Dm755 reaper_imgui-${stdenv.hostPlatform.parsed.cpu.name}.so $out/UserPlugins

    mkdir -p $out/Data
    cp reaper_imgui_doc.html $out/Data

    SCRIPTS="$out/Scripts/ReaTeam Extensions/API"
    mkdir -p "$SCRIPTS"
    cp imgui.py "$SCRIPTS"
    cp /build/source/shims/imgui.lua "$SCRIPTS"

    runHook postInstall
  '';

  meta = {
    description = "ReaScript binding and REAPER backend for the Dear ImGui toolkit";
    homepage = "https://github.com/cfillion/reaimgui";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
