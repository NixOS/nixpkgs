{
  lib,
  stdenv,
  testers,
  package,
}:

lib.optionalAttrs stdenv.hostPlatform.isLinux {
  service = testers.runNixOSTest (import ./service.nix { inherit package; });
}
// lib.optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
  playwright = testers.runNixOSTest (
    import ./browser.nix {
      inherit package;
      browser = "playwright";
      image = {
        imageName = "browserless/chrome";
        imageDigest = "sha256:57d19e414d9fe4ae9d2ab12ba768c97f38d51246c5b31af55a009205c136012f";
        hash = "sha256-Or2XoaYtVBQKI6lYClk46dL97eKTpm8LAGTQxmmiTPc=";
        finalImageName = "browserless/chrome";
        finalImageTag = "latest";
      };
    }
  );
  webdriver = testers.runNixOSTest (
    import ./browser.nix {
      inherit package;
      browser = "webdriver";
      image = {
        imageName = "selenium/standalone-chrome";
        imageDigest = "sha256:7efe71e7e4a83bdf574b26bd354690928075e8f443223d2ced16a2c208eae1d7";
        hash = "sha256-FadKny0lZDnm45uGjWVz64qfJzNuJlHBA+f39neP0pw=";
        finalImageName = "selenium/standalone-chrome";
        finalImageTag = "latest";
      };
    }
  );
}
