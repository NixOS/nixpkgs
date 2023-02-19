{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.2.2";
  sha256 = "1ylimwxp5b7dp14kjl5jimpjiqh5vh83cfah226kxndb6k64i7h8";
  vendorSha256 = "sha256-UWzWBZBzoq4Mzqk3ukvGAcXqiSeJV/V3K2V1GOA9vwc=";
}
