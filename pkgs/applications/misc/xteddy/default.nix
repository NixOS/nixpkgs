{ stdenv, fetchzip, pkg-config, xorg, imlib2, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xteddy-${version}";
  version = "2.2";
  src = fetchzip {
    url = "https://deb.debian.org/debian/pool/main/x/xteddy/xteddy_${version}.orig.tar.gz";
    sha256 = "0sap4fqvs0888ymf5ga10p3n7n5kr35j38kfsfd7nj0xm4hmcma3";
  };
  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ imlib2 xorg.libX11 xorg.libXext ];

  makeFlags = [ "LIBS=-lXext" ];

  postPatch = ''
    sed -i 's/man 1 xteddy/man 6 xteddy/' xteddy.c
    sed -i "s:/usr/games/xteddy:$out/bin/xteddy:" xtoys
    sed -i "s:/usr/share/xteddy:$out/share/xteddy:" xtoys
  '';

  postInstall = ''
    cp -R images $out/share/images
    # remove broken test script
    rm $out/bin/xteddy_test
  '';

  postFixup = ''
    # this is needed, because xteddy expects images to reside
    # in the current working directory
    wrapProgram $out/bin/xteddy --run "cd $out/share/images/"
  '';

  meta = with stdenv.lib; {
    description = "Cuddly teddy bear for your X desktop";
    homepage = https://weber.itn.liu.se/~stegu/xteddy/;
    license = licenses.gpl2;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
