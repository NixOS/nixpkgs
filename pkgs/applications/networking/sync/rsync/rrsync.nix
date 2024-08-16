{ stdenv, python3, rsync }:

stdenv.mkDerivation {
  pname = "rrsync";
  inherit (rsync) version src;

  buildInputs = [
    rsync
    (python3.withPackages (pythonPackages: with pythonPackages; [ braceexpand ]))
  ];
  # Skip configure and build phases.
  # We just want something from the support directory
  dontConfigure = true;
  dontBuild = true;

  inherit (rsync) patches;

  postPatch = ''
    substituteInPlace support/rrsync --replace /usr/bin/rsync ${rsync}/bin/rsync
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp support/rrsync $out/bin
    chmod a+x $out/bin/rrsync
  '';

  meta = rsync.meta // {
    description = "Helper to run rsync-only environments from ssh-logins";
  };
}
