{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "nano-1.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.nano-editor.org/dist/v1.2/nano-1.2.4.tar.gz;
    md5 = "2c513310ec5e8b63abaecaf48670ac7a";
  };

  inherit ncurses;
  buildInputs = [ncurses];
}
