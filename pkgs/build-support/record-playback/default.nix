{ stdenv }:

stdenv.mkDerivation rec {

  name = "record-playback";

  version = "1.0";

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  src = ./.;

  installPhase = ''
    mkdir -p "$out"/bin
    install record-command "$out"/bin/record-command
    install playback-command "$out"/bin/playback-command
    mkdir -p "$out"/nix-support
    install setup-hook "$out"/nix-support/setup-hook
    substituteAllInPlace "$out"/nix-support/setup-hook
  '';

}
