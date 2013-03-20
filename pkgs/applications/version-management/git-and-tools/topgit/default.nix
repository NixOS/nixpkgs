{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "topgit-0.9";

  src = fetchurl {
    url = "https://github.com/greenrd/topgit/archive/${name}.tar.gz";
    sha256 = "1z9x42a0cmn8n2n961qcfl522nd6j9a3dpx1jbqfp24ddrk5zd94";
  };

  configurePhase = "makeFlags=prefix=$out";

  postInstall = ''
    mkdir -p "$out/share/doc/${name}" "$out/etc/bash_completion.d/"
    mv README "$out/share/doc/${name}/"
    mv contrib/tg-completion.bash "$out/etc/bash_completion.d/"
  '';

  meta = {
    homepage = "https://github.com/greenrd/topgit";
    description = "TopGit manages large amount of interdependent topic branches";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ marcweber ludo simons ];
  };
}
