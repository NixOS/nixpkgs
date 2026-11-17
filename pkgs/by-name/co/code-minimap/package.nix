{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code-minimap";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "code-minimap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-unf7gFc/tQiUw3VqQ0KC96Srxn1E27WsmJviSggaCF4=";
  };

  cargoHash = "sha256-35qMpxROBnXfnTIAkCRUg7zRQTvSIIA2qGD0Vu9r488=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = {
    description = "High performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ bsima ];
    mainProgram = "code-minimap";
  };
})
