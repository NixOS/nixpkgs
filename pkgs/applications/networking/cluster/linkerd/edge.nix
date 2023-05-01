{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.4.2";
  sha256 = "1g7ghvxrk906sz6kgclyk078jlbxjm0idx5mbj6ll6q756ncnzyl";
  vendorSha256 = "sha256-B0vqZBycn2IYxjy0kMOtN3KnQA8ARiKDaH6mT6dtXTo=";
}
