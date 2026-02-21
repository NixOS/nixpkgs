{ lib, runTest }:
lib.recurseIntoAttrs {
  nextcloud = runTest ./nextcloud-online.nix;
}
