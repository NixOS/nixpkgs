{ stdenv, fetchurl, python, pythonPackages, makeWrapper, gettext }:

pythonPackages.buildPythonPackage rec {
  name = "git-cola-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/git-cola/git-cola/archive/v${version}.tar.gz";
    sha256 = "0fpi5nvhyqkx67ak5pfcpgxbc3m19dqlvdh2c9igv2j0vp5rzkj1";
  };

  buildInputs = [ makeWrapper gettext ];
  propagatedBuildInputs = with pythonPackages; [ pyqt4 sip pyinotify ];

  # HACK: wrapPythonPrograms adds 'import sys; sys.argv[0] = "git-cola"', but
  # "import __future__" must be placed above that. This removes the argv[0] line.
  postFixup = ''
    wrapPythonPrograms

    sed -i "$out/bin/.git-dag-wrapped" -e '{
      /import sys; sys.argv/d
    }'
    
    sed -i "$out/bin/.git-cola-wrapped" -e '{
      /import sys; sys.argv/d
    }'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/git-cola/git-cola;
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
