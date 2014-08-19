{ newScope, stdenv, makeWrapper, makeDesktopItem

# package customization
, channel ? "stable"
, enableSELinux ? false
, enableNaCl ? false
, useOpenSSL ? false
, gnomeSupport ? false
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enablePepperPDF ? false
, cupsSupport ? false
, pulseSupport ? false
}:

let
  callPackage = newScope chromium;

  chromium = {
    source = callPackage ./source {
      inherit channel;
      # XXX: common config
      inherit useOpenSSL;
    };

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableSELinux enableNaCl useOpenSSL gnomeSupport
              gnomeKeyringSupport proprietaryCodecs cupsSupport
              pulseSupport;
    };

    browser = callPackage ./browser.nix { };
    sandbox = callPackage ./sandbox.nix { };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enablePepperPDF;
    };
  };

  desktopItem = makeDesktopItem {
    name = "chromium";
    exec = "chromium";
    icon = "${chromium.browser}/share/icons/hicolor/48x48/apps/chromium.png";
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
    ];
    categories = "Network;WebBrowser";
  };

in stdenv.mkDerivation {
  name = "chromium-${channel}-${chromium.browser.version}";

  buildInputs = [ makeWrapper ];

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    sandboxBinary = "${chromium.sandbox}/bin/chromium-sandbox";
  in ''
    mkdir -p "$out/bin" "$out/share/applications"

    ln -s "${chromium.browser}/share" "$out/share"
    makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --set CHROMIUM_SANDBOX_BINARY_PATH "${sandboxBinary}" \
      --add-flags "${chromium.plugins.flagsEnabled}"

    ln -s "${chromium.browser}/share/icons" "$out/share/icons"
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  inherit (chromium.browser) meta packageName;

  passthru = {
    mkDerivation = chromium.mkChromiumDerivation;
  };
}
