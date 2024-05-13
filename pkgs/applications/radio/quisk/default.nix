{ lib
, python3
, fetchPypi
, fftw
, alsa-lib
, pulseaudio
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quisk";
  version = "4.2.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-41eyqYxRg0crtN6qp239eHWSFPt7XuJneTAndZuS3EY=";
  };

  buildInputs = [
    fftw
    alsa-lib
    pulseaudio
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyusb
    wxpython
  ];

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
    maintainers = with maintainers; [ pulsation kashw2 ];
    platforms = platforms.linux;
  };
}
