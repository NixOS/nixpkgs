{ callPackage }:

rec {
  fetchFromMPM = callPackage ./fetcher.nix { inherit matlab-package-manager; };
  matlab = callPackage ./matlab.nix { inherit fetchFromMPM matlab-package-manager; };
  matlab-package-manager = callPackage ./mpm.nix { };
}
