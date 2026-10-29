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
    version = "1.3.8-unstable-2026-05-16";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "a28c6fb2a77de392f2758c4dfe1a4d7d1aa86c5a";
      hash = "sha256-0SwowTDkgF9Rdenx/nlSPuGf3kvk7ucxtr7D6r9fU/c=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
