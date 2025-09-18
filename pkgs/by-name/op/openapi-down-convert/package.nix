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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "apiture";
    repo = "openapi-down-convert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8csxj2HfOb9agDmwNmksNaiQhRd+3D1tf0vWU2w+XWw=";
  };

  npmDepsHash = "sha256-5VgFAiphahDKz3ZhzNEdQOFxvhvDy+S/qOClqBgMzSg=";

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
