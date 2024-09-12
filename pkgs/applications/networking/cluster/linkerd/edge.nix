{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.8.3";
  sha256 = "05ynk7p86pa81nyfj9vkfmvgss0nfz3zszrlm967cakhanc5083g";
  vendorHash = "sha256-Edn5w264IU3ez47jb2wqX5zXeKiLtewWs05LXYr5q50=";
}
