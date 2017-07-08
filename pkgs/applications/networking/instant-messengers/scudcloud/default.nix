{ stdenv, fetchurl, python3Packages }:

let version = "1.58";
in python3Packages.buildPythonPackage {
  name = "scudcloud-${version}";

  src = fetchurl {
    url = "https://github.com/raelgc/scudcloud/archive/v${version}.tar.gz";
    sha256 = "1j84qdc2j3dvl1nhrjqm0blc8ww723p9a6hqprkkp8alw77myq1l";
  };

  propagatedBuildInputs = with python3Packages; [ pyqt5 dbus-python ];

  meta = with stdenv.lib; {
    description = "Non-official desktop client for Slack";
    homepage = "https://github.com/raelgc/scudcloud";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
