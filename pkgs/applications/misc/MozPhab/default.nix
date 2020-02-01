{ lib, python3Packages, pkgs }:

python3Packages.buildPythonApplication rec {
  pname = "MozPhab";
  version = "0.1.74";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1qbl54pvba15b2ic9lxsajakbk4gj1rjazzj4qbrh43ngllrhi7y";
  };

  propagatedBuildInputs = [
    python3Packages.setuptools
    pkgs.mercurial
  ];

  meta = with lib; {
    description = "Phabricator CLI from Mozilla to support submission of a series of commits";
    longDescription = ''
      MozPhab is a custom command-line tool, moz-phab, which communicates to
      Phabricator’s API, providing several conveniences, including support for
      submitting series of commits.
    '';
    homepage = "https://moz-conduit.readthedocs.io/en/latest/phabricator-user.html";
    license = licenses.mpl20;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
}
