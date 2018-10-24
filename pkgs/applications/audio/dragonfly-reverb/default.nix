{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "dragonfly-reverb-${src.rev}";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    rev = "0.9.4";
    sha256 = "0lc45jybjwg4wrcz4s9lvzpvqawgj825rkqhz2xxvalfbvjazi53";
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
    mkdir -p $out/lib/lv2/
    cp -a bin/DragonflyReverb.lv2/ $out/lib/lv2/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/michaelwillis/dragonfly-reverb;
    description = "A hall-style reverb based on freeverb3 algorithms";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl2;
    platforms = ["x86_64-linux"];
  };
}
