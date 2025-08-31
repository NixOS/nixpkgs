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
}:
let
  fau = callPackage ./fau.nix { };
in
buildNimPackage (finalAttrs: {
  pname = "animdustry";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "animdustry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RND5AhlD9uTMg9Koz5fq7WMgJt+Ajiyi6K60WFbF0bg=";
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
  requiredNimVersion = 1;
  lockFile = ./lock.json;

  installPhase = ''
    runHook preInstall

    mv $out/bin/main $out/bin/animdustry
    install -Dm644 ./assets/icon.png $out/share/icons/hicolor/64x64/apps/animdustry.png

    runHook postInstall
  '';

  desktopItems =
    let
      name = "Animdustry";
      exec = "animdustry";
      icon = exec;
    in
    makeDesktopItem {
      inherit name icon exec;
      desktopName = name;
      categories = [ "Game" ];
    };

  meta = {
    homepage = "https://github.com/Anuken/animdustry";
    downloadPage = "https://github.com/Anuken/animdustry/releases";
    description = "Anime gacha rhythm game";
    longDescription = ''
      the anime gacha bullet hell rhythm game
      created as a mindustry april 1st event
    '';
    license = lib.licenses.gpl3; # Listed in animdustry.nimble
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      Ezjfc
    ];
  };
})
