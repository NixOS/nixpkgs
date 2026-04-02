{
  buildNpmPackage,
  shelfmark,
}:

buildNpmPackage (finalAttrs: {
  pname = "shelfmark-frontend";
  inherit (shelfmark) version src;

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  npmDepsHash = "sha256-VCnxEcaqWo31oIpF6X8Lid4I/aaQCQZ9l9rV6TTqXPI=";

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
