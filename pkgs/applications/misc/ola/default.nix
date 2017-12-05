{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig
, libuuid, cppunit, protobuf, zlib, avahi, libmicrohttpd
, perl, python3, python3Packages
}:

stdenv.mkDerivation rec {
  name = "ola-${version}";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "OpenLightingProject";
    repo = "ola";
    rev = version;
    sha256 = "1296iiq8fxbvv8sghpj3nambfmixps48dd77af0gpwf7hmjjm8al";
  };

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig perl ];
  buildInputs = [ libuuid cppunit protobuf zlib avahi libmicrohttpd python3 ];
  propagatedBuildInputs = with python3Packages; [ protobuf3_2 numpy ];

  configureFlags = [ "--enable-python-libs" ];

  meta = with stdenv.lib; {
    description = "A framework for controlling entertainment lighting equipment.";
    maintainers = [ maintainers.globin ];
    license = with licenses; [ lgpl21 gpl2Plus ];
    platforms = platforms.all;
  };
}
