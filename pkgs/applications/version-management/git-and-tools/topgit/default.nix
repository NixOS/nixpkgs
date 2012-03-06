{ stdenv, fetchurl, unzip }:

let
  version = "0.8-45-gd279e29";
  lib = stdenv.lib;
in
stdenv.mkDerivation {
  name = "topgit-${version}";

  src = fetchurl {
    url = "http://repo.or.cz/w/topgit.git/snapshot/topgit-${version}.zip";
    sha256 = "0vzrng1w2k7m4z0x9h6zbrcf33dx08ly8fnbxzz3ms2k2dbsmpl6";
  };

  buildInputs = [unzip];
  configurePhase = "export prefix=$out";

  postInstall = ''
    mkdir -p "$out/share/doc/topgit-${version}"
    cp README "$out/share/doc/topgit-${version}/"
    mkdir -p "$out/etc/bash_completion.d"
    make prefix="$out" install
    mv "contrib/tg-completion.bash" "$out/etc/bash_completion.d/"
  '';

  meta = {
    description = "TopGit aims to make handling of large amount of interdependent topic branches easier";
    maintainers = [ lib.maintainers.marcweber lib.maintainers.ludo lib.maintainers.simons ];
    homepage = http://repo.or.cz/w/topgit.git;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.unix;
  };
}
