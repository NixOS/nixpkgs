{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  pname = "dragonfly-reverb";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    rev = version;
    sha256 = "188cm45hr0i33m4h2irql1wrsmsfis65s706wjiid0z59q47rf9p";
    fetchSubmodules = true;
  };

  patchPhase = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libjack2 xorg.libX11 libGL
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/lv2/
    mkdir -p $out/lib/vst/
    cd bin
    for bin in DragonflyEarlyReflections DragonflyPlateReverb DragonflyHallReverb DragonflyRoomReverb; do
      cp -a $bin        $out/bin/
      cp -a $bin-vst.so $out/lib/vst/
      cp -a $bin.lv2/   $out/lib/lv2/ ;
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/michaelwillis/dragonfly-reverb";
    description = "A hall-style reverb based on freeverb3 algorithms";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
