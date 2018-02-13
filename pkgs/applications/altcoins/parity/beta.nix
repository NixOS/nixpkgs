let
  version     = "1.9.2";
  sha256      = "0dhjqp23qqypdvnxcqgbc2jrjx0pbnf465f9m99r3y0i37lkdrd5";
  cargoSha256 = "1vdvqs6ligp5fkw5s7v44vwqwz5dqa0ipilx0piz6swz0drilima";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
