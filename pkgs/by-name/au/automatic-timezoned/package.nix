{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.101";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OiBFFXdaBYBSToEzWafxNLBC12J1f3mO7DMzKESRxSY=";
  };

  cargoHash = "sha256-vX7QGLPuU08KhAJUujgqtPmzW3Ji38W1YiEZ4KbI2mE=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.maxbrunet ];
    platforms = lib.platforms.linux;
    mainProgram = "automatic-timezoned";
  };
})
