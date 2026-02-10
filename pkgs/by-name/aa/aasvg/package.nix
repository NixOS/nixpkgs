{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "aasvg";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "martinthomson";
    repo = "aasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DR/bSzOirqrkXtuYxRh2LZDVwa1nzhVUrIfxOPak/zM=";
  };

  # the project has no dependencies
  preInstall = "mkdir node_modules/";
  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-FdVXR2Myit3GiA1/VXzHBRSihKAQlh+Zd1gzSMuYi6c=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert ASCII art diagrams into SVG";
    homepage = "https://github.com/martinthomson/aasvg";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "aasvg";
  };
})
