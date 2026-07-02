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
    inherit (finalAttrs) version src sourceRoot;
    hash = "sha256-LDH8aR+FSiIFYMDaQ3wNYAzv6VpHtH5X+DMHGBhPkm0=";
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
