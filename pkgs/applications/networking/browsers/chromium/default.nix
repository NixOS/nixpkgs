{ newScope, config, stdenv, makeWrapper
, buildPackages
, ed, gnugrep, coreutils, xdg-utils
, glib, gtk3, gtk4, adwaita-icon-theme, gsettings-desktop-schemas, gn, fetchgit
, libva, pipewire, wayland
, runCommand
, lib, libkrb5
, widevine-cdm
, electron-source # for warnObsoleteVersionConditional

# package customization
# Note: enable* flags should not require full rebuilds (i.e. only affect the wrapper)
, upstream-info ? (lib.importJSON ./info.json).${if !ungoogled then "chromium" else "ungoogled-chromium"}
, proprietaryCodecs ? true
, enableWideVine ? false
, ungoogled ? false # Whether to build chromium or ungoogled-chromium
, cupsSupport ? true
, pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux
, commandLineArgs ? ""
, pkgsBuildBuild
, pkgs
}:

let
  stdenv = pkgs.rustc.llvmPackages.stdenv;

  # Helper functions for changes that depend on specific versions:
  warnObsoleteVersionConditional = min-version: result:
    let min-supported-version = (lib.head (lib.attrValues electron-source)).unwrapped.info.chromium.version;
    in lib.warnIf
         (lib.versionAtLeast min-supported-version min-version)
         "chromium: min-supported-version ${min-supported-version} is newer than a conditional bounded at ${min-version}. You can safely delete it."
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
    inherit stdenv upstream-info;

    mkChromiumDerivation = callPackage ./common.nix ({
      inherit chromiumVersionAtLeast versionRange;
      inherit proprietaryCodecs
              cupsSupport pulseSupport ungoogled;
      gnChromium = buildPackages.gn.overrideAttrs (oldAttrs: {
        version = if (upstream-info.deps.gn ? "version") then upstream-info.deps.gn.version else "0";
        src = fetchgit {
          url = "https://gn.googlesource.com/gn";
          inherit (upstream-info.deps.gn) rev hash;
        };
      } // lib.optionalAttrs (chromiumVersionAtLeast "127") {
        # Relax hardening as otherwise gn unstable 2024-06-06 and later fail with:
        # cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
        hardeningDisable = [ "format" ];
      } // lib.optionalAttrs (chromiumVersionAtLeast "130") {
        # At the time of writing, gn is at v2024-05-13 and has a backported patch.
        # This patch appears to be already present in v2024-09-09 (from M130), which
        # results in the patch not applying and thus failing the build.
        # As a work around until gn is updated again, we filter specifically that patch out.
        patches = lib.filter (e: lib.getName e != "LFS64.patch") oldAttrs.patches;
      });
    });

    browser = callPackage ./browser.nix {
      inherit chromiumVersionAtLeast enableWideVine ungoogled;
    };

    # ungoogled-chromium is, contrary to its name, not a build of
    # chromium.  It is a patched copy of chromium's *source code*.
    # Therefore, it needs to come from buildPackages, because it
    # contains python scripts which get /nix/store/.../bin/python3
    # patched into their shebangs.
    ungoogled-chromium = pkgsBuildBuild.callPackage ./ungoogled.nix {};
  };

  sandboxExecutableName = chromium.browser.passthru.sandboxExecutableName;

  # We want users to be able to enableWideVine without rebuilding all of
  # chromium, so we have a separate derivation here that copies chromium
  # and adds the unfree WidevineCdm.
  chromiumWV = let browser = chromium.browser; in if enableWideVine then
    runCommand (browser.name + "-wv") { version = browser.version; }
      ''
        mkdir -p $out
        cp -a ${browser}/* $out/
        chmod u+w $out/libexec/chromium
        cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm $out/libexec/chromium/
      ''
    else browser;

in stdenv.mkDerivation {
  pname = lib.optionalString ungoogled "ungoogled-"
    + "chromium";
  inherit (chromium.browser) version;

  nativeBuildInputs = [
    makeWrapper ed
  ];

  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk3 gtk4

    # needed for XDG_ICON_DIRS
    adwaita-icon-theme

    # Needed for kerberos at runtime
    libkrb5
  ];

  outputs = ["out" "sandbox"];

  buildCommand = let
    browserBinary = "${chromiumWV}/libexec/chromium/chromium";
    libPath = lib.makeLibraryPath [ libva pipewire wayland gtk3 gtk4 libkrb5 ];

  in ''
    mkdir -p "$out/bin"

    makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

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

  '' + lib.optionalString (!xdg-utils.meta.broken) ''
    # Mainly for xdg-open but also other xdg-* tools (this is only a fallback; \$PATH is suffixed so that other implementations can be used):
    export PATH="\$PATH\''${PATH:+:}${xdg-utils}/bin"
  '' + ''

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
