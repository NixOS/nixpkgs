{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gnuplot,
  makeWrapper,
  testers,
  mini-calc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mini-calc";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "vanilla-extracts";
    repo = "calc";
    tag = finalAttrs.version;
    hash = "sha256-NR5SJpJW7L6VGu6tCyzt0hhQ5Wnvx3TKlq3MAK4EcLM=";
  };

  cargoHash = "sha256-LejKPnp4GvGykMTFZM9WVQIa0EMueeit5XfSuE1uiPQ=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/mini-calc \
      --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
  '';

  passthru.tests.version = testers.testVersion {
    package = mini-calc;
    # `mini-calc -v` does not output in the test env, fallback to pipe
    command = "echo -v | mini-calc";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/vanilla-extracts/calc/blob/${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://calc.charlotte-thomas.me/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
})
