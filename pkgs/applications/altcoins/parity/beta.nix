let
  version     = "2.2.5";
  sha256      = "0q9vgwc0jlja73r4na7yil624iagq1607ac47wh8a7xgfjmjjai1";
  cargoSha256 = "0ibdmyh1jvfq51vhwn4riyhilqwhf71hjd4vyj525smn95p75b14";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
