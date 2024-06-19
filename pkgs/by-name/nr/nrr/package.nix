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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-jC+jyg97ifn2T6o0K2KEELGbko5eBIo9ZFLw9ly9lyE=";
  };

  cargoHash = "sha256-byDFHxXqXd14/ql1FGj/ySn7zrNgSGo5RBGJrHIRDC4=";

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
