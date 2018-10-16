{ stdenv, fetchFromGitHub, qmake, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0-rc2";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "v${version}";
    sha256 = "119cc8p82cf78rha711zxm4pzmazwgiv81w2qbwwwxd2mkhjwflx";
  };

  buildInputs = [ qmake flex bison ];

  preBuild = ''
    sed -i '/DESTDIR/d' tikzit.pro
    echo "DESTDIR = build" >> tikzit.pro
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r $srcdir/build/source/build/* $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    homepage = http://tikzit.github.io/;
    license = licenses.gpl3;
    maintainers = [ maintainers.mgttlinger ];
    platforms   = [ "x86_64-linux" ];
  };
}
