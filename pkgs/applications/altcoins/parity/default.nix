let
  version     = "2.1.11";
  sha256      = "0s0vig9pcz9iw774drfanb6hwnx97wm5fgn4hf5pydwb4jws1qrf";
  cargoSha256 = "1nx6aiq4888d75xfzx9q7ih5jgidjaq1i63bvvgxqyldxq0hjrma";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
