{ lib, stdenv, fetchFromGitHub, cmake, libpulseaudio, libX11 }:

stdenv.mkDerivation rec {
  pname = "multimon-ng";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "EliasOenal";
    repo = "multimon-ng";
    rev = version;
    sha256 = "sha256-Qk9zg3aSrEfC16wQqL/EMG6MPobX8dnJ1OLH8EMap0I=";
  };

  buildInputs = lib.optionals stdenv.isLinux [ libpulseaudio libX11 ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Multimon is a digital baseband audio protocol decoder";
    longDescription = ''
      multimon-ng a fork of multimon, a digital baseband audio
      protocol decoder for common signaling modes in commercial and
      amateur radio data services. It decodes the following digital
      transmission modes:

      POCSAG512 POCSAG1200 POCSAG2400 EAS UFSK1200 CLIPFSK AFSK1200
      AFSK2400 AFSK2400_2 AFSK2400_3 HAPN4800 FSK9600 DTMF ZVEI1 ZVEI2
      ZVEI3 DZVEI PZVEI EEA EIA CCIR MORSE CW
    '';
    homepage = "https://github.com/EliasOenal/multimon-ng";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
