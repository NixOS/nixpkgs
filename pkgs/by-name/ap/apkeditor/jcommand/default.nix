{
  fetchFromGitHub,
  gradle,
  lib,
  REAndroidLibrary,
}:

let
  self = REAndroidLibrary {
    pname = "jcommand";
    version = "0-unstable-2024-09-20";
    projectName = "JCommand";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "JCommand";
      # No tagged releases, and
      # it is hard to determine the actual commit that APKEditor is intended to use,
      # so I think we should use the latest commit that doesn't break compilation or basic functionality.
      # Currently this is the latest commit at the time of packaging.
      rev = "714b6263c28dabb34adc858951cf4bc60d6c3fed";
      hash = "sha256-6Em+1ddUkZBCYWs88qtfeGnxISZchFrHgDL8fsgZoQg=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta.license = lib.licenses.asl20;
  };
in
self
