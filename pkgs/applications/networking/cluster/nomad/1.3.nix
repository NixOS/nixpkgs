{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.2";
  sha256 = "0vrcdm0xjimi5z1j180wigf4gd806w73jxvrzclv2d2pr7pab6qq";
  vendorSha256 = "139bzvaw0nyl0whvs74m2hj2xww08zfd615wkn2y10c8f5h69arj";
}
