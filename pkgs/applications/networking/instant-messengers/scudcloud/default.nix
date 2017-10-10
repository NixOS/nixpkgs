{ stdenv, fetchurl, python3Packages }:

let version = "1.63";
in python3Packages.buildPythonPackage {
  name = "scudcloud-${version}";

  src = fetchurl {
    url = "https://github.com/raelgc/scudcloud/archive/v${version}.tar.gz";
    sha256 = "08hd6n6vwv88qgx869lpa3i8zbaq2pjqplljvcbxl3sx25rcplg0";
  };

  propagatedBuildInputs = with python3Packages; [ pyqt5 dbus-python ];

  meta = with stdenv.lib; {
    description = "Non-official desktop client for Slack";
    homepage = https://github.com/raelgc/scudcloud;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
