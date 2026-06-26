{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  flac,
  lame,
  makeBinaryWrapper,
  sox_ng,
}:
let
  runtimeDeps = [
    flac
    lame
    sox_ng
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caesura";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4vBRUYAO9JzZGN7L0s8T4JbXMMVUpMy21m9V18nti54=";
  };

  cargoHash = "sha256-TnxPINGHQyPHt6PNp780QMcfr1B1rb16lrb6PKAVif0=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  nativeCheckInputs = [ cacert ] ++ runtimeDeps;

  env = {
    CAESURA_NIX = "1";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  postPatch = ''
    substituteInPlace Cargo.toml crates/*/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'

    # Upstream documents that snapshot output depends on the SoX/FLAC build.
    # Extend their existing platform-dependent snapshot normalization to image
    # dimensions so the spectrogram tests can run with nixpkgs' sox_ng.
    substituteInPlace crates/core/src/utils/testing/snapshots/file_snapshot.rs \
      --replace-fail '        if let (Some(actual_audio), Some(stored_audio)) = (&mut actual.audio, &stored.audio) {' '        if let (Some(actual_image), Some(stored_image)) = (&mut actual.image, &stored.image) {
            actual_image.width = stored_image.width;
            actual_image.height = stored_image.height;
        }
        if let (Some(actual_audio), Some(stored_audio)) = (&mut actual.audio, &stored.audio) {'
  '';

  preCheck = ''
    export HOME=$TMPDIR
    cat > config.yml <<EOF
    verbosity: trace
    EOF
  '';

  postInstall = ''
    wrapProgram $out/bin/caesura \
      --prefix PATH : ${lib.makeBinPath finalAttrs.passthru.runtimeDeps}
  '';

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Versatile command line tool for automated verifying and transcoding of all your torrents";
    homepage = "https://github.com/RogueOneEcho/caesura";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "caesura";
  };
})
