{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, ncurses, glib, openssl, perl, libintl, libgcrypt, libotr, git }:

stdenv.mkDerivation rec {
  pname = "irssi";
  version = "1.2.3";


  src = fetchFromGitHub {
    "owner" = "irssi";
    "repo" = "irssi";
    "rev" = "91dc3e4dfa1a9558c5a7fe0ea982cb9df0e2de65";
    "sha256" = "efnE4vuDd7TnOBxMPduiV0/nez1jVhTjbJ0vzN4ZMcg=";
    "leaveDotGit" = true;
  };

  nativeBuildInputs = [ pkg-config autoconf automake libtool git ];
  buildInputs = [ ncurses glib openssl perl libintl libgcrypt libotr ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--with-otr=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = "https://irssi.org";
    description = "A terminal based IRC client";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lovek323 ];
    license     = lib.licenses.gpl2Plus;
  };
}
