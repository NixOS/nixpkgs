{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "ergogen";
  version = "4.2.1";

  forceGitDeps = true;

  src = fetchFromGitHub {
    owner = "ergogen";
    repo = "ergogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pddohqq08w/PpU3ZF3tCGSjUMLKnhCn/Db6WLKytjo0=";
  };

  npmDepsHash = "sha256-gSF4L4QiScW3ZaAm8QFCBGhbw7NhFe4gHWitN/OuQi4=";

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
