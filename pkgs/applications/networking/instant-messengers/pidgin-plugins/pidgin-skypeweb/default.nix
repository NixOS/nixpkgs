{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json_glib }:

stdenv.mkDerivation rec {
  name = "pidgin-skypeweb-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = "${version}";
    sha256 = "0qmqf1r9kc7r6rgzz0byyq7yf5spsl2iima0cvxafs43gn4hnc2z";
  };

  sourceRoot = "skype4pidgin-${version}-src/skypeweb";

  buildInputs = [ pkgconfig pidgin json_glib ];

  makeFlags = [
    "PLUGIN_DIR_PURPLE=/lib/pidgin/"
    "DATA_ROOT_DIR_PURPLE=/share"
    "DESTDIR=$(out)"
  ];

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-skypeweb";

  meta = with stdenv.lib; {
    homepage = https://github.com/EionRobb/skype4pidgin;
    description = "SkypeWeb plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
