{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.11.1";
  sha256 = "09zwxcaqn537ls737js7rcsqarapw5k25gv41d844k73yvxm882c";
  vendorSha256 = "sha256-c3EyVrblqtFuoP7+YdbyPN0DdN6TcQ5DTtFQ/frKM0Q=";
}
