{ lib, stdenv, fetchurl, perl, rsync, fetchpatch }:

let
  base = import ./base.nix { inherit lib fetchurl fetchpatch; };
in
stdenv.mkDerivation {
  pname = "rrsync";
  version = base.version;

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
