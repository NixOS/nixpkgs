{
  stdenv,
  lib,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  writeText,

  fetchFromGitHub,
  buildNimPackage,
  nim-1_0,
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
  buildNimPackage' = buildNimPackage.override {
    nim2 = nim-1_0; # Intended for Nim 1, but resolves to Nim 2 because of "nim >= 1.6.2" in animdustry.nimble
  };

  fau = callPackage ./fau.nix { buildNimPackage = buildNimPackage'; };
  fauLock = builtins.fromJSON (builtins.readFile ./fau-lock.json);
  partialLock = builtins.fromJSON (builtins.readFile ./package-lock-partial.json);
  lockFile = writeText "package-lock.json" (
    builtins.toJSON {
      depends = fauLock.depends ++ partialLock.depends;
    }
  );
in
buildNimPackage' (finalAttrs: {
  inherit lockFile;

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
    fau.package

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
