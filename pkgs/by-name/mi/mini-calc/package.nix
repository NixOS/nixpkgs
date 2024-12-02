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
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "vanilla-extracts";
    repo = "calc";
    rev = version;
    hash = "sha256-JAIqigELPu4ZCj1uDgGNSCIqVhJVH7tZwFiI/PSTjSI=";
  };

  cargoHash = "sha256-s35rR0nb5uX9J3rvEs15+FYBfhXycZwL90yeQf0esJA=";

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
    changelog = "https://github.com/coco33920/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.charlotte-thomas.me/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
