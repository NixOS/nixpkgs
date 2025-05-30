{
  lib,
  fetchurl,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "markuplint";
  version = "4.12.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/markuplint/-/markuplint-${finalAttrs.version}.tgz";
    hash = "sha256-mt6qjKf5GoybYTkAduXNbuPxzpbzwyOiLoH0QJh/tyo=";
  };
  npmDepsHash = "sha256-ohAw9wcA4nxOs7iRQ61GPI2VBFefA654XJIgqLmKrss=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Static code analysis tool for HTML";
    homepage = "https://markuplint.dev";
    license = lib.licenses.mit;
    changelog = "https://github.com/markuplint/markuplint/blob/v${finalAttrs.version}/packages/markuplint/CHANGELOG.md";
    mainProgram = "markuplint";
    maintainers = [ lib.maintainers.zspher ];
  };
})
