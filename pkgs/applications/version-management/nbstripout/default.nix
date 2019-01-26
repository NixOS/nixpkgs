{lib, python2Packages, fetchFromGitHub, fetchurl, git, mercurial, coreutils}:

with python2Packages;
buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "0.3.1";
  pname = "nbstripout";

  # Mercurial should be added as a build input but because it's a Python
  # application, it would mess up the Python environment. Thus, don't add it
  # here, instead add it to PATH when running unit tests
  buildInputs = [ pytest pytest-flake8 pytest-cram git pytestrunner ];
  propagatedBuildInputs = [ ipython nbformat ];

  # PyPI source is currently missing tests. Thus, use GitHub instead.
  # See: https://github.com/kynan/nbstripout/issues/73
  # Use PyPI again after it has been fixed in a release.
  src = fetchFromGitHub {
    owner = "kynan";
    repo = pname;
    rev = version;
    sha256 = "1jifqmszjzyaqzaw2ir83k5fdb04iyxdad4lclawpb42hbink9ws";
  };

  patches = [
    (
      # Fix git diff tests by using --no-index.
      # See: https://github.com/kynan/nbstripout/issues/74
      #
      # Remove this patch once the pull request has been merged and a new
      # release made.
      fetchurl {
        url = "https://github.com/jluttine/nbstripout/commit/03e28424fb788dd09a95e99814977b0d0846c0b4.patch";
        sha256 = "09myfb77a2wh8lqqs9fcpam97vmaw8b7zbq8n5gwn6d80zbl7dn0";
      }
    )
  ];

  # for some reason, darwin uses /bin/sh echo native instead of echo binary, so
  # force using the echo binary
  postPatch = ''
    substituteInPlace tests/test-git.t --replace "echo" "${coreutils}/bin/echo"
  '';

  # ignore flake8 tests for the nix wrapped setup.py
  checkPhase = ''
    PATH=$PATH:$out/bin:${mercurial}/bin pytest .
  '';

  meta = {
    inherit version;
    description = "Strip output from Jupyter and IPython notebooks";
    homepage = https://github.com/kynan/nbstripout;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
