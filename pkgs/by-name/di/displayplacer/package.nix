{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  makeWrapper,
  darwin,
  apple-sdk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "displayplacer";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jakehilborn";
    repo = "displayplacer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BYq8lrS8yE9ARCdAvZxiuC/2vRv6uha++WwKfM37gC0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    apple-sdk.privateFrameworksHook
    darwin.apple_sdk.frameworks.ApplicationServices
    darwin.apple_sdk.frameworks.CoreDisplay
    darwin.apple_sdk.frameworks.DisplayServices
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.SkyLight
    darwin.apple_sdk.frameworks.System
  ];

  buildPhase = ''
    runHook preBuild

    make -C src displayplacer

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/displayplacer $out/bin/

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line utility for macOS to configure multi-display resolutions and arrangements";
    homepage = "https://github.com/jakehilborn/displayplacer";
    changelog = "https://github.com/jakehilborn/displayplacer/releases/tag/v${finalAttrs.version}";
    mainProgram = "displayplacer";
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ametzger ];
  };
})
