{ newScope, config, stdenv, llvmPackages, gcc8Stdenv, llvmPackages_8
, makeWrapper, ed
, glib, gtk3, gnome3, gsettings-desktop-schemas
, libva ? null
, gcc, nspr, nss, patchelfUnstable, runCommand
, lib

# package customization
, channel ? "stable"
, enableNaCl ? false
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, useVaapi ? false # test video on radeon, before enabling this
, cupsSupport ? true
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, commandLineArgs ? ""
}:

let
  stdenv_ = if stdenv.isAarch64 then gcc8Stdenv else llvmPackages_8.stdenv;
  llvmPackages_ = if stdenv.isAarch64 then llvmPackages else llvmPackages_8;
in let
  stdenv = stdenv_;
  llvmPackages = llvmPackages_;

  callPackage = newScope chromium;

  chromium = {
    inherit stdenv llvmPackages;

    upstream-info = (callPackage ./update.nix {}).getChannel channel;

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableNaCl gnomeSupport gnome
              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
              useVaapi;
    };

    browser = callPackage ./browser.nix { inherit channel enableWideVine; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash;
    };
  };

  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
  widevine = let upstream-info = chromium.upstream-info; in stdenv.mkDerivation {
    name = "chromium-binary-plugin-widevine";

    # The .deb file for Google Chrome
    src = upstream-info.binary;

    nativeBuildInputs = [ patchelfUnstable ];

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];

    unpackCmd = let
      soPath =
        if upstream-info.channel == "stable" then
          "./opt/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
        else if upstream-info.channel == "beta" then
          "./opt/google/chrome-beta/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
        else if upstream-info.channel == "dev" then
          "./opt/google/chrome-unstable/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
        else
          throw "Unknown chromium channel.";
    in ''
      mkdir -p plugins
      # Extract just libwidevinecdm.so from upstream's .deb file
      ar p "$src" data.tar.xz | tar xJ -C plugins ${soPath}
      mv plugins/${soPath} plugins/
      rm -rf plugins/opt
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

    meta = {
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.unfree;
    };
  };

  suffix = if channel != "stable" then "-" + channel else "";

  sandboxExecutableName = chromium.browser.passthru.sandboxExecutableName;

  version = chromium.browser.version;

  # We want users to be able to enableWideVine without rebuilding all of
  # chromium, so we have a separate derivation here that copies chromium
  # and adds the unfree libwidevinecdm.so.
  chromiumWV = let browser = chromium.browser; in if enableWideVine then
    runCommand (browser.name + "-wv") { version = browser.version; }
      ''
        mkdir -p $out
        cp -a ${browser}/* $out/
        chmod u+w $out/libexec/chromium
        mkdir -p $out/libexec/chromium/WidevineCdm/_platform_specific/linux_x64
        cp ${widevine}/lib/libwidevinecdm.so $out/libexec/chromium/WidevineCdm/_platform_specific/linux_x64/
      ''
    else browser;
in stdenv.mkDerivation {
  name = "chromium${suffix}-${version}";
  inherit version;

  buildInputs = [
    makeWrapper ed

    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk3

    # needed for XDG_ICON_DIRS
    gnome3.adwaita-icon-theme
  ];

  outputs = ["out" "sandbox"];

  buildCommand = let
    browserBinary = "${chromiumWV}/libexec/chromium/chromium";
    getWrapperFlags = plugin: "$(< \"${plugin}/nix-support/wrapper-flags\")";
    libPath = stdenv.lib.makeLibraryPath ([]
      ++ stdenv.lib.optional useVaapi libva
    );

  in with stdenv.lib; ''
    mkdir -p "$out/bin"

    eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --add-flags ${escapeShellArg (escapeShellArg commandLineArgs)} \
      ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}

    ed -v -s "$out/bin/chromium" << EOF
    2i

    if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
    then
      export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
    else
      export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
    fi

    export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:${libPath}"

    # libredirect causes chromium to deadlock on startup
    export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | tr ':' '\n' | grep -v /lib/libredirect\\\\.so$ | tr '\n' ':')"

    export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    .
    w
    EOF

    ln -sv "${chromium.browser.sandbox}" "$sandbox"

    ln -s "$out/bin/chromium" "$out/bin/chromium-browser"

    mkdir -p "$out/share"
    for f in '${chromium.browser}'/share/*; do # hello emacs */
      ln -s -t "$out/share/" "$f"
    done
  '';

  inherit (chromium.browser) packageName;
  meta = chromium.browser.meta;
  passthru = {
    inherit (chromium) upstream-info browser;
    mkDerivation = chromium.mkChromiumDerivation;
    inherit sandboxExecutableName;
  };
}
