{ stdenv, fetchFromGitHub, cmake, boost, gnuradio
, pythonSupport ? true, python, swig, limesuite
} :

assert pythonSupport -> python != null && swig != null;

let
  version = "1.0.0-RC";

in stdenv.mkDerivation rec {
  name = "gnuradio-limesdr-${version}";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "gr-limesdr";
    rev = "v${version}";
    sha256 = "0b34mg9nfar2gcir98004ixrxmxi8p3p2hrvvi1razd869x2a0lf";
  };

  nativeBuildInputs = [
    cmake
  ] ++ stdenv.lib.optionals pythonSupport [ swig ];

  buildInputs = [
    boost gnuradio limesuite
  ] ++ stdenv.lib.optionals pythonSupport [ python ];


  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio source and sink blocks for LimeSDR";
    homepage = https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
