{ stdenv
, lib
, protobuf
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CEsnZ0V85eOH+bjtico5yo9kS6eMT7Dx3H6wiDUjQm4=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-z+2G/hD1zYOoJrYFB0eEP6y9MoV2OfdkJVt6je94EkU=";
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
