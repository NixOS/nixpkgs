{ stdenv, fetchurl, libusb, cmake, wxGTK30, mesa, libX11, soapysdr, sqlite, doxygen, gnuplot ? null }:

stdenv.mkDerivation rec {
  version = "17.12.0";
  name = "LimeSuite-${version}";

  src = fetchurl {
    url = "https://github.com/myriadrf/LimeSuite/archive/v${version}.tar.gz";
    sha256 = "0fiadrkz5rh1yngjw6q6mg55k375pvp4ba9fkj3x8h3wh9ym32i6";
  };

  buildInputs = [ libusb cmake wxGTK30 mesa libX11 soapysdr sqlite doxygen gnuplot ];

  configurePhase = ''
    mkdir -p build
    pushd build

    cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_BUILD_TYPE=Release -DENABLE_STREAM_UNITE=ON
  '';

  meta = with stdenv.lib; {
    description = "Driver and GUI for LMS7002M-based SDR platforms";
    homepage = https://myriadrf.org/projects/lime-suite/;
    license = licenses.asl20;
    maintainers = with maintainers; [ roosemberth ];
    platforms = platforms.linux;
  };
}
