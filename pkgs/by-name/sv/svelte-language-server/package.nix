{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.10";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-KGsiYv57EnY5Atynuv1Qk0i/vq07FCbHuI9OOkyxOvE=";
  };

  npmDepsHash = "sha256-Gph0papxZnN0BKbzhwyOeNQwtYI1QkWupG6RRaUiv8U=";

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
