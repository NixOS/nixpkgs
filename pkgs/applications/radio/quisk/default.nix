{ lib, python39Packages, fetchPypi
, fftw, alsa-lib, pulseaudio, pyusb, wxPython_4_0 }:

python39Packages.buildPythonApplication rec {
  pname = "quisk";
  version = "4.2.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62b017d881139ed38bd906b0467b303fbdae17e5607e93b6b2fe929e26d0551d";
  };

  buildInputs = [ fftw alsa-lib pulseaudio ];

  propagatedBuildInputs = [ pyusb wxPython_4_0 ];

  doCheck = false;

  meta = with lib; {
    description = "A SDR transceiver for radios that use the Hermes protocol";
    longDescription = ''
      QUISK is a Software Defined Radio (SDR) transceiver. You supply radio
      hardware that converts signals at the antenna to complex (I/Q) data at an
      intermediate frequency (IF). Data can come from a sound card, Ethernet or
      USB. Quisk then filters and demodulates the data and sends the audio to
      your speakers or headphones. For transmit, Quisk takes the microphone
      signal, converts it to I/Q data and sends it to the hardware.

      Quisk can be used with SoftRock, Hermes Lite 2, HiQSDR, Odyssey and many
      radios that use the Hermes protocol. Quisk can connect to digital
      programs like Fldigi and WSJT-X. Quisk can be connected to other software
      like N1MM+ and software that uses Hamlib.
    '';
    license = licenses.gpl2Plus;
    homepage = "https://james.ahlstrom.name/quisk/";
    maintainers = with maintainers; [ pulsation ];
    platforms = platforms.linux;
  };
}
