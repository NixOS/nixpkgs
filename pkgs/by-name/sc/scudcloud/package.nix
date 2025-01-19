{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "scudcloud";
  version = "1.65";

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

  meta = {
    description = "Non-official desktop client for Slack";
    homepage = "https://github.com/raelgc/scudcloud";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ volhovm ];
  };
}
