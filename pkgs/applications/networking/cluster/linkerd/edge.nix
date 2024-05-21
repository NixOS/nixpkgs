{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.5.2";
  sha256 = "06harh6dl90jmcwc3myqaak1dzg4wpbfyra6xvgqc8fj7k4f9w94";
  vendorHash = "sha256-ADxXIkKKhlik70DwDfQG8gNpzkx3zhas34chZ+CLZSQ=";
}
