{ mkDerivation, lib, fetchFromGitHub, pkg-config, sconsPackages, qtbase, lash, libjack2, jack ? libjack2, alsa-lib }:

mkDerivation rec {
  pname = "jackmix";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kampfschlaefer";
    repo = "jackmix";
    rev = version;
    sha256 = "0p59411vk38lccn24r7nih10jpgg9i46yc26zpc3x13amxwwpd4h";
  };

  patches = [ ./no_error.patch ];

  nativeBuildInputs = [ sconsPackages.scons_3_1_2 pkg-config ];
  buildInputs = [
    qtbase
    lash
    jack
    alsa-lib
  ];

  installPhase = ''
    install -D jackmix/jackmix $out/bin/jackmix
  '';

  meta = with lib; {
    description = "Matrix-Mixer for the Jack-Audio-connection-Kit";
    homepage = "https://github.com/kampfschlaefer/jackmix";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kampfschlaefer ];
    platforms = platforms.linux;
  };
}
