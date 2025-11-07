{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.21";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-zRUeAocuEyoaBUrCDkqxJhMY7ryv9y7hYQC5/CsL2NM=";
  };

  npmDepsHash = "sha256-0nad0gdQhl3nwHbmDyLCfnIfgn4ixBbZn/oy3THDniw=";

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
