{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2079";
    x64sha256 = "y4ocLXxxEkGaw9O/vhX9MJnc56QgK37YPJkUwK2YS0U=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2082";
    x64sha256 = "Gl1BrLTSDLRTgrYQW/99o0XRjSIxvnNYRIViZEidcsM=";
    dev = true;
  } {};
}
