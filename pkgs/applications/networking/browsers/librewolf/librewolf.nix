{ callPackage }:
let
  src = callPackage ./src.nix { };
in
rec {

  inherit (src) packageVersion firefox source;

  extraPatches = [ "${source}/patches/pref-pane/pref-pane-small.patch" ];

  extraConfigureFlags = [
    "--with-app-name=librewolf"
    "--with-unsigned-addon-scopes=app,system"
  ];

  extraPostPatch = ''
    while read patch_name; do
      if ! sed -n '/nvidia-wayland-backported-fixes-.*-Bug-1898476/p'; then
        echo "applying LibreWolf patch: $patch_name"
        patch -p1 < ${source}/$patch_name
      fi
    done <${source}/assets/patches.txt

    cp -r ${source}/themes/browser .
    cp ${source}/assets/search-config.json services/settings/dumps/main/search-config.json
    sed -i '/MOZ_SERVICES_HEALTHREPORT/ s/True/False/' browser/moz.configure
    sed -i '/MOZ_NORMANDY/ s/True/False/' browser/moz.configure

    cp ${source}/patches/pref-pane/category-librewolf.svg browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.css browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.inc.xhtml browser/components/preferences
    cp ${source}/patches/pref-pane/librewolf.js browser/components/preferences
    cat ${source}/browser/preferences/preferences.ftl >> browser/locales/en-US/browser/preferences/preferences.ftl
  '';

  extraPrefsFiles = [ "${source}/settings/librewolf.cfg" ];

  extraPoliciesFiles = [ "${source}/settings/distribution/policies.json" ];

  extraPassthru = {
    librewolf = {
      inherit src extraPatches;
    };
    inherit extraPrefsFiles extraPoliciesFiles;
  };
}
