{
  lib,
  mkChromiumDerivation,
  chromiumVersionAtLeast,
  enableWideVine,
  variant,
}:

let
  # https://chromium-review.googlesource.com/c/chromium/src/+/7253206
  ifElseM145 = new: old: if chromiumVersionAtLeast "145" then new else old;

  browserName = if variant == "helium" then "helium" else "chromium";
in

mkChromiumDerivation (base: rec {
  name = "chromium-browser";
  packageName = "chromium";
  buildTargets = [
    "chrome_sandbox"
    "chrome"
  ];

  outputs = [
    "out"
    "sandbox"
  ];

  sandboxExecutableName = "__chromium-suid-sandbox";

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.so "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/libvulkan.so.1" "$libExecPath/"
    cp -v "$buildPath/vk_swiftshader_icd.json" "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome_crashpad_handler" "$libExecPath/"
    cp -v "$buildPath/chrome" "$libExecPath/$packageName"

    # Swiftshader
    # See https://stackoverflow.com/a/4264351/263061 for the find invocation.
    if [ -n "$(find "$buildPath/swiftshader/" -maxdepth 1 -name '*.so' -print -quit)" ]; then
      echo "Swiftshader files found; installing"
      mkdir -p "$libExecPath/swiftshader"
      cp -v "$buildPath/swiftshader/"*.so "$libExecPath/swiftshader/"
    else
      echo "Swiftshader files not found"
    fi

    mkdir -p "$sandbox/bin"
    cp -v "$buildPath/chrome_sandbox" "$sandbox/bin/${sandboxExecutableName}"

    mkdir -vp "$out/share/man/man1"
    cp -v "$buildPath/chrome.1" "$out/share/man/man1/$packageName.1"

    for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      expr "$icon_size" : "^[0-9][0-9]*$" || continue
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -vp "$logo_output_path"
      cp -v "$icon_file" "$logo_output_path/$packageName.png"
    done

    # Install Desktop Entry
    install -D chrome/installer/linux/common/desktop.template \
      $out/share/applications/${browserName}-browser.desktop

    substituteInPlace $out/share/applications/${browserName}-browser.desktop \
      --replace-fail "${ifElseM145 "@@MENUNAME" "@@MENUNAME@@"}" "${lib.toSentenceCase browserName}" \
      --replace-fail "${ifElseM145 "@@PACKAGE" "@@PACKAGE@@"}" "${browserName}" \
      --replace-fail "${ifElseM145 "/usr/bin/@@usr_bin_symlink_name" "/usr/bin/@@USR_BIN_SYMLINK_NAME@@"}" "${browserName}" \
      --replace-fail "${ifElseM145 "@@uri_scheme" "@@URI_SCHEME@@"}" "x-scheme-handler/chromium;" \
      --replace-fail "${ifElseM145 "@@extra_desktop_entries" "@@EXTRA_DESKTOP_ENTRIES@@"}" ""

    # See https://github.com/NixOS/nixpkgs/issues/12433
    substituteInPlace $out/share/applications/${browserName}-browser.desktop \
      --replace-fail "[Desktop Entry]" "[Desktop Entry]''\nStartupWMClass=${browserName}-browser"

    if grep -F '@@' $out/share/applications/${browserName}-browser.desktop ; then
      echo "error: ${browserName}-browser.desktop contains unsubstituted placeholders" >&2
      exit 1
    fi
  '';

  passthru = { inherit sandboxExecutableName; };

  requiredSystemFeatures = [ "big-parallel" ];

  meta =
    let
      upstreamMeta = (import ./variants/meta.nix lib).${variant}.meta;
    in
    upstreamMeta
    // {
      license = if enableWideVine then lib.licenses.unfree else lib.licenses.bsd3;
      platforms = lib.platforms.linux;
      hydraPlatforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      timeout = 172800; # 48 hours (increased from the Hydra default of 10h)
    };
})
