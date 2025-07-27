{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YwmDTj1uc71rpp5Iq/7cDq0gLLy8Bh96bu0RaYqi5J0=";
  };

  vendorHash = "sha256-zZK4v9IncoOurf2yUeFqwmAkqsMBlLfuZTUm9cWQBCA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Phel is a functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
