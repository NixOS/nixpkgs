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
    version = "1.3.8-unstable-2026-02-27";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "b34f2e36d29077400e5b9f24fef9af3a3d9e8100";
      hash = "sha256-FhIZ9O1af8UcmcDcEWewMNBDr5Knd3BZL5PqEltCqxE=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
