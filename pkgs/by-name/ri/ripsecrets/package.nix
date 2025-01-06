{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripsecrets";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${version}";
    hash = "sha256-MyFeSEZAG99g1Uh8KVA7CSZZVXUOF2qYJ0o1YviiPp4=";
  };

  cargoHash = "sha256-BKq1ttf8ctXvIbhKxHwCpjeiRKqSyN5+kP2k4CV511I=";

  meta = {
    description = "Command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "ripsecrets";
  };
}
