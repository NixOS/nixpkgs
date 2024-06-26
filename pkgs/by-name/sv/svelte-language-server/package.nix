{ lib
, buildNpmPackage
, fetchurl
}:
let
  version = "0.16.11";
in buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-xTBdiOS6XwJN5t6L49COWeoyMUBRzlxbAND5S1e9/Xw=";
  };

  npmDepsHash = "sha256-RR67TdgQHgF7RdrHjebGzIVGkeLABwXQgikd+Bc8lSE=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Language server (implementing the language server protocol) for Svelte";
    downloadPage = "https://www.npmjs.com/package/svelte-language-server";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelteserver";
    maintainers = with lib.maintainers; [ ];
  };
}
