{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "hello-2.1.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/hello/hello-2.1.1.tar.gz;
    md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };
  inherit perl;

  meta = {
    description = "GNU Hello, a classic computer science tool";
    homepage = http://www.gnu.org/software/hello/;
  };
}
