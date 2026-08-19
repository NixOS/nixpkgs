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
  '';

  extraPostPatch = ''
    while read patch_name; do
      echo "applying LibreWolf patch: $patch_name"
      patch -p1 < ${source}/$patch_name
    done <${source}/assets/patches.txt

    sed -i 's/5bc8c9bbe8c0eabe408d9a7cd7a8e6e09eee0ead817607643882b38a36d07c91/bddacbe056ce7458663a39dc99d5bb3434099aa69cae793cf0c57d4e54f5a6a4/g' third_party/rust/glean-core/.cargo-checksum.json
    sed -i 's/c20989b1aa336b0849e96ec1b2beea1eab825ffd192c2c3a636e20f830b811d0/0b43fbc5f86c6c247c5189af58be425a829c3b09018c6b26589661eec9a5ad24/g' third_party/rust/glean-core/.cargo-checksum.json

    rm toolkit/components/ml/content/backends/OpenAIPipeline.mjs
    rm -rf toolkit/components/ml/vendor/openai

    cp -r ${source}/themes/browser .
    cp ${source}/assets/search-config-v2.json services/settings/dumps/main/search-config-v2.json
    cp ${source}/assets/search-config-icons.json services/settings/dumps/main/search-config-icons.json
    cp ${source}/assets/2c4b8834-030c-4097-a887-c7506689095c services/settings/dumps/main/search-config-icons
    cp ${source}/assets/2c4b8834-030c-4097-a887-c7506689095c.meta.json services/settings/dumps/main/search-config-icons
    sed -i '/MOZ_SERVICES_HEALTHREPORT/ s/True/False/' browser/moz.configure

    cp ${source}/patches/pref-pane/category-librewolf.svg browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.css browser/themes/shared/preferences
    cp ${source}/patches/pref-pane/librewolf.inc.xhtml browser/components/preferences
    cp ${source}/patches/pref-pane/librewolf.js browser/components/preferences

    # override firefox version
    for fn in browser/config/version.txt browser/config/version_display.txt; do
      echo "${packageVersion}" > "$fn"
    done

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
