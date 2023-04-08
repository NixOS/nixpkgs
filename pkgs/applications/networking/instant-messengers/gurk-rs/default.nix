{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uJvi082HkWW9y8jwHTvzuzBAi7uVtjq/4U0bO0EWdVM=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-T/NGZddFQWq32eRu6FYfgdPqU8Y4Shi1NpMaX4GeQ54=";
      "libsignal-protocol-0.1.0" = "sha256-gapAurbs/BdsfPlVvWWF7Ai1nXZcxCW8qc5gQdbnthM=";
      "libsignal-service-0.1.0" = "sha256-CrfTdUcxP591pigS2069gEjzy5jSRz7mHORLCodQDSE=";
      "presage-0.3.0" = "sha256-Ptyjf5/SI8ftjiIxK+gVya5Cmv5sOBmWXM8ZveVV7Pc=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  PROTOC = "${protobuf}/bin/protoc";

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
