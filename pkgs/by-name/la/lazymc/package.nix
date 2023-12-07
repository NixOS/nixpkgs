{
  lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "lazymc";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "lazymc";
    rev = "v${version}";
    hash = "sha256-IObLjxuMJDjZ3M6M1DaPvmoRqAydbLKdpTQ3Vs+B9Oo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "minecraft-protocol-0.1.0" = "sha256-vSFS1yVxTBSpx/ZhzA3EjcZyOWHbmoGARl0eMn1fJ+4=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Remote wake-up daemon for minecraft servers";
    homepage = "https://github.com/timvisee/lazymc";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ h7x4 dandellion ];
    platforms = platforms.unix;
    mainProgram = "lazymc";
  };
}
