{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phel";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5PMd87Xp7i3Q1ryKQWJBmNbU5TGo2LQ6uvIFP3T36vk=";
  };

  vendorHash = "sha256-83GX/dxHa6w1E34wnJshg7yxlVyRkDT5jmAPCCqPdtA=";

  doInstallCheck = true;
  postCheckInstall = ''
    $out/bin/phel --version
  '';

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Phel is a functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet.";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
