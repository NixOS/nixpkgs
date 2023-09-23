{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.8.3";
  sha256 = "1mj16nzs2da530lvvsg6gh8fcgy8rwq13mryqznflgyr39x4c56i";
  vendorHash = "sha256-HxxekAipoWNxcLUSOSwUOXlrWMODw7gS8fcyTD3CMYE=";
}
