{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "autocorrect";
  version = "2.13.3";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fwq+Q2GpPXWfIQjfSACBjdyjrmYwVKSSZxCy3+NIKNI=";
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
