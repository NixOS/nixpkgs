{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "taskwarrior-${version}";
  version = "2.2.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "057fh50qp9bd5s08rw51iybpamn55v5nhn3s6ds89g76hp95vqir";
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
