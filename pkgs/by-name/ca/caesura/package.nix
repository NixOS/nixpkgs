{
  lib,
  fetchFromGitHub,
  rustPlatform,
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
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7PRYjKwnLiHLQ0+egzwf3YAmyu6+/2ysHfMmyv/VUZY=";
  };

  cargoHash = "sha256-0+vZma8AC44XqVHzmJT/roV7sy8w6DYhujRK9N91J5c=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ runtimeDeps;

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

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/caesura version --offline
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
