{ fetchFromGitHub
, callPackage
}:
let args = rec {
      /* Do not use "dev" as a version. If you do, Tilt will consider itself
        running in development environment and try to serve assets from the
        source tree, which is not there once build completes.  */
      version = "0.33.10";

      src = fetchFromGitHub {
        owner = "tilt-dev";
        repo = "tilt";
        rev = "v${version}";
        hash = "sha256-LPb2tC3xIGhjiLYkTU+NBIUoqiicO2ORM6Nt1eTnwQs=";
      };
    };

  tilt-assets = callPackage ./assets.nix args;
in callPackage ./binary.nix (args // { inherit tilt-assets; })

