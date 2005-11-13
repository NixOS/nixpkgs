{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "pinfo-0.6.8";
  src = fetchurl {
    url = http://dione.cc/~pborys/software/pinfo/pinfo-0.6.8.tar.gz;
    md5 = "55feb4ebaa709b52bd00a15ed0fb52fb";
  };
  buildInputs = [ncurses];
}
