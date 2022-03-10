{ fetchurl, fetchFromGitLab }:
let src = builtins.fromJSON (builtins.readFile ./src.json);
in
{
  inherit (src) packageVersion;
  source = fetchFromGitLab {
    owner = "librewolf-community";
    repo = "browser/source";
    fetchSubmodules = true;
    inherit (src.source) rev sha256;
  };
  firefox = fetchurl {
    url =
      "mirror://mozilla/firefox/releases/${src.firefox.version}/source/firefox-${src.firefox.version}.source.tar.xz";
    inherit (src.firefox) sha512;
  };
}

