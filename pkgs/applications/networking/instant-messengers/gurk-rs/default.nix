{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WZUoUvu7GaiBOaRAOGRCXrLe6u3DRbI6CDTAf5jryGc=";
  };

  cargoHash = "sha256-81ZW61JX40W0D/cmYogR3RJH2dvEKW1K7sIsl2io/7E=";
  buildInputs = [ protobuf ];

  PROTOC = "${protobuf}/bin/protoc";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Signal Messenger client for terminal";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
