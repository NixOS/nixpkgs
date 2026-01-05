{
  fetchFromGitHub,
  gradle,
  lib,
  REAndroidLibrary,
}:

let
  self = REAndroidLibrary {
    pname = "arsclib";
    # 1.3.8 is not new enough for APKEditor because of API changes
    version = "1.3.8-unstable-2025-09-23";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "7238433395dea6f7d0fce3139f1659063ac31f42";
      hash = "sha256-93eskC/qdkkNAZFYqSzoFxhmWgzTvDyZmZxOvwELGCs=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
