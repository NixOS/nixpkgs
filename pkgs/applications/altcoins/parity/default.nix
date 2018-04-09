let
  version     = "1.9.5";
  sha256      = "0f2x78p5bshs3678qcybqd34k83d294mp3vadp99iqhmbkhbfyy7";
  cargoSha256 = "1irc01sva5yyhdv79cs6jk5pbmhxyvs0ja4cly4nw639m1kx7rva";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
