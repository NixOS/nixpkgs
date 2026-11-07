{
  src,
  version,

  buildNpmPackage,
  nodejs,
}:
buildNpmPackage {
  pname = "audiobookshelf-client";
  inherit version nodejs;

  src = "${src}/client";

  npmDepsHash = "sha256-Rvy/bULWyVkGthfpIGkTMO8Lv1miywwea7jLODfm54Y=";

  env = {
    # don't download the Cypress binary
    CYPRESS_INSTALL_BINARY = 0;
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmBuildScript = "generate";
}
