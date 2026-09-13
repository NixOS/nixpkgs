{
  fetchFromGitHub,
  lib,
  makeWrapper,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber-lsp";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d5FJGeQol6NPVCbZ8F97s6jiV/JrbVJMcXwro2hBJfI=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-YSoNYjru/CWEYNqSkjCKFDps3XmmCRo4VaZ6n/7pI5A=";

  # Each of the 380+ async tests spins up a tokio runtime which can exhaust
  # memory if run in parallel on many cores.
  checkFlags = [ "--test-threads=4" ];

  postFixup = ''
    # By default it wants to write to $out/amber-lsp-resources
    wrapProgram $out/bin/amber-lsp \
      --run '
        export AMBER_LSP_RESOURCES_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/amber-lsp-resources"
      '
  '';

  meta = {
    description = "Amber's Language Server";
    homepage = "https://github.com/amber-lang/amber-lsp";
    license = lib.licenses.gpl3Only;
    mainProgram = "amber-lsp";
    maintainers = with lib.maintainers; [ beeb ];
  };
})
