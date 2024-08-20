{ lib, buildNpmPackage, fetchFromGitHub, jq, quicktype, testers }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.105"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "glideapps";
    repo = "quicktype";
    rev = "0b5924db1d3858d6f4abe5923cce53b2f4e581aa"; # version not tagged
    hash = "sha256-JqpTnIhxLxLECqW8DjG1Oig/HOs9PpwmjdfhwE8sJAA=";
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
    maintainers = [ ];
    mainProgram = "quicktype";
  };
}
