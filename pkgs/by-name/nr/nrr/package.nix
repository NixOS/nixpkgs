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
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-P1LJFVe2MUkvKFP4XJvuFup9JKPv9Y2uWfoi8/N7JUo=";
  };

  cargoHash = "sha256-owj5rzqtlbMMc84u5so0QbEzd2vnWk3KyM/A9ChxoVw=";

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
