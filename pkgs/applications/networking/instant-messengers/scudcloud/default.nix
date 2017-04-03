{ stdenv, fetchgit, python3Packages }:

python3Packages.buildPythonPackage {
  name = "scudcloud-1.44";

  # Branch 254-port-to-qt5
  # https://github.com/raelgc/scudcloud/commit/65c304416dfdd5f456fa6f7301432a953d5e12d0
  src = fetchgit {
      url = https://github.com/raelgc/scudcloud/;
      rev = "65c304416dfdd5f456fa6f7301432a953d5e12d0";
      sha256 = "0h1055y88kldqw31ayqfx9zsksgxsyqd8h0hwnhj80yn3jcx0rp6";
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
