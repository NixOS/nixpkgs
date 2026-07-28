{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freqle";
  version = "0.1.0";
  __structuredAttrs = true;
  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-1LL1C9jYPjboGgz0z7AdWeMZR7DApCDlQ8Cj7I+iADY=";
  };
  cargoHash = "sha256-VeI2jyq7EXpjIT4e6nuTXj8z5ANoZyfxd27k/4ZaY7k=";

  meta = {
    description = "Simple CLI frecency history";
    homepage = "https://github.com/jonascarpay/freqle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonascarpay ];
    mainProgram = "freqle";
  };

})
