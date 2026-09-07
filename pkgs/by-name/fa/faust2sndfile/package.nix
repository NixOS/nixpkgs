{
  faust,
  flac,
  lame,
  libmpg123,
  libogg,
  libopus,
  libsndfile,
  libvorbis,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2sndfile";

  propagatedBuildInputs = [
    flac
    lame
    libmpg123
    libogg
    libopus
    libsndfile
    libvorbis
  ];

}
