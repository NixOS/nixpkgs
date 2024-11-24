{ lib }:
let
  # extractLatestVersionFromHtml :: String -> String
  extractLatestVersionFromHtml = htmlString:
    let
      majorMinorPatchGroup = "([0-9]+\\.[0-9]+\\.[0-9]+)";
      splittedVersions = builtins.split "href=\"${majorMinorPatchGroup}" htmlString;
      stableVersions = builtins.concatLists
        (builtins.filter (e: builtins.isList e)
          splittedVersions);
    in
    if stableVersions == [ ]
    then abort "Failed to extract versions from html."
    else lib.last (builtins.sort builtins.lessThan stableVersions);

  # getHtml :: String -> String
  getHtml = url:
    builtins.readFile (builtins.fetchurl url);

  # getLatestStableVersion :: String
  getLatestStableVersion =
    extractLatestVersionFromHtml
      (getHtml "https://download.documentfoundation.org/libreoffice/stable/");

  # extractSha256FromHtml :: String -> String
  extractSha256FromHtml = htmlString:
    let
      sha256 = (builtins.match ".*([0-9a-fA-F]{64}).*" htmlString);
    in
    if sha256 == [ ]
    then abort "Failed to extract sha256 from html."
    else builtins.head sha256;

  # getSha256 :: String -> String
  getSha256 = dmgUrl: oldVersion: newVersion:
    extractSha256FromHtml (getHtml (getSha256Url dmgUrl oldVersion newVersion));

  # getSha256Url :: String -> String -> String -> String
  getSha256Url = dmgUrl: oldVersion: newVersion:
    (builtins.replaceStrings [ oldVersion ] [ newVersion ] dmgUrl) + ".sha256";

in
{
  inherit
    extractLatestVersionFromHtml
    getHtml
    getLatestStableVersion
    extractSha256FromHtml
    getSha256
    getSha256Url;
}
