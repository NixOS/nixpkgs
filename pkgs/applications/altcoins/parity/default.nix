let
  version     = "1.9.6";
  sha256      = "17h7c93c95pj71nbw152rl4ka240zzd8w0yf8k4l4rimcsbra92g";
  cargoSha256 = "0gk26yncahrlnx6xz13x775wrwh7xsfqiifspjislmgk7xknqjm0";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
