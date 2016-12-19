{ stdenv, fetchgit, python3Packages }:

python3Packages.buildPythonPackage {
  name = "scudcloud-1.35";
  namePrefix = "";

  # Version 1.35, branch 254-port-to-qt5
  # https://github.com/raelgc/scudcloud/commit/6d924b5c23597c94d1a8e829a8a5d917806a5bc9
  src = fetchgit {
      url = https://github.com/raelgc/scudcloud/;
      rev = "6d924b5c23597c94d1a8e829a8a5d917806a5bc9";
      sha256 = "01k5am3067l3p1c91mdrh2fk3cgr20dhppa6flqi5b2ygzrc1i8q";
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
