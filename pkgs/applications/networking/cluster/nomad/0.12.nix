{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.4";
  sha256 = "0lwrkynq7iksfjk2m7i56l59d06gibyn6vd9bw80x5h08yw2zdks";
}
