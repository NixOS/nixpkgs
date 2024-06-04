{lib, stdenv, fetchurl, id3lib, groff, zlib}:

stdenv.mkDerivation rec {
  pname = "id3v2";
  version = "0.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/id3v2/${pname}-${version}.tar.gz";
    sha256 = "1gr22w8gar7zh5pyyvdy7cy26i47l57jp1l1nd60xfwx339zl1c1";
  };

  nativeBuildInputs = [ groff ];
  buildInputs = [ id3lib zlib ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "clean" "all" ];

  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';

  meta = with lib; {
    description = "A command line editor for id3v2 tags";
    homepage = "https://id3v2.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    mainProgram = "id3v2";
  };
}
