let
  version     = "2.5.7";
  sha256      = "0aprs71cbf98dsvjz0kydngkvdg5x7dijji8j6xadgvsarl1ljnj";
  cargoSha256 = "11mr5q5aynli9xm4wnxcypl3ij7f4b0p7l557yi9n0cvdraw8ki4";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
