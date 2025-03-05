{
  lib,
  php,
  fetchFromGitHub,
  makeBinaryWrapper,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpdocumentor";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ylwv+tW5Lyx1rooUy7wjinsutGpbLvIvXuLDGWLv24g=";
  };

  vendorHash = "sha256-oPhe4yfOdsguXS3dF62mTr0+J1pfphsVJkMKR++c8go=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/phpdoc" \
      --set-default APP_CACHE_DIR /tmp \
      --set-default APP_LOG_DIR /tmp/log
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/phpDocumentor/phpDocumentor/releases/tag/v${finalAttrs.version}";
    description = "PHP documentation generator";
    homepage = "https://phpdoc.org";
    license = lib.licenses.mit;
    mainProgram = "phpdoc";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
