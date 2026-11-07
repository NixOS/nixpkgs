{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.160";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lfP+XgarNGhtbamALFM5T/3U5hF1a+nQUAOuZb4sgUI=";
  };

  cargoHash = "sha256-Vo5qhfBrgif+z2dPJttl6dKRSTQ0kfiAGu9wZkAOCpw=";

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
