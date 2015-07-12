{ newScope, stdenv, makeWrapper, makeDesktopItem

# package customization
, channel ? "stable"
, enableSELinux ? false
, enableNaCl ? false
, enableHotwording ? false
, useOpenSSL ? false
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
    source = callPackage ./source {
      inherit channel;
      # XXX: common config
      inherit useOpenSSL;
    };

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableSELinux enableNaCl enableHotwording useOpenSSL gnomeSupport
              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
              hiDPISupport;
    };

    browser = callPackage ./browser.nix { };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enableWideVine;
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
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
    categories = "Network;WebBrowser";
  };

  suffix = if channel != "stable" then "-" + channel else "";

in stdenv.mkDerivation {
  name = "chromium${suffix}-${chromium.browser.version}";

  buildInputs = [ makeWrapper ] ++ chromium.plugins.enabledPlugins;

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    mkEnvVar = key: val: "--set '${key}' '${val}'";
    envVars = chromium.plugins.settings.envVars or {};
    flags = chromium.plugins.settings.flags or [];
  in with stdenv.lib; ''
    mkdir -p "$out/bin" "$out/share/applications"

    ln -s "${chromium.browser}/share" "$out/share"
    makeWrapper "${browserBinary}" "$out/bin/chromium" \
      ${concatStrings (mapAttrsToList mkEnvVar envVars)} \
      --add-flags "${concatStringsSep " " flags}"

    ln -s "$out/bin/chromium" "$out/bin/chromium-browser"
    ln -s "${chromium.browser}/share/icons" "$out/share/icons"
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  inherit (chromium.browser) meta packageName;

  passthru = {
    mkDerivation = chromium.mkChromiumDerivation;
  };
}
