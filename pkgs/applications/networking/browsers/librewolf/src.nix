{
  lib,
  fetchurl,
  fetchFromGitea,
}:
let
  src = lib.importJSON ./src.json;
in
{
  inherit (src) packageVersion;
  source = fetchFromGitea (
    src.source
    // {
      domain = "codeberg.org";
      owner = "librewolf";
      repo = "source";
      fetchSubmodules = true;
    }
  );
  release = src.firefox.version;
  firefox = fetchurl (
    src.firefox
    // {
      url = "mirror://mozilla/firefox/releases/${src.firefox.version}/source/firefox-${src.firefox.version}.source.tar.xz";
    }
  );
}
