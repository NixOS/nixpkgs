{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "22.1.4";
  sha256 = "00r58k26qnxjsqjdcqz04p21c1vvw5ls485gad0pcny370wrp65n";
  vendorSha256 = "sha256-5vYf9/BCSHJ0iydKhz+9yDg0rRXpLd+j8uD8kcKhByc=";
}
