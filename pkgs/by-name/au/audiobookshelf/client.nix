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

  npmDepsHash = "sha256-g3Y/4UU2YH/CeU8Z/NNkLP0OTeBM+4/rQfL406uVdio=";

  env = {
    # don't download the Cypress binary
    CYPRESS_INSTALL_BINARY = 0;
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmBuildScript = "generate";
}
