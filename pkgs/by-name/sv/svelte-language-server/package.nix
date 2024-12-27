{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.8";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-IbLjoXLN8sdnGy5SmoEeJUl1BzCulptMFtbJc+IRH70=";
  };

  npmDepsHash = "sha256-2rCgzEkwht03jxusPCdemA8EOabwRsHeDxiV4Uf4K8g=";

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
