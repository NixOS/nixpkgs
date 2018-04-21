{lib, pkgs, stdenv, fetchFromGitHub, cmake, pkgconfig, boost, python, ...}:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "raiblocks";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "clemahieu";
    repo = pname;
    rev = "V${version}";
    sha256 = "1b41hn9hb60m4lwpqrqlk3idc29cdhgx6i8ww3lki1mh78cfpypa";
    fetchSubmodules = true;
  };

  RAIBLOCKS_GUI = "ON";

  BOOST_ROOT = "${boost}";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost python ];

  buildPhase = ''
    make rai_wallet
  '';

}
