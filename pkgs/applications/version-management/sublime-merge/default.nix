{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2071";
    sha256 = "xYVk5Fx6VdoHzf0cbmhwKyEr5HDEZgPgDoBWQg/tS0U=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2067";
    sha256 = "sha256-ViBBi9Ghh4dHg7Gmg4i/B+Q4OgDd4XiHNIs12qffZdg=";
    dev = true;
  } {};
}
