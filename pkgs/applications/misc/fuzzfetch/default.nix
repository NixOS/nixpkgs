{ lib
, buildPythonApplication
, fetchPypi
# build inputs
, pytz
, requests
, setuptools
# check inputs
, freezegun
, pytestCheckHook
, requests-mock
}:

buildPythonApplication rec {
  pname = "fuzzfetch";
  version = "2.0.0";

  src = fetchPypi {
    pname = "fuzzfetch";
    inherit version;
    sha256 = "sha256-u5K0HW//cj3T2VG9ufPH8mF4gn+xxIv2f2KnDbDZ61I=";
  };

  propagatedBuildInputs = [
    pytz
    requests
    setuptools
  ];
  checkInputs = [
    freezegun
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Tool for retrieving builds from the Firefox-CI Taskcluster instance";
    longDescription = ''
      Fuzzfetch can be used to retrieve nearly any build type indexed by Firefox-CI.
      This includes AddressSanitizer, ThreadSanitizer, Valgrind, debug, and Fuzzing
      builds for both Firefox and Spidermonkey.
    '';
    homepage = "https://github.com/MozillaSecurity/fuzzfetch";
    license = licenses.mpl20;
    maintainers = [ maintainers.kvark ];
    platforms = platforms.unix;
  };
}
