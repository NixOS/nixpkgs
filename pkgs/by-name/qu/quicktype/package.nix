{ lib, buildNpmPackage, fetchFromGitHub, jq, quicktype, testers }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.104"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "glideapps";
    repo = "quicktype";
    rev = "916cd94a9d4fdeab870b6a12f42ad43ebaedf314"; # version not tagged
    hash = "sha256-PI9YgFVy7Mlln9+7IAU9vzyvK606PuAJ32st3NDwXIw=";
  };

  postPatch = ''
    cat <<< $(${jq}/bin/jq '.version = "${version}"' package.json) > package.json
  '';

  npmDepsHash = "sha256-RA4HVQfB/ge1aIKl9HiUT7vUM5n+Ro6N2D6xj1dgSu8=";

  postInstall = ''
    mv packages/ $out/lib/node_modules/quicktype/
  '';

  passthru.tests = {
    version = testers.testVersion { package = quicktype; };
  };

  meta = with lib; {
    description = "Generate types and converters from JSON, Schema, and GraphQL";
    homepage = "https://quicktype.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "quicktype";
  };
}
