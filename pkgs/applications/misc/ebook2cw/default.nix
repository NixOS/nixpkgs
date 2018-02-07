{ stdenv, fetchsvn, lame, libvorbis }:

stdenv.mkDerivation rec {

  name = "ebook2cw-${version}";
  version = "0.8.2";

  src = fetchsvn {
    url = "svn://svn.fkurz.net/ebook2cw/tags/${name}";
    sha256 = "1mvp3nz3k76v757792n9b7fcm5jm3jcwarl1k7cila9fi0c2rsiw";
  };

  buildInputs = [ lame libvorbis ];

  patches = [ ./configfile.patch ];

  postPatch = ''
    substituteInPlace Makefile --replace gcc cc
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Convert ebooks to Morse MP3s/OGGs";
    homepage = http://fkurz.net/ham/ebook2cw.html;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ earldouglas ];
  };

}
