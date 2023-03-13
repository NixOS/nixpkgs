{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.3.1";
  sha256 = "10vl3lay9f823qp0cqh4a7fzfkh8qcl0k6jwdjvrd93d4rasvnsm";
  vendorSha256 = "sha256-DPYGh2lUgyYqquaNVRWb2CCAAFi0bm3ZKHNOoVq6dJ4=";
}
