{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.158";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LVkScvoYPog0u1wfRheKT15DicyKc/aIBeye3ZVjHy4=";
  };

  cargoHash = "sha256-OS+FDdj6tfgstOQl8I/jzpEFH1AzCtzEFQASKEuN6hY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
