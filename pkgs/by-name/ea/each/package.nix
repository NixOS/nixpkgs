{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "each";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "arraypad";
    repo = "each";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5Aa/uHWrU4bpWd28Uddnuhmi6guHy09W9AU8sAfea6I=";
  };

  cargoHash = "sha256-TfAT36/JeBjBxymnX1gIyCEPZcxTW4fPVIOhHF3z9wA=";

  meta = {
    description = "Command-line tool for processing CSV, JSON and other structured data";
    mainProgram = "each";
    homepage = "https://github.com/arraypad/each";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
})
