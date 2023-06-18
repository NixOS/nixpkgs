{ stdenv, fetchzip, applyPatches, lib, ... }:
{ url
, sha256
, licenses
, patches ? [ ]
, name ? null
, version ? null
, description ? null
, homepage ? null
}:
let
  # TODO: do something better
  licenseMap = {
    "agpl" = lib.licenses.agpl3Only;
    "apache" = lib.licenses.asl20;
  };
in
if name != null || version != null then throw ''
  `pkgs.fetchNextcloudApp` has been changed to use `fetchzip`.
  To update, please
  * remove `name`/`version`
  * update the hash
''
else applyPatches {
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
    meta =
    ({
      licenses = map (licenseString: licenseMap.${licenseString}) licenses;
      longDescription = description;
      inherit homepage;
    });
  };
}
