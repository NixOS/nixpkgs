{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.12";
  sha256 = "sha256-PdMo96/foN7rSNvMOQ16N3advy+h0GX7LYtfl23xRfs=";
  vendorSha256 = "sha256-fmqhaM3yK2ThiD+qwQTr+d5FqhZWzkwcGTSPdXNNFTU=";
}
