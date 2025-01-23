{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "lips";
  version = "1.0.0-beta.20";

  src = fetchFromGitHub {
    owner = "jcubic";
    repo = "lips";
    tag = version;
    hash = "sha256-zvdtFfa+1Ols3TZSe2XCbGX9hColwGV/ReTJcTrrA4k=";
  };

  npmDepsHash = "sha256-7YeKTcBGsyiI6U0PeddAcs2x/O0LL/DT00KuSkqfy2A=";
  npmInstallFlags = [ "--only=prod" ];
  dontBuild = true; # dist folder is checked in
  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Powerful Scheme based Lisp in JavaScript";
    homepage = "https://lips.js.org";
    changelog = "https://github.com/jcubic/lips/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.all;
    mainProgram = "lips";
  };
}
