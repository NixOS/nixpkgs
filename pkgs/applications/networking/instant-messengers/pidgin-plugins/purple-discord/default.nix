{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json_glib }:

stdenv.mkDerivation rec {
  name = "purple-discord-${version}";
  version = "unstable-2018-04-10";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "purple-discord";
    rev = "9a97886d15a1f028de54b5e6fc54e784531063b0";
    sha256 = "0dc344zh1v4yh9c8javcw5ylzwc1wpx0ih8bww8p8cjmhr8kcl32";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json_glib ];

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "/share";

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/purple-discord;
    description = "Discord plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sna ];
  };
}
