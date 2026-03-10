{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2123";
    aarch64sha256 = "9ceHfTutGJAZlIwRUXJvpli7LtZFuz6vuDgIi7i9+kM=";
    x64sha256 = "HxKKwc4dOX1ADPl0axn5bDr21yG5FsrrzMyK95p6sy4=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2120";
    dev = true;
    aarch64sha256 = "3JKxLke1l7l+fxhIJWbXbMHK5wPgjZTEWcZd9IvrdPM=";
    x64sha256 = "N8lhSmQnj+Ee1A2eIOkhdhQnHBK3B6vFA3vrPAbYtaI=";
  } { };
}
