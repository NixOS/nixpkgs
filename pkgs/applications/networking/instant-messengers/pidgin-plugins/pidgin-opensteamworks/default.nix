{ stdenv, fetchFromGitHub, pidgin, unzip, glib, json_glib, nss, nspr, libgnome_keyring } :

stdenv.mkDerivation rec {
  name = "pidgin-opensteamworks-1.5.1";

  # Temporarily sourcing this from a mirror in my github account, until such time as the project is officially migrated away from the deprecated google code service
  src = fetchFromGitHub {
    owner = "Shados";
    repo = "pidgin-opensteamworks";
    rev = "4f0ea110a5bdba9d2b18ec8785b2edb276f0cccd";
    sha256 = "0gcrc1yaf29yjfhpflpn451i7isw8zc7maw77g604815myc5k025";
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
    maintainters = with maintainers; [ arobyn ];
  };
}
