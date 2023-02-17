{ lib, fetchurl, fetchpatch, stdenv, zlib, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "fnc";
  version = "0.13";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${version}/fnc-${version}.tar.gz";
    sha256 = "126aklsjfqmrj0f9p1g6sdlqhwnbfhyn0lq2c9pidfnhppa7sz95";
  };

  buildInputs = [ libiconv ncurses zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
  ];

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
