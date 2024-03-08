{ lib
, stdenv
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "maglnet";
    repo = "ComposerRequireChecker";
    rev = finalAttrs.version;
    hash = "sha256-qCHUNaPunCPuWax/YUbYXaVh1JlJEwYvG/NmaSc1VpA=";
  };

  vendorHash = "sha256-B5w5n2S/mTF7vpsLuHtf2DGR5aPBfO9QGmodYGXE+Cg=";

  meta = {
    description = "A CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "composer-require-checker";
  };
})
