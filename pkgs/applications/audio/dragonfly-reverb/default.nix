{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "dragonfly-reverb-${src.rev}";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    rev = "1.0.0";
    sha256 = "05m4hd8lg0a7iiia6cbiw5qmc4p8vbkxp2qh7ywaabawiwa9r24x";
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
