{ lib
, buildNpmPackage
, fetchurl
}:
let
  version = "0.16.10";
in buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-Int5mc147BUqpOGT2T3oNRbLNjioEaEifOH3wF1vJL4=";
  };

  npmDepsHash = "sha256-/JjMrbDyoHUvGJxqmkxjxCkWURJa8sXUZryQRGTdRMY=";

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
