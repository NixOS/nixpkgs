mkFirefoxBaseModule:
{
  lib,
  pkgs,
  ...
}:
let
  baseModule = mkFirefoxBaseModule {
    variant = "librewolf";
    prettyName = "Librewolf";
    defaultPackage = pkgs.librewolf;
    relatedPackages = [
      "librewolf"
      "librewolf-bin"
    ];
  };
in
{
  inherit (baseModule) config options;

  meta.maintainers = with lib.maintainers; [
    mbornand
  ];
}
