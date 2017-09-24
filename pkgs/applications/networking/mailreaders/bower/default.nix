{ stdenv, fetchFromGitHub, mercury, ncurses, gpgme, pandoc, gawk }:

stdenv.mkDerivation rec {
  name = "bower-${version}";
  version = "2017-08-05";

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    rev = "ff95a1eb709ba998913a78b6bf7c50ef4ed480af";
    sha256 = "0m6zmcz132ylaisvz73skpw4f9bg3av0dljzf43db3g2cm1wwi2d";
  };

  buildInputs = [ mercury ncurses gpgme pandoc gawk ];

  buildPhase = ''
    patchShebangs make_man
    make man
    make PARALLEL=-j6
  '';

  installPhase = ''
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
    mkdir -p $out/bin
    mv bower $out/bin/
  '';

  meta = {
    homepage = https://github.com/wangp/bower;
    description = "A curses terminal client for the Notmuch email system ";
    maintainers = with stdenv.lib.maintainers; [ erictapen ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
