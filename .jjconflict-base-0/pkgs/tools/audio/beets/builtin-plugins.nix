{ aacgain
, ffmpeg
, flac
, imagemagick
, keyfinder-cli
, mp3gain
, mp3val
, python3Packages
, ...
}: {
  absubmit = {
    deprecated = true;
    testPaths = [ ];
  };

  acousticbrainz.propagatedBuildInputs = [ python3Packages.requests ];
  albumtypes = { };
  aura = {
    propagatedBuildInputs = with python3Packages; [ flask pillow ];
    testPaths = [ ];
  };
  badfiles = {
    testPaths = [ ];
    wrapperBins = [ mp3val flac ];
  };
  bareasc = { };
  beatport.propagatedBuildInputs = [ python3Packages.requests-oauthlib ];
  bench.testPaths = [ ];
  bpd.testPaths = [ ];
  bpm.testPaths = [ ];
  bpsync.testPaths = [ ];
  bucket = { };
  chroma = {
    propagatedBuildInputs = [ python3Packages.pyacoustid ];
    testPaths = [ ];
  };
  convert.wrapperBins = [ ffmpeg ];
  deezer = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  discogs.propagatedBuildInputs = with python3Packages; [ discogs-client requests ];
  duplicates.testPaths = [ ];
  edit = { };
  embedart = {
    propagatedBuildInputs = with python3Packages; [ pillow ];
    wrapperBins = [ imagemagick ];
  };
  embyupdate.propagatedBuildInputs = [ python3Packages.requests ];
  export = { };
  fetchart = {
    propagatedBuildInputs = with python3Packages; [ requests pillow ];
    wrapperBins = [ imagemagick ];
  };
  filefilter = { };
  fish.testPaths = [ ];
  freedesktop.testPaths = [ ];
  fromfilename.testPaths = [ ];
  ftintitle = { };
  fuzzy.testPaths = [ ];
  gmusic.testPaths = [ ];
  hook = { };
  ihate = { };
  importadded = { };
  importfeeds = { };
  info = { };
  inline.testPaths = [ ];
  ipfs = { };
  keyfinder.wrapperBins = [ keyfinder-cli ];
  kodiupdate = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  lastgenre.propagatedBuildInputs = [ python3Packages.pylast ];
  lastimport = {
    propagatedBuildInputs = [ python3Packages.pylast ];
    testPaths = [ ];
  };
  loadext = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  lyrics.propagatedBuildInputs = [ python3Packages.beautifulsoup4 ];
  mbcollection.testPaths = [ ];
  mbsubmit = { };
  mbsync = { };
  metasync.testPaths = [ ];
  missing.testPaths = [ ];
  mpdstats.propagatedBuildInputs = [ python3Packages.mpd2 ];
  mpdupdate = {
    propagatedBuildInputs = [ python3Packages.mpd2 ];
    testPaths = [ ];
  };
  parentwork = { };
  permissions = { };
  play = { };
  playlist.propagatedBuildInputs = [ python3Packages.requests ];
  plexupdate = { };
  random = { };
  replaygain.wrapperBins = [ aacgain ffmpeg mp3gain ];
  rewrite.testPaths= [ ];
  scrub.testPaths = [ ];
  smartplaylist = { };
  sonosupdate = {
    propagatedBuildInputs = [ python3Packages.soco ];
    testPaths = [ ];
  };
  spotify = { };
  subsonicplaylist = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  subsonicupdate.propagatedBuildInputs = [ python3Packages.requests ];
  the = { };
  thumbnails = {
    propagatedBuildInputs = with python3Packages; [ pillow pyxdg ];
    wrapperBins = [ imagemagick ];
  };
  types.testPaths = [ "test/plugins/test_types_plugin.py" ];
  unimported.testPaths = [ ];
  web.propagatedBuildInputs = [ python3Packages.flask ];
  zero = { };
  limit = { };
  substitute = {
    testPaths = [ ];
  };
  advancedrewrite = {
    testPaths = [ ];
  };
  autobpm = {
    propagatedBuildInputs = with python3Packages; [
      librosa
      # An optional dependency of librosa, needed for beets' autobpm
      resampy
    ];
    testPaths = [ ];
  };
  listenbrainz = {
    testPaths = [ ];
  };
}
