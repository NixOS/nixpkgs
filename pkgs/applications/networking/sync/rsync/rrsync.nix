{ stdenv, fetchurl, perl, rsync }:

stdenv.mkDerivation rec {
  name = "rrsync-${version}";
  version = "3.1.2";

  src = import ./src.nix { inherit fetchurl version; };

  buildInputs = [ rsync ];
  nativeBuildInputs = [perl];

  # Skip configure and build phases.
  # We just want something from the support directory
  configurePhase = "true";
  dontBuild = true;

  postPatch = ''
    sed -i 's#/usr/bin/rsync#${rsync}/bin/rsync#' support/rrsync
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp support/rrsync $out/bin
    chmod a+x $out/bin/rrsync
  '';

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    description = "A helper to run rsync-only environments from ssh-logins.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simons ehmry ];
  };
}
