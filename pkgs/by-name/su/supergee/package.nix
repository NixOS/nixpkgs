{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  gtk3,
  beets,
  libgee,
  glib,
  libxml2,
  unstableGitUpdater,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supergee";
  version = "0-unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "DannyGB";
    repo = "SuperGee";
    rev = "c1232f6a8a9d4161644d728df793ffd3cb5cc4af";
    hash = "sha256-lv7C4ku3MdiHxg1LfmnzT5Sx3DTtvP9g3XPOQlNBDkg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    libxml2.bin
    vala
    pkg-config
    cmake
    glib.bin
  ];

  buildInputs = [
    gtk3
    libgee
    glib
  ];

  postPatch = ''
    substituteInPlace BeetService.vala \
      --replace-fail '"beet"' '"${lib.getExe beets}"'
  '';

  preConfigure = ''
    pushd ..
    find -exec chmod +w {} \;
    mkdir build
    cd build
    mkdir SuperG@exe
    glib-compile-resources --sourcedir ../resources --generate-source --target SuperG@exe/resources.c ../resources/superg.gresource.xml
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 SuperG $out/bin/SuperG

    runHook postInstall
  '';

  sourceRoot = "${finalAttrs.src.name}/src";

  dontUseCmakeConfigure = true;

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    description = "Vala based UI for beets";
    homepage = "https://github.com/DannyGB/SuperGee";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "SuperG";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
})
