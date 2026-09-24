{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.156";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s/VUlcMxveeYN9PUg7fWd9HFGbwkcYeN3s4nKhehYhY=";
  };

  cargoHash = "sha256-PcdNomx0ZwdmPWORbIayeFLWbyrmWdl9EO2P7GC25B4=";

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
