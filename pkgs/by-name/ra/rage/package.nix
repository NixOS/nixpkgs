{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7PfNDFDuvQ9T3BeA15FuY1jAprGLsyglWXcNrZvtPAE=";
  };

  cargoHash = "sha256-5aLT0JfeFj0fZP/1sHXulCQtoquHYriapMdPtN+fxko=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  # cargo test has an x86-only dependency
  doCheck = stdenv.hostPlatform.isx86;

  postInstall = ''
    installManPage target/*/release/manpages/man1/*
    installShellCompletion \
      --bash target/*/release/completions/*.bash \
      --fish target/*/release/completions/*.fish \
      --zsh target/*/release/completions/_*
  '';

  meta = with lib; {
    description = "A simple, secure and modern encryption tool with small explicit keys, no config options, and UNIX-style composability";
    homepage = "https://github.com/str4d/rage";
    changelog = "https://github.com/str4d/rage/blob/v${version}/rage/CHANGELOG.md";
    license = with licenses; [ asl20 mit ]; # either at your option
    maintainers = with maintainers; [ ryantm ];
    mainProgram = "rage";
  };
}
