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
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "vanilla-extracts";
    repo = "calc";
    tag = finalAttrs.version;
    hash = "sha256-GvWWFTJfgPn26BXVl4MV65pubpIg1y544oHvycTcrGo=";
  };

  cargoHash = "sha256-tPrACzeUaBK/981ReGWwwfuhBki8Bfebmp7xCLPzXDo=";

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
