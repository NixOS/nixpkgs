{
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  src,
  version,
  meta,
}:

stdenv.mkDerivation {
  pname = "listmonk-email-builder";
  inherit version;

  src = "${src}/frontend/email-builder";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/email-builder/yarn.lock";
    hash = "sha256-ANPLOL9j0gljtNtbfb+ZifVRN9vLexPddAevpeFwX4o=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R dist/* $out
    runHook postInstall
  '';

  inherit meta;
}
