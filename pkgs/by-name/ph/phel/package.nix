{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
<<<<<<< HEAD
  version = "0.27.0";
=======
  version = "0.23.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-8e29IQcTOT6kgcluGxp5bJ/tmD1tmA2VfrgAqpoao4o=";
  };

  vendorHash = "sha256-G78w7Cwhrs2kqtVEZFlbw9EqnE3roOWlR+O16R5M3eI=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-v/xRYzKCwF1kKDV00jK7Cwz3TupkNZVec/h2JnhVq4E=";
  };

  vendorHash = "sha256-oABfUeL52XFKUui1tBuoyK2B7kBcYdLuVo4OllX07AQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = [ ];
  };
})
