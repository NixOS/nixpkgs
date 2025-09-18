{
  stdenv,
  lib,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  fetchFromGitHub,
  buildNimPackage,
  callPackage,
  libX11,
  libXcursor,
  libXrandr,
  libXinerama,
  libXi,
  libGL,
  libXxf86vm,
  libpulseaudio,
  fau ? callPackage ./fau.nix { },
}:
buildNimPackage (finalAttrs: {
  pname = "animdustry";
  version = "1.2-unstable-2024-07-30";

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "animdustry";
    rev = "f408e632872929964a9b3f8888f1c7a18e6c1ead";
    hash = "sha256-BG0U5hk+g74JEMTKFX/3szibUg1Ap/fYNQdVIAQp7HQ=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libGL
    libXxf86vm
  ];
  nativeBuildInputs = [
    fau
    autoPatchelfHook
    copyDesktopItems
  ];
  runtimeDependencies = [
    libpulseaudio
  ];

  nimFlags = [
    "--app:gui"
    "-d:danger"
    "--path:\"${fau.src}/src\""

    "-d:NimblePkgVersion=${finalAttrs.version}"
  ];
  lockFile = ./lock.json;

  preBuild = ''
    ${fau}/bin/faupack -p:"./assets-raw/sprites" -o:"./assets/atlas"
  '';

  installPhase = ''
    runHook preInstall

    mv $out/bin/main $out/bin/animdustry
    install -Dm644 ./assets/icon.png $out/share/icons/hicolor/64x64/apps/animdustry.png

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = "Animdustry";
    exec = "animdustry";
    icon = "animdustry";
    desktopName = "Animdustry";
    categories = [ "Game" ];
  };

  meta = {
    homepage = "https://github.com/Anuken/animdustry";
    downloadPage = "https://github.com/Anuken/animdustry/releases";
    description = "Anime gacha rhythm game";
    longDescription = ''
      The anime gacha bullet hell rhythm game that was created as a Mindustry (2022) April 1st event.
    '';
    license = with lib.licenses; [
      unfree
      cc-by-30
      cc-by-nd-30
    ];
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [
      Ezjfc
    ];
  };
})
