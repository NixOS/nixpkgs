{
  lib,
  fetchFromGitHub,
  rustPlatform,
  graphviz,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-graphviz";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = "mdbook-graphviz";
    # Upstream has rewritten tags before:
    # https://github.com/dylanowen/mdbook-graphviz/issues/180
    rev = "36abbdff3d1f67128d81ff86336fe31619663abe";
    hash = "sha256-uqNgP1rRgP6NecReqpinsg7u01gNDpIxX2qag8IyklY=";
  };

  cargoHash = "sha256-OBCECv9ZN9xjkOestZbjCXNAA/hAl2u0AtfqxA+cV78=";

  nativeCheckInputs = [ graphviz ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  updateScript = nix-update-script { };

  meta = {
    description = "Preprocessor for mdbook, rendering Graphviz graphs to HTML at build time";
    mainProgram = "mdbook-graphviz";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    changelog = "https://github.com/dylanowen/mdbook-graphviz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
})
