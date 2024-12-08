{
  stdenv,
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
  nodejs,
  version,
  src,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "listmonk-frontend";
  inherit version meta;

  src = "${src}/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-2STFJtlneyR6QBsy/RVIINV/0NMggnfZwyz1pki8iPk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
