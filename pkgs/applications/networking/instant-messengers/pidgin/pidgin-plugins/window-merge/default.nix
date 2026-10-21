{
  lib,
  stdenv,
  fetchurl,
  pidgin,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-window-merge";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/downloads/dm0-/window_merge/window_merge-${version}.tar.gz";
    hash = "sha256-6JDIKfjwdMoLvzKgvTybgAiALyeV1vQKGXVjeeLOZTE=";
  };

  buildInputs = [ pidgin ];

  meta = {
    homepage = "https://github.com/dm0-/window_merge";
    description = "Pidgin plugin that merges the Buddy List window with a conversation window";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
