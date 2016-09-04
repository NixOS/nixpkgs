{stdenv, fetchurl, id3lib, groff, zlib}:

stdenv.mkDerivation rec {
  name = "id3v2-${version}";
  version = "0.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/id3v2/${name}.tar.gz";
    sha256 = "1gr22w8gar7zh5pyyvdy7cy26i47l57jp1l1nd60xfwx339zl1c1";
  };

  nativeBuildInputs = [ groff ];
  buildInputs = [ id3lib zlib ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "clean" "all" ];

  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';

  meta = with stdenv.lib; {
    description = "A command line editor for id3v2 tags";
    homepage = http://id3v2.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; unix;
  };
}
