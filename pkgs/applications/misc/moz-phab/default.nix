{ lib, python3Packages, pkgs }:

python3Packages.buildPythonApplication rec {
  pname = "MozPhab";
  version = "0.1.99";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-uKoMMSp5AIvB1qTRYAh7n1+2dDLneFbssfkfTTshfcs=";
  };

  propagatedBuildInputs = with python3Packages; [
    distro
    glean-sdk
    python-hglib
    sentry-sdk
    setuptools
  ];
  buildInputs = [
    pkgs.mercurial
  ];

  # https://bugzilla.mozilla.org/show_bug.cgi?id=1741683
  doCheck = false;

  meta = with lib; {
    description = "Phabricator CLI from Mozilla to support submission of a series of commits";
    longDescription = ''
      moz-phab is a custom command-line tool, which communicates to
      Phabricator’s API, providing several conveniences, including support for
      submitting series of commits.
    '';
    homepage = "https://moz-conduit.readthedocs.io/en/latest/phabricator-user.html";
    license = licenses.mpl20;
    maintainers = [ maintainers.kvark ];
    platforms = platforms.all;
  };
}
