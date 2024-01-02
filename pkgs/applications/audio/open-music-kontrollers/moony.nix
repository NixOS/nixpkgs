{ callPackage, cairo, libvterm-neovim, robodoc, cmake, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "moony";
  version = "0.40.0";

  sha256 = "sha256-9a3gR3lV8xFFTDZD+fJPCALVztgmggzyIpsPZCOw/uY=";

  additionalBuildInputs = [ cairo libvterm-neovim robodoc cmake ];

  description = "Realtime Lua as programmable glue in LV2";

})
