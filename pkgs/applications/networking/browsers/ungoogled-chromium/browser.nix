{ stdenv, mkChromiumDerivation }:

with stdenv.lib;

mkChromiumDerivation (base: rec {
  name = "ungoogled-chromium";
  packageName = "ungoogled-chromium";
  buildTargets = [ "mksnapshot" "chrome_sandbox" "chrome" ];

  outputs = ["out" "sandbox"];

  sandboxExecutableName = "__chromium-suid-sandbox";

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome" "$libExecPath/$packageName"

    if [ -e "$buildPath/libwidevinecdmadapter.so" ]; then
      cp -v "$buildPath/libwidevinecdmadapter.so" \
            "$libExecPath/libwidevinecdmadapter.so"
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
  '';

  passthru = { inherit sandboxExecutableName; };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Modifications to Google Chromium for removing Google integration and enhancing privacy, control, and transparency";
    longDescription = "
      A number of features or background services communicate with Google servers despite the absence of an associated Google account or compiled-in Google API keys. Furthermore, the normal build process for Chromium involves running Google's own high-level commands that invoke many scripts and utilities, some of which download and use pre-built binaries provided by Google. Even the final build output includes some pre-built binaries. Fortunately, the source code is available for everything. Ungoogled-chromium is a set of configuration flags, patches, and custom scripts";
    homepage = https://github.com/Eloston/ungoogled-chromium;
    maintainers = with maintainers; [ ylwghst ];
    license = licenses.bsd3;
    platforms = platforms.linux;
    hydraPlatforms = x86_64-linux;
  };
})
