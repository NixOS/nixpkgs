{
  src,
  version,
  stdenv,
  yarnConfigHook,
  yarnBuildHook,
  nodejs-slim,
  fetchYarnDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gotify-ui";
  inherit version;

  src = src + "/ui";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-0OIxoT7iS7i3E1fD6E/6+WVYZcu2r+Qa7KBX56+CzIk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs-slim
  ];

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  installPhase = ''
    runHook preInstall

    mv build $out

    runHook postInstall
  '';
})
