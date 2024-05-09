{ lib
, stdenv
, fetchFromGitLab
, meta
, buildNpmPackage
, jq
, moreutils
}:

buildNpmPackage rec {
  pname = "glitchtip-frontend";
  version = "4.0.8";

  npmDepsHash = "sha256-mQAjvOmoDfvJiBCkiioWUhWqQE+SONUCm0wbxYyCCdo=";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    rev = "v${version}";
    hash = "sha256-6+th7iGbxC7m1WOhYqk1xTEGvs8sVyHRvORT3jtan0s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postPatch = ''
    find . -name package.json | while IFS=$'\n' read -r pkg_json; do
      <"$pkg_json" jq '. + {
        "devDependencies": .devDependencies | del(.cypress) | del(."cypress-localstorage-commands")
      }' | sponge "$pkg_json"
    done
  '';

  buildPhase = ''
    runHook preBuild

    npm run build-prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/glitchtip-frontend $out/

    runHook postInstall
  '';

  inherit meta;
}
