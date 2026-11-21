{
  lib,
  stdenv,
  fetchFromGitLab,
  unstableGitUpdater,
  gradle_8,
}:

let
  gradle = gradle_8;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "keycloak-vikunja-team-mapper";
  version = "0-unstable-2026-08-11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "rechenknecht.net";
    owner = "giz/keycloak";
    repo = "vikunja-team-mapper";
    rev = "d2e5ccc12c44ebfb2635bf55d6c7f5f5bf563930";
    hash = "sha256-vhIZF47GE/KjROeT1BfXpGHIGztoBTq7CtitHAukR3s=";
  };

  nativeBuildInputs = [
    gradle
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out" build/libs/vikunja-team-mapper-1.0.0.jar

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Map Keycloak user groups to Vikunja teams";
    homepage = "https://rechenknecht.net/giz/keycloak/vikunja-team-mapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niklaskorz ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
