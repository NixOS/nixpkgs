{
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  meta,
  version,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listmonk-frontend";
  inherit version;

  src = "${src}/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-VCaEMftA7AzW/6jyceVO596iby0wC3LW9YDG66kLJmw=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    mkdir -p $out/admin
    cp -R dist/* $out/admin
    cp node_modules/altcha/dist/altcha.umd.cjs $out/altcha.umd.js
  '';

  inherit meta;
})
