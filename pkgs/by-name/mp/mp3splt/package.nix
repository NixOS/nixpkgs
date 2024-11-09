{ lib, stdenv, fetchurl, pkg-config, libmp3splt }:

stdenv.mkDerivation rec {
  pname = "mp3splt";
  version = "2.6.2";


  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1aiv20gypb6r84qabz8gblk8vi42cg3x333vk2pi3fyqvl82phry";
  };

  configureFlags = [ "--enable-oggsplt-symlink" "--enable-flacsplt-symlink" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmp3splt ];

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Utility to split mp3, ogg vorbis and FLAC files without decoding";
    homepage = "https://sourceforge.net/projects/mp3splt/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bosu ];
    platforms = platforms.unix;
  };
}
