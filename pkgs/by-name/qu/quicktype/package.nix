{ lib, buildNpmPackage, fetchFromGitHub, jq }:

buildNpmPackage rec {
  pname = "quicktype";
  version = "23.0.75"; # version from https://npm.im/quicktype

  src = fetchFromGitHub {
    owner = "quicktype";
    repo = "quicktype";
    rev = "9b570a73a896306778940c793c0037a38815304a"; # version not tagged
    hash = "sha256-boCBgIoM2GECipZTJlp9IaeXT24aR8tawS1X8CFDDqw=";
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
