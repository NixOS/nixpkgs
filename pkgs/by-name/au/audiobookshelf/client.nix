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

  npmDepsHash = "sha256-l7vdcggcVs9LYQ7DLumUUh67lxZ5giVMrtwUU6prfwI=";

  env = {
    # don't download the Cypress binary
    CYPRESS_INSTALL_BINARY = 0;
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmBuildScript = "generate";
}
