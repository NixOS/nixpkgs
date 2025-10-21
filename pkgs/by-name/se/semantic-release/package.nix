{
  cctools,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
  stdenv,
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-B+j84GeRw9YFMx8kTXPqqs57ClgZtziAh/BXh47WfVc=";
  };

  npmDepsHash = "sha256-0eHK2FiRRzfvCrGag0/KDq/3nWZbwnM1FEhtKu4mrHE=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools;

  # Fixes `semantic-release --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  meta = {
    description = "Fully automated version management and package publishing";
    mainProgram = "semantic-release";
    homepage = "https://semantic-release.gitbook.io/semantic-release/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sestrella ];
    # https://hydra.nixos.org/job/nixpkgs/trunk/semantic-release.aarch64-linux
    badPlatforms = [ "aarch64-linux" ];
  };
}
