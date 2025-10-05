{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dummyhttp";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${version}";
    hash = "sha256-J8TOOLTNvm6udkPdYTrjrCX/3D35lXeFDc0H5kki+Uk=";
  };

  cargoHash = "sha256-566hk79oXApJm5p+gEgikV08n19hH1Tk36DvgPuQKLI=";

  meta = with lib; {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    mainProgram = "dummyhttp";
  };
}
