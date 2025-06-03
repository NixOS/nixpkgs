{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "autocorrect";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "autocorrect";
    rev = "v${version}";
    sha256 = "sha256-Tqg0awxRtzqAVTTVrmN0RDTQvYJllejx8V94jTreZyI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [
    "-p"
    "autocorrect-cli"
  ];
  cargoTestFlags = [
    "-p"
    "autocorrect-cli"
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Linter and formatter for help you improve copywriting, to correct spaces, punctuations between CJK (Chinese, Japanese, Korean)";
    mainProgram = "autocorrect";
    homepage = "https://huacnlee.github.io/autocorrect";
    changelog = "https://github.com/huacnlee/autocorrect/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
