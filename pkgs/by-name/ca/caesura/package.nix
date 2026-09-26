{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  cacert,
  writableTmpDirAsHomeHook,
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
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+REt+MKImO7fnYWJ32P6mKzulGJTnxc+9ednVF5aCJU=";
  };

  patches = [
    (fetchpatch2 {
      name = "normalize-sox-dependent-full-spectrogram-widths.patch";
      url = "https://github.com/RogueOneEcho/caesura/commit/3af818ae35a3e18f444c889d9d3b88294f4f110f.patch?full_index=1";
      hash = "sha256-znAbk6hFVj198BUUwwDo76SWei0cKINeXzlYEFvTwHA=";
    })
  ];

  cargoHash = "sha256-0+vZma8AC44XqVHzmJT/roV7sy8w6DYhujRK9N91J5c=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  nativeCheckInputs = [
    cacert
    writableTmpDirAsHomeHook
  ]
  ++ runtimeDeps;

  env = {
    CAESURA_NIX = "1";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  postPatch = ''
    substituteInPlace Cargo.toml crates/*/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  preCheck = ''
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
