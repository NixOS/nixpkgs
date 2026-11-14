{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  apple-sdk_15,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sketchybar";
  version = "2.24.1";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fEbVzafjFTigR7TjQ41gOnDpk6S4B8qCwpz890ZNgwE=";
  };

  buildInputs = [
    apple-sdk_15
  ];

  makeFlags = [ "arm64" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    changelog = "https://github.com/FelixKratz/SketchyBar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    mainProgram = "sketchybar";
    maintainers = with lib.maintainers; [
      azuwis
      khaneliman
    ];
    platforms = lib.platforms.darwin;
  };
})
