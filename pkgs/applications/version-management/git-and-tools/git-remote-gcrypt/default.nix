{ stdenv, fetchgit, docutils }:

stdenv.mkDerivation {
  name = "git-remote-gcrypt-20140715";

  # Use joeyh's branch that works better with git-annex
  src = fetchgit {
    url = "https://github.com/joeyh/git-remote-gcrypt.git";
    rev = "5dcc77f507d497fe4023e94a47b6a7a1f1146bce";
    sha256 = "d509efde143cfec4898872b5bb423d52d5d1c940b6a1e21b8444c904bdb250c2";
  };

  # Required for rst2man.py
  buildInputs = [ docutils ];

  # The install.sh script expects rst2man, but here it's named rst2man.py
  patchPhase = ''
    sed -i 's/rst2man/rst2man.py/g' install.sh
  '';

  installPhase = ''
    prefix="$out" ./install.sh
  '';

  meta = {
    homepage = "https://github.com/joeyh/git-remote-gcrypt";
    description = "GNU Privacy Guard-encrypted git remote";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ ellis ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
