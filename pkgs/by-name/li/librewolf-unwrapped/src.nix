{
  lib,
  fetchurl,
  fetchFromGitLab,
}:
let
  src = lib.importJSON ./src.json;
in
{
  inherit (src) packageVersion;
  source = fetchFromGitLab (
    src.source
    // {
      domain = "librewolf.dev";
      owner = "librewolf";
      repo = "source";
      fetchSubmodules = true;
    }
  );
  firefox = fetchurl (
    src.firefox
    // {
      url = "mirror://mozilla/firefox/releases/${src.firefox.version}/source/firefox-${src.firefox.version}.source.tar.xz";
    }
  );
}
