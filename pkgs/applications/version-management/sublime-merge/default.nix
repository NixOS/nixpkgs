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
    buildVersion = "2120";
    dev = true;
    aarch64sha256 = "3JKxLke1l7l+fxhIJWbXbMHK5wPgjZTEWcZd9IvrdPM=";
    x64sha256 = "N8lhSmQnj+Ee1A2eIOkhdhQnHBK3B6vFA3vrPAbYtaI=";
  } { };
}
