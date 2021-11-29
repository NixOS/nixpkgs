{ lib
, buildPythonApplication
, fetchPypi
, mercurial
# build inputs
, distro
, glean-sdk
, python-hglib
, sentry-sdk
, setuptools
}:

buildPythonApplication rec {
  pname = "moz-phab";
  version = "0.1.99";

  src = fetchPypi {
    pname = "MozPhab";
    inherit version;
    sha256 = "sha256-uKoMMSp5AIvB1qTRYAh7n1+2dDLneFbssfkfTTshfcs=";
  };

  # Relax python-hglib requirement
  # https://phabricator.services.mozilla.com/D131618
  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    distro
    glean-sdk
    python-hglib
    sentry-sdk
    setuptools
  ];
  checkInputs = [
    mercurial
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
    platforms = platforms.unix;
  };
}
