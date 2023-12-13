{ lib, stdenv, fetchgit, fetchpatch, lame, libvorbis, gettext }:

stdenv.mkDerivation rec {
  pname = "ebook2cw";
  version = "0.8.4";

  src = fetchgit {
    url = "https://git.fkurz.net/dj1yfk/ebook2cw.git";
    rev = "${pname}-${version}";
    sha256 = "0h7lg59m3dcydzkc8szipnwzag8fqwwvppa9fspn5xqd4blpcjd5";
  };

  patches = [
    # Fixes non-GCC compilers and a missing directory in the install phase.
    (fetchpatch {
      url = "https://git.fkurz.net/dj1yfk/ebook2cw/commit/eb5742e70b042cf98a04440395c34390b171c035.patch";
      sha256 = "1m5f819cj3fj1piss0a5ciib3jqrqdc14lp3i3dszw4bg9v1pgyd";
    })
  ];

  buildInputs = [ lame libvorbis gettext ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Convert ebooks to Morse MP3s/OGGs";
    homepage = "https://fkurz.net/ham/ebook2cw.html";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ earldouglas ];
  };
}
