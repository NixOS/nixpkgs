{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
}:

buildNpmPackage rec {
  pname = "balanceofsatoshis";
  version = "19.4.14";

  src = fetchFromGitHub {
    owner = "alexbosworth";
    repo = "balanceofsatoshis";
    tag = "v${version}";
    hash = "sha256-lXwE7/7ZWO6GD4SY0BPh/QXNpxkCYJS00Gjna0DkOE0=";
  };

  npmDepsHash = "sha256-WKpbYzNd0srD8yVB7Xa4v4qF9qHBiHHtKrYitnqEPTM=";

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
