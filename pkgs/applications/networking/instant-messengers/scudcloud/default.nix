{ stdenv, fetchgit, python3Packages }:

python3Packages.buildPythonPackage {
  name = "scudcloud-1.38";

  # Branch 254-port-to-qt5
  # https://github.com/raelgc/scudcloud/commit/6bcd877daea3d679cd5fd2c946c2d933940c48d9
  src = fetchgit {
      url = https://github.com/raelgc/scudcloud/;
      rev = "6bcd877daea3d679cd5fd2c946c2d933940c48d9";
      sha256 = "1884svz6m5vl06d0yac5zjb2phxwg6bjva72y15fw4larkjnh72s";
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
