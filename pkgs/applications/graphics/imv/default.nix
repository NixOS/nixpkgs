{ stdenv, fetchFromGitHub, SDL2, SDL2_ttf
, freeimage, fontconfig, pkgconfig
, asciidoc, docbook_xsl, libxslt, cmocka
}:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "eXeC64";
    repo   = "imv";
    rev    = "v${version}";
    sha256 = "0j5aykdkm1g518ism5y5flhwxvjvl92ksq989fhl2wpnv0la82jp";
  };

  buildInputs = [
    SDL2 SDL2_ttf freeimage fontconfig pkgconfig
    asciidoc docbook_xsl libxslt cmocka
  ];

  installFlags = [ "PREFIX=$(out)" "CONFIGPREFIX=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv; 
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = [ "x86_64-linux" ];
  };
}

