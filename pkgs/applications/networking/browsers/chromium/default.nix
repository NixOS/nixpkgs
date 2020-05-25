{ newScope, config, stdenv, llvmPackages_9, llvmPackages_10
, makeWrapper, ed
, glib, gtk3, gnome3, gsettings-desktop-schemas, gn, fetchgit
, libva ? null
, gcc, nspr, nss, patchelfUnstable, runCommand
, lib

# package customization
# Note: enable* flags should not require full rebuilds (i.e. only affect the wrapper)
, channel ? "stable"
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, useVaapi ? false # Deprecated, use enableVaapi instead!
, enableVaapi ? false # Disabled by default due to unofficial support and issues on radeon
, useOzone ? false
, cupsSupport ? true
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, commandLineArgs ? ""
}:

let
  llvmPackages = if channel != "stable"
    then llvmPackages_10
    else llvmPackages_9;
  stdenv = llvmPackages.stdenv;

  callPackage = newScope chromium;

  chromium = {
    inherit stdenv llvmPackages;

    upstream-info = (callPackage ./update.nix {}).getChannel channel;

    mkChromiumDerivation = callPackage ./common.nix ({
      inherit gnome gnomeSupport gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport useOzone;
      gnChromium = gn;
    } // lib.optionalAttrs (channel != "stable") {
      # TODO: Remove after we can update gn for the stable channel (backward incompatible changes):
      gnChromium = gn.overrideAttrs (oldAttrs: {
        version = "2020-03-23";
        src = fetchgit {
          url = "https://gn.googlesource.com/gn";
          rev = "5ed3c9cc67b090d5e311e4bd2aba072173e82db9";
          sha256 = "00y2d35wvqmx9glaqhfb62wdgbfpwr77v0934nnvh9ks71vnsjqy";
        };
      });
    });

    browser = callPackage ./browser.nix { inherit channel enableWideVine; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash;
    };
  };

  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
  widevineCdm = let upstream-info = chromium.upstream-info; in stdenv.mkDerivation {
    name = "chrome-widevine-cdm";

    # The .deb file for Google Chrome
    src = upstream-info.binary;

    nativeBuildInputs = [ patchelfUnstable ];

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];

    unpackCmd = let
      widevineCdmPath =
        if upstream-info.channel == "stable" then
          "./opt/google/chrome/WidevineCdm"
        else if upstream-info.channel == "beta" then
          "./opt/google/chrome-beta/WidevineCdm"
        else if upstream-info.channel == "dev" then
          "./opt/google/chrome-unstable/WidevineCdm"
        else
          throw "Unknown chromium channel.";
    in ''
      # Extract just WidevineCdm from upstream's .deb file
      ar p "$src" data.tar.xz | tar xJ "${widevineCdmPath}"

      # Move things around so that we don't have to reference a particular
      # chrome-* directory later.
      mv "${widevineCdmPath}" ./

      # unpackCmd wants a single output directory; let it take WidevineCdm/
      rm -rf opt
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    PATCH_RPATH = mkrpath [ gcc.cc glib nspr nss ];

    patchPhase = ''
      patchelf --set-rpath "$PATCH_RPATH" _platform_specific/linux_x64/libwidevinecdm.so
    '';

    installPhase = ''
      mkdir -p $out/WidevineCdm
      cp -a * $out/WidevineCdm/
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
  # and adds the unfree WidevineCdm.
  chromiumWV = let browser = chromium.browser; in if enableWideVine then
    runCommand (browser.name + "-wv") { version = browser.version; }
      ''
        mkdir -p $out
        cp -a ${browser}/* $out/
        chmod u+w $out/libexec/chromium
        cp -a ${widevineCdm}/WidevineCdm $out/libexec/chromium/
      ''
    else browser;

  optionalVaapiFlags = if useVaapi # TODO: Remove after 20.09:
    then throw ''
      Chromium's useVaapi was replaced by enableVaapi and you don't need to pass
      "--ignore-gpu-blacklist" anymore (also no rebuilds are required anymore).
    '' else lib.optionalString
      (!enableVaapi)
      "--add-flags --disable-accelerated-video-decode --add-flags --disable-accelerated-video-encode";
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
    libPath = stdenv.lib.makeLibraryPath [ libva ];

  in with stdenv.lib; ''
    mkdir -p "$out/bin"

    eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --add-flags ${escapeShellArg (escapeShellArg commandLineArgs)} \
      ${optionalVaapiFlags} \
      ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}

    ed -v -s "$out/bin/chromium" << EOF
    2i

    if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
    then
      export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
    else
      export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
    fi

  '' + lib.optionalString (libPath != "") ''
    # To avoid loading .so files from cwd, LD_LIBRARY_PATH here must not
    # contain an empty section before or after a colon.
    export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}${libPath}"
  '' + ''

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
