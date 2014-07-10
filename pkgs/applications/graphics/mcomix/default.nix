{ stdenv, fetchurl, buildPythonPackage, pygtk, pil, python27Packages }:

buildPythonPackage rec {
    namePrefix = "";
    name = "mcomix-0.98";

    src = fetchurl {
      url = "mirror://sourceforge/mcomix/${name}.tar.bz2";
      sha256 = "93805b6c8540bd673ac4a6ef6e952f00f8fc10e59a63c7e163324a64db2a6b03";
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
    };
}
