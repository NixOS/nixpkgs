{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.151";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-k5LjeOripX6r6EKs6+NpaoBjLIBH+C7Xe/5Hk6ZKcdw=";
  };

  cargoHash = "sha256-X7rHgemEuW1/+MkNpw3HSmQEnPMyu09zDPvVcOicYVo=";

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
