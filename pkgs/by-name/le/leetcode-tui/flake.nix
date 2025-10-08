{
  description = "Terminal UI for LeetCode";

  inputs = {
    nixpkgs.url = "path:../../../..";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        leetcode-tui = pkgs.callPackage ./package.nix { pkgs = pkgs; };
      in {
        packages = {
          default = leetcode-tui;
          leetcode-tui = leetcode-tui;
        };
        apps = {
          default = {
            type = "app";
            program = "${leetcode-tui}/bin/leetui";
          };
          leetcode-tui = {
            type = "app";
            program = "${leetcode-tui}/bin/leetui";
          };
        };
      }
    );
}
