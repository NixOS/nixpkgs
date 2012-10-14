{stdenv, fetchurl, libmusicbrainz, flac, slang, neon, unac, libjpeg, asciidoc, libdiscid, pkgconfig}:

stdenv.mkDerivation rec {
  ver = "2.0.4";
  name = "flactag-${ver}";

  src = fetchurl {
    url = "mirror://sourceforge/flactag/v$ver}/${name}.tar.gz";
    sha256 = "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2";
  };

  buildInputs = [ libmusicbrainz flac slang neon unac libjpeg asciidoc libdiscid pkgconfig ];

  meta = {
    description = "A utility for maintaining single album FLAC file (with embedded CUE sheets) metadata from MusicBrainz. ";
    longDescription = ''
      A common mechanism for backing up audio cds is to extract them from the media
      into a single flac file, and embed the cue sheet into the flac file. This means
      that the cd can be exactly reproduced at a later date. 

      flactag uses the embedded CUE sheet to create a musicbrainz 'discid', and
      queries the musicbrainz server for track lists, and other album metadata. 
    '';
    homepage = http://flactag.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
