{
  lib,
  fetchgit,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
<<<<<<< HEAD
  version = "4.19.0";
=======
  version = "4.18.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-cTXXPsHI2yiHSakiWuuxripGLvkwmzIAADqKtwHOI7c=";
  };

  vendorHash = "sha256-1c0PtgqHttqiOPdlHHTE4qRQx8xMsX/nXqsj3iyTgnQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-8y8ziaWCno389ti263N+xinADoPZZGXqhTHoc9ZkF4Y=";
  };

  vendorHash = "sha256-BDGxHoDLSEdukN+zv8QNZPtVXfRpp/o95ysGFs0wl9Q=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    mainProgram = "composer-require-checker";
    maintainers = [ lib.maintainers.patka ];
  };
})
