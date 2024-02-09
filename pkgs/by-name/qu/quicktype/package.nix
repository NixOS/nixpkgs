{ lib, buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.81"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "glideapps";
    repo = "quicktype";
    rev = "838c5e0e63a50d7c7790dc81118e664480fc4a80"; # version not tagged
    hash = "sha256-+VMkfkBSomxxlkuOeMqBCySe7VCx2K5bIdF/tmVgK/Y=";
  };

  postPatch = ''
    cat <<< $(${jq}/bin/jq '.version = "${version}"' package.json) > package.json
  '';

  npmDepsHash = "sha256-RA4HVQfB/ge1aIKl9HiUT7vUM5n+Ro6N2D6xj1dgSu8=";

  postInstall = ''
    mv packages/ $out/lib/node_modules/quicktype/
  '';

  meta = with lib; {
    description = "Generate types and converters from JSON, Schema, and GraphQL";
    homepage = "https://quicktype.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "quicktype";
  };
}
