{
  buildNpmPackage,
  importNpmLock,
}:

let
  src = ./package;
in
buildNpmPackage {
  pname = "overrides-test";
  version = "1.0.0";

  inherit src;

  npmDeps = importNpmLock {
    npmRoot = src;
  };

  npmConfigHook = importNpmLock.npmConfigHook;

  dontNpmBuild = true;
}
