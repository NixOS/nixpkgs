{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  name = "cssmodules-language-server";
  url = "https://github.com/antonk52/${name}";
in
buildNpmPackage (finalAttrs: {
  pname = name;
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "antonk52";
    repo = name;
    tag = "v${finalAttrs.version}";
    hash = "sha256-9RZNXdmBP4OK7k/0LuuvqxYGG2fESYTCFNCkAWZQapk=";
  };

  npmDepsHash = "sha256-1CnCgut0Knf97+YHVJGUZqnRId/BwHw+jH1YPIrDPCA=";

  meta = with lib; {
    description = "Language server for autocompletion and go-to-definition functionality for css modules";
    changelog = "${url}/releases/tag/v${finalAttrs.version}";
    homepage = url;
    license = licenses.mit;
    maintainers = [ lib.maintainers.nicknb ];
    mainProgram = "cssmodules-language-server";
    platforms = lib.platforms.unix;
  };
})
