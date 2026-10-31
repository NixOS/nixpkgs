{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  sdl3,
  speexdsp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reflectionhle";
  version = "20260606";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ReflectionHLE";
    repo = "ReflectionHLE";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-QiK/8h5iBF9aW40KYjaNceUFJQCaDiy2iizxWkaoL9U=";
  };

  postPatch = ''
    substituteInPlace cmake/GenReflectionHLEGitHash.cmake \
      --replace-fail "COMMAND git describe --tags" "COMMAND echo ${finalAttrs.src.tag}"
    # Skip fixup_bundle, which copies store libraries into the .app
    : > cmake/MacOSBundle.cmake
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];
  buildInputs = [
    sdl3
    speexdsp
  ];

  postInstall = ''
    for size in 32 128; do
      install -Dm644 $src/rsrc/reflectionhle-''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/reflectionhle.png
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/reflectionhle.app/Contents/MacOS/reflectionhle $out/bin/reflectionhle
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "reflectionhle";
      categories = [
        "Game"
        "ActionGame"
      ];
      comment = "Source port of Keen Dreams, Catacomb 3-D, Wolfenstein 3D and BioMenace";
      desktopName = "ReflectionHLE";
      exec = "reflectionhle";
      icon = "reflectionhle";
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    description = "Source port of Keen Dreams, the Catacomb 3-D series, Wolfenstein 3D and BioMenace";
    homepage = "https://github.com/ReflectionHLE/ReflectionHLE";
    changelog = "https://github.com/ReflectionHLE/ReflectionHLE/blob/${finalAttrs.src.tag}/ChangeLog.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "reflectionhle";
  };
})
