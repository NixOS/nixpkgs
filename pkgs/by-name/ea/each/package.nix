{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "each";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "arraypad";
    repo = "each";
    rev = "v${version}";
    sha256 = "sha256-5Aa/uHWrU4bpWd28Uddnuhmi6guHy09W9AU8sAfea6I=";
  };

  cargoHash = "sha256-TfAT36/JeBjBxymnX1gIyCEPZcxTW4fPVIOhHF3z9wA=";

  meta = with lib; {
    description = "Command-line tool for processing CSV, JSON and other structured data";
    mainProgram = "each";
    homepage = "https://github.com/arraypad/each";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ thiagokokada ];
  };
}
