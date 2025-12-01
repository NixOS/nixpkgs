{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "openapi-down-convert";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "apiture";
    repo = "openapi-down-convert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-auHZ6xfsOhGetzH4sSsZy+EC9eM06GKMww0h9iN8Heo=";
  };

  npmDepsHash = "sha256-gVRHp28NhremVit34nngq0KvDn16m0xJIyUooiD7MtU=";

  postInstall = ''
    find $out/lib -type f \( -name '*.ts' \) -delete
    rm -r $out/lib/node_modules/@apiture/openapi-down-convert/node_modules/typescript
    rm $out/lib/node_modules/@apiture/openapi-down-convert/node_modules/.bin/*
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert an OpenAPI 3.1.x document to OpenAPI 3.0.x format";
    homepage = "https://github.com/apiture/openapi-down-convert";
    changelog = "https://github.com/apiture/openapi-down-convert/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fliegendewurst ];
    mainProgram = "openapi-down-convert";
  };
})
