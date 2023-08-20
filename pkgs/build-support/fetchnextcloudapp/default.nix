{ stdenv, fetchzip, applyPatches, lib, ... }:
{ url
, sha256
, appName ? null
, appVersion ? null
, license
, patches ? [ ]
, name ? null
, version ? null
, description ? null
, homepage ? null
}:
if name != null || version != null then throw ''
  `pkgs.fetchNextcloudApp` has been changed to use `fetchzip`.
  To update, please
  * remove `name`/`version`
  * update the hash
''
else applyPatches ({
  inherit patches;
  src = fetchzip {
    inherit url sha256;
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
    };
  };
} // lib.optionalAttrs (appName != null && appVersion != null) {
  name = "nextcloud-app-${appName}-${appVersion}";
})
