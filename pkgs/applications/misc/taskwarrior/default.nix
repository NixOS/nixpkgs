{stdenv, fetchurl, cmake}:

stdenv.mkDerivation {
  name = "taskwarrior-2.1.2";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://www.taskwarrior.org/download/task-2.1.2.tar.gz;
    sha256 = "0diy72sgiyvfl6bdy7k3qwv3ijx2z1y477smkk6jsbbd9fsp2lfg";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "GTD (getting things done) implementation";
    homepage = http://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
