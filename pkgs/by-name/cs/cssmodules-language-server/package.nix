{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "cssmodules-language-server";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "antonk52";
    repo = "cssmodules-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9RZNXdmBP4OK7k/0LuuvqxYGG2fESYTCFNCkAWZQapk=";
  };

  npmDepsHash = "sha256-1CnCgut0Knf97+YHVJGUZqnRId/BwHw+jH1YPIrDPCA=";

  meta = {
    description = "Language server for autocompletion and go-to-definition functionality for css modules";
    changelog = "https://github.com/antonk52/cssmodules-language-server/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/antonk52/cssmodules-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicknb ];
    mainProgram = "cssmodules-language-server";
    platforms = lib.platforms.unix;
  };
})
