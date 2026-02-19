{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpx";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "11happy";
    repo = "cpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tZ9NQUwnbONpJ59ByvgHESqqBWz6RaPgY6842VuAlL0=";
  };

  cargoHash = "sha256-atEB43eB8btQfMXPTCfsZ6bbAUIPzF8lUELx0Rdul84=";

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/11happy/cpx/releases/tag/v${finalAttrs.version}";
    description = "File copy tool for Linux with progress bars, resume capability";
    homepage = "https://github.com/11happy/cpx";
    license = lib.licenses.mit;
    mainProgram = "cpx";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
