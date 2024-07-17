{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  alsa-lib,
  curl,
  freetype,
  gtk3,
  libGL,
  libX11,
  libXext,
  libXinerama,
  webkitgtk,
}:

stdenv.mkDerivation {
  pname = "tunefish";
  version = "unstable-2020-08-13";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "tunefish";
    rev = "b3d83cc66201619f6399500f6897fbeb1786d9ed";
    fetchSubmodules = true;
    sha256 = "0rjpq3s609fblzkvnc9729glcnfinmxljh0z8ldpzr245h367zxh";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = [
    alsa-lib
    curl
    freetype
    gtk3
    libGL
    libX11
    libXext
    libXinerama
    webkitgtk
  ];

  postPatch = ''
    patchShebangs src/tunefish4/generate-lv2-ttl.py
  '';

  makeFlags = [
    "-C"
    "src/tunefish4/Builds/LinuxMakefile"
    "CONFIG=Release"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r src/tunefish4/Builds/LinuxMakefile/build/Tunefish4.lv2 $out/lib/lv2
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://tunefish-synth.com/";
    description = "Virtual analog synthesizer LV2 plugin";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
