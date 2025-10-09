{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-open-on-gh";
    rev = version;
    hash = "sha256-73738Vei7rQ67LQIOrHPGOtsBnHClaXClRWDmA5pP58=";
  };

  cargoHash = "sha256-6BR/xXo5pBv7n5beqgY9kEe24o/lZl1sit0uumSEbe8=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    mainProgram = "mdbook-open-on-gh";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
