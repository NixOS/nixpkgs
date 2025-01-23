{
  fetchFromGitHub,
  gradle,
  lib,
  REAndroidLibrary,
}:

let
  self = REAndroidLibrary {
    pname = "arsclib";
    # 1.3.5 is not new enough for APKEditor because of API changes
    version = "1.3.5-unstable-2024-10-21";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "ed6ccf00e56d7cce13e8648ad46a2678a6093248";
      hash = "sha256-jzd7xkc4O+P9hlGsFGGl2P3pqVvV5+mDyKTRUuGfFSA=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
