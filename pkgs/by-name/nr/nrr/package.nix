{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pkg-config
, libiconv
, nrxAlias ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-X1zgQvgjWbTQAOHAZ+G2u0yO+qeiU0hamTLM39VOK20=";
  };

  cargoHash = "sha256-NpvYN68l5wibrFxST35sWDBbUG1mauNszA8NYIWGGa0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.IOKit
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  postInstall = lib.optionalString nrxAlias "ln -s $out/bin/nr{r,x}";

  meta = with lib; {
    description = "Minimal, blazing fast npm scripts runner";
    maintainers = with maintainers; [ ryanccn ];
    license = licenses.gpl3Only;
    mainProgram = "nrr";
  };
}
