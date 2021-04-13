{ stdenv, mkChromiumDerivation, channel, enableWideVine, ungoogled }:

with stdenv.lib;

mkChromiumDerivation (base: rec {
  name = "chromium-browser";
  packageName = "chromium";
  buildTargets = [ "mksnapshot" "chrome_sandbox" "chrome" ];

  outputs = ["out" "sandbox"];

  sandboxExecutableName = "__chromium-suid-sandbox";

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.so "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
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
      $out/share/applications/chromium-browser.desktop

    substituteInPlace $out/share/applications/chromium-browser.desktop \
      --replace "@@MENUNAME@@" "Chromium" \
      --replace "@@PACKAGE@@" "chromium" \
      --replace "Exec=/usr/bin/@@USR_BIN_SYMLINK_NAME@@" "Exec=chromium"

    # Append more mime types to the end
    sed -i '/^MimeType=/ s,$,x-scheme-handler/webcal;x-scheme-handler/mailto;x-scheme-handler/about;x-scheme-handler/unknown,' \
      $out/share/applications/chromium-browser.desktop

    # See https://github.com/NixOS/nixpkgs/issues/12433
    sed -i \
      -e '/\[Desktop Entry\]/a\' \
      -e 'StartupWMClass=chromium-browser' \
      $out/share/applications/chromium-browser.desktop
  '';

  passthru = { inherit sandboxExecutableName; };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "An open source web browser from Google"
      + optionalString ungoogled ", with dependencies on Google web services removed";
    longDescription = ''
      Chromium is an open source web browser from Google that aims to build a
      safer, faster, and more stable way for all Internet users to experience
      the web. It has a minimalist user interface and provides the vast majority
      of source code for Google Chrome (which has some additional features).
    '';
    homepage = if ungoogled
      then "https://github.com/Eloston/ungoogled-chromium"
      else "https://www.chromium.org/";
    maintainers = with maintainers; if ungoogled
      then [ squalus primeos ]
      else [ primeos thefloweringash bendlas ];
    license = if enableWideVine then licenses.unfree else licenses.bsd3;
    platforms = platforms.linux;
    hydraPlatforms = if (channel == "stable" || channel == "ungoogled-chromium")
      then ["aarch64-linux" "x86_64-linux"]
      else [];
    timeout = 172800; # 48 hours (increased from the Hydra default of 10h)
  };
})
