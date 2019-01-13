{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "nicotineplus";
  version = "1.4.1";
  src = fetchurl {
    url = "https://github.com/Nicotine-Plus/nicotine-plus/archive/1.4.1.tar.gz";
    sha256 = "1mmpjwa4c78b8325kxc8z629fa23653cr459dywlw7lqdlcyyf0v";
  };

  propagatedBuildInputs = with python2Packages; [ pygobject2 pygtk mutagen ];

  meta = with stdenv.lib; {
    description = "Python Soulseek Client";
    homepage = http://www.nicotine-plus.org/;
    downloadPage = https://github.com/Nicotine-Plus/nicotine-plus/releases;
    license = licenses.gpl3;
    maintainers = with maintainers; [ "6AA4FD" ];
    platforms = platforms.all;
    longDescription = ''
    Nicotine+ is an updated fork of the popular Nicotine client for Soulseek,
    a peer to peer file sharing network generally used for music.
    '';
  };
}
