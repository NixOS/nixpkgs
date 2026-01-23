{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  scons,
  libjack2,
  jack ? libjack2,
  alsa-lib,
  libsForQt5,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jackmix";
  version = "0.6.1-unstable-2024-03-26";

  src = fetchFromGitHub {
    owner = "kampfschlaefer";
    repo = "jackmix";
    rev = "f0f29a7111f704f369f1ecd6c29a713ce21f767a";
    hash = "sha256-6dz7U6umkdBOLx1MQOEeY51OrEtKlFpVMBudBTe6ehM=";
  };

  patches = [
    ./no_error.patch
  ];

  nativeBuildInputs = [
    scons
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    jack
    alsa-lib
  ];

  installPhase = ''
    install -D jackmix/jackmix $out/bin/jackmix
  '';

  meta = {
    description = "Matrix-Mixer for the Jack-Audio-connection-Kit";
    mainProgram = "jackmix";
    homepage = "https://github.com/kampfschlaefer/jackmix";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
