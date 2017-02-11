{ stdenv, fetchgit, python3Packages }:

python3Packages.buildPythonPackage {
  name = "scudcloud-1.40";

  # Branch 254-port-to-qt5
  # https://github.com/raelgc/scudcloud/commit/43ddc87f123a641b1fa78ace0bab159b05d34b65
  src = fetchgit {
      url = https://github.com/raelgc/scudcloud/;
      rev = "43ddc87f123a641b1fa78ace0bab159b05d34b65";
      sha256 = "1lh9naf9xfrmj1pj7p8bd3fz7vy3gap6cvda4silk4b6ylyqa8vj";
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
