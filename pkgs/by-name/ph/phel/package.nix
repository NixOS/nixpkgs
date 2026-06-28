{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+4sseXsHXnOYC4I6ntDdloPYxhrusVT5D7S6h/NWdCs=";
  };

  vendorHash = "sha256-GYBriug9CmIsZkyG1xEmqyu1K3NDiskDnxeHWIZzM7o=";

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
