{
  lib,
  fetchFromGitHub,
  fetchzip,
  rustPlatform,
  flac,
  lame,
  makeBinaryWrapper,
  sox,
  writableTmpDirAsHomeHook,
}:
let
  runtimeDeps = [
    flac
    lame
    sox
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caesura";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ArlTXjNYjawlNwUVOjcmM/5+s7Sqj4rkWzdsoyiRRRQ=";
  };

  cargoHash = "sha256-fuEVdQpKsy6vEALKQ50WTkTC7mEB4L6lq2dEp5BQBOs=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  nativeCheckInputs = runtimeDeps;

  env = {
    CAESURA_NIX = "1";
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
