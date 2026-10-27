{
  callPackage,
  runCommand,
  lib,
  stdenv,
}:
let
  src = callPackage ./src.nix { };
in
rec {

  inherit (src) packageVersion firefox source;

  extraPatches = [ "${source}/patches/pref-pane/pref-pane-small.patch" ];

  extraConfigureFlags = [
    "--with-unsigned-addon-scopes=app,system"
    "--disable-default-browser-agent"
    # Flags based on discussion in https://github.com/NixOS/nixpkgs/issues/482250
    "--disable-debug"
    "--disable-debug-symbols"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-lto=thin,cross"
  ];

  extraPreConfigure = ''
    export MOZ_TELEMETRY_REPORTING=
    export MOZ_PKG_VERSION=${packageVersion}
  '';

  extraPostPatch = ''
    while read patch_name; do
      echo "applying LibreWolf patch: $patch_name"
      patch -p1 < ${source}/$patch_name
    done <${source}/assets/patches.txt

    sed -i 's/ada8f059f0fa8a3a82315606318429d3a70200bbb2886d1a1bcaad2856a6303b/70a4a176b6494fce419e590180bc9c631945282ded0ab05bc1591bdd37b65093/g' third_party/rust/glean-core/.cargo-checksum.json
    sed -i 's/1753c69b71ae24a9b339d98e9b71166740a15506cfc46245251eb63c0222568f/af3ae3d026bd2e26fd9cc7c710847ac4f853b0c899412ddc9ee7e0ef1027de87/g' third_party/rust/glean-core/.cargo-checksum.json

    find . -type f -exec sed -i 's/follows_collection_enabled: false/follows_collection_enabled: true/g' {} +

    rm toolkit/components/ml/content/backends/OpenAIPipeline.mjs
    rm -rf toolkit/components/ml/vendor/openai

    cp -r ${source}/themes/browser .
    cp ${source}/assets/icons/* browser/themes/shared/icons/
    cp ${source}/assets/search-config-v2.json services/settings/dumps/main/search-config-v2.json
    cp ${source}/assets/search-config-icons.json services/settings/dumps/main/search-config-icons.json
    cp ${source}/assets/2c4b8834-030c-4097-a887-c7506689095c services/settings/dumps/main/search-config-icons
    cp ${source}/assets/2c4b8834-030c-4097-a887-c7506689095c.meta.json services/settings/dumps/main/search-config-icons
    cp ${source}/assets/marsigner.der toolkit/mozapps/update/updater/release_primary.der
    cp ${source}/assets/marsigner2.der toolkit/mozapps/update/updater/release_secondary.der
    sed -i '/MOZ_SERVICES_HEALTHREPORT/ s/True/False/' browser/moz.configure

    cp ${source}/patches/pref-pane/category-librewolf.svg browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.css browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.inc.xhtml browser/components/preferences
    cp ${source}/patches/pref-pane/librewolf.js browser/components/preferences

    # override firefox version
    echo "${firefox.version}" > browser/config/version.txt
    echo "${packageVersion}" > browser/config/version_display.txt

    echo "patching appstrings.properties"
    find . -path '*/appstrings.properties' -exec sed -i s/Firefox/LibreWolf/ {} \;

    for fn in $(find "${source}/l10n/en-US/browser" -type f -name '*.inc.*'); do
      target_fn=$(echo "$fn" | sed "s,${source}/l10n/en-US/browser,browser/locales/en-US," | sed "s,\.inc,,")
      cat "$fn" >> "$target_fn"
    done
  '';

  localSettingsPrefs = runCommand "local-settings.js" { } ''
    # Import of `librewolf.cfg` file is already being done manually.
    substitute ${source}/settings/defaults/pref/local-settings.js $out \
      --replace-fail 'pref("general.config.filename", "librewolf.cfg");' ""
  '';

  extraPrefsFiles = [
    "${source}/settings/librewolf.cfg"
    localSettingsPrefs
  ];

  extraPoliciesFiles = [ "${source}/settings/distribution/policies.json" ];

  extraPassthru = {
    librewolf = {
      inherit src extraPatches;
    };
    inherit extraPrefsFiles extraPoliciesFiles;
  };
}
