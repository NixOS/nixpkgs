{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sig";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${version}";
    hash = "sha256-685VBQ64B+IbSSyqtVXtOgs4wY85WZ/OceHL++v5ip4=";
  };

  cargoHash = "sha256-afsLf/WsCShjagYWDUA3ZgpgK1XjQiZzISZngzzYybg=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
}
