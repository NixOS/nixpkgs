{ stdenv, fetchurl, pkgconfig, libmp3splt }:

stdenv.mkDerivation rec {
  pname = "mp3splt";
  version = "2.6.2";
  name = "${pname}-${version}";


  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1aiv20gypb6r84qabz8gblk8vi42cg3x333vk2pi3fyqvl82phry";
  };

  configureFlags = [ "--enable-oggsplt-symlink" "--enable-flacsplt-symlink" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmp3splt ];

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "Utility to split mp3, ogg vorbis and FLAC files without decoding";
    homepage = http://sourceforge.net/projects/mp3splt/;
    license = licenses.gpl2;
    maintainers = [ maintainers.bosu ];
    platforms = platforms.unix;
  };
}
