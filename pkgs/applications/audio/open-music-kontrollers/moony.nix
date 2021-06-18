{ callPackage, cairo, libvterm-neovim, robodoc, cmake, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "moony";
  version = "0.38.0";

  sha256 = "195sahigkdr3j8rl867zylwhpiif71jsyx635bpzs7zay9l7bba7";

  additionalBuildInputs = [ cairo libvterm-neovim robodoc cmake ];

  description = "Realtime Lua as programmable glue in LV2";

})
