{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch";
  version = "0.2.23";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mW0oMrmDUn8qsCCu870z6zS3szGVyCU4wnSytH6DkUE=";
  };

  cargoHash = "sha256-g5SLS6PpcRNm1zcHkX8pvqk7s2yQ+zUAjp4CSCq/U/o=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Minimalist fetch tool for Japanese quotes";
    mainProgram = "kotofetch";
    homepage = "https://github.com/hxpe-dev/kotofetch";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yarn ];
  };
})
