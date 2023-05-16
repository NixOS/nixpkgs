<<<<<<< HEAD
{ stdenv, fetchzip, applyPatches, lib, ... }:
{ url
, sha256
, appName ? null
, appVersion ? null
, license
, patches ? [ ]
, description ? null
, homepage ? null
}:
applyPatches ({
=======
{ stdenv, fetchzip, applyPatches, ... }:
{ url
, sha256
, patches ? [ ]
, name ? null
, version ? null
}:
if name != null || version != null then throw ''
  `pkgs.fetchNextcloudApp` has been changed to use `fetchzip`.
  To update, please
  * remove `name`/`version`
  * update the hash
''
else applyPatches {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
