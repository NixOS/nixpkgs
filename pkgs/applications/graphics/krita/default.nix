{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.1.3";
  kde-channel = "stable";
  sha256 = "sha256-69+P0wMIciGxuc6tmWG1OospmvvwcZl6zHNQygEngo0=";
})
