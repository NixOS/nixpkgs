{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdvi";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "taf2";
    repo = "mdvi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lLMIekzNw3kRi7PZWtmVUfITig5ytMJnDfeVIKuGOx8=";
  };

  cargoHash = "sha256-AaGpQMbTOBETWfnfduDnbE5zvae4c0HyGHoIMBQIDWM=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal markdown viewer with Vim-style navigation";
    homepage = "https://github.com/taf2/mdvi";
    changelog = "https://github.com/taf2/mdvi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "mdvi";
  };
})
