{ mkDerivation, lib, fetchFromGitHub, pkg-config, scons, qtbase, lash, libjack2, jack ? libjack2, alsa-lib
, fetchpatch
}:

mkDerivation rec {
  pname = "jackmix";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kampfschlaefer";
    repo = "jackmix";
    rev = version;
    sha256 = "0p59411vk38lccn24r7nih10jpgg9i46yc26zpc3x13amxwwpd4h";
  };

  patches = [
    ./no_error.patch
    (fetchpatch {
      name = "sconstruct-python3.patch";
      url = "https://github.com/kampfschlaefer/jackmix/commit/3a0c868b267728fdbc69cc3dc1941edac27d97f6.patch";
      hash = "sha256-MLgxIiZ0+C1IVEci9Q347DR+SJUlPG2N3iPvuhRptJU=";
    })
  ];

  nativeBuildInputs = [ scons pkg-config ];
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
    mainProgram = "jackmix";
    homepage = "https://github.com/kampfschlaefer/jackmix";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kampfschlaefer ];
    platforms = platforms.linux;
  };
}
