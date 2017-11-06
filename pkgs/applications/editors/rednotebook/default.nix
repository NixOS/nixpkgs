{ lib, buildPythonPackage, fetchurl, pygtk, pywebkitgtk, pyyaml, chardet }:

buildPythonPackage rec {
  name = "rednotebook-1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/rednotebook/${name}.tar.gz";
    sha256 = "00b7s4xpqpxsbzjvjx9qsx5d84m9pvn383c5di1nsfh35pig0rzn";
  };

  # no tests available
  doCheck = false;

  propagatedBuildInputs = [ pygtk pywebkitgtk pyyaml chardet ];

  meta = with lib; {
    homepage = http://rednotebook.sourceforge.net/index.html;
    description = "A modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel ];
  };
}
