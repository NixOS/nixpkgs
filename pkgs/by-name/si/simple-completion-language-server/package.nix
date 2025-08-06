{
  lib,
  fetchFromGitHub,
  rustPlatform,
  withCitation ? true,
}:

rustPlatform.buildRustPackage {
  pname = "simple-completion-language-server";
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "estin";
    repo = "simple-completion-language-server";
    rev = "f6ab8e8374d046e5c6ff36cc9804dfc708b56c02";
    hash = "sha256-ot2h85cn2ID7GAOSJvIeKcC3uUYzS3TWQ4Ql6MzPG50=";
  };

  cargoHash = "sha256-L0Xa+B5hMkVKdOD0YAyGErbgAY68CHzzeP0CLew0BMs=";

  buildFeatures = lib.optional withCitation [ "citation" ];

  meta = {
    description = "Language server to enable word completion and snippets for Helix editor";
    homepage = "https://github.com/estin/simple-completion-language-server";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "simple-completion-language-server";
    platforms = lib.platforms.all;
  };
}
