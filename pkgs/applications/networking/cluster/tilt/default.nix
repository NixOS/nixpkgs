{ fetchFromGitHub
, callPackage
}:
let args = rec {
      /* Do not use "dev" as a version. If you do, Tilt will consider itself
        running in development environment and try to serve assets from the
        source tree, which is not there once build completes.  */
      version = "0.33.13";

      src = fetchFromGitHub {
        owner = "tilt-dev";
        repo = "tilt";
        rev = "v${version}";
        hash = "sha256-B1kau6G56Iz6Yso2KpJCPE18yznhKCmq+Pabi2sxSmI=";
      };
    };

  tilt-assets = callPackage ./assets.nix args;
in callPackage ./binary.nix (args // { inherit tilt-assets; })

