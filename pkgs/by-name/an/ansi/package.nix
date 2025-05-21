{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ansi-escape-sequences-cli";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-15C389g4PrI8Qg25B1LxFgb7gkABw0q0O5RDg3YTv3w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u7BfevNT3f7YVFke9BzHK/LHHYJZlGTYyg0dENc1pVs=";

  meta = {
    description = "Quickly get ANSI escape sequences";
    longDescription = ''
      CLI utility called "ansi" to quickly get ANSI escape sequences. Supports
      the colors and styles, such as bold or italic.
    '';
    homepage = "https://github.com/phip1611/ansi-escape-sequences-cli";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
    mainProgram = "ansi";
  };
}
