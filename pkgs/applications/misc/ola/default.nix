{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, bison
, flex
, pkg-config
, libftdi1
, libuuid
, cppunit
, protobuf
, zlib
, avahi
, libmicrohttpd
, perl
, python3
}:

stdenv.mkDerivation rec {
  pname = "ola";
  version = "unstable-2020-07-17";

  src = fetchFromGitHub {
    owner = "OpenLightingProject";
    repo = "ola";
    rev = "e2cd699c7792570500578fd092fb6bfb3d511023"; # HEAD of "0.10" branch
    sha256 = "17a3z3zhx00rjk58icd3zlqfw3753f3y8bwy2sza0frdim09lqr4";
  };

  nativeBuildInputs = [ autoreconfHook bison flex pkg-config perl ];
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
    (python3.pkgs.protobuf.override { protobuf = protobuf; })
    python3.pkgs.numpy
  ];

  configureFlags = [ "--enable-python-libs" ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Framework for controlling entertainment lighting equipment";
    homepage = "https://www.openlighting.org/ola/";
    maintainers = [ ];
    license = with licenses; [ lgpl21 gpl2Plus ];
    platforms = platforms.all;
  };
}
