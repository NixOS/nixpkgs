{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
}:

buildNpmPackage rec {
  pname = "haraka";
  version = "3.1.1-unstable-2025-10-27";

  src = fetchFromGitHub {
    owner = "haraka";
    repo = "Haraka";
    # `release` branch has lock files, tagged revisions don't
    rev = "d20509f060127a9428737583d8ed2ceffc8df928";
    hash = "sha256-6hkmnOulDZpHk63t0btH7eN9jomToEmMu0vINdbiPBI=";
  };

  npmDepsHash = "sha256-wpkFXWAGnEnZ/fkNUDD5e+/SaNzdSNPi6eNELKe/AKs=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ];

  meta = {
    changelog = "https://github.com/haraka/Haraka/blob/${src.rev}/Changes.md";
    description = "Fast, highly extensible, and event driven SMTP server";
    homepage = "https://haraka.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
  };
}
