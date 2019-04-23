{ stdenv, mkChromiumDerivation, channel, upstream-info, gcc, glib, nspr, nss, patchelfUnstable, enableWideVine }:

with stdenv.lib;

let
  mkrpath = p: "${makeSearchPathOutput "lib" "lib64" p}:${makeLibraryPath p}";
  widevine = stdenv.mkDerivation {
    name = "chromium-binary-plugin-widevine";

    src = upstream-info.binary;

    nativeBuildInputs = [ patchelfUnstable ];

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];

    unpackCmd = let
      chan = if upstream-info.channel == "dev"    then "chrome-unstable"
        else if upstream-info.channel == "stable" then "chrome"
        else "chrome-${upstream-info.channel}";
    in ''
      mkdir -p plugins
      ar p "$src" data.tar.xz | tar xJ -C plugins --strip-components=4 \
        ./opt/google/${chan}/libwidevinecdm.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    PATCH_RPATH = mkrpath [ gcc.cc glib nspr nss ];

    patchPhase = ''
      patchelf --set-rpath "$PATCH_RPATH" libwidevinecdm.so
    '';

    installPhase = ''
      install -vD libwidevinecdm.so \
        "$out/lib/libwidevinecdm.so"
    '';

    meta.platforms = platforms.x86_64;
  };
in mkChromiumDerivation (base: rec {
  name = "chromium-browser";
  packageName = "chromium";
  buildTargets = [ "mksnapshot" "chrome_sandbox" "chrome" ];

  outputs = ["out" "sandbox"];

  sandboxExecutableName = "__chromium-suid-sandbox";

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome" "$libExecPath/$packageName"

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

    ${optionalString enableWideVine "ln -s ${widevine}/lib/libwidevinecdm.so \"$libExecPath/libwidevinecdm.so\""}
  '';

  passthru = { inherit sandboxExecutableName; };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "An open source web browser from Google";
    homepage = http://www.chromium.org/;
    maintainers = with maintainers; [ bendlas ivan ];
    license = licenses.bsd3;
    platforms = platforms.linux;
    hydraPlatforms = if channel == "stable" then ["aarch64-linux" "x86_64-linux"] else [];
    timeout = 172800; # 48 hours
  };
})
