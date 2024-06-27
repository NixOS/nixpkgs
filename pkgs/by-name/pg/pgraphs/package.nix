{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "pgraphs";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "pg-format";
    repo = "pgraphs";
    rev = "refs/tags/v${version}";
    hash = "sha256-NLQMBEN/wO/xOMy+gX3sQZRqU8gYesXS7hwRGWyjvX0=";
  };

  npmDepsHash = "sha256-Fj5huWKatJmdH2PUqNWWysE+qhiq7aR2ue723Pv5Y4M=";
  dontNpmBuild = true;

  meta = {
    description = "Property Graph Exchange Format (PG) converter";
    changelog = "https://github.com/pg-format/pgraphs/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/pg-format/pgraphs";
    license = lib.licenses.mit;
    mainProgram = "pgraphs";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
  };
}
