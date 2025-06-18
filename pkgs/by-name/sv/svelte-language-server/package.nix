{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.15";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-xjA17Dn1XxT5ghNXrkMtgcesMpRqtBP40RT/3AcU6lw=";
  };

  npmDepsHash = "sha256-jsjnbjM4PkFgbbmkMNmOCrZ7HgLHDELOHe+MSr05o1A=";

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
