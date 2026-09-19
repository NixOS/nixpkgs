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
    buildVersion = "2131";
    dev = true;
    aarch64sha256 = "9tiHTnSiawmNnNkQXHQi5/e5g1BuBNsZ/JK4xKlu0Ic=";
    x64sha256 = "0NcyF9+hPC0pj9d6GCM0x2AFKM0d5AWdOgxIjMj2DuU=";
  } { };
}
