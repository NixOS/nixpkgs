{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json-glib }:

stdenv.mkDerivation rec {
  name = "pidgin-skypeweb-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = "${version}";
    sha256 = "1lxpz316jmns6i143v4j6sd6k0a4a54alw08rvwjckf2rig57lj2";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */skypeweb)
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib ];

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
