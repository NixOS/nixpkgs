{
  buildNpmPackage,
  shelfmark,
}:

buildNpmPackage (finalAttrs: {
  pname = "shelfmark-frontend";
  inherit (shelfmark) version src;

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  npmDepsHash = "sha256-c/KDGUe+X4dfzbDXpkzYsEzvBxJjq46PTzqbgoCdGgw=";

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Shelfmark frontend";
    homepage = "https://github.com/calibrain/shelfmark/tree/main/src/frontend";
    inherit (shelfmark.meta) changelog license maintainers;
  };
})
