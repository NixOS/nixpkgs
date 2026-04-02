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
    version = "1.3.8-unstable-2026-03-21";
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      # This is the latest commit at the time of packaging.
      # It can be changed to a stable release ("V${version}")
      # if it is compatible with APKEditor.
      rev = "f6c2dc2f6db9063445e84f7ede316d4f1f029351";
      hash = "sha256-IZ2Us7tcuE+L4bfA4JAcF6Idz1Y2S2IfqW4NSbsxr5o=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
