{ lib, fetchurl, fetchpatch, stdenv, zlib, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "fnc";
  version = "0.15";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${version}/fnc-${version}.tar.gz";
    sha256 = "sha256-8up844ekIOMcPlfB2DJzR/GgJY9s/sBeYpG+YtdauvU=";
  };

  buildInputs = [ libiconv ncurses zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
  ]);

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Interactive ncurses browser for Fossil repositories";
    longDescription = ''
      An interactive ncurses browser for Fossil repositories.

      fnc uses libfossil to create a fossil ui experience in the terminal.
    '';
    homepage = "https://fnc.bsdbox.org";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbe ];
  };
}
