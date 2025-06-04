{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.5.4";
  sha256 = "0hyjhcb36qbsigc0knf4spyal0djijln1w5cdjrrpwx58jzjhzj8";
  vendorHash = "sha256-DNR2qLTai7BOOovbd9MfQ1ZUUehkD9WQ/UJo+MDdjSg=";
}
