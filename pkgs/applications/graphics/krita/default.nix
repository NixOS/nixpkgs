{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.2.0";
  kde-channel = "stable";
  sha256 = "sha256-02oZc4pZw2dQucx1IuPJslWQGjOqwGmgeDgnUIqKkpc=";
})
