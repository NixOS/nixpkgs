let
  version     = "2.3.1";
  sha256      = "13y3gczqb0rb6v17j63j1zp11cnykbv9c674hrk1i6jb3y4am4lv";
  cargoSha256 = "1pj5hzy7k1l9bbw1qpz80vvk89qz4qz4rnnkcvn2rkbmq382gxwy";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
