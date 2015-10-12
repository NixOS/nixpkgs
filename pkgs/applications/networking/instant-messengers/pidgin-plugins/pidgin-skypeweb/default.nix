{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json_glib }:

let
  rev = "b92a05c67e";
  date = "2015-10-02";
in
stdenv.mkDerivation rec {
  name = "pidgin-skypeweb-${date}-${rev}";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = "${rev}";
    sha256 = "00r57w9iwx2yp68ld6f3zkhf53vsk679b42w3xxla6bqblpcxzxl";
  };

  sourceRoot = "skype4pidgin-${rev}-src/skypeweb";

  buildInputs = [ pkgconfig pidgin json_glib ];

  makeFlags = [
    "PLUGIN_DIR_PURPLE=/lib/pidgin/"
    "DATA_ROOT_DIR_PURPLE=/share"
    "DESTDIR=$(out)"
  ];

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-skypeweb";

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/skype4pidgin;
    description = "SkypeWeb Plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
