{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, gnuradio
, pythonSupport ? true, python, swig, limesuite, log4cpp
} :

assert pythonSupport -> python != null && swig != null;

let
  version = "2.0.0";

in stdenv.mkDerivation {
  pname = "gr-limesdr";
  inherit version;

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "gr-limesdr";
    rev = "v${version}";
    sha256 = "0ldqvfwl0gil89l9s31fjf9d7ki0dk572i8vna336igfaz348ypq";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals pythonSupport [ swig ];

  buildInputs = [
    boost gnuradio limesuite log4cpp
  ] ++ lib.optionals pythonSupport [ python ];


  meta = with lib; {
    description = "Gnuradio source and sink blocks for LimeSDR";
    homepage = "https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
