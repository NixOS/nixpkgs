{ buildNpmPackage
, version
, src
}:
buildNpmPackage {
  pname = "jshelter-wasm";
  inherit version src;

  sourceRoot = "${src.name}/wasm";

  npmDepsHash = "sha256-pmY3tUBz+I6aa7fFpZy/TkXa2ApZdWT8sPMll1SMQv0=";
}
