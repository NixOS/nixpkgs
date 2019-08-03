{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig
, libuuid, cppunit, protobuf3_1, zlib, avahi, libmicrohttpd
, perl, python36 # Replace by python3 after the next update
}:

stdenv.mkDerivation rec {
  name = "ola-${version}";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "OpenLightingProject";
    repo = "ola";
    rev = version;
    sha256 = "18krwrw7w1qzwih8gnmv7r4sah5ppvq7ax65r7l5yjxn3ihwp2kf";
  };

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig perl ];
  buildInputs = [ libuuid cppunit protobuf3_1 zlib avahi libmicrohttpd python36 ];
  propagatedBuildInputs = [
    (python36.pkgs.protobuf.override { protobuf = protobuf3_1; })
    python36.pkgs.numpy
  ];

  configureFlags = [ "--enable-python-libs" ];

  meta = with stdenv.lib; {
    description = "A framework for controlling entertainment lighting equipment.";
    maintainers = [ maintainers.globin ];
    license = with licenses; [ lgpl21 gpl2Plus ];
    platforms = platforms.all;
  };
}
