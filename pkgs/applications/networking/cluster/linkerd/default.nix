{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
<<<<<<< HEAD
  version = "2.14.0";
  sha256 = "0j4qzmfhi286vsngf1j3s8zhk7xj2saqr27clmjy7ypjszlz5rvm";
  vendorHash = "sha256-HxxekAipoWNxcLUSOSwUOXlrWMODw7gS8fcyTD3CMYE=";
=======
  version = "2.13.2";
  sha256 = "0pcb4f8s8l156y0zd9g9f0pyydvp52n02krjy2giajp00gaqx3s3";
  vendorSha256 = "sha256-6KuXEKuQJvRNUM+6Uo+J9D3eHI+1tt62C5XZsEDwkTc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
