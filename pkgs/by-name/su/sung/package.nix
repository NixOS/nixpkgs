{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  ffmpeg,
  nodejs,
  python3,
  testers,
  unstableGitUpdater,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      ytmusicapi
      yt-dlp
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sung";
  version = "0.12.0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "yappologistic";
    repo = "Sung";
    rev = "589cb6fa17b579e4400e73a0df9a3547cb8ce8dc";
    hash = "sha256-uhdEKlpb9zZ8Ecw2TwVekHQBB4jS18zVm+Go7OLkS7M=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtimageformats
    ffmpeg
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DSUNG_DIAGNOSTICS=OFF"
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          ffmpeg
        ]
      }
      --set SUNG_PYTHON "${pythonEnv}/bin/python3"
      --set SUNG_HELPER "$out/lib/sung/catalog.py"
    )
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen sung --version";
      version = "0.12.0";
    };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Native Material 3 music player for Linux";
    homepage = "https://github.com/yappologistic/Sung";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sung";
    maintainers = with lib.maintainers; [ surajklmn ];
  };
})
