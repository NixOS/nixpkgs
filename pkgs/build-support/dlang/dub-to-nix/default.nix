{
  lib,
  writeShellApplication,
  coreutils,
  gnugrep,
  jq,
  nix,
}:

writeShellApplication {
  name = "dub-to-nix";

  runtimeInputs = [
    coreutils
    gnugrep
    jq
    nix
  ];

  text = lib.readFile ./dub-to-nix.sh;
}
