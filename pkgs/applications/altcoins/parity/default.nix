let
  version     = "1.8.10";
  sha256      = "0slqfzyz11s6wjf77npgw4q6bcgkqmfm53daj47slxm6axkd954r";
  cargoSha256 = "0k0vqvmz2jr0lfzm8bfrshapgvxjr617shsg5m479m3r02p8l9l3";
  patches     = [ ./patches/vendored-sources-1.8.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
