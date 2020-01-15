{ lib, stdenv, fetchFromGitHub, aalib, ncurses }:

stdenv.mkDerivation rec {
  pname = "aview";
  version = "1.3.0rc1-debian4";

  src = fetchFromGitHub {
    owner = "deepfire";
    repo = "aview";
    rev = "c128170199aa3516649ad9ed806af30849f19ffc";
    sha256 = "1gikxn2z12rfbb9vdf7pgrjk2kvr83bk1hycmijvdnbls6l87cyp";
  };

  buildInputs = [
    aalib ncurses
  ];

  meta = {
    homepage = http://aa-project.sourceforge.net/;
    description = "Aview is a high quality ascii-art image(pnm) browser and animation(fli/flc) player.";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.deepfire ];
  };
}
