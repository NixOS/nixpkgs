{ lib, stdenv, fetchgit, lame, libvorbis, gettext }:

stdenv.mkDerivation rec {
  pname = "ebook2cw";
  version = "0.8.3";

  src = fetchgit {
    url = "https://git.fkurz.net/dj1yfk/ebook2cw.git";
    rev = "${pname}-${version}";
    sha256 = "0jqmnjblv3wzr0ppqzndzd8wg02nlkvzg1fqw14vyyp76sdjsh46";
  };

  buildInputs = [ lame libvorbis gettext ];

  patches = [ ./Makefile.patch ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Convert ebooks to Morse MP3s/OGGs";
    homepage = "http://fkurz.net/ham/ebook2cw.html";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ earldouglas ];
  };
}
