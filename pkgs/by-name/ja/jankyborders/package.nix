{ lib
, fetchFromGitHub
, pkg-config
, pkgs
, overrideSDK
, darwin
, testers
, nix-update-script
}:
let
  stdenv = overrideSDK pkgs.stdenv "11.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "JankyBorders";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "JankyBorders";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DX1d228UCOI+JU+RxenhiGyn3AiqpsGe0aCtr091szs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = with darwin.apple_sdk.frameworks; [
    AppKit
    ApplicationServices
    CoreFoundation
    CoreGraphics
    SkyLight
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/borders $out/bin/borders

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "borders-v${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "JankyBorders is a lightweight tool designed to add colored borders to user windows on macOS 14.0+";
    longDescription = "It enhances the user experience by visually highlighting the currently focused window without relying on the accessibility API, thereby being faster than comparable tools.";
    homepage = "https://github.com/FelixKratz/JankyBorders";
    license = lib.licenses.gpl3;
    mainProgram = "borders";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
