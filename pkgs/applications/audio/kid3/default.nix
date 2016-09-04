{ stdenv, fetchurl
, pkgconfig, cmake, perl, ffmpeg
, docbook_xml_dtd_45, docbook_xsl, libxslt
, phonon, automoc4, chromaprint, id3lib
, taglib, mp4v2, flac, libogg, libvorbis
, qt, zlib, readline
, makeWrapper
}:

stdenv.mkDerivation rec {

  name = "kid3-${meta.version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/kid3/kid3/${meta.version}/${name}.tar.gz";
    sha256 = "12sa54mg1b3wkagmh5yi20ski8km9d199lk0a1yfxy0ffjfld7js";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig cmake perl ffmpeg docbook_xml_dtd_45 docbook_xsl libxslt
    phonon automoc4 chromaprint id3lib taglib mp4v2 flac libogg libvorbis
    qt zlib readline makeWrapper ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DWITH_APPS=Qt;CLI" ];
  NIX_LDFLAGS = "-lm -lpthread";

  preConfigure = ''
    export DOCBOOKDIR="${docbook_xsl}/xml/xsl/docbook/"
  '';

  postInstall = ''
    wrapProgram $out/bin/kid3-qt --prefix QT_PLUGIN_PATH : $out/lib/qt4/plugins
  '';

  meta = with stdenv.lib; {
    version = "3.3.0";
    description = "A simple and powerful audio tag editor";
    longDescription = ''
      If you want to easily tag multiple MP3, Ogg/Vorbis, FLAC, MPC,
      MP4/AAC, MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV and AIFF
      files (e.g. full albums) without typing the same information
      again and again and have control over both ID3v1 and ID3v2 tags,
      then Kid3 is the program you are looking for.

      With Kid3 you can:
      - Edit ID3v1.1 tags;
      - Edit all ID3v2.3 and ID3v2.4 frames;
      - Convert between ID3v1.1, ID3v2.3 and ID3v2.4 tags
      - Edit tags in MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC, MP2, Opus,
        Speex, TrueAudio, WavPack, WMA, WAV, AIFF files and tracker
        modules (MOD, S3M, IT, XM);
      -  Edit tags of multiple files, e.g. the artist, album, year and
         genre of all files of an album typically have the same values
         and can be set together;
      - Generate tags from filenames;
      - Generate tags from the contents of tag fields;
      - Generate filenames from tags;
      - Rename and create directories from tags;
      - Generate playlist files;
      - Automatically convert upper and lower case and replace strings;
      - Import from gnudb.org, TrackType.org, MusicBrainz, Discogs,
        Amazon and other sources of album data;
      - Export tags as CSV, HTML, playlists, Kover XML and in other
        formats;
      - Edit synchronized lyrics and event timing codes, import and
        export LRC files
    '';
    homepage = http://kid3.sourceforge.net/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: Qt5 support
