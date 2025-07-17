{
  lib,
  fetchFromGitHub,
  fetchzip,
  rustPlatform,
  eyed3,
  flac,
  imagemagick,
  intermodal,
  lame,
  makeBinaryWrapper,
  sox,
  writableTmpDirAsHomeHook,
}:
let
  runtimeDeps = [
    eyed3
    flac
    intermodal
    imagemagick
    lame
    sox
  ];

  testSampleContent = fetchzip {
    url = "https://archive.org/download/tennyson-discography_/Tennyson%20-%20With%20You%20-%20Lay-by.zip";
    hash = "sha256-/MgnOgn+OSPPg9wkJ32hq+1MXDdW+Qo9MqLtZMLQYBY=";
    stripRoot = false;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caesura";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rpaOFmD/0/c5F6TIS7vGn7G3+rLOoBZKMW/HuzroUxM=";
  };

  cargoHash = "sha256-agdhYEhhw3gMdZmYiQZVeLARkMsYQ/AWLTrpiaH0mtA=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  checkFlags = [
    # Those test need internet access for its `Source` (i.e: tracker)
    "--skip=commands::spectrogram::tests::spectrogram_command_tests::spectrogram_command"
    "--skip=commands::transcode::tests::transcode_command_tests::transcode_command"
    "--skip=utils::source::tests::source_provider_tests::source_provider"
  ];

  preCheck = ''
    # From samples/download-sample
    mkdir samples/content/
    ln -s ${finalAttrs.passthru.testSampleContent} "samples/content/Tennyson - With You (2014) [Digital] "'{'"16-44.1 Bandcamp"'}'" (FLAC)"
    # Adapted from .github/workflows/on-push.yml
    tee config.yml <<EOF
    announce_url: https://flacsfor.me/YOUR_ANNOUNCE_KEY/announce
    api_key: YOUR_API_KEY
    content:
    - samples/content
    source: $(mktemp -d)
    verbosity: trace
    EOF
  '';

  postInstall = ''
    wrapProgram $out/bin/caesura \
      --prefix PATH : ${lib.makeBinPath finalAttrs.passthru.runtimeDeps}
  '';

  passthru = {
    inherit runtimeDeps testSampleContent;
  };

  meta = {
    description = "versatile command line tool for automated verifying and transcoding of all your torrents";
    homepage = "https://github.com/RogueOneEcho/caesura";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "caesura";
  };
})
