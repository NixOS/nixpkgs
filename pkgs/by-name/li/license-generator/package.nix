{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "license-generator";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RofgO5pJJlHP1rHFK5pgvi1TF77ZYrLYP5EML43zQMI=";
  };

  cargoHash = "sha256-6iJJ6ZK5ZUfKG+1qYehz1LeYs6kzS1QlTjIogCLWjZA=";

  meta = with lib; {
    description = "Command-line tool for generating license files";
    homepage = "https://github.com/azu/license-generator";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
    mainProgram = "license-generator";
  };
}
