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
  version = "24.2.6";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-HfhyZ+YxYI4QQ3t1s8c794TxKXhiZtCbEPWOwtK95IU=";
  };

  npmDepsHash = "sha256-YJa5Al8BM3b2lJsl/+Fzzx++D3Yb1yEWcPPqU+DiYSs=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin cctools;

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
  };
}
