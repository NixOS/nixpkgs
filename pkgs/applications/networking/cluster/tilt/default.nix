{ fetchFromGitHub
, callPackage
}:
let args = rec {
      /* Do not use "dev" as a version. If you do, Tilt will consider itself
        running in development environment and try to serve assets from the
        source tree, which is not there once build completes.  */
      version = "0.33.12";

      src = fetchFromGitHub {
        owner = "tilt-dev";
        repo = "tilt";
        rev = "v${version}";
        hash = "sha256-gZD99wu8RxqWOdIDz3L/OEFvYIS0r2xIpecB4sTRzqg=";
      };
    };

  tilt-assets = callPackage ./assets.nix args;
in callPackage ./binary.nix (args // { inherit tilt-assets; })

