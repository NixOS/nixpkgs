{ newScope, stdenv, makeWrapper, makeDesktopItem, ed
, glib, gtk3, gnome3, gsettings-desktop-schemas

# package customization
, channel ? "stable"
, enableNaCl ? false
, enableHotwording ? false
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, cupsSupport ? true
, pulseSupport ? false
, commandLineArgs ? ""
}:

let
  callPackage = newScope chromium;

  chromium = {
    upstream-info = (callPackage ./update.nix {}).getChannel channel;

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableNaCl enableHotwording gnomeSupport gnome
              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
              enableWideVine;
    };

    browser = callPackage ./browser.nix { inherit channel; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enableWideVine;
    };
  };

  desktopItem = makeDesktopItem {
    name = "chromium-browser";
    exec = "chromium %U";
    icon = "chromium";
    comment = "An open source web browser from Google";
    desktopName = "Chromium";
    genericName = "Web browser";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/mailto"
      "x-scheme-handler/webcal"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
    categories = "Network;WebBrowser";
    extraEntries = ''
      StartupWMClass=chromium-browser
    '';
  };

  suffix = if channel != "stable" then "-" + channel else "";

  sandboxExecutableName = chromium.browser.passthru.sandboxExecutableName;

  version = chromium.browser.version;

  inherit (stdenv.lib) versionAtLeast;

in stdenv.mkDerivation {
  name = "chromium${suffix}-${version}";
  inherit version;

  buildInputs = [
    makeWrapper ed

    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk3

    # needed for XDG_ICON_DIRS
    gnome3.defaultIconTheme
  ];

  outputs = ["out" "sandbox"];

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    getWrapperFlags = plugin: "$(< \"${plugin}/nix-support/wrapper-flags\")";
  in with stdenv.lib; ''
    mkdir -p "$out/bin"

    eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
      ${commandLineArgs} \
      ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}

    ed -v -s "$out/bin/chromium" << EOF
    2i

    if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
    then
      export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
    else
      export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
    fi

    # libredirect causes chromium to deadlock on startup
    export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | tr ':' '\n' | grep -v /lib/libredirect\\\\.so$ | tr '\n' ':')"

    export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    .
    w
    EOF

    ln -sv "${chromium.browser.sandbox}" "$sandbox"

    ln -s "$out/bin/chromium" "$out/bin/chromium-browser"

    mkdir -p "$out/share/applications"
    for f in '${chromium.browser}'/share/*; do # hello emacs */
      ln -s -t "$out/share/" "$f"
    done
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  inherit (chromium.browser) packageName;
  meta = chromium.browser.meta // {
    broken = if enableWideVine then
          builtins.trace "WARNING: WideVine is not functional, please only use for testing"
             true
        else false;
  };

  passthru = {
    inherit (chromium) upstream-info browser;
    mkDerivation = chromium.mkChromiumDerivation;
    inherit sandboxExecutableName;
  };
}
