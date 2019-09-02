let
  version     = "2.5.7";
  sha256      = "0aprs71cbf98dsvjz0kydngkvdg5x7dijji8j6xadgvsarl1ljnj";
  cargoSha256 = "0aa0nkv3jr7cdzswbxghxxv0y65a59jgs1682ch8vrasi0x17m1x";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
