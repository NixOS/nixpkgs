{ stdenv, fetchurl, pythonPackages, makeWrapper, gettext, git }:

let
  inherit (pythonPackages) buildPythonApplication pyqt4 sip pyinotify python mock;
in buildPythonApplication rec {
  name = "git-cola-${version}";
  version = "2.8";

  src = fetchurl {
    url = "https://github.com/git-cola/git-cola/archive/v${version}.tar.gz";
    sha256 = "19ff7i0h5fznrkm17lp3xkxwkq27whhiil6y6bm16b1wny5hjqlr";
  };

  buildInputs = [ git makeWrapper gettext ];
  propagatedBuildInputs = [ pyqt4 sip pyinotify ];

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

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/git-cola/git-cola;
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
