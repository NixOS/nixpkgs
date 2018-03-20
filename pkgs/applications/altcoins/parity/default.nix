let
  version     = "1.8.11";
  sha256      = "1vabkglmmbx9jccwsqwvwck1brdjack3sw6iwsxy01wsc2jam56k";
  cargoSha256 = "1l5hx77glclpwd9i35rr3lxfxshsf1bsxvs2chsp2vwjy06knjmi";
  patches     = [ ./patches/vendored-sources-1.8.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
