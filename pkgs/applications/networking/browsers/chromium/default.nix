{ newScope, stdenv, makeWrapper

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

in stdenv.mkDerivation {
  name = "chromium-${channel}-${chromium.browser.version}";

  buildInputs = [ makeWrapper ];

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    sandboxBinary = "${chromium.sandbox}/bin/chromium-sandbox";
  in ''
    ensureDir "$out/bin"
    ln -s "${chromium.browser}/share" "$out/share"
    makeWrapper "${browserBinary}" "$out/bin/chromium" \
      --set CHROMIUM_SANDBOX_BINARY_PATH "${sandboxBinary}" \
      --add-flags "${chromium.plugins.flagsEnabled}"
  '';

  inherit (chromium.browser) meta packageName;

  passthru = {
    mkDerivation = chromium.mkChromiumDerivation;
  };
}
