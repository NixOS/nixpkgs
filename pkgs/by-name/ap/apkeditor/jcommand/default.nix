{
  fetchFromGitHub,
  gradle,
  lib,
  REAndroidLibrary,
}:

let
  self = REAndroidLibrary {
    pname = "jcommand";
    version = "0-unstable-2025-01-21";
    projectName = "JCommand";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "JCommand";
      # No tagged releases, and
      # it is hard to determine the actual commit that APKEditor is intended to use,
      # so I think we should use the latest commit that doesn't break compilation or basic functionality.
      # Currently this is the latest commit at the time of packaging.
      rev = "27d5fd21dc7da268182ea81e59007af890adb06e";
      hash = "sha256-sbblGrp16rMGGGt7xAFd9F3ACeadYYEymBEL+s5BZ1E=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
