{ stdenv
, fetchgit
, cmake
, pkgconfig
, boost
, pythonSupport ? true
, python
, swig
, airspy
, gnuradio
, hackrf
, libbladeRF
, rtl-sdr
, soapysdr-with-plugins
, uhd
}:

assert pythonSupport -> python != null && swig != null;

let
  version = if gnuradio.branch == "3.7" then "0.1.5" else "0.2.0";
  src_hash = if gnuradio.branch == "3.7" then
   "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv"
  else # if gnuradio.branch == "3.8" then
   "1rdx7fa0xiq0qmgrrbby7z1bblmqhl9qh9jqpsznzxkx91f17ypd"
  ;
in

stdenv.mkDerivation rec {
  pname = "gr-osmosdr";
  inherit version;

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "v${version}";
    sha256 = src_hash;
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [
    cmake
    makeWrapper
    boost
    airspy
    gnuradio
    hackrf
    libbladeRF
    rtl-sdr
    uhd
  ]
    ++ stdenv.lib.optionals stdenv.isLinux [
      soapysdr-with-plugins
    ]
    ++ stdenv.lib.optionals pythonSupport [
      python
      swig
    ]
  ;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor the-kenny ];
  };
}
