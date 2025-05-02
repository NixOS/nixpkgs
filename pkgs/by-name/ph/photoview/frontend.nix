{
  src,
  version,
  lib,
  buildNpmPackage,
  nodejs_20,
}:
buildNpmPackage {
  pname = "photoview-frontend";
  inherit version;
  nodejs = nodejs_20;

  src = src + "/ui/";

  npmDepsHash = "sha256-31CyjyNd85hNg4MXIWctoQ3YgorGqCMz+wDAu/K1lWo=";
  makeCacheWritable = true;
  npmPackFlags = [
    "--ignore-scripts"
    "--cache"
    "cache"
  ];

  NODE_ENV = "production npm prune";
}
