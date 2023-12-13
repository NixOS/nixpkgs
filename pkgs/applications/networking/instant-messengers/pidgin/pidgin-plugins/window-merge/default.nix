{ lib, stdenv, fetchurl, pidgin } :

stdenv.mkDerivation rec {
  pname = "pidgin-window-merge";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/downloads/dm0-/window_merge/window_merge-${version}.tar.gz";
    sha256 = "0cb5rvi7jqvm345g9mlm4wpq0240kcybv81jpw5wlx7hz0lwi478";
  };

  buildInputs = [ pidgin ];

  meta = with lib; {
    homepage = "https://github.com/dm0-/window_merge";
    description = "Pidgin plugin that merges the Buddy List window with a conversation window";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
