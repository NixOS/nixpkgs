{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LN54XUu+54yGVCbi7ZwY22KOnfS67liioI4JeR3l92I=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-T/NGZddFQWq32eRu6FYfgdPqU8Y4Shi1NpMaX4GeQ54=";
      "libsignal-protocol-0.1.0" = "sha256-gapAurbs/BdsfPlVvWWF7Ai1nXZcxCW8qc5gQdbnthM=";
      "libsignal-service-0.1.0" = "sha256-C1Lhi/NRWyPT7omlAdjK7gVTLxmZjZVuZgmZ8dn/D3Y=";
      "presage-0.5.0-dev" = "sha256-OtRrPcH4/o6Sq/day1WU6R8QgQ2xWkespkfFPqFeKWk=";
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
