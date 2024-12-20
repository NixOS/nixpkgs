{ kicad }:
{
  kikit = kicad.callPackage ./kikit.nix { addonName = "kikit"; };
  kikit-library = kicad.callPackage ./kikit.nix { addonName = "kikit-library"; };
}
