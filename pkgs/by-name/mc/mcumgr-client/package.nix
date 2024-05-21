{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  udev,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcumgr-client";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "vouch-opensource";
    repo = "mcumgr-client";
    rev = "v${version}";
    hash = "sha256-MTNMnA5/CzwVrhNhDrfaXOatT4BFmc4nOPhIxTyc248=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  meta = with lib; {
    description = "Client for mcumgr commands";
    homepage = "https://github.com/vouch-opensource/mcumgr-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "mcumgr-client";
  };
}
