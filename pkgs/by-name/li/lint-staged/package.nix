{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.0.8";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-xjbEVAZhcMns5daTE68PCX2mib0Lz4HZKwxR1a8/ucU=";
  };

  npmDepsHash = "sha256-y9wEbsPNYAzmvXlaOe7H7E/dRBCbnLhxUtUd+oP9iiQ=";

  dontNpmBuild = true;

  # Fixes `lint-staged --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  passthru.tests.version = testers.testVersion { package = lint-staged; };

  meta = {
    description = "Run linters on git staged files";
    longDescription = ''
      Run linters against staged git files and don't let 💩 slip into your code base!
    '';
    homepage = src.meta.homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
    mainProgram = "lint-staged";
  };
}
