{ stdenv, fetchurl, which, diffutils, gnupatch, gnutar }:

stdenv.mkDerivation rec {
  name = "tla-1.3.5";
  
  src = fetchurl {
    url = "mirror://gnu/gnu-arch/" + name + ".tar.gz";
    sha256 = "01mfzj1i6p4s8191cgd5850hds1zls88hkf9rb6qx1vqjv585aj0";
  };

  patches = [ ./configure-tmpdir.patch ];

  buildInputs = [which];
  
  propagatedBuildInputs = [diffutils gnupatch gnutar];

  # Instead of GNU Autoconf, tla uses Tom Lord's now
  # defunct `package-framework'.
  buildPhase = ''
    mkdir +build && cd +build &&		\
    ../src/configure --prefix="$out" &&		\
    make install
  '';

  meta = {
    description = "GNU Arch (aka. `tla'), a distributed revision control system";
    homepage = http://www.gnu.org/software/gnu-arch/;
    license = "GPL";
  };
}
