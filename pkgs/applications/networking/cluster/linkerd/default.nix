{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.0";
  sha256 = "0j4qzmfhi286vsngf1j3s8zhk7xj2saqr27clmjy7ypjszlz5rvm";
  vendorSha256 = "sha256-HxxekAipoWNxcLUSOSwUOXlrWMODw7gS8fcyTD3CMYE=";
}
