{
  fetchurl,
  fetchzip,
  applyPatches,
  lib,
  ...
}:
{
  url,
  hash ? "",
  sha256 ? "",
  appName ? null,
  appVersion ? null,
  license,
  patches ? [ ],
  description ? null,
  homepage ? null,
  unpack ? true, # whether to use fetchzip rather than fetchurl
}:
applyPatches (
  {
    inherit patches;
    src = (if unpack then fetchzip else fetchurl) {
      inherit url hash sha256;
      meta =
        {
          license = lib.licenses.${license};
          longDescription = description;
          inherit homepage;
        }
        // lib.optionalAttrs (description != null) {
          longDescription = description;
        }
        // lib.optionalAttrs (homepage != null) {
          inherit homepage;
        };
    };
    prePatch = ''
      if [ ! -f ./appinfo/info.xml ]; then
        echo "appinfo/info.xml doesn't exist in $out, aborting!"
        exit 1
      fi
    '';
  }
  // lib.optionalAttrs (appName != null && appVersion != null) {
    name = "nextcloud-app-${appName}-${appVersion}";
  }
)
