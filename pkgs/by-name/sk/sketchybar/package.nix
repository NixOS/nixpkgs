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

  target =
    {
      "aarch64-darwin" = "arm64";
      "x86_64-darwin" = "x86";
    }
    .${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sketchybar";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0082rRSfIKJFTAzmJ65ItEdLSwjFks5ZkTlVZqaWKEw=";
  };

  buildInputs = [
    apple-sdk_15
  ];

  makeFlags = [ target ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    license = lib.licenses.gpl3;
    mainProgram = "sketchybar";
    maintainers = with lib.maintainers; [
      azuwis
      khaneliman
    ];
    platforms = lib.platforms.darwin;
  };
})
