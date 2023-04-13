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
  version = "2.7";
  disabled = ! isPy3k;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "hovercraft";
    rev = version;
    sha256 = "0k0gjlqjz424rymcfdjpj6a71ppblfls5f8y2hd800d1as4im8az";
  };

  nativeCheckInputs = [ manuel ];
  propagatedBuildInputs = [ setuptools docutils lxml svg-path pygments watchdog ];

  meta = with lib; {
    description = "Makes impress.js presentations from reStructuredText";
    homepage = "https://github.com/regebro/hovercraft";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu makefu ];
  };
}
