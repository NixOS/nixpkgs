{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  copyDesktopItems,
  ctestCheckHook,
  gtest,
  icoutils,
  libGL,
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catacombgl";
  version = "0.5.7-beta";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ArnoAnsems";
    repo = "CatacombGL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XoWbjx3aqUSj3iPI3nZq6+Ky2u4XorrffWTZKAToYkw=";
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    icoutils
  ];

  buildInputs = [
    SDL2
    libGL
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  checkInputs = [ gtest ];

  postInstall = ''
    for size in 16 24 32 48 128; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      icotool --extract --width $size \
        --output $out/share/icons/hicolor/''${size}x''${size}/apps/catacombgl.png \
        $src/res/win/CatacombGL.ico
    done
  '';

  ctestFlags = [
    "--test-dir"
    "src/Test"
    "--no-tests=error"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "catacombgl";
      categories = [
        "Game"
        "ActionGame"
      ];
      comment = "Source port of Catacomb 3-D and the Catacomb Adventure Series";
      desktopName = "CatacombGL";
      exec = "CatacombGL";
      icon = "catacombgl";
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
    ];
  };

  meta = {
    description = "Source port of Catacomb 3-D and the Catacomb Adventure Series with OpenGL rendering";
    homepage = "https://github.com/ArnoAnsems/CatacombGL";
    changelog = "https://github.com/ArnoAnsems/CatacombGL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "CatacombGL";
  };
})
