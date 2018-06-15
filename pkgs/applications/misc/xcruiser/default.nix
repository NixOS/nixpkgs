{ stdenv, fetchurl, gccmakedep, xorg }:

stdenv.mkDerivation {
  name = "xcruiser-0.30";

  src = fetchurl {
      url = mirror://sourceforge/xcruiser/xcruiser/xcruiser-0.30/xcruiser-0.30.tar.gz;
      sha256 = "1r8whva38xizqdh7jmn6wcmfmsndc67pkw22wzfzr6rq0vf6hywi";
    };

  buildInputs = with xorg; [ gccmakedep imake libXt libXaw libXpm libXext ];

  configurePhase = "xmkmf -a";

  preBuild = ''
    makeFlagsArray=( BINDIR=$out/bin XAPPLOADDIR=$out/etc/X11/app-defaults)
  '';

  meta = with stdenv.lib; {
    description = "Filesystem visualization utility";
    longDescription = ''
      XCruiser, formerly known as XCruise, is a filesystem visualization utility.
      It constructs a virtually 3-D formed universe from a directory
      tree and allows you to "cruise" within a visualized filesystem.
    '';
    homepage = http://xcruiser.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux;
  };
}
