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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UTjTXUc0W+vlO77ilveAy0HWF5KSKbDnrg5ewTyuTdA=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsignal-protocol-0.1.0" = "sha256-FCrJO7porlY5FrwZ2c67UPd4tgN7cH2/3DTwfPjihwM=";
      "libsignal-service-0.1.0" = "sha256-OWLtaxldKgYPP/aJuWezNkNN0990l3RtDWK38R1fL90=";
      "curve25519-dalek-4.0.0" = "sha256-KUXvYXeVvJEQ/+dydKzXWCZmA2bFa2IosDzaBL6/Si0=";
      "presage-0.6.0-dev" = "sha256-65YhxMAAFsnOprBWiB0uH/R9iITt+EYn+kMVjAwTgOQ=";
      "qr2term-0.3.1" = "sha256-U8YLouVZTtDwsvzZiO6YB4Pe75RXGkZXOxHCQcCOyT8=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  PROTOC = "${pkgsBuildHost.protobuf}/bin/protoc";

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
