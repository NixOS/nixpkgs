{ chromaprint
, cmake
, docbook_xml_dtd_45
, docbook_xsl
, fetchurl
, ffmpeg
, flac
, id3lib
, kdePackages
, lib
, libogg
, libvorbis
, libxslt
, mp4v2
, pkg-config
, python3
, qtbase
, qtdeclarative
, qtmultimedia
, qttools
, readline
, stdenv
, taglib
, wrapQtAppsHook
, zlib
, withCLI ? true
, withKDE ? true
, withQt ? false
}:

let
  inherit (lib) optionals;

  apps = lib.concatStringsSep ";" (
    optionals withCLI [ "CLI" ]
    ++ optionals withKDE [ "KDE" ]
    ++ optionals withQt [ "Qt" ]
  );

  mainProgram =
    if withQt then "kid3-qt"
    else if withKDE then "kid3"
    else "kid3-cli";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "kid3";
  version = "3.9.5";

  src = fetchurl {
    url = "mirror://kde/stable/kid3/${finalAttrs.version}/kid3-${finalAttrs.version}.tar.xz";
    hash = "sha256-pCT+3eNcF247RDNEIqrUOEhBh3LaAgdR0A0IdOXOgUU=";
  };

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    docbook_xsl
    pkg-config
    python3
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    chromaprint
    ffmpeg
    flac
    id3lib
    libogg
    libvorbis
    libxslt
    mp4v2
    qtbase
    qtdeclarative
    qtmultimedia
    readline
    taglib
    zlib
  ] ++ lib.optionals withKDE (with kdePackages; [
    kconfig
    kconfigwidgets
    kcoreaddons
    kio
    kxmlgui
    phonon
  ]);

  cmakeFlags = [ (lib.cmakeFeature "WITH_APPS" apps) ];

  env = {
    DOCBOOKDIR = "${docbook_xsl}/xml/xsl/docbook/";
    LANG = "C.UTF-8";
    NIX_LDFLAGS = "-lm -lpthread";
  };

  meta = {
    description = "A simple and powerful audio tag editor";
    inherit mainProgram;
    homepage = "https://kid3.kde.org/";
    license = lib.licenses.lgpl2Plus;
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
