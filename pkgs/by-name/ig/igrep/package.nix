{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  igrep,
}:

rustPlatform.buildRustPackage rec {
  pname = "igrep";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    hash = "sha256-ZZhzBGLpzd9+rok+S/ypKpWXVzXaA1CnviC7LfgP/CU=";
  };

  cargoHash = "sha256-NZN9pB9McZkTlpGgAbxi8bwn+aRiPMymGmBLYBc6bmw=";

  passthru.tests = {
    version = testers.testVersion {
      package = igrep;
      command = "ig --version";
    };
  };

  meta = {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    changelog = "https://github.com/konradsz/igrep/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "ig";
  };
}
