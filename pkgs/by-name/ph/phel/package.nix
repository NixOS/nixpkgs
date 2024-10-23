{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phel";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0LUxBNWmXoP6jZTVskU3FEg7E/ZscnwD42AwH2BvzeY=";
  };

  vendorHash = "sha256-TTtyYe/mz1jVboRsazCdh2BvsPw+ZQVDeQGBEv++J5o=";

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
