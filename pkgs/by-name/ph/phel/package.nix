{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h+YNS9CWSAlP2K2RV9BVMko6iYC/aJUiD6YexCrRHNI=";
  };

  vendorHash = "sha256-efobguWNFK6cC17WYtmXyTu3MGFQnT0Y69E8CZ3++fA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = [ ];
  };
})
