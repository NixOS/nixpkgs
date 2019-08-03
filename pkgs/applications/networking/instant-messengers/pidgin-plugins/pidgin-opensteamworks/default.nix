{ stdenv, fetchFromGitHub, pidgin, glib, json-glib, nss, nspr, libgnome-keyring } :

stdenv.mkDerivation rec {
  name = "pidgin-opensteamworks-${version}";
  version = "unstable-2018-08-02";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "pidgin-opensteamworks";
    rev = "b16a636d177f4a8862abdfbdb2c0994712ea0cd3";
    sha256 = "0qyxfrfzsm43f1gmbg350znwxld1fqr9a9yziqs322bx2vglzgfh";
  };

  preConfigure = "cd steam-mobile";
  installFlags = [
    "PLUGIN_DIR_PURPLE=${placeholder "out"}/lib/purple-2"
    "DATA_ROOT_DIR_PURPLE=${placeholder "out"}/share"
  ];

  buildInputs = [ pidgin glib json-glib nss nspr libgnome-keyring ];

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/pidgin-opensteamworks;
    description = "Plugin for Pidgin 2.x which implements Steam Friends/Steam IM compatibility";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arobyn ];
  };
}
