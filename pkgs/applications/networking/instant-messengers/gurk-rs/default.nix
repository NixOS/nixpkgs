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

  cargoHash = "sha256-jS6wAswGqgfmpPV6qERhqn1IhpcBSDNh8HDdPo04F0A=";

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
