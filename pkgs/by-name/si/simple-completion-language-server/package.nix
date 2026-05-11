{
  lib,
  fetchFromGitHub,
  rustPlatform,
  withCitation ? true,
}:

rustPlatform.buildRustPackage {
  pname = "simple-completion-language-server";
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "estin";
    repo = "simple-completion-language-server";
    rev = "f8319589ab87b18f441627999f4a8316dd712234";
    hash = "sha256-PKJVaj5et+afrMk7x/H/d/ygabjDALGKM3fr/16EKoQ=";
  };

  cargoHash = "sha256-RgRmbQVZK/4U37CO8AjNQOqR/SXvL1TQU03LX7LnqPY=";

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
