{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.162";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6wfWcfdM90goU31NXRnVedpc8fRtdR2sxvByYdsWq8w=";
  };

  cargoHash = "sha256-4pa4CeNkKQYRdf92HyocbUxmpQ6e7oHWQvG1j+xZ+9U=";

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
