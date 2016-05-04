{ newScope, stdenv, makeWrapper, makeDesktopItem

# package customization
, channel ? "stable"
, enableSELinux ? false
, enableNaCl ? false
, enableHotwording ? false
, gnomeSupport ? false
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, cupsSupport ? true
, pulseSupport ? false
, hiDPISupport ? false
}:

let
  callPackage = newScope chromium;

  chromium = {
    upstream-info = (callPackage ./update.nix {}).getChannel channel;

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableSELinux enableNaCl enableHotwording gnomeSupport
              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
              hiDPISupport;
    };

    browser = callPackage ./browser.nix { inherit channel; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enableWideVine;
    };
  };

  desktopItem = makeDesktopItem {
    name = "chromium";
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

in stdenv.mkDerivation {
  name = "chromium${suffix}-${chromium.browser.version}";

  buildInputs = [ makeWrapper ];

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    getWrapperFlags = plugin: "$(< \"${plugin}/nix-support/wrapper-flags\")";
  in with stdenv.lib; ''
    mkdir -p "$out/bin" "$out/share/applications"

    ln -s "${chromium.browser}/share" "$out/share"
    eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
      ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}

    ln -s "$out/bin/chromium" "$out/bin/chromium-browser"
    ln -s "${chromium.browser}/share/icons" "$out/share/icons"
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  inherit (chromium.browser) meta packageName;

  passthru = {
    mkDerivation = chromium.mkChromiumDerivation;
  };
}
