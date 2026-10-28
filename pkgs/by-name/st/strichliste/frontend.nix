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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "strichliste";
    repo = "strichliste-web-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LzTdFYuIIFmAVuHtGjljqSBZGEPibwXcK5WuYB6ELNg=";
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

  meta = meta // {
    changelog = "https://github.com/strichliste/strichliste-web-frontend/releases/tag/${finalAttrs.src.tag}";
  };
})
