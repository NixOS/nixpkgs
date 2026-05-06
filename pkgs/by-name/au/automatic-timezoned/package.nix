{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
  version = "2.0.130";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SGZbDpe64JazQCXxiT2yUvtafTyrTv6HxQyrQQQHde8=";
  };

  cargoHash = "sha256-yBpO0Uovh0M6sygN2PhczzSh7il2rQiyZD0f80+5Sak=";

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
