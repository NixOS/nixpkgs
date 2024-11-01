{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-UFNOW/INV/65C6UysKi9lGw+PIj2NXF6ejG5UY702/I=";
  };

  cargoHash = "sha256-sy/RNMXJn5k9qw0ghCQA7PqZokpDw0xns4abwa938Gk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    mainProgram = "ox";
  };
}
