{ lib, fetchurl, fetchFromGitea }:
let src = lib.importJSON ./src.json;
in
{
  inherit (src) packageVersion;
  source = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librewolf";
    repo = "source";
    fetchSubmodules = true;
    inherit (src.source) rev sha256;
  };
  settings = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librewolf";
    repo = "settings";
    inherit (src.settings) rev sha256;
  };
  firefox = fetchurl {
    url =
      "mirror://mozilla/firefox/releases/${src.firefox.version}/source/firefox-${src.firefox.version}.source.tar.xz";
    inherit (src.firefox) sha512;
  };
}

