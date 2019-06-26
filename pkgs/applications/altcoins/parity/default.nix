let
  version     = "2.4.8";
  sha256      = "1kr7hzv27vxa14wafhpaq5a4fv97zh71xjjmwzaqq4gj3k9yj0rm";
  cargoSha256 = "1yjyk6mhr3ws73aq6h8z5iabvj03ch7mxhkrfdkmhw3cjj0jgx6j";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
