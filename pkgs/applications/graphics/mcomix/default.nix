{ stdenv, fetchurl, buildPythonPackage, pygtk, pil, python27Packages }:

buildPythonPackage rec {
    namePrefix = "";
    name = "mcomix-1.00";

    src = fetchurl {
      url = "mirror://sourceforge/mcomix/${name}.tar.bz2";
      sha256 = "1phcdx1agacdadz8bvbibdbps1apz8idi668zmkky5cpl84k2ifq";
    };

    doCheck = false;

    pythonPath = [ pygtk pil python27Packages.sqlite3 ];

    meta = {
      description = "Image viewer designed to handle comic books";

      longDescription = ''
        MComix is an user-friendly, customizable image viewer. It is specifically
        designed to handle comic books, but also serves as a generic viewer.
        It reads images in ZIP, RAR, 7Zip or tar archives as well as plain image
        files. It is written in Python and uses GTK+ through the PyGTK bindings,
        and runs on both Linux and Windows.

        MComix is a fork of the Comix project, and aims to add bug fixes and
        stability improvements after Comix development came to a halt in late 2009.
      '';

      homepage = http://mcomix.sourceforge.net/;
      license = stdenv.lib.licenses.gpl2;
      maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    };
}
