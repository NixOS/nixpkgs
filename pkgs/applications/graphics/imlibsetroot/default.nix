{ stdenv, fetchurl, libX11, libXinerama, imlib2 }:

stdenv.mkDerivation {
  pname = "imlibsetroot";
  version = "1.2";
  src = fetchurl {
    url = "https://robotmonkeys.net/wp-content/uploads/2010/03/imlibsetroot-12.tar.gz";
    sha256 = "8c1b3b7c861e4d865883ec13a96b8e4ab22464a87d4e6c67255b17a88e3cfd1c";
  };

  buildInputs = [ libX11 imlib2 libXinerama ];
  buildPhase = ''
    gcc -g imlibsetroot.c -o imlibsetroot             \
      `imlib2-config --cflags` `imlib2-config --libs` \
      -I/include/X11/extensions -lXinerama -lX11
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -m 755 imlibsetroot $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A Xinerama Aware Background Changer";
    homepage = http://robotmonkeys.net/2010/03/30/imlibsetroot/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dwarfmaster ];
  };
}
