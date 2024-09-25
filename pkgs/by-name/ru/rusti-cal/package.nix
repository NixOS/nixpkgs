{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rusti-cal";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "arthurhenrique";
    repo = "rusti-cal";
    rev = "v${version}";
    hash = "sha256-pdsP2nuJh30BzqIyxSQXak/rceA4hI9jBYy1dDVEIvI=";
  };

  cargoHash = "sha256-5eS+OMaNAVNyDMKFNfb0J0rLsikw2LCXhWk7MS9UV2k=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    description = "Minimal command line calendar, similar to cal";
    mainProgram = "rusti-cal";
    homepage = "https://github.com/arthurhenrique/rusti-cal";
    license = [ licenses.mit ];
    maintainers = [ maintainers.detegr ];
  };
}
