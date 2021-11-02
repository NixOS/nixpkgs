{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "scudcloud";
  version = "1.63";

  src = fetchFromGitHub {
    owner = "raelgc";
    repo = "scudcloud";
    rev = "v${version}";
    sha256 = "sha256-b8+MVjYKbSpnfM2ow2MNVY6MiT+urpNYDkFR/yUC7ik=";
  };

  propagatedBuildInputs = with python3Packages; [ pyqt5_with_qtwebkit dbus-python jsmin ];

  meta = with lib; {
    description = "Non-official desktop client for Slack";
    homepage = "https://github.com/raelgc/scudcloud";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
