{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5EYskcYEDZENK7ehws36+5MrTY2rNTXoFnWYOC+LuiQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j0BdEnPP7/0i1hg7GNgc+F4EeElVm6AZIWZNelYZLIU=";

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
