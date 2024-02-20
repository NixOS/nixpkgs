{ php
, fetchFromGitHub
, lib
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject (finalAttrs: {
  pname = "paratest";
  version = "7.4.2";

  src = fetchFromGitHub {
    owner = "paratestphp";
    repo = "paratest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sd7S51SjI8g2Qz/NAeKKpxpSyBhvlrtJFbazbPJf2N0=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-O8iEkvXIkkaQxcKfhm0Z4EZOtLolNsTPaPkXekpxkqs=";

  meta = {
    changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
    description = "Parallel testing for PHPUnit";
    homepage = "https://github.com/paratestphp/paratest";
    license = lib.licenses.mit;
    mainProgram = "paratest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
