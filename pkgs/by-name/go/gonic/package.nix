{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  # Disable on-the-fly transcoding,
  # removing the dependency on ffmpeg.
  # The server will (as of 0.11.0) gracefully fall back
  # to the original file, but if transcoding is configured
  # that takes a while. So best to disable all transcoding
  # in the configuration if you disable transcodingSupport.
  transcodingSupport ? true,
  ffmpeg,
  # Setting this to false does not disable the jukebox feature,
  # but avoids the dependency on mpv at least.
  jukeboxSupport ? true,
  mpv,
}:

buildGo127Module (finalAttrs: {
  pname = "gonic";
  version = "0.23.0";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "gonic";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yQu3NDBYuD/C0HtMF0ArSx+Im473mwRTREWlMOdLmf8=";
  };

  vendorHash = "sha256-W/9BD/s+OUteXPIFm3ZJ+Eh+W6VfS8stgx98MLLk2ys=";

  # TODO(Profpatsch): write a test for transcoding support,
  # since it is prone to break
  postPatch =
    lib.optionalString transcodingSupport ''
      substituteInPlace \
        transcode/transcode.go \
        --replace-fail \
          '`ffmpeg' \
          '`${lib.getBin ffmpeg}/bin/ffmpeg'
    ''
    + lib.optionalString jukeboxSupport ''
      substituteInPlace \
        jukebox/jukebox.go \
        --replace-fail \
          '"mpv"' \
          '"${lib.getBin mpv}/bin/mpv"'
    ''
    + ''
      substituteInPlace server/ctrlsubsonic/testdata/test* \
        --replace-quiet \
          '"audio/flac"' \
          '"audio/x-flac"'
    '';

  passthru = {
    tests.gonic = nixosTests.gonic;
  };

  # tests require it
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ autrimpo ];
    mainProgram = "gonic";
  };
})
