{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "22.2.4";
  sha256 = "1s53zlb7f0xp2vqa5fnsjdhjq203bsksrmdbrxkkm1yi3nc3p369";
  vendorSha256 = "sha256-cN19kKa4Ieweta95/4bKlAYn/Bq8j27H408za3OoJoI=";
}
