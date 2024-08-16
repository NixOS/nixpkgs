{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
, Cocoa
, pkgsBuildHost
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MPYqWgwh5PKH3GsCDx6aa4ryorWZ96YK8KOYZ5PILkk=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsignal-protocol-0.1.0" = "sha256-p4YzrtJaQhuMBTtquvS1m9llszfyTeDfl7+IXzRUFSE=";
      "libsignal-service-0.1.0" = "sha256-p0umCPtBg9s4G6RHcwK/tU+RtQE2fFLRHOYt2GmBCtQ=";
      "curve25519-dalek-4.1.1" = "sha256-p9Vx0lAaYILypsI4/RVsHZLOqZKaa4Wvf7DanLA38pc=";
      "presage-0.6.1" = "sha256-MsVSUI4ht+ftO2UC1IIeCtomkzg4ug95kKsc41PDVNg=";
      "qr2term-0.3.1" = "sha256-U8YLouVZTtDwsvzZiO6YB4Pe75RXGkZXOxHCQcCOyT8=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  PROTOC = "${pkgsBuildHost.protobuf}/bin/protoc";

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
