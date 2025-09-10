{
  fetchurl,
  fetchzip,
  applyPatches,
  lib,
  ...
}:
{
  name ?
    if appName == null || appVersion == null then null else "nextcloud-app-${appName}-${appVersion}",
  url,
  hash ? "",
  sha256 ? "",
  sha512 ? "",
  appName ? null,
  appVersion ? null,
  license,
  patches ? [ ],
  description ? null,
  longDescription ? description,
  homepage ? null,
  maintainers ? [ ],
  teams ? [ ],
  unpack ? false, # whether to use fetchzip rather than fetchurl
}:
applyPatches {
  ${if name == null then null else "name"} = name;
  inherit patches;

  src = (if unpack then fetchzip else fetchurl) {
    inherit url;
    ${if hash == "" then null else "hash"} = hash;
    ${if sha256 == "" then null else "sha256"} = sha256;
    ${if sha512 == "" then null else "sha512"} = sha512;

    meta = {
      license = lib.licenses.${license};
      ${if description == null then null else "description"} = description;
      ${if longDescription == null then null else "longDescription"} = longDescription;
      ${if homepage == null then null else "homepage"} = homepage;
      inherit maintainers teams;
    };
  };
  prePatch = ''
    if [ ! -f ./appinfo/info.xml ]; then
      echo "appinfo/info.xml doesn't exist in $out, aborting!"
      exit 1
    fi
  '';
}
