{ stdenv, fetchurl, pythonPackages, gettext }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "cherrytree-${version}";
  version = "0.38.7";

  src = fetchurl {
    url = "https://www.giuspen.com/software/${name}.tar.xz";
    sha256 = "1ls7vz993hj5gd99imlrzahxznfg6fa4n77ikkj79va4csw9b892";
  };

  buildInputs = with pythonPackages;
  [ python gettext wrapPython pygtk dbus-python pygtksourceview ];

  pythonPath = with pythonPackages;
  [ pygtk dbus-python pygtksourceview ];

  patches = [ ./subprocess.patch ];

  installPhase = ''
    python setup.py install --prefix="$out"

    for file in "$out"/bin/*; do
        wrapProgram "$file" \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
    done
  '';

  doCheck = false;

  meta = {
    description = "An hierarchical note taking application";
    longDescription = ''
      Cherrytree is an hierarchical note taking application,
      featuring rich text, syntax highlighting and powerful search
      capabilities. It organizes all information in units called
      "nodes", as in a tree, and can be very useful to store any piece
      of information, from tables and links to pictures and even entire
      documents. All those little bits of information you have scattered
      around your hard drive can be conveniently placed into a
      Cherrytree document where you can easily find it.
    '';
    homepage = http://www.giuspen.com/cherrytree;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
