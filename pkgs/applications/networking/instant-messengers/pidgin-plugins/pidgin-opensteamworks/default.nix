{ stdenv, fetchFromGitHub, pidgin, unzip, glib, json_glib, nss, nspr, libgnome_keyring } :

stdenv.mkDerivation rec {
  name = "pidgin-opensteamworks-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "pidgin-opensteamworks";
    rev = "${version}";
    sha256 = "6ab27831e454ad3b440e4f06b52e0b3671a4f8417ba4da3ab6f56c56d82cc29b";
  };

  preConfigure = "cd steam-mobile";
  postInstall = ''
    mkdir -p $out/lib/pidgin/
    mkdir -p $out/share/pixmaps/pidgin/protocols/
    cp libsteam.so $out/lib/pidgin/
    unzip releases/icons.zip -d $out/share/pixmaps/pidgin/protocols/
  '';

  buildInputs = [ pidgin unzip glib json_glib nss nspr libgnome_keyring ];

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/pidgin-opensteamworks;
    description = "Plugin for Pidgin 2.x which implements Steam Friends/Steam IM compatibility";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arobyn ];
  };
}
