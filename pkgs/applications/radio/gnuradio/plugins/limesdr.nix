{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, boost
, gnuradio
, pythonSupport ? true
, python
, swig
, limesuite
} :

assert pythonSupport -> python != null && swig != null;

let
  version = if gnuradio.branch == "3.7" then "2.0.0" else "3.0.1";
  src_hash = if gnuradio.branch == "3.7" then
   "0ldqvfwl0gil89l9s31fjf9d7ki0dk572i8vna336igfaz348ypq"
  else # if gnuradio.branch == "3.8" then
   "1m9kdxvcnw8j7lm3dysccrc90l23kgv2fnawbf4bxjil6pqkxyvx"
  ;

in stdenv.mkDerivation {
  pname = "gr-limesdr";
  inherit version;

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "gr-limesdr";
    rev = "v${version}";
    sha256 = src_hash;
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ] ++ stdenv.lib.optionals pythonSupport [ swig ];

  buildInputs = [
    boost
    gnuradio
    limesuite
  ] ++ stdenv.lib.optionals pythonSupport [ python ];


  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio source and sink blocks for LimeSDR";
    homepage = "https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
