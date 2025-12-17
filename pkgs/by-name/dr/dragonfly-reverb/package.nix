{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libGL,
  pkg-config,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dragonfly-reverb";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    tag = finalAttrs.version;
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

    mkdir -p $out/lib/lv2

    pushd bin
      for bin in DragonflyEarlyReflections DragonflyPlateReverb DragonflyHallReverb DragonflyRoomReverb; do
        install -Dm755 $bin -t $out/bin
        install -Dm755 $bin-vst.so -t $out/lib/vst

        cp -r $bin.lv2 $out/lib/lv2
      done
    popd

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/michaelwillis/dragonfly-reverb";
    description = "Hall-style reverb based on freeverb3 algorithms";
    maintainers = [ lib.maintainers.magnetophon ];
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
})
