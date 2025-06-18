{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nodejs,
  stdenvNoCC,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ncc";
  version = "0.38.3";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "ncc";
    rev = finalAttrs.version;
    hash = "sha256-NW9o0I+pzA9nCXY0S13OsB33adI+D76PX/cjGZ+Ju6Q=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ZJOcWZH2h3Io6M5tzs8CUB4T1GZ5QQhjN4RbpHkJpZ4=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.npmjs.com/package/@vercel/ncc";
    description = "Simple CLI for compiling a Node.js module into a single file, together with all its dependencies, gcc-style";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.three ];
    mainProgram = "ncc";
  };
})
