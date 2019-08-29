{ stdenv, fetchFromGitHub, SDL2, SDL2_ttf
, freeimage, fontconfig, pkgconfig
, asciidoc, docbook_xsl, libxslt, cmocka
, librsvg
}:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner  = "eXeC64";
    repo   = "imv";
    rev    = "v${version}";
    sha256 = "0gg362x2f7hli6cr6s7dmlanh4cqk7fd2pmk4zs9438jvqklf4cl";
  };

  buildInputs = [
    SDL2 SDL2_ttf freeimage fontconfig pkgconfig
    asciidoc docbook_xsl libxslt cmocka librsvg
  ];

  installFlags = [ "PREFIX=$(out)" "CONFIGPREFIX=$(out)/etc" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj markus1189 ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
