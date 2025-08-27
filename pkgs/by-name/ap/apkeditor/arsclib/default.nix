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
    version = "1.3.8-unstable-2025-08-17";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "66051037efb9c27314e67d1e3c291e26d003a4d8";
      hash = "sha256-wgygFsnScsyyLYUpMdtoSneYQH1zxAqTSo4EcGOSGZM=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
