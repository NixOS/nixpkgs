{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-diagnostic";
  version = "0-unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "coc-diagnostic";
    rev = "1515cae0c7f8e7e4284d046b6aaad7ba665489e4";
    hash = "sha256-t5hB9lzbyHu0s7m/mYtohF/FW0Ymat9PM9zjdXwKiIM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-/WBOZKIIE2ERKuGwG+unXyam2JavPOuUeSIwZQ9RiHY=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
  ];

  # ERROR: noBrokenSymlinks: found 1 dangling symlinks and 0 reflexive symlinks
  postFixup = ''
    unlink $out/lib/node_modules/coc-diagnostic/node_modules/.bin/node-which
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Diagnostic-languageserver extension for coc.nvim";
    homepage = "https://github.com/iamcco/coc-diagnostic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
