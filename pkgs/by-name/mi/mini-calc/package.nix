{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gnuplot,
  makeWrapper,
  testers,
  mini-calc,
}:
rustPlatform.buildRustPackage rec {
  pname = "mini-calc";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "vanilla-extracts";
    repo = "calc";
    rev = version;
    hash = "sha256-A5nD1SuV2p2o+WRTHr9tqhyqfeZMiGWi9QUXFSSM7C0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TFAt0JcPX8EKTSwyxF5efYJC5LbSPBr2f9L4DaQ1ebI=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/mini-calc \
      --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
  '';

  passthru.tests.version = testers.testVersion {
    package = mini-calc;
    # `mini-calc -v` does not output in the test env, fallback to pipe
    command = "echo -v | mini-calc";
    version = "v${version}";
  };

  meta = {
    description = "Fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/vanilla-extracts/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.charlotte-thomas.me/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
