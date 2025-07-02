{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "scudcloud";
  version = "1.65";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raelgc";
    repo = "scudcloud";
    rev = "v${version}";
    sha256 = "1ffdy74igll74fwpmnn3brvcxbk4iianqscdzz18sx1pfqpw16cl";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqt5-webkit
    dbus-python
    jsmin
  ];

  meta = with lib; {
    description = "Non-official desktop client for Slack";
    homepage = "https://github.com/raelgc/scudcloud";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
