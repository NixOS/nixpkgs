{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpulseaudio,
  libX11,
  makeWrapper,
  sox,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "multimon-ng";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "EliasOenal";
    repo = "multimon-ng";
    rev = version;
    sha256 = "sha256-/2NHUlAojDamNq/EVs8hoBYVikPLAFFFu/2syG4Xo4U=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/EliasOenal/multimon-ng/commit/1c111e83053e9e78ba568463cc015edadf77ed5f.diff";
      hash = "sha256-gW9ihUn3rZcyurbu7+IhkWSotqWlJsHdeFHu12oVld4=";
    })
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    libX11
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/multimon-ng --prefix PATH : "${lib.makeBinPath [ sox ]}"
  '';

  meta = with lib; {
    description = "Digital baseband audio protocol decoder";
    mainProgram = "multimon-ng";
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
