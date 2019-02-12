{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json-glib }:

stdenv.mkDerivation rec {
  name = "pidgin-skypeweb-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = version;
    sha256 = "1bd9gd36yhrbrww0dvai9rnzxxj1c9sb4003c72wg27w12y47xfv";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */skypeweb)
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/skype4pidgin;
    description = "SkypeWeb plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
