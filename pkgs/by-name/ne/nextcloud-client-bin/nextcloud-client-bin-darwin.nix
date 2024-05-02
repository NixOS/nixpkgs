{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "nextcloud-client-bin";
  version = "3.13.0";
  url = "https://github.com/nextcloud-releases/desktop/releases/latest/download/Nextcloud-3.13.0.pkg";
  hash = "sha256-xqrOJxkFCQcTN7N0ZEjT85zn+u/o/fJUMZdaMBizls0=";
}
