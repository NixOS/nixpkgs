{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mko5udM8BY50uUwn7xESxB+s0MEO1kAJX4Dt/DnEEa4=";
  };

  cargoHash = "sha256-pYMMgBvLsqkj2peouDQK1vn97ByUjtdCrkbzuZZLXrY=";
  buildInputs = [ protobuf ];

  PROTOC = "${protobuf}/bin/protoc";

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
