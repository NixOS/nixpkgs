{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json-glib }:

stdenv.mkDerivation rec {
  pname = "pidgin-skypeweb";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = version;
    sha256 = "1q3m8hyr77mxm4y0zify2xhjp9d8y4pgwvqyfly4zcpmyd2argi1";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */skypeweb)
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    homepage = "https://github.com/EionRobb/skype4pidgin";
    description = "SkypeWeb plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
