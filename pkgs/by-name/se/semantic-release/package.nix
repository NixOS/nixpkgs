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
  version = "24.2.9";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-6dR1wUkoUTRtyQliJFUYLC4eNW2ppIOqeUsL7rLCZiA=";
  };

  npmDepsHash = "sha256-Frhb7bsY0z160EAKOWB5VCsrBMcrjKPE5OYtgX1Cmhs=";

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
