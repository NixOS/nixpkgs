{ lib, stdenv, fetchurl, perl, rsync }:

let
  base = import ./base.nix { inherit stdenv lib fetchurl; };
in
stdenv.mkDerivation {
  name = "rrsync-${base.version}";

  src = base.src;

  buildInputs = [ rsync perl ];

  # Skip configure and build phases.
  # We just want something from the support directory
  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace support/rrsync --replace /usr/bin/rsync ${rsync}/bin/rsync
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp support/rrsync $out/bin
    chmod a+x $out/bin/rrsync
  '';

  meta = base.meta // {
    description = "A helper to run rsync-only environments from ssh-logins";
    maintainers = [ lib.maintainers.kampfschlaefer ];
  };
}
