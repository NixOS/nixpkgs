{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = "${version}";
    sha256 = "11j2qm67sszfqq730czsr2zmpgkghsb50556ax1vlpm7rw3gm33c";
  };

  propagatedBuildInputs = with python2Packages; [ pygobject2 pygtk mutagen ];

  meta = with stdenv.lib; {
    description = "Python Soulseek Client";
    homepage = http://www.nicotine-plus.org/;
    downloadPage = https://github.com/Nicotine-Plus/nicotine-plus/releases;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ "6AA4FD" ];
    longDescription = ''
      Nicotine+ is an updated fork of the popular Nicotine client for Soulseek,
      a peer to peer file sharing network generally used for music.
    '';
  };
}
