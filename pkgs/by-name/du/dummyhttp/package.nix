{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dummyhttp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${version}";
    hash = "sha256-C3fjZgjVazZ8BNhcFJD5SsRO+xjHxw9XQPfPS+qnGtc=";
  };

  cargoHash = "sha256-bjNB0aoG9Mrz1JzD80j2Czfg0pfU2uGlFFsi5WO4pdU=";

  meta = with lib; {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GuillaumeDesforges ];
    mainProgram = "dummyhttp";
  };
}
