{
  lib,
  php,
  fetchFromGitHub,
  makeBinaryWrapper,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpdocumentor";
<<<<<<< HEAD
  version = "3.9.1";
=======
  version = "3.8.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-T1aN/I06OdQnMxjutSsk3nNyXQ0Z+GWY6fADvJc7Iks=";
  };

  vendorHash = "sha256-IPKwEESlcwGotRAM1ZnTB+wbFF6tkMZTnpQ1aYDakSQ=";
=======
    hash = "sha256-iQA19FrXvVLzg+LaY1BcNmG8amMfKPVFwYbZ7dr+H9Q=";
  };

  vendorHash = "sha256-iXkj0Pa4ln8GX/ARCpnijaWdFM4VYZuj42RP0GS2LW8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/phpdoc" \
      --set-default APP_CACHE_DIR /tmp \
      --set-default APP_LOG_DIR /tmp/log
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/phpDocumentor/phpDocumentor/releases/tag/v${finalAttrs.version}";
    description = "PHP documentation generator";
    homepage = "https://phpdoc.org";
    license = lib.licenses.mit;
    mainProgram = "phpdoc";
    maintainers = [ lib.maintainers.patka ];
  };
})
