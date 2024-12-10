{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phel";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EITeApaQ1nmQb53/DrSidcmWUACapjTUuUYuJQDML0Y=";
  };

  vendorHash = "sha256-IWFOpsPcrPg2/QWemRJ8tP6k0sIc2OogETdiBFAQ5BI=";

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
