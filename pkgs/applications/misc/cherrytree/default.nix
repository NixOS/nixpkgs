{ stdenv, fetchurl, python, pythonPackages, gettext, pygtksourceview, sqlite }:

stdenv.mkDerivation rec {
  name = "cherrytree-0.35.6";

  src = fetchurl {
    url = "http://www.giuspen.com/software/${name}.tar.xz";
    sha256 = "1nfrnnwaxb07jf5c3id8zimr3q3rbhvzjlmpb99d41d7hqrd2bxj";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 ];

  buildInputs = with pythonPackages; [ python gettext wrapPython pygtk dbus pygtksourceview ];

  pythonPath = with pythonPackages; [ pygtk dbus pygtksourceview ];

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
    description = "A hierarchical note taking application, featuring rich text and syntax highlighting, storing data in a single xml or sqlite file";
    homepage = http://www.giuspen.com/cherrytree;
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; linux;
  };
}
