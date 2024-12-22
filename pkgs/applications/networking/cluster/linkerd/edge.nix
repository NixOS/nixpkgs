{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.10.4";
  sha256 = "0n1fcl2mi3q3g44bd5x7wgnx91769051dwaxmvc4yapkbsbwnr6g";
  vendorHash = "sha256-AGFuNFwZjWnu+FcXGpTxDQysgSGmYbfEtERaGjCOnUA=";
}
