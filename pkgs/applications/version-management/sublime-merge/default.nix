{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2125";
    aarch64sha256 = "Zs4VKbFKkw4KRViX/QGVtVo4hluJ3HVen39Vq3Xz3KI=";
    x64sha256 = "0Zlv4nZMb2FDUG5KLkHTXJjdRzTa3TuNL54yacFVR/c=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2124";
    dev = true;
    aarch64sha256 = "jYd22OPZnC6X2Ceuzz4ZiqqD1pFsmQsrihIqY3A+gAc=";
    x64sha256 = "3Tm9TH+kzTCElFLI44K00CXTuV98+uCswy4auXcY+YY=";
  } { };
}
