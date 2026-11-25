{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustywind";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R0B73wVfEK3zDg9NCmzivZnPifppbHL8nIC3A6W8Pg8=";
  };

  cargoHash = "sha256-EN78SQoDjGn2TkLH03hGP95mjzsVsFhikKcG90zinJ4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
