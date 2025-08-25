{
  lib,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  writeText,

  fetchFromGitHub,
  buildNimPackage,
  nim-1_0,

  xorg,
  libGL,
  libGLU,
  libpulseaudio,
}:
let
  buildNimPackage' = buildNimPackage.override {
    nim2 = nim-1_0; # Intended for Nim 1, but resolves to Nim 2 because of "nim >= 1.6.2" in animdustry.nimble
  };

  fau = fetchFromGitHub {
    owner = "Anuken";
    repo = "fau";
    rev = "73df4a699873d0f82fd612a2a2ac63c21d3f2233";
    hash = "sha256-9zwmFinDJV4+R/aiVVOQ/Bv30jX7NHJyufzMNWHGA+k=";
    fetchSubmodules = true;
  };
  faupack = buildNimPackage' {
    pname = "fau";
    version = "0-unstable-2022-05-14";
    src = fau;
    lockFile = ./fau-lock.json;
  };

  fauLock = builtins.fromJSON (builtins.readFile ./fau-lock.json);
  partialLock = builtins.fromJSON (builtins.readFile ./package-lock-partial.json);
  lockFile = writeText "package-lock.json" (builtins.toJSON {
    depends = fauLock.depends ++ partialLock.depends;
  });
in
buildNimPackage' (finalAttrs: {
  inherit lockFile;

  pname = "animdustry";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "animdustry";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RND5AhlD9uTMg9Koz5fq7WMgJt+Ajiyi6K60WFbF0bg=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    libGL
    libGLU
    xorg.libXxf86vm
  ];
  nativeBuildInputs = [
    faupack

    makeWrapper
    copyDesktopItems
  ];

  nimFlags = [
    "--app:gui"
    "-d:danger"
    "--path:\"${fau}/src\""

    "-d:NimblePkgVersion=${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall

    mv $out/bin/main $out/bin/animdustry
    wrapProgram $out/bin/animdustry \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpulseaudio
        ]
      }
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

  meta = with lib; {
    homepage = "https://github.com/Anuken/animdustry";
    downloadPage = "https://github.com/Anuken/animdustry/releases";
    description = "Anime gacha rhythm game";
    longDescription = ''
      the anime gacha bullet hell rhythm game
      created as a mindustry april 1st event
    '';
    license = licenses.gpl3; # Listed in animdustry.nimble
    platforms = platforms.all;
    maintainers = with maintainers; [
      Ezjfc
    ];
  };
})
