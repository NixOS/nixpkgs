{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.20";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-AUvJfgA0CBfJRRxMcV+ZBCf0yNT93UI79DswAm2QB0c=";
  };

  npmDepsHash = "sha256-AjOXah8pUCcZBFuUy1y2FbCZTQwZWimyc1RO8SKGUd0=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmFlags = [ "--legacy-peer-deps" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Language server (implementing the language server protocol) for Svelte";
    downloadPage = "https://www.npmjs.com/package/svelte-language-server";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelteserver";
    maintainers = [ ];
  };
}
