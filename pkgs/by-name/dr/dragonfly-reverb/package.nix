{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libGL,
  pkg-config,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "dragonfly-reverb";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    tag = version;
    hash = "sha256-YXJ4U5J8Za+DlXvp6QduvCHIVC2eRJ3+I/KPihCaIoY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    libx11
    libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib/lv2/
    mkdir -p $out/lib/vst/
    mkdir -p $out/lib/vst3/
    mkdir -p $out/lib/clap/
    cd bin
    for bin in DragonflyEarlyReflections DragonflyPlateReverb DragonflyHallReverb DragonflyRoomReverb; do
      cp -a $bin        $out/bin/
      cp -a $bin-vst.so $out/lib/vst/
      cp -a $bin.vst3   $out/lib/vst3/
      cp -a $bin.clap   $out/lib/clap/
      cp -a $bin.lv2/   $out/lib/lv2/ ;
    done
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/michaelwillis/dragonfly-reverb";
    description = "Hall-style reverb based on freeverb3 algorithms";
    maintainers = [ lib.maintainers.magnetophon ];
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
