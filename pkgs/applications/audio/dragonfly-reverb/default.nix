{ lib, stdenv, fetchFromGitHub, libjack2, libGL, pkg-config, xorg }:

stdenv.mkDerivation rec {
  pname = "dragonfly-reverb";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    rev = version;
    sha256 = "sha256-hTapy/wXt1rRZVdkx2RDW8LS/DcY30p+WaAWgemGqVo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2 xorg.libX11 libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib/lv2/
    mkdir -p $out/lib/vst/
    cd bin
    for bin in DragonflyEarlyReflections DragonflyPlateReverb DragonflyHallReverb DragonflyRoomReverb; do
      cp -a $bin        $out/bin/
      cp -a $bin-vst.so $out/lib/vst/
      cp -a $bin.lv2/   $out/lib/lv2/ ;
    done
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/michaelwillis/dragonfly-reverb";
    description = "A hall-style reverb based on freeverb3 algorithms";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3Plus;
    platforms = ["x86_64-linux"];
  };
}
