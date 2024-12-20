{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  pkg-config,
  libftdi1,
  libuuid,
  cppunit,
  protobuf,
  zlib,
  avahi,
  libmicrohttpd,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "ola";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "OpenLightingProject";
    repo = "ola";
    rev = "refs/tags/${version}";
    hash = "sha256-8w8ZT3D/+8Pxl9z2KTXeydVxE5xiPjxZevgmMFgrblU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    perl
  ];
  buildInputs = [
    # required for ola-ftdidmx plugin (support for 'dumb' FTDI devices)
    libftdi1
    libuuid
    cppunit
    protobuf
    zlib
    avahi
    libmicrohttpd
    python3
  ];
  propagatedBuildInputs = [
    (python3.pkgs.protobuf4.override { protobuf = protobuf; })
    python3.pkgs.numpy
  ];

  configureFlags = [ "--enable-python-libs" ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Framework for controlling entertainment lighting equipment";
    homepage = "https://www.openlighting.org/ola/";
    maintainers = [ ];
    license = with licenses; [
      lgpl21
      gpl2Plus
    ];
    platforms = platforms.all;
  };
}
