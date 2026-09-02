{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "aasvg";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "martinthomson";
    repo = "aasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eM7wQfWroG5Kaqs6dLpwdNi8DC7K5x2NPnE7aOhtcvA=";
  };

  # the project has no dependencies
  preInstall = "mkdir node_modules/";
  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-S3ulEkkxc+kZqMX52f2wC4UBOnviuWsasRyHby9tTLs=";

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
