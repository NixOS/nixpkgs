{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4s3PCgaJfJR9+XXqT2WLrEwNUSLLCIOb+nJ8w9SbKps=";
  };

  vendorHash = "sha256-4/J3TJPdbj+eAneMwxP73N1cI53hJSEQg4G+LlQOJeE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ ];
  };
})
