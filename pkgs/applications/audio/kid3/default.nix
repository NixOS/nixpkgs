<<<<<<< HEAD
{
  chromaprint
, cmake
, docbook_xml_dtd_45
, docbook_xsl
, fetchurl
, ffmpeg
, flac
, id3lib
, lib
=======
{ lib
, stdenv
, fetchurl
, chromaprint
, cmake
, docbook_xml_dtd_45
, docbook_xsl
, ffmpeg
, flac
, id3lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libogg
, libvorbis
, libxslt
, mp4v2
, phonon
, pkg-config
, python3
, qtbase
, qtmultimedia
, qtquickcontrols
, qttools
, readline
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, taglib
, wrapQtAppsHook
, zlib
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "kid3";
  version = "3.9.4";

  src = fetchurl {
    url = "https://download.kde.org/stable/kid3/${finalAttrs.version}/kid3-${finalAttrs.version}.tar.xz";
    hash = "sha256-xBCWDpYiXeChxIiMPqHG3CyiRau2kUdDJtzcPtvWpSA=";
=======
stdenv.mkDerivation rec {
  pname = "kid3";
  version = "3.9.3";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-D2hrdej2Q69AYjDn2Ey4vBSOmzBY3UzZMUdJSRjurdA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    docbook_xsl
    pkg-config
    python3
    wrapQtAppsHook
  ];
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    chromaprint
    ffmpeg
    flac
    id3lib
    libogg
    libvorbis
    libxslt
    mp4v2
    phonon
    qtbase
    qtmultimedia
    qtquickcontrols
    qttools
    readline
    taglib
    zlib
  ];

  cmakeFlags = [ "-DWITH_APPS=Qt;CLI" ];
  NIX_LDFLAGS = "-lm -lpthread";

  preConfigure = ''
    export DOCBOOKDIR="${docbook_xsl}/xml/xsl/docbook/"
  '';

<<<<<<< HEAD
  meta = {
    description = "A simple and powerful audio tag editor";
    homepage = "https://kid3.kde.org/";
    license = lib.licenses.lgpl2Plus;
=======
  meta = with lib; {
    homepage = "https://kid3.kde.org/";
    description = "A simple and powerful audio tag editor";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      If you want to easily tag multiple MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC,
      MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV and AIFF files (e.g. full
      albums) without typing the same information again and again and have
      control over both ID3v1 and ID3v2 tags, then Kid3 is the program you are
      looking for.

      With Kid3 you can:
      - Edit ID3v1.1 tags;
      - Edit all ID3v2.3 and ID3v2.4 frames;
      - Convert between ID3v1.1, ID3v2.3 and ID3v2.4 tags
      - Edit tags in MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC, MP2, Opus, Speex,
        TrueAudio, WavPack, WMA, WAV, AIFF files and tracker modules (MOD, S3M,
        IT, XM);
      - Edit tags of multiple files, e.g. the artist, album, year and genre of
        all files of an album typically have the same values and can be set
        together;
      - Generate tags from filenames;
      - Generate tags from the contents of tag fields;
      - Generate filenames from tags;
      - Rename and create directories from tags;
      - Generate playlist files;
      - Automatically convert upper and lower case and replace strings;
      - Import from gnudb.org, TrackType.org, MusicBrainz, Discogs, Amazon and
        other sources of album data;
      - Export tags as CSV, HTML, playlists, Kover XML and in other formats;
      - Edit synchronized lyrics and event timing codes, import and export
        LRC files.
    '';
<<<<<<< HEAD
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
=======
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
