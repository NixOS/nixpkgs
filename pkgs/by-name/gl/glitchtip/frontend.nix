{ lib
, fetchFromGitLab
, buildNpmPackage
, jq
, moreutils
}:

buildNpmPackage rec {
  pname = "glitchtip-frontend";
  version = "4.0.9";

  npmDepsHash = "sha256-mQAjvOmoDfvJiBCkiioWUhWqQE+SONUCm0wbxYyCCdo=";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    rev = "v${version}";
    hash = "sha256-91ePKzaDM+YAGxCxT0XdIf3NJ9vFbLe9SYWdoMX+5Cg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postPatch = ''
    find . -name package.json | while IFS=$'\n' read -r pkg_json; do
      <"$pkg_json" ${lib.getExe jq} '. + {
        "devDependencies": .devDependencies | del(.cypress) | del(."cypress-localstorage-commands")
      }' | ${moreutils}/bin/sponge "$pkg_json"
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

  meta = {
    description = "Frontend for GlitchTip";
    homepage = "https://glitchtip.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
