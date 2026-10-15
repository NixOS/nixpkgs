{ lib, fetchFromGitHub }:

{
  # Fujitsu ScanSnap
  epjitsu = fetchFromGitHub {
    name = "scansnap-firmware";
    owner = "stevleibelt";
    repo = "scansnap-firmware";
    rev = "96c3a8b2a4e4f1ccc4e5827c5eb5598084fd17c8";
    hash = "sha256-XjVc+rpQLeKXIFlTVHAC7Ah7c7kQvTs1aIl7rLaFzMY=";
    meta.license = lib.licenses.unfree;
  };
}
