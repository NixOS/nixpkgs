{ callPackage, pkgs }:

let
  callVSCodePackage = pkg: attrs: let p = callPackage pkg attrs; in p // {
    withExtensions = callPackage ./with-extensions.nix { vscode = p; };
  };

in {
  vscode = callVSCodePackage ./vscode.nix { };
  vscodium = callVSCodePackage ./vscodium.nix { };
  vscode-oss = callVSCodePackage ./oss.nix { electron = pkgs.electron_7; };
}
