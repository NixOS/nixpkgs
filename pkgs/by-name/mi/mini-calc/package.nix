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
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "coco33920";
    repo = "calc";
    rev = version;
    hash = "sha256-qLPIo+Ht34YApWwl16Xscq2+vlAdlbCK5AeKy5q9cO0=";
  };

  cargoHash = "sha256-oWN9JLPswNKRKDG3dh3z7aleAaqQ7AlMP+Zp2BpBueE=";

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
    description = "A fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/coco33920/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.nwa2coco.fr";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
