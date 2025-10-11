{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  taglib,
  zlib,

  # Disable on-the-fly transcoding,
  # removing the dependency on ffmpeg.
  # The server will (as of 0.11.0) gracefully fall back
  # to the original file, but if transcoding is configured
  # that takes a while. So best to disable all transcoding
  # in the configuration if you disable transcodingSupport.
  transcodingSupport ? true,
  ffmpeg,
  mpv,
}:

buildGoModule rec {
  pname = "gonic";
  version = "0.19.0";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "gonic";
    rev = "v${version}";
    sha256 = "sha256-la3xBECo4zZfkp5BlXuUzFEUGtxMl8ZAQdwgjFXIuSM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    taglib
    zlib
  ];
  vendorHash = "sha256-HrYS7c0MtiOYRyiSg7eLbiSIUkHeRikJ0Rwf4EoZIsQ=";

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
    + ''
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
}
