{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "mnamer";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "jkwill87";
    repo = "mnamer";
    rev = version;
    sha256 = "sha256-fONQq/RboWHFuEFU7HP1ThUpSjOIlkg54c2WlMUKwuk=";
  };

  propagatedBuildInputs = with python3Packages; [
    babelfish
    requests
    appdirs
    teletype
    requests-cache
    guessit
  ];

  patches = [
    # requires specific old versions of dependencies which have been updated in nixpkgs
    ./remove_requirements.patch

    # author reads a private property that changed between versions
    ./update_hack.patch
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # disable test that fail (networking, etc)
  disabledTests = [
    "network"
    "e2e"
    "test_utils.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/jkwill87/mnamer";
    description = "An intelligent and highly configurable media organization utility";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
