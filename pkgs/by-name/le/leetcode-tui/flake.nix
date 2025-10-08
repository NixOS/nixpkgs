{
  description = "Terminal UI for LeetCode";

  inputs = {
    nixpkgs.url = "path:../../../..";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      leetcode-tui = pkgs.callPackage ./package.nix { };
    in
    {
      packages.${system} = {
        default = leetcode-tui;
        leetcode-tui = leetcode-tui;
      };

      apps.${system} = {
        default = {
          type = "app";
          program = "${leetcode-tui}/bin/leetui";
        };

        leetcode-tui = {
          type = "app";
          program = "${leetcode-tui}/bin/leetui";
        };
      };
    };
}
