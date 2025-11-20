{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "popcorn-cli";
  version = "1.1.46";

  src = fetchFromGitHub {
    owner = "gpu-mode";
    repo = "popcorn-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6WARKafEtroLCYsW1VqKAZ2OFX/o/b5NZrDyawjMts=";
  };

  cargoHash = "sha256-eMhhoONOUNRDx+vxzkcv9AE2XE3mQ8XLH2QqlgDbXeI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Version check disabled: binary reports 0.1.0 while git tag is v1.1.46
  # Upstream issue: https://github.com/gpu-mode/popcorn-cli/issues/25
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = "--version";
  # doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for submitting solutions to the Popcorn Discord Bot";
    homepage = "https://github.com/gpu-mode/popcorn-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethanthoma ];
    mainProgram = "popcorn-cli";
  };
})
