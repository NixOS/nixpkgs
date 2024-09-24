{ lib
, stdenv
, fetchFromGitHub
, autoconf
, protobuf
, pkg-config
, grpc
, libtool
, which
, automake
, libax25
}:

stdenv.mkDerivation {
  pname = "ax25ms";
  version = "0-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "ax25ms";
    rev = "c7d7213bb182e4b60f655c3f9f1bcb2b2440406b";
    hash = "sha256-GljGJa44topJ6T0g5wuU8GTHLKzNmQqUl8/AR+pw2+I=";
  };

  buildInputs = [
    protobuf
    grpc
    libax25
  ];

  nativeBuildInputs = [
    which
    pkg-config
    autoconf
    libtool
    automake
  ];

  preConfigure = ''
    patchShebangs scripts
    ./bootstrap.sh
  '';

  postInstall = ''
    set +e
    for binary_path in "$out/bin"/*; do
      filename=$(basename "$binary_path")
      mv "$binary_path" "$out/bin/ax25ms-$filename"
    done
    set -e
  '';

  meta = with lib; {
    description = "Set of AX.25 microservices, designed to be pluggable for any implementation";
    homepage = "https://github.com/ThomasHabets/ax25ms";
    license = licenses.asl20;
    maintainers = with maintainers; [
      matthewcroughan
      sarcasticadmin
      pkharvey
    ];
    platforms = platforms.all;
  };
}
