{
  src,
  version,

  buildNpmPackage,
  nodejs,
}:
buildNpmPackage {
  pname = "audiobookshelf-client";
  inherit src version nodejs;

  sourceRoot = "${src.name}/client";

  npmDepsHash = "sha256-Rvy/bULWyVkGthfpIGkTMO8Lv1miywwea7jLODfm54Y=";

  npmRebuildFlags = [ "--ignore-scripts" ];

  npmBuildScript = "generate";

  installPhase = ''
    runHook preInstall
    cp -r dist "$out"
    runHook postInstall
  '';
}
