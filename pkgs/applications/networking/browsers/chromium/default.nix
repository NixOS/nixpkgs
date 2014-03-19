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
    source = callPackage ./source.nix {
      inherit channel;
      # XXX: common config
      inherit useOpenSSL;
    };

    browser = callPackage ./browser.nix {
      inherit enableSELinux enableNaCl useOpenSSL gnomeSupport
              gnomeKeyringSupport proprietaryCodecs cupsSupport
              pulseSupport;
    };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enablePepperPDF;
    };
  };

in chromium.browser
