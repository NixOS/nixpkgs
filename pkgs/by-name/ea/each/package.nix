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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Aa/uHWrU4bpWd28Uddnuhmi6guHy09W9AU8sAfea6I=";
  };

  cargoHash = "sha256-sH9rraPNAIlW2KQVaZfYa10c1HHQpDgedY1+9e94RLE=";

  meta = with lib; {
    description = " A better way of working with structured data on the command line";
    mainProgram = "each";
    homepage = "https://github.com/arraypad/each";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ thiagokokada ];
  };
}
