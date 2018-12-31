{ stdenv, fetchurl, python3Packages }:

let version = "1.63";
in python3Packages.buildPythonPackage {
  name = "scudcloud-${version}";

  src = fetchurl {
    url = "https://github.com/raelgc/scudcloud/archive/v${version}.tar.gz";
    sha256 = "e0d1cb72115d0fda17db92d28be51558ad8fe250972683fac3086dbe8d350d22";
  };

  propagatedBuildInputs = with python3Packages; [ pyqt5_with_qtwebkit dbus-python jsmin ];

  meta = with stdenv.lib; {
    description = "Non-official desktop client for Slack";
    homepage = https://github.com/raelgc/scudcloud;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
