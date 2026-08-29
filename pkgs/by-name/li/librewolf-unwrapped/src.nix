{
  lib,
  fetchurl,
  fetchFromForgejo,
}:
let
  src = lib.importJSON ./src.json;
in
{
  inherit (src) packageVersion;
  source = fetchFromForgejo (
    src.source
    // {
      domain = "librewolf.dev";
      owner = "librewolf";
      repo = "source";
    }
  );
  firefox = fetchurl (
    src.firefox
    // {
      url = "mirror://mozilla/firefox/releases/${src.firefox.version}/source/firefox-${src.firefox.version}.source.tar.xz";
    }
  );
}
