{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lazymc";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "lazymc";
    rev = "v${version}";
    hash = "sha256-uMjM3w78qWnB/sNXRcxl30KJRm0I3BPEOr5IRU8FI0s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "minecraft-protocol-0.1.0" = "sha256-3eDMj8+Ug46WOl3zRqNxUa+SZr2qlhyi8OSewLu+gI8=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Remote wake-up daemon for minecraft servers";
    homepage = "https://github.com/timvisee/lazymc";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      h7x4
      dandellion
    ];
    platforms = platforms.unix;
    mainProgram = "lazymc";
  };
}
