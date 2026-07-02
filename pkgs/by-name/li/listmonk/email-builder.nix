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
    hash = "sha256-sFRmnMPStNp45hxcF+Iq1WhH6LtVFtgq2regq6MPzcc=";
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
