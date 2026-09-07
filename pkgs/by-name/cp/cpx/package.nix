{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpx";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "11happy";
    repo = "cpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1TjUlV0l4JnSSmmCprEy6wT1v7RPdsuhrnuKbkHiMkw=";
  };

  cargoHash = "sha256-zc2R9cm/dDJqDVp2osLXxY0O0MK6gLVG0bxt40bl9wY=";

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
