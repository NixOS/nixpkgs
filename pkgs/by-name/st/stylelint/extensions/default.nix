{ pkgs }: {
  stylelint-config-standard =
    pkgs.callPackage ./stylelint-config-standard/package.nix { };
  stylelint-config-clean-order =
    pkgs.callPackage ./stylelint-config-clean-order/package.nix { };
}
