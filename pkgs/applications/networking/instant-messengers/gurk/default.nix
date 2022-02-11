{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, protobuf
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "${pname}-rs";
    rev = "v${version}";
    sha256 = "1bhiqhwzrvc0bw4l1mhfq78aq7y4288yy9scp5s8w19wsfwkjjij";
  };

  cargoSha256 = "07ccd61crx2fnh4bh78z6cqmsh2hbgz36scyhwipz7hg2aqbis8b";

  nativeBuildInputs = [ pkg-config ];

  preBuild = ''
  export PROTOC=${protobuf}/bin/protoc
  export PROTOC_INCLUDE="${protobuf}/include";
  '';

  buildInputs = [ protobuf ];

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = with licenses; [ agpl3 ];
    maintainers = with maintainers; [ mredaelli ];
  };
}
