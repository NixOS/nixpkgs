{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bagr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "pwinckles";
    repo = "bagr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tvo9/ywPhYgqj4i+o6lYOmrVnLcyciM7HPdT2dKerO8=";
  };

  cargoHash = "sha256-r4tgDPyLxTjq/sxNLvlX/2MePUfOwNgranQSSbgDtu0=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Command line utility for interacting with BagIt bags (RFC 8493)";
    homepage = "https://github.com/pwinckles/bagr";
    license = lib.licenses.asl20;
    mainProgram = "bagr";
    maintainers = with lib.maintainers; [
      jezcope
    ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
