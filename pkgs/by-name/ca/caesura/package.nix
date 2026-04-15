{
  lib,
  fetchFromGitHub,
  rustPlatform,
  flac,
  lame,
  makeBinaryWrapper,
  sox,
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
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ifaZ+rmMmWhn8HM25sRPXJKuXvWE5VG+5hFMi9hqxA0=";
  };

  cargoHash = "sha256-g8Duhl5nZ6umIrAafW7s4vtDS+f06CWnFLoLSw0wa4o=";

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
