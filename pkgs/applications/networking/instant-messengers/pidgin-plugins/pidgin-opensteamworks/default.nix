{ stdenv, fetchFromGitHub, pkgconfig, pidgin, glib, json-glib, nss, nspr
, libsecret
} :

stdenv.mkDerivation rec {
  pname = "pidgin-opensteamworks";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "pidgin-opensteamworks";
    rev = version;
    sha256 = "0zxd45g9ycw5kmm4i0800jnqg1ms2gbqcld6gkyv6n3ac1wxizpj";
  };

  sourceRoot = "source/steam-mobile";

  installFlags = [
    "PLUGIN_DIR_PURPLE=${placeholder "out"}/lib/purple-2"
    "DATA_ROOT_DIR_PURPLE=${placeholder "out"}/share"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [
    pidgin glib json-glib nss nspr libsecret
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/pidgin-opensteamworks;
    description = "Plugin for Pidgin 2.x which implements Steam Friends/Steam IM compatibility";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arobyn ];
  };
}
