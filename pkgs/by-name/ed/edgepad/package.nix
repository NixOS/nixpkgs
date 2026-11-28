{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "edgepad";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "assembledev";
    repo = "edgepad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iH6IQqsn9SQRa/dmDUfJ78K23qNYBQjwY5oq/4QVgIc=";
  };

  cargoHash = "sha256-Osu8yIzTa63xZsTU9E5ASnEpSJcCSra4Q59Pe9EpU3c=";

  postInstall = ''
    install -Dm644 packaging/70-edgepad.rules "$out/lib/udev/rules.d/70-edgepad.rules"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Run commands with touchpad edge gestures";
    homepage = "https://github.com/assembledev/edgepad";
    changelog = "https://github.com/assembledev/edgepad/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.assembledev ];
    platforms = lib.platforms.linux;
    mainProgram = "edgepad";
  };
})
