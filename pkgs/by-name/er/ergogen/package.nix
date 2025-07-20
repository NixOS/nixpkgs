{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "ergogen";
  version = "4.1.0";

  forceGitDeps = true;

  src = fetchFromGitHub {
    owner = "ergogen";
    repo = "ergogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y4Ri5nLxbQ78LvyGARPxsvoZ9gSMxY14QuxZJg6Cu3Y=";
  };

  npmDepsHash = "sha256-BQbf/2lWLYnrSjwWjDo6QceFyR+J/vhDcVgCaytGfl0=";

  makeCacheWritable = true;
  dontNpmBuild = true;
  npmPackFlags = [ "--ignore-scripts" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ergonomic keyboard layout generator";
    homepage = "https://ergogen.xyz";
    mainProgram = "ergogen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Tygo-van-den-Hurk ];
  };
})
