{ newScope, config, stdenv, fetchurl, makeWrapper
, llvmPackages_11, ed, gnugrep, coreutils, xdg_utils
, glib, gtk3, gnome3, gsettings-desktop-schemas, gn, fetchgit
, libva ? null
, pipewire_0_2
, gcc, nspr, nss, runCommand
, lib

# package customization
# Note: enable* flags should not require full rebuilds (i.e. only affect the wrapper)
, channel ? "stable"
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, enableVaapi ? false # Disabled by default due to unofficial support
, ungoogled ? false # Whether to build chromium or ungoogled-chromium
, cupsSupport ? true
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, commandLineArgs ? ""
}:

let
  llvmPackages = llvmPackages_11;
  stdenv = llvmPackages.stdenv;

  callPackage = newScope chromium;

  chromium = rec {
    inherit stdenv llvmPackages;

    upstream-info = (lib.importJSON ./upstream-info.json).${channel};

    mkChromiumDerivation = callPackage ./common.nix ({
      inherit channel gnome gnomeSupport gnomeKeyringSupport proprietaryCodecs
              cupsSupport pulseSupport ungoogled;
      gnChromium = gn.overrideAttrs (oldAttrs: {
        inherit (upstream-info.deps.gn) version;
        src = fetchgit {
          inherit (upstream-info.deps.gn) url rev sha256;
        };
      });
    });

    browser = callPackage ./browser.nix { inherit channel enableWideVine ungoogled; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash;
    };

    ungoogled-chromium = callPackage ./ungoogled.nix {};
  };

  pkgSuffix = if channel == "dev" then "unstable" else
    (if channel == "ungoogled-chromium" then "stable" else channel);
  pkgName = "google-chrome-${pkgSuffix}";
  chromeSrc = fetchurl {
    urls = map (repo: "${repo}/${pkgName}/${pkgName}_${version}-1_amd64.deb") [
      "https://dl.google.com/linux/chrome/deb/pool/main/g"
      "http://95.31.35.30/chrome/pool/main/g"
      "http://mirror.pcbeta.com/google/chrome/deb/pool/main/g"
      "http://repo.fdzh.org/chrome/deb/pool/main/g"
    ];
    sha256 = chromium.upstream-info.sha256bin64;
  };

  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
  widevineCdm = stdenv.mkDerivation {
    name = "chrome-widevine-cdm";

    src = chromeSrc;

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];

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
  name = lib.optionalString ungoogled "ungoogled-"
    + "chromium${suffix}-${version}";
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
    libPath = stdenv.lib.makeLibraryPath [ libva pipewire_0_2 ];

  in with stdenv.lib; ''
    mkdir -p "$out/bin"

    eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --add-flags ${escapeShellArg (escapeShellArg commandLineArgs)} \
      ${lib.optionalString enableVaapi "--add-flags --enable-accelerated-video-decode"} \
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
    export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | ${coreutils}/bin/tr ':' '\n' | ${gnugrep}/bin/grep -v /lib/libredirect\\\\.so$ | ${coreutils}/bin/tr '\n' ':')"

    export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    # Mainly for xdg-open but also other xdg-* tools:
    export PATH="${xdg_utils}/bin\''${PATH:+:}\$PATH"

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
    updateScript = ./update.py;
  };
}
