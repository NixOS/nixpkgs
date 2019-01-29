let
  version     = "2.1.10";
  sha256      = "1l4yl8i24q8v4hzljzai37f587x8m3cz3byzifhvq3bjky7p8h80";
  cargoSha256 = "04pni9cmz8nhlqznwafz9d81006808kh24aqnb8rjdcr84d11zis";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
