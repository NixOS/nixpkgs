let
  version     = "1.9.3";
  sha256      = "19qyp6kafnnfhdnbq745v8zybnqizjzzc3k4701ly9hf0dvx53ka";
  cargoSha256 = "1vdvqs6ligp5fkw5s7v44vwqwz5dqa0ipilx0piz6swz0drilima";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
