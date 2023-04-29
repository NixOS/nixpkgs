{ newScope, config, stdenv, fetchurl, makeWrapper
, llvmPackages_15
, ed, gnugrep, coreutils, xdg-utils
, glib, gtk3, gtk4, gnome, gsettings-desktop-schemas, gn, fetchgit
, libva, pipewire, wayland
, gcc, nspr, nss, runCommand
, lib, libkrb5

# package customization
# Note: enable* flags should not require full rebuilds (i.e. only affect the wrapper)
, channel ? "stable"
, proprietaryCodecs ? true
, enableWideVine ? false
, ungoogled ? false # Whether to build chromium or ungoogled-chromium
, cupsSupport ? true
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, commandLineArgs ? ""
}:

let
  llvmPackages = llvmPackages_15;
  stdenv = llvmPackages.stdenv;

  upstream-info = (lib.importJSON ./upstream-info.json).${channel};

  # Helper functions for changes that depend on specific versions:
  warnObsoleteVersionConditional = min-version: result:
    let ungoogled-version = (lib.importJSON ./upstream-info.json).ungoogled-chromium.version;
    in lib.warnIf
         (lib.versionAtLeast ungoogled-version min-version)
         "chromium: ungoogled version ${ungoogled-version} is newer than a conditional bounded at ${min-version}. You can safely delete it."
         result;
  chromiumVersionAtLeast = min-version:
    let result = lib.versionAtLeast upstream-info.version min-version;
    in  warnObsoleteVersionConditional min-version result;
  versionRange = min-version: upto-version:
    let inherit (upstream-info) version;
        result = lib.versionAtLeast version min-version && lib.versionOlder version upto-version;
    in warnObsoleteVersionConditional upto-version result;

  callPackage = newScope chromium;

  chromium = rec {
    inherit stdenv llvmPackages upstream-info;

    mkChromiumDerivation = callPackage ./common.nix ({
      inherit channel chromiumVersionAtLeast versionRange;
      inherit proprietaryCodecs
              cupsSupport pulseSupport ungoogled;
      gnChromium = gn.overrideAttrs (oldAttrs: {
        inherit (upstream-info.deps.gn) version;
        src = fetchgit {
          inherit (upstream-info.deps.gn) url rev sha256;
        };
      });
    });

    browser = callPackage ./browser.nix {
      inherit channel chromiumVersionAtLeast enableWideVine ungoogled;
    };

    ungoogled-chromium = callPackage ./ungoogled.nix {};
  };

  pkgSuffix = if channel == "dev" then "unstable" else
    (if channel == "ungoogled-chromium" then "stable" else channel);
  pkgName = "google-chrome-${pkgSuffix}";
  chromeSrc =
    let
      # Use the latest stable Chrome version if necessary:
      version = if chromium.upstream-info.sha256bin64 != null
        then chromium.upstream-info.version
        else (lib.importJSON ./upstream-info.json).stable.version;
      sha256 = if chromium.upstream-info.sha256bin64 != null
        then chromium.upstream-info.sha256bin64
        else (lib.importJSON ./upstream-info.json).stable.sha256bin64;
    in fetchurl {
      urls = map (repo: "${repo}/${pkgName}/${pkgName}_${version}-1_amd64.deb") [
        "https://dl.google.com/linux/chrome/deb/pool/main/g"
        "http://95.31.35.30/chrome/pool/main/g"
        "http://mirror.pcbeta.com/google/chrome/deb/pool/main/g"
        "http://repo.fdzh.org/chrome/deb/pool/main/g"
      ];
      inherit sha256;
  };

  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
  widevineCdm = stdenv.mkDerivation {
    name = "chrome-widevine-cdm";

    src = chromeSrc;

    unpackCmd = let
      widevineCdmPath =
        if (channel == "stable" || channel == "ungoogled-chromium") then
          "./opt/google/chrome/WidevineCdm"
        else if channel == "beta" then
          "./opt/google/chrome-beta/WidevineCdm"
        else if channel == "dev" then
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

  suffix = if (channel == "stable" || channel == "ungoogled-chromium")
    then ""
    else "-" + channel;

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

in stdenv.mkDerivation {
  pname = lib.optionalString ungoogled "ungoogled-"
    + "chromium${suffix}";
  inherit version;

  nativeBuildInputs = [
    makeWrapper ed
  ];

  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk3 gtk4

    # needed for XDG_ICON_DIRS
    gnome.adwaita-icon-theme

    # Needed for kerberos at runtime
    libkrb5
  ];

  outputs = ["out" "sandbox"];

  buildCommand = let
    browserBinary = "${chromiumWV}/libexec/chromium/chromium";
    libPath = lib.makeLibraryPath [ libva pipewire wayland gtk3 gtk4 libkrb5 ];

  in with lib; ''
    mkdir -p "$out/bin"

    makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${escapeShellArg commandLineArgs}

    ed -v -s "$out/bin/chromium" << EOF
    2i

    if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
    then
      export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
    else
      export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
    fi

    # Make generated desktop shortcuts have a valid executable name.
    export CHROME_WRAPPER='chromium'

  '' + lib.optionalString (libPath != "") ''
    # To avoid loading .so files from cwd, LD_LIBRARY_PATH here must not
    # contain an empty section before or after a colon.
    export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}${libPath}"
  '' + ''

    # libredirect causes chromium to deadlock on startup
    export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | ${coreutils}/bin/tr ':' '\n' | ${gnugrep}/bin/grep -v /lib/libredirect\\\\.so$ | ${coreutils}/bin/tr '\n' ':')"

    export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    # Mainly for xdg-open but also other xdg-* tools (this is only a fallback; \$PATH is suffixed so that other implementations can be used):
    export PATH="\$PATH\''${PATH:+:}${xdg-utils}/bin"

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
    inherit chromeSrc sandboxExecutableName;
  };
}
