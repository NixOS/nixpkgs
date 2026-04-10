{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "aasvg";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "martinthomson";
    repo = "aasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Le6ZbJY7ZkqblZx4TkHWIiRKn1foi8jB+rldhu95NQ0=";
  };

  # the project has no dependencies
  preInstall = "mkdir node_modules/";
  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-FdVXR2Myit3GiA1/VXzHBRSihKAQlh+Zd1gzSMuYi6c=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
