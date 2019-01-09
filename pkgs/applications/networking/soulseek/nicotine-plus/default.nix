{ stdenv, fetchFromGitHub, python27Packages }:

with stdenv.lib;

python27Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = "4e057d64184885c63488d4213ade3233bd33e67b";
    sha256 = "11j2qm67sszfqq730czsr2zmpgkghsb50556ax1vlpm7rw3gm33c";
  };

  # TODO: include GeoIP as an optional dependency
  propagatedBuildInputs = with python27Packages; [
    pygtk
    miniupnpc
    mutagen
    notify
  ];

  meta = {
    description = "A graphical client for the SoulSeek peer-to-peer system ";
    homepage = https://www.nicotine-plus.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.all;
  };
}
