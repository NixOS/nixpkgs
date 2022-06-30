{ lib, fetchurl, fetchpatch, stdenv, zlib, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "fnc";
  version = "0.12";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${version}/fnc-${version}.tar.gz";
    sha256 = "05cg8id4d1ia8y60y3x23167bl1rn2fdpkf1jfj3aklhlihvkbxd";
  };

  buildInputs = [ libiconv ncurses zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

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
