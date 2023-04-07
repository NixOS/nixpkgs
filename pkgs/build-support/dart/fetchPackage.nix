{ lib, fetchzip }: { pubUrl ? "https://pub.dev", name, version, sha256 ? lib.fakeSha256 }:

let
  shortUrl = builtins.replaceStrings [ "https://" "http://" ] [ "" "" ] pubUrl;
in
fetchzip {
  inherit sha256;
  name = "${pubUrl}-${name}-${version}";
  url = "${pubUrl}/packages/${name}/versions/${version}.tar.gz";
  stripRoot = false;
  passthru = {
    isPub = true;
    inherit shortUrl name version;
  };
}
