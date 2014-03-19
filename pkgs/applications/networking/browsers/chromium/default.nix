{ newScope

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
    browser = callPackage ./browser.nix {
      inherit channel enableSELinux enableNaCl useOpenSSL gnomeSupport
              gnomeKeyringSupport proprietaryCodecs enablePepperFlash
              enablePepperPDF cupsSupport pulseSupport;
    };
  };

in chromium.browser
