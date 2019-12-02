let
  version     = "2.6.5";
  sha256      = "1ykrsphqil68051wwp9b0259gsmfrj9xmx0pfhh2yvmmjzv7k4fv";
  cargoSha256 = "1xqmnirx2r91q5gy1skxl0f79xvaqzimq3l0cj4xvfms7mpdfbg1";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
