{
  src,
  version,
  meta,
  fetchNpmDeps,
  fetchpatch,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "lasuite-meet-frontend";
  inherit src version;

  patches = [
    # backport build fix
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://github.com/suitenumerique/meet/commit/df1495c97bc913866169ee8875a9a3169fcfc87e.diff";
      stripLen = 2;
      includes = [
        "package.json"
        "package-lock.json"
      ];
      hash = "sha256-1A26T6LtFlOiJNVGD/fZs562feoQXY37A2ecUfvDGpk=";
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs)
      version
      src
      patches
      sourceRoot
      ;
    hash = "sha256-uiD5pcpmka43uraMFo7lRuQFx/4aq1BEhQvyCAzo8fg=";
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
