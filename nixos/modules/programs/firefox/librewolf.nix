{
  lib,
  pkgs,
  ...
}:
let
  firefoxLib = import ./lib.nix;
in
{
  imports = [
    (firefoxLib.mkFirefoxBaseModule {
      variant = "librewolf";
      prettyName = "Librewolf";
      defaultPackage = pkgs.librewolf;
    })
  ];

  meta.maintainers = with lib.maintainers; [
    mbornand
  ];
}
