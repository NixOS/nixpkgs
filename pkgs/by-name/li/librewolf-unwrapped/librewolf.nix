{ callPackage }:
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
    "--enable-lto=thin,cross"
  ];

  extraPostPatch = ''
    while read patch_name; do
      echo "applying LibreWolf patch: $patch_name"
      patch -p1 < ${source}/$patch_name
    done <${source}/assets/patches.txt

    rm toolkit/components/ml/content/backends/OpenAIPipeline.mjs
    rm -rf toolkit/components/ml/vendor/openai

    cp -r ${source}/themes/browser .
    cp ${source}/assets/search-config.json services/settings/dumps/main/search-config.json
    sed -i '/MOZ_SERVICES_HEALTHREPORT/ s/True/False/' browser/moz.configure

    sed -i '/# This must remain last./i gkrust_features += ["glean_disable_upload"]\'$'\n' toolkit/library/rust/gkrust-features.mozbuild

    # Temporary fix used with patches/rust-build.patch
    sed -i 's/9456ca46168ef86c98399a2536f577ef7be3cdde90c0c51392d8ac48519d3fae/60cd124908737068ab21c7773b3df71d00e186cd605f15bad9977232830aabc0/g' third_party/rust/encoding_rs/.cargo-checksum.json
    sed -i 's/d7405d2bcf99cf9729075473c45f677630f4c1947c8ba9757db607f2025a7da2/a066ad881d5a74386e666fc844f7fecbbd70021d0330c1b08a2d7a2a67437ccf/g' third_party/rust/encoding_rs/.cargo-checksum.json

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

  extraPrefsFiles = [ "${source}/settings/librewolf.cfg" ];

  extraPoliciesFiles = [ "${source}/settings/distribution/policies.json" ];

  extraPassthru = {
    librewolf = {
      inherit src extraPatches;
    };
    inherit extraPrefsFiles extraPoliciesFiles;
  };
}
