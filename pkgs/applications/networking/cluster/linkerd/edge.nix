{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.9.4";
  sha256 = "1hjhbkwn44i1gsc7llxc9mrdjf5xc1nl4dxqgnxgks3hzkch6qqc";
  vendorHash = "sha256-OzHl9QhNLaTCBCWpCmqzPkdWMwygKXSkYTczQD5KVh8=";
}
