{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "clex";
  version = "4.6.patch10";

  src = fetchurl {
    sha256 = "03niihqk57px7rm2c84qira5jm5vw8lj5s58dximk0w5gsis4fhw";
    url = "${meta.homepage}/download/${pname}-${version}.tar.gz";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "File manager with full-screen terminal interface";
    longDescription = ''
      CLEX (pronounced KLEKS) displays directory contents including the file
      status details and provides features like command history, filename
      insertion, or name completion in order to help users to create commands
      to be executed by the shell. There are no built-in commands, CLEX is an
      add-on to your favorite shell.
    '';
    homepage = "http://www.clex.sk";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
