{ stdenv, lib, fetchurl, cmake, qt4, file, gcc }:

stdenv.mkDerivation rec {
  pname = "animbar";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0836nwcpyfdrapyj3hbg3wh149ihc26pc78h01adpc7c0r7d9pr9";
  };

  nativeBuildInputs = [ cmake  ];

  buildInputs = [ qt4 file ];

  installPhase = ''
    mkdir -p $out/bin $out/share/pixmaps
    cp src/animbar $out/bin
    cp ../icon/* $out/share/pixmaps
  '';

  meta = with lib; {
    description = "Create your own animation on paper and transparancy";
    longDescription = ''
	Animbar lets you easily create your own animation on paper and
	transparancy. From a set of input images two output images are
	computed, that are printed one on paper and one on
	transparency. By moving the transparency over the paper you
	create a fascinating animation effect. This kind of animation
	technique is hundreds of years old and known under several
	names: picket fence animation, barrier grid animation, Moiré
	animation, to name a few.
    '';
    homepage = http://animbar.mnim.org;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
