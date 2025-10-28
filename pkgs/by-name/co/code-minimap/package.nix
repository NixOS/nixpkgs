{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "code-minimap";
    rev = "v${version}";
    sha256 = "sha256-unf7gFc/tQiUw3VqQ0KC96Srxn1E27WsmJviSggaCF4=";
  };

  cargoHash = "sha256-35qMpxROBnXfnTIAkCRUg7zRQTvSIIA2qGD0Vu9r488=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = with lib; {
    description = "High performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ bsima ];
    mainProgram = "code-minimap";
  };
}
