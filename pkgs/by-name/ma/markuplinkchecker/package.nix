{ lib
, fetchFromGitHub
, rustPlatform
, openssl
, perl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "markuplinkchecker";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "becheran";
    repo = "mlc";
    rev = "v${version}";
    hash = "sha256-vRsL3t/uauAWMCXgJXQ5ICgNtLpa8Dzq/gyjFlKgfqw=";
  };

  cargoHash = "sha256-nlHNhO9g4Oa878Tl6/Qe1yQeZR6c/fEzY4LilVpMSk0=";

  nativeBuildInputs = [ perl ];

  buildInputs = [ openssl ];

  doCheck = false; # because it requires an internet connection

  meta = {
    description = "Check for broken links in markup files";
    homepage = "https://github.com/becheran/mlc";
    changelog = "https://github.com/becheran/mlc/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "mlc";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.isDarwin; # needing some apple_sdk packages
  };
}
