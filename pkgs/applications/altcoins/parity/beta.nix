let
  version     = "1.9.3";
  sha256      = "19qyp6kafnnfhdnbq745v8zybnqizjzzc3k4701ly9hf0dvx53ka";
  cargoSha256 = "1f2rq96ci1pm29wlaahp4vq6wmmywq33a7svdi9nw5wqvbr1l1nk";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
