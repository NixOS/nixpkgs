{
  writeShellScript,
  nix,
  curl,
  gzip,
  xmlstarlet,
  common-updater-scripts,
}:

{ attrPath }:

let
  url = "http://mirrors.kodi.tv/addons/omega/addons.xml.gz";
  updateScript = writeShellScript "update.sh" ''
    set -ex

    attrPath=$1
    namespace=$(${nix}/bin/nix-instantiate $systemArg --eval -E "with import ./. {}; $attrPath.namespace" | tr -d '"')
    version=$(${curl}/bin/curl -s -L ${url} | ${gzip}/bin/gunzip -c | ${xmlstarlet}/bin/xml select -T -t -m "//addons/addon[@id='$namespace']" -v @version)

    ${common-updater-scripts}/bin/update-source-version "$attrPath" "$version"
  '';
in
[
  updateScript
  attrPath
]
