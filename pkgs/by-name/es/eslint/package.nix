{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eslint";
  version = "9.9.1";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    rev = "refs/tags/v${version}";
    hash = "sha256-n07a50bigglwr3ItZqbyQxu0mPZawTSVunwIe8goJBQ=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-/E1JUsbPyHzWJ4kuNRg/blYRaAdATYbk+jnJFJyzHLE=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
