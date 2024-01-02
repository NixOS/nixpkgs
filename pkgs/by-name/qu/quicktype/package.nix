{ lib, buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.80"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "glideapps";
    repo = "quicktype";
    rev = "2a60269d431b392b658e671df2c1fb5479aec855"; # version not tagged
    hash = "sha256-3VW/CyvgetS9sqLflJgOmQERn4e/0nLQsezRHb6km3s=";
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
