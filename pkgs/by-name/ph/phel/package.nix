{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phel";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-U+E4AdxjBjuMEG5CDpyr4Avu/NzvQXdksPsl+tQMybM=";
  };

  vendorHash = "sha256-ROJrVhkq3A0ZOsWv8rNNlVmE8KYu+vDM201BECOgmik=";

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
