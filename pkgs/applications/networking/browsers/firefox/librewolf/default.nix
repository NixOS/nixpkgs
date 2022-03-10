{ callPackage, git }:
let
  src = callPackage ./src.nix { };
in
rec {

  inherit (src) packageVersion firefox source;

  patches = [ ./verify-telemetry-macros.patch ];

  extraConfigureFlags = [
    "--with-app-name=librewolf"
    "--with-app-basename=LibreWolf"
    "--with-branding=browser/branding/librewolf"
    "--with-distribution-id=io.gitlab.librewolf-community"
    "--with-unsigned-addon-scopes=app,system"
    "--allow-addon-sideload"
  ];

  extraPostPatch = ''
    while read patch_name; do
      echo "applying LibreWolf patch: $patch_name"
      patch -p1 < ${source}/$patch_name
    done <${source}/assets/patches.txt

    cp -r ${source}/themes/browser .
    cp ${source}/assets/search-config.json services/settings/dumps/main/search-config.json
    sed -i '/MOZ_SERVICES_HEALTHREPORT/ s/True/False/' browser/moz.configure
    sed -i '/MOZ_NORMANDY/ s/True/False/' browser/moz.configure
  '';

  extraPrefsFiles = [ "${source}/submodules/settings/librewolf.cfg" ];

  extraPoliciesFiles = [ "${source}/submodules/settings/distribution/policies.json" ];

  extraPassthru = {
    librewolf = { inherit src patches; };
    inherit extraPrefsFiles extraPoliciesFiles;
  };
}

