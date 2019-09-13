let
  version     = "2.5.8";
  sha256      = "01cmr1zakgc452arc7qkd2860l99hvs49m941ba96pzkpkhm3dfa";
  cargoSha256 = "1kdy0bnmyqx4rhpq0a8gliy6mws68n035kfkxrfa6cxr2cn53dyb";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
