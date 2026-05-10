{
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  meta,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "strichliste-frontend";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "strichliste";
    repo = "strichliste-web-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fi4pz3ylWyC4yvDWsK2Rvv8KDaXeHNVz0jY6PpF07hE=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-leMwcsyhbxPoHJdA3kZDz97Ti77d1TCe8SrzTQMGrWo=";
  };

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  installPhase = ''
    mkdir $out
    cp -R build/* $out/
  '';

  __structuredAttrs = true;

  inherit meta;
})
