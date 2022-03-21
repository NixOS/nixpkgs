{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2068";
    sha256 = "sha256-CseZQgjqr8B66Slf/yFZZsnRFc3zqCGKFAzSdMRQdNI=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2067";
    sha256 = "sha256-ViBBi9Ghh4dHg7Gmg4i/B+Q4OgDd4XiHNIs12qffZdg=";
    dev = true;
  } {};
}
