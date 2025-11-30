{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  openssl,
  protobuf_25,
  protobufc,
}:

stdenv.mkDerivation rec {
  pname = "libomemo-c";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "libomemo-c";
    rev = "v${version}";
    hash = "sha256-HoZykdGVDsj4L5yN3SHGF5tjMq5exJyC15zTLBlpX/c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    protobuf_25
    protobufc
  ];
  buildInputs = [
    openssl
    protobufc
  ];
  mesonFlags = [
    "-Dtests=false"
  ];

  meta = with lib; {
    description = "Fork of libsignal-protocol-c adding support for OMEMO XEP-0384 0.5.0+";
    homepage = "https://github.com/dino/libomemo-c";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.astro ];
  };
}
