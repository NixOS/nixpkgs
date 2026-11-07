{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TJaQWdCTmpM5DAQf2qdHyDzZvNdctNRoeVT74lBoZPk=";
  };

  vendorHash = "sha256-s4GM2M1s7zV78XLWoipSQzm1eNzW+TQhhMVFCKfCLlc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ Chemaclass ];
  };
})
