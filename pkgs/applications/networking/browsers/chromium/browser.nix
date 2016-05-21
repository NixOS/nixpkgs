{ stdenv, mkChromiumDerivation, channel, enableNaCl }:

with stdenv.lib;

mkChromiumDerivation (base: rec {
  name = "chromium-browser";
  packageName = "chromium";
  buildTargets = [ "mksnapshot" "chrome_sandbox" "chrome" ];

  # Trying to run NaCl apps with a stripped nacl_irt_*.nexe file results in a
  # segfault. We therefore disable stripping here and manually strip the
  # binaries when they're copied.
  dontStrip = true;

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome" "$libExecPath/$packageName"
    strip -S "$libExecPath/$packageName"
    cp -v "$buildPath/chrome_sandbox" "$libExecPath/chrome-sandbox"
    strip -S "$libExecPath/chrome-sandbox"

    ${optionalString enableNaCl ''
      cp -v "$buildPath/nacl_helper" "$libExecPath/"
      strip -S "$libExecPath/nacl_helper"
      cp -v "$buildPath/nacl_helper_bootstrap" "$libExecPath/"
      strip -S "$libExecPath/nacl_helper_bootstrap"
      cp -v "$buildPath/"nacl_irt_*.nexe "$libExecPath/"
    ''}

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

  meta = {
    description = "An open source web browser from Google";
    homepage = http://www.chromium.org/;
    maintainers = with maintainers; [ chaoflow ];
    license = licenses.bsd3;
    platforms = platforms.linux;
    hydraPlatforms = if channel == "stable" then ["x86_64-linux"] else [];
    requiredSystemFeatures = [ "big-parallel" ];
  };
})
