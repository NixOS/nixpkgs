{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.5.1";
  sha256 = "0zb0vyvrx5fbr2ixqnm7qk7bivdljakjw25zgq19hv4bv6khilqv";
  vendorSha256 = "sha256-mcxG60HHgKRWgJLRO7q2O6PL4qxW6CD0qbqJ/fSrIlk=";
}
