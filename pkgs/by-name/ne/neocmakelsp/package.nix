{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-MRno86pi389p2lBTu86LCPx5yFN76CbM5AXAs4bsl7c=";
  };

  cargoHash = "sha256-UVXJF8jvZUcEWbsL+UmrO2VSlvowkXNGRbxCEmB89OU=";

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
