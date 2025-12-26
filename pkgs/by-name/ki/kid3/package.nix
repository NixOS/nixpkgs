{
  lib,
  chromaprint,
  cmake,
  docbook_xml_dtd_45,
  docbook_xsl,
  fetchurl,
  ffmpeg,
  flac,
  id3lib,
  kdePackages,
  libogg,
  libvorbis,
  libxslt,
  mp4v2,
  pkg-config,
  python3,
  qt6,
  readline,
  stdenv,
  taglib,
  zlib,
  # Boolean flags
  withCLI ? true,
  withKDE ? true,
  withQt ? false,
}:

let
  inherit (qt6)
    qtbase
    qtdeclarative
    qtmultimedia
    qttools
    wrapQtAppsHook
    ;

  apps = lib.concatStringsSep ";" (
    lib.optionals withCLI [ "CLI" ] ++ lib.optionals withKDE [ "KDE" ] ++ lib.optionals withQt [ "Qt" ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "kid3";
  version = "3.9.7";

  src = fetchurl {
    url = "mirror://kde/stable/kid3/${finalAttrs.version}/kid3-${finalAttrs.version}.tar.xz";
    hash = "sha256-+c/u99Td3nitiXiHbLNSWEOjAlBPVHwiXpwiyB1xB2A=";
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
  ]
  ++ lib.optionals withKDE (
    with kdePackages;
    [
      kconfig
      kconfigwidgets
      kcoreaddons
      kio
      kxmlgui
      phonon
    ]
  );

  cmakeFlags = [
    (lib.cmakeFeature "WITH_APPS" apps)
    (lib.cmakeBool "WITH_MP4V2" true)
  ];

  env = {
    DOCBOOKDIR = "${docbook_xsl}/xml/xsl/docbook/";
    LANG = "C.UTF-8";
    NIX_LDFLAGS = "-lm -lpthread";
  };

  meta = {
    homepage = "https://kid3.kde.org/";
    description = "Simple and powerful audio tag editor";
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
    license = lib.licenses.lgpl2Plus;
    mainProgram =
      if withQt then
        "kid3-qt"
      else if withKDE then
        "kid3"
      else
        "kid3-cli";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
