{ callPackage, qtx11extras, ... } @ args:

callPackage ./generic.nix (args // {
  version = "27.2.4";
  sha256 = "sha256-OiSejQovSmhItrnrQlcVp9PCDRgAhuxTinSpXbH8bo0=";
  extraBuildInputs = [ qtx11extras ];
})
