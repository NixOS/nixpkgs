{
  src,
  version,
  meta,
  fetchNpmDeps,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "lasuite-meet-frontend";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs)
      version
      src
      sourceRoot
      ;
    hash = "sha256-3O8QNXj3NG0vb7JmudnNzsqZmerMRyPsmz4b6TQBmtM=";
  };
  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = meta // {
    description = "Open source alternative to Google Meet and Zoom powered by LiveKit: HD video calls, screen sharing, and chat features. Built with Django and React";
  };
})
