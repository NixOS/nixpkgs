{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
<<<<<<< HEAD
  version = "23.8.3";
  sha256 = "1mj16nzs2da530lvvsg6gh8fcgy8rwq13mryqznflgyr39x4c56i";
  vendorHash = "sha256-HxxekAipoWNxcLUSOSwUOXlrWMODw7gS8fcyTD3CMYE=";
=======
  version = "23.4.3";
  sha256 = "1wyqqb2frxrid7ln0qq8x6y3sg0a6dnq464csryzsh00arycyfph";
  vendorSha256 = "sha256-5T3YrYr7xeRkAADeE24BPu4PYU4mHFspqAiBpS8n4Y0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
