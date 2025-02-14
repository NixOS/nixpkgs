{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "code2prompt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "code2prompt";
    rev = "v${version}";
    hash = "sha256-ESgSMkid92ojTcT/iPskz7S4dJQnigtxdj5IlS4xvhc=";
  };

  # v2.0.0 does not yet contain a Cargo.lock, but there is one on main.
  # Maybe next time this is not needed...
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    # src is missing Cargo.lock
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.AppKit
    ];

  meta = {
    description = "A CLI tool that converts your codebase into a single LLM prompt with a source tree, prompt templating, and token counting";
    homepage = "https://github.com/mufeedvh/code2prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "code2prompt";
  };
}
