{ stdenv
, fetchgit
, cmake
, pkgconfig
, boost
, pythonSupport ? true
, python
, swig
, gnuradio
# TODO: not avalable because https://cgit.osmocom.org/osmo-sdr/ is not packaged
, enableOsmoSDR ? false
, enableFcd ? true
# TODO: not available because https://github.com/dl1ksv/gr-fcdproplus is not packaged
, enableFcdPp ? false
# IQ file source & sink support
, enableFile ? true
, enableRtlsdr ? true
, rtl-sdr ? null
, enableUhd ? true
, uhd ? null
# TODO: not available because https://cgit.osmocom.org/libmirisdr/ is not packaged
, enableMiri ? false
, enableHackrf ? true
, hackrf ? null
, enableBladerf ? true
, libbladeRF ? null
, enableRfspace ? true
, enableAirspy ? true
, airspy ? null
, enableSoapy ? true
, soapysdr-with-plugins ? null
, enableRedpitaya ? true
# TODO: not available (probably) because https://github.com/myriadrf/libfreesrp is not packaged
, enableFreesrp ? false
}:

assert pythonSupport -> python != null && swig != null;

let
  version = if gnuradio.branch == "3.7" then "0.1.5" else "0.2.0";
  src_hash = if gnuradio.branch == "3.7" then
   "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv"
  else # if gnuradio.branch == "3.8" then
   "1rdx7fa0xiq0qmgrrbby7z1bblmqhl9qh9jqpsznzxkx91f17ypd"
  ;
  inherit (stdenv.lib) optionals;
  onOffBool = b: if b then "ON" else "OFF";
in

stdenv.mkDerivation rec {
  pname = "gr-osmosdr";
  inherit version;

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "v${version}";
    sha256 = src_hash;
  };

  propagatedBuildInputs = optionals (pythonSupport) [
    (python.withPackages (ps: with ps; [
      cheetah
    ]))
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ]
    ++ optionals (pythonSupport) [ swig ]
  ;
  buildInputs = [
    boost
    gnuradio
  ]
    ++ optionals (enableRtlsdr) [ rtl-sdr ]
    ++ optionals (enableUhd) [ uhd ]
    ++ optionals (enableHackrf) [ hackrf ]
    ++ optionals (enableAirspy) [ airspy ]
    ++ optionals (enableSoapy) [ soapysdr-with-plugins ]
    ++ optionals (enableBladerf) [ libbladeRF ]
  ;
  cmakeFlags = [
    "-DENABLE_OSMO_SDR=${onOffBool enableOsmoSDR}"
    "-DENABLE_FCD_PP=${onOffBool enableFcdPp}"
    "-DENABLE_FCD=${onOffBool enableFcd}"
    "-DENABLE_FILE=${onOffBool enableFile}"
    "-DENABLE_RTLSDR=${onOffBool enableRtlsdr}"
    "-DENABLE_UHD=${onOffBool enableUhd}"
    "-DENABLE_MIRI=${onOffBool enableMiri}"
    "-DENABLE_HACKRF=${onOffBool enableHackrf}"
    "-DENABLE_RFSPACE=${onOffBool enableRfspace}"
    "-DENABLE_AIRSPY=${onOffBool enableAirspy}"
    "-DENABLE_SOAPY=${onOffBool enableSoapy}"
    "-DENABLE_REDPITAYA=${onOffBool enableRedpitaya}"
    "-DENABLE_FREESRP=${onOffBool enableFreesrp}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor the-kenny ];
  };
}
