{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rt-cli";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "unvalley";
    repo = "rt";
    rev = "v${version}";
    hash = "sha256-Y3QWpYrAkWymI+s24YJFtpIXy9QGAksU68OOlgp0DdA=";
  };

  cargoHash = "sha256-LN/5qSLpFZqiZrMPufPbCvjb9dRTewxROb03thPXVhk=";

  meta = {
    description = "Run tasks across different task runners";
    homepage = "https://github.com/unvalley/rt";
    changelog = "https://github.com/unvalley/rt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ unvalley ];
    mainProgram = "rt";
  };
}
