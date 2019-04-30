{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  pname = "dragonfly-reverb";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    rev = version;
    sha256 = "060g4ddh1z222n39wqj8jxj0zgmpjrgraw76qgyg6xkn15cn9q9y";
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
    cp -a DragonflyReverb        $out/bin/
    cp -a DragonflyReverb-vst.so $out/lib/vst/
    cp -a DragonflyReverb.lv2/   $out/lib/lv2/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/michaelwillis/dragonfly-reverb;
    description = "A hall-style reverb based on freeverb3 algorithms";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
