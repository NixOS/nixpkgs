{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "cinny-unwrapped";
  # Remember to update cinny-desktop when bumping this version.
  version = "4.11.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dwI3zNey/ukF3t2fhH/ePf4o4iBDwZyLWMYebPgXmWU=";
  };

  npmDepsHash = "sha256-27WFjb08p09aJRi0S2PvYq3bivEuG5+z2QhFahTSj4Q=";

  # Skip rebuilding native modules since they're not needed for the web app
  npmRebuildFlags = [
    "--ignore-scripts"
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [
      abbe
      rebmit
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
})
