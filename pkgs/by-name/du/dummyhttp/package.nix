{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dummyhttp";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J8TOOLTNvm6udkPdYTrjrCX/3D35lXeFDc0H5kki+Uk=";
  };

  cargoHash = "sha256-566hk79oXApJm5p+gEgikV08n19hH1Tk36DvgPuQKLI=";

  meta = {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    mainProgram = "dummyhttp";
  };
})
