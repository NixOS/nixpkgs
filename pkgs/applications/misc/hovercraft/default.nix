{ lib
, buildPythonApplication
, isPy3k
, fetchFromGitHub
, manuel
, setuptools
, docutils
, lxml
, svg-path
, pygments
, watchdog
}:

buildPythonApplication rec {
  pname = "hovercraft";
  version = "2.6";
  disabled = ! isPy3k;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "hovercraft";
    rev = version;
    sha256 = "150sn6kvqi2s89di1akl5i0g81fasji2ipr12zq5s4dcnhw4r5wp";
  };

  checkInputs = [ manuel ];
  propagatedBuildInputs = [ setuptools docutils lxml svg-path pygments watchdog ];

  meta = with lib; {
    description = "Makes impress.js presentations from reStructuredText";
    homepage = https://github.com/regebro/hovercraft;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu makefu ];
  };
}
