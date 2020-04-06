{ stdenv, fetchFromGitHub, pidgin, pkgconfig }:

stdenv.mkDerivation {
  pname = "purple-slack-unstable";
  version = "2019-08-18";

  src = fetchFromGitHub {
    owner = "dylex";
    repo = "slack-libpurple";
    rev = "be97802c7fd0b611722d2f551756e2a2672f6084";
    sha256 = "0l6hwnnv6zzszxkk0a3nli88w5gijvlc9qgkkai0sb4v4c504y5v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATAROOTDIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    homepage = https://github.com/dylex/slack-libpurple;
    description = "Slack plugin for Pidgin";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb ];
  };
}

