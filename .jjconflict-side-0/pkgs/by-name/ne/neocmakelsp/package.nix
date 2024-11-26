{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-5j1nNPdTZFPmda+2ZNYh9uM1qNCsK6gqUOXZwKJ6ckU=";
  };

  cargoHash = "sha256-5ZI4heLlhPaNsNJlD9dYlvzTjoWNdHJGGmU6ugUZqds=";

  meta = with lib; {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      rewine
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
}
