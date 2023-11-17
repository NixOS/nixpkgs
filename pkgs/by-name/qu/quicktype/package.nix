{ lib, buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.78"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "quicktype";
    repo = "quicktype";
    rev = "317deefa6a0c8ba0201b9b2b50d00c7e93c41d78"; # version not tagged
    hash = "sha256-KkyxS3mxOmUA8ZpB0tqdpdafvP429R5Y39C3CszTiZk=";
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
