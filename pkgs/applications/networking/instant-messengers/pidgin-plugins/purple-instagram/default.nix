{ stdenv, fetchFromGitHub, pidgin, glib, json-glib }:

stdenv.mkDerivation rec {
  name = "purple-instagram-${version}";
  version = "2019-01-13";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "purple-instagram";
    rev = "6add7c2aeadd3b0eb77d9554a5fce6c0d0612e6a";
    sha256 = "1669zgdv9ccbqh7img4v600xsj5c1f772hidd4mcr7n57xcrkdwj";
  };

  buildInputs = [ pidgin glib json-glib ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Instagram chat support for pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jb55 ];
  };
}
