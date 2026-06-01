{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  assimp,
  opencascade-occt,
  ctestCheckHook,
  copyDesktopItems,
  makeDesktopItem,
  # options
  withAssimp ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "0.9.0";
  pname = "mayo";

  src = fetchFromGitHub {
    owner = "fougue";
    repo = "mayo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A2ODbbOyoWIhKOWGzSQS2gUF8kpWlN8hN8CdeumAUps=";
  };

  cmakeFlags = [
    (lib.cmakeOptionType "string" "Mayo_VersionMajor" (lib.versions.major finalAttrs.version))
    (lib.cmakeOptionType "string" "Mayo_VersionMinor" (lib.versions.minor finalAttrs.version))
    (lib.cmakeOptionType "string" "Mayo_VersionPatch" (lib.versions.patch finalAttrs.version))
    (lib.cmakeBool "Mayo_BuildTests" finalAttrs.doCheck)
  ]
  ++ lib.optional withAssimp "-DMayo_BuildPluginAssimp=ON";

  strictDeps = true;
  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    opencascade-occt
  ]
  ++ lib.optional withAssimp assimp;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
    cmake
  ];
  desktopItems = [
    (makeDesktopItem {
      name = "mayo";
      exec = "mayo";
      desktopName = "Mayo";
      icon = "mayo";
      comment = finalAttrs.meta.description;
      categories = [
        "Graphics"
        "3DGraphics"
        "Engineering"
      ];
    })
  ];

  doCheck = true;
  nativeCheckInputs = [
    ctestCheckHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mayo $out/bin/mayo
    install -Dm755 mayo-conv $out/bin/mayo-conv

    pushd ..
    install -Dm444 images/appicon.svg "$out/share/icons/hicolor/scalable/apps/mayo.svg"
    install -Dm444 images/appicon_256.png "$out/share/icons/hicolor/256x256/apps/mayo.png"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm444 images/appicons.icns "$out/Applications/Mayo.app/Contents/Resources/mayo.icns"
  ''
  + ''
    popd

    runHook postInstall
  '';

  meta = {
    description = "3D CAD viewer and converter based on Qt + OpenCascade";
    mainProgram = "mayo";
    changelog = "https://github.com/fougue/mayo/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/fougue/mayo";
    maintainers = [ lib.maintainers.gigahawk ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.bsd2;
  };
})
