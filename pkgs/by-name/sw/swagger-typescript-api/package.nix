{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  srcOnly,
  stdenvNoCC,
}:
let
  pname = "swagger-typescript-api";
  version = "13.0.23";

  src = srcOnly {
    name = "${pname}-${version}"; # -source appended by srcOnly

    stdenv = stdenvNoCC;

    src = fetchFromGitHub {
      owner = "acacode";
      repo = "swagger-typescript-api";
      rev = version;
      hash = "sha256-Ahb/6RfLBJXRL0eSTDp5KPBdtwisCnNnugJ09LsOUTA=";
    };

    # Project use corepack and modern yarn (v4+), which has different lockfile format than yarn v1.
    # Use yarn/lockfile v1 for usage with mkYarnPackage and fetchYarnDeps.
    patches = [ ./yarnv1.patch ];
  };
in
mkYarnPackage rec {
  inherit pname version src;

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-OLEeSPKqGIyum+lmYX6Bs8EPc3rdNhHP59GeNChaDHE=";
  };

  doDist = false;

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    yarn --offline build
    runHook postBuild
  '';

  # package.json define two bin: sta and swagger-typescript-api.
  # These are the same script, keep only swagger-typescript-api.
  postInstall = ''
    rm $out/bin/sta
  '';

  meta = {
    mainProgram = "swagger-typescript-api";
    description = "Generate TypeScript API client and definitions for fetch or axios from an OpenAPI specification";
    homepage = "https://github.com/acacode/swagger-typescript-api";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
}
