{
  lib,
  fetchurl,
  fetchFromCodeberg,
}:
let
  src = lib.importJSON ./src.json;
in
{
  inherit (src) packageVersion;
  source = fetchFromCodeberg (
    src.source
    // {
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
