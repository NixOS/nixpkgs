{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
, Cocoa
, pkgsBuildHost
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g0V6FPkCpIEWx+/kDG9+0NtlCVj6jc1gbkkzOSl/lAo=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsignal-protocol-0.1.0" = "sha256-4aHINlpVAqVTtm7npwXQRutZUmIxYgkhXhApg7jSM4M=";
      "libsignal-service-0.1.0" = "sha256-AOGw76A9R2qH3hc7B+MBE3okzW8b5LTZdepzUDOv9lM=";
      "curve25519-dalek-4.1.3" = "sha256-bPh7eEgcZnq9C3wmSnnYv0C4aAP+7pnwk9Io29GrI4A=";
      "presage-0.6.2" = "sha256-t9t8ecPtefI/jYlk+Ul8WdgH26VJIkfMptbKxprekS0=";
      "qr2term-0.3.1" = "sha256-U8YLouVZTtDwsvzZiO6YB4Pe75RXGkZXOxHCQcCOyT8=";
    };
  };

  nativeBuildInputs = [ protobuf pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  PROTOC = "${pkgsBuildHost.protobuf}/bin/protoc";

  OPENSSL_NO_VENDOR = true;

  useNextest = true;

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
