{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "0.17.12";
in
buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-KNXaXjgIE0ryVkSxzsEoXE/1VjKPpEiMv+E2np8K6OU=";
  };

  npmDepsHash = "sha256-B8Ji9bsKKN7mem8W3Qg/oEQy9Emr5ilUKMYrMkAFS8Y=";

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
