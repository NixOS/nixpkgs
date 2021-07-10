{ stdenv, lib, fetchhg }:

stdenv.mkDerivation {
  name = "isabelle-sha1";

  src = fetchhg {
    url = "https://isabelle.sketis.net/repos/sha1";
    rev = "f7eebd505545";
    sha256 = "1f1i3f5p37x09a4ar83ii5xbiir4f41rfasp6inrrydba20g68wh";
  };

  buildPhase = (if stdenv.isDarwin then ''
    LDFLAGS="-dynamic -undefined dynamic_lookup -lSystem"
  '' else ''
    LDFLAGS="-fPIC -shared"
  '') + ''
    CFLAGS="-fPIC -I."
    $CC $CFLAGS -c sha1.c -o sha1.o
    $LD $LDFLAGS sha1.o -o libsha1.so
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libsha1.so $out/lib/libsha1.so
  '';

  meta = with lib; {
    description = "Internal SHA1 library written for and used by Isabelle";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.NieDzejkob ];
  };
}
