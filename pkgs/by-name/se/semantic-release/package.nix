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
  version = "25.0.6";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-5k8asT62OasHrcNb2hZYQYEpR3eGe2gVa5AkDbK35Og=";
  };

  npmDepsHash = "sha256-31Bb5OyxX4i3x2m+2t8p927GXsaHM7TQQRi8X1TSdB8=";

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
