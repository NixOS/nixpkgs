{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-O2hFv/9pqrs8cSDvHLAUnXx4mX6TN8hvPLroWgoCgwE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EoWsjuvvWeAI3OnVRJQT2hwoYq4BNqqvitH9LT0XGnA=";

  meta = {
    description = "Preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}
