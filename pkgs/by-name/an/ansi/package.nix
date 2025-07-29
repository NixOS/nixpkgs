{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ansi-escape-sequences-cli";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-55CdEw1bVgabWRbZIRe9jytwDf70Y92nITwDRQaTXaQ=";
  };

  cargoHash = "sha256-g+FP98lcC3EeQtcGO0kE+g6Z9tUgrlieTlVJYKs/ig4=";

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
