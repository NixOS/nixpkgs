{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  graphviz,
  cargo-bloat,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pugio";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "my4ng";
    repo = "pugio";
    tag = finalAttrs.version;
    hash = "sha256-lWiveZugZUf4xvQa2c6j6voe5wlWNl+pljD6MlImQoY=";
  };

  cargoHash = "sha256-oAC+GweB4rj1zYcUQj3DfxM4ZE4sGfI+JTKeNXN0rRE=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/pugio --prefix PATH : ${
      lib.makeBinPath [
        cargo-bloat
        graphviz
      ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graph visualisation tool for Rust to estimate and present the binary size contributions of a crate and its dependencies";
    homepage = "https://github.com/my4ng/pugio";
    changelog = "https://github.com/my4ng/pugio/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2Patent;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pugio";
  };
})
