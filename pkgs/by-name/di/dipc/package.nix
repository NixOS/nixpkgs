{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "dipc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "doprz";
    repo = "dipc";
    rev = "bf578bd9474084b7099ef665138667e486dce671";
    hash = "sha256-RXEC8bwdnUOaDmYIb7ci/JD+vi16tBn55FRsUmwaRzk=";
  };

  cargoHash = "sha256-XQ85T64K1NLdSOtAFr0XluvFNTaHzoWKxoQtBQ+uSKQ=";

  meta = with lib; {
    description = "Convert your favorite images and wallpapers with your favorite color palettes/themes";
    homepage = "https://github.com/doprz/dipc";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "dipc";
  };
}
