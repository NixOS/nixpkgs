{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.3.2";
  sha256 = "1vbi24nd8mh7vpzxy6qbjd3b7ifg16yc6abb8yvnqvxws8klpj8f";
  vendorSha256 = "sha256-sWNaCmh1fbtJOIHMwA4XAyGUNWpqME+PfmbxSFfH4ws=";
}
