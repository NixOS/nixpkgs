{ stdenv, fetchzip, applyPatches, lib, ... }:
{ url
, hash ? ""
, sha256 ? ""
, appName ? null
, appVersion ? null
, license
, patches ? [ ]
, description ? null
, homepage ? null
}:
applyPatches ({
  inherit patches;
  src = fetchzip {
    inherit url hash sha256;
    postFetch = ''
      pushd $out &>/dev/null
      if [ ! -f ./appinfo/info.xml ]; then
        echo "appinfo/info.xml doesn't exist in $out, aborting!"
        exit 1
      fi
      popd &>/dev/null
    '';
    meta = {
      license = lib.licenses.${license};
      longDescription = description;
      inherit homepage;
    } // lib.optionalAttrs (description != null) {
      longDescription = description;
    } // lib.optionalAttrs (homepage != null) {
      inherit homepage;
    };
  };
} // lib.optionalAttrs (appName != null && appVersion != null) {
  name = "nextcloud-app-${appName}-${appVersion}";
})
