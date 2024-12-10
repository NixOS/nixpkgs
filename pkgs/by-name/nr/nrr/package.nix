{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  pkg-config,
  libiconv,
  nrxAlias ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-wof/KmoHiBkcn2aTh+M6bNH/B6Le3H6hnT8BzUCs0Pw=";
  };

  cargoHash = "sha256-BtYZNZxFjgY/BFd1kwGyy/F1iRezSDxoPHF4exrNzuk=";

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
