let
  version     = "2.3.2";
  sha256      = "1063n7lkcfkywi0a06pxkw0wkq3qyq4lr53fv584mlbnh2hj8gpm";
  cargoSha256 = "1pj5hzy7k1l9bbw1qpz80vvk89qz4qz4rnnkcvn2rkbmq382gxwy";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
