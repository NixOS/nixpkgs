{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylance-cli";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "basro";
    repo = "stylance-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-raimzhK0o3ZMMfHpBIOVkDly5MSIpfgpSDDdW2aWbUI=";
  };

  cargoHash = "sha256-wqNQUCD7/q41GKIxjLFEGrlNru3SIN9mbUh+nApm1i8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
