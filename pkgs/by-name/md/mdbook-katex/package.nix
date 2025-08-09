{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xwIW8igfxO9vsck8ktDBc7XFLuYzwqI3I4nLDTYC8JI=";
  };

  cargoHash = "sha256-ULcjcY+CaVSohSzlm4KbSgG27IZyxX8zp8ifZNj5c54=";

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
