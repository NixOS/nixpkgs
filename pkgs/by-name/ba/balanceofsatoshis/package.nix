{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
}:

buildNpmPackage rec {
  pname = "balanceofsatoshis";
  version = "20.0.4";

  src = fetchFromGitHub {
    owner = "alexbosworth";
    repo = "balanceofsatoshis";
    tag = "v${version}";
    hash = "sha256-2nM+B/e/FSP2rTC2Yktw4mkw7McqL32xTnEYPh/gPAA=";
  };

  npmDepsHash = "sha256-B77A+HPSDo5Y60TJk7N/8taGdWAZjf72Lvv7t3ziMbI=";

  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  meta = {
    changelog = "https://github.com/alexbosworth/balanceofsatoshis/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for working with the balance of your satoshis on LND";
    homepage = "https://github.com/alexbosworth/balanceofsatoshis";
    license = lib.licenses.mit;
    mainProgram = "bos";
    maintainers = with lib.maintainers; [ mariaa144 ];
  };
}
