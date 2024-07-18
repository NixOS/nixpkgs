{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.1.81";
  versionString = "v{$version}";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "jinja-lsp";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    rev = versionString;
    hash = "sha256-6qv1w48tjcBmZzZpeahBsrMgFhKw9sTzvR2A8qeIIGo=";
  };

  cargoHash = "sha256-F+Gof+muTsQ4V465dW27U51ZsbD7smycY+P2WAeKGLs=";

  meta = {
    homepage = "https://github.com/uros-5/jinja-lsp";
    description = "Language Server for jinja";
    changelog = "https://github.com/uros-5/jinja-lsp/releases/tag/${versionString}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jeidnx ];
    mainProgram = "jinja-lsp";
  };
}
