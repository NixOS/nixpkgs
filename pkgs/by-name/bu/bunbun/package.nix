{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bunbun";
  version = "1.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devraza";
    repo = "bunbun";
    # There is no 1.6.1 tag on github. This corresponds to the commit of the release.
    rev = "595857b1cd03b907e97c7eb0effc29fe973821bf";
    hash = "sha256-TaAlEST6WLPTlYADzAA4i46dr4Bo+fButu65g43EvWo";
  };

  cargoHash = "sha256-tL70RQ8YOSHyyTnPjg7IiuCEhb4EF4xIkT8HMMXhc9g";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple and adorable sysinfo utility written in Rust";
    homepage = "https://github.com/devraza/bunbun";
    changelog = "https://github.com/devraza/bunbun/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "bunbun";
  };
})
