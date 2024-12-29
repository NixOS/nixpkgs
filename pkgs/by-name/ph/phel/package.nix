{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-irN1Dnov6vDiU4xGsf2nxz7/kz1YOMq0yOLYt4HY1EM=";
  };

  vendorHash = "sha256-jcMfGPnGoSP8E1JXPEqKr53amV0d08GvGfe8niwM8Q4=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/phel --version
  '';

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Phel is a functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
