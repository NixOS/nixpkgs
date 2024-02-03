{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phel";
  version = "0.11.0-dev";

  src = fetchFromGitHub {
    owner = "phel-lang";
    repo = "phel-lang";
    rev = "83d9d81b6c7daae361c0f1f68462083027b81581";
    hash = "sha256-B2IozL/nJE4C1Gq54/64TJEySC1STroG1poCBzd3j3I=";
  };

  vendorHash = "sha256-83GX/dxHa6w1E34wnJshg7yxlVyRkDT5jmAPCCqPdtA=";

  meta = {
    changelog = "https://github.com/phel-lang/phel-lang/releases/tag/v${finalAttrs.version}";
    description = "Phel is a functional programming language that compiles to PHP. A Lisp dialect inspired by Clojure and Janet.";
    homepage = "https://github.com/phel-lang/phel-lang";
    license = lib.licenses.mit;
    mainProgram = "phel";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
