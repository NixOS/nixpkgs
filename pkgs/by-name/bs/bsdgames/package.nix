{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  openssl,
  flex,
  bison,
  less,
  miscfiles,
}:

stdenv.mkDerivation rec {
  pname = "bsd-games";
  version = "2.17";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/games/${pname}-${version}.tar.gz";
    hash = "sha256-Bm+SSu9sHF6pRvWI428wMCH138CTlEc48CXY7bxv/2A=";
  };

  buildInputs = [
    ncurses
    openssl
    flex
    bison
  ];

  patches = [
    # Remove UTMPX support on Makefrag file
    (fetchurl {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/dm-noutmpx.patch";
      sha256 = "1k3qp3jj0dksjr4dnppv6dvkwslrgk9c7p2n9vipqildpxgqp7w2";
    })
  ];

  hardeningDisable = [ "format" ];

  makeFlags = [ "STRIP=" ];

  preConfigure = ''
    cat > config.params << EOF
    bsd_games_cfg_man6dir=$out/share/man/man6
    bsd_games_cfg_man8dir=$out/share/man/man8
    bsd_games_cfg_man5dir=$out/share/man/man5
    bsd_games_cfg_wtf_acronymfile=$out/share/misc/acronyms
    bsd_games_cfg_fortune_dir=$out/share/games/fortune
    bsd_games_cfg_quiz_dir=$out/share/games/quiz
    bsd_games_cfg_gamesdir=$out/bin
    bsd_games_cfg_sbindir=$out/bin
    bsd_games_cfg_usrbindir=$out/bin
    bsd_games_cfg_libexecdir=$out/lib/games/dm
    bsd_games_cfg_docdir=$out/share/doc/bsd-games
    bsd_games_cfg_sharedir=$out/share/games
    bsd_games_cfg_varlibdir=.
    bsd_games_cfg_non_interactive=y
    bsd_games_cfg_no_build_dirs="dab hack phantasia sail"
    bsd_games_cfg_dictionary_src=${miscfiles}/share/web2
    bsd_games_cfg_pager=${less}
    EOF

    sed -e s/getline/bsdgames_local_getline/g -i $(grep getline -rl .)
  '';

  postConfigure = ''
    sed -i -e 's,/usr,'$out, \
       -e "s,-o root -g root, ," \
       -e "s,-o root -g games, ," \
       -e "s,.*chown.*,true," \
       -e 's/INSTALL_VARDATA.*/INSTALL_VARDATA := true/' \
       -e 's/INSTALL_HACKDIR.*/INSTALL_HACKDIR := true/' \
       -e 's/INSTALL_DM.*/INSTALL_DM := true/' \
       -e 's/INSTALL_SCORE_FILE.*/INSTALL_SCORE_FILE := true/' \
       Makeconfig install-man
  '';

  meta = {
    homepage = "http://www.t2-project.org/packages/bsd-games.html";
    description = "Ports of all the games from NetBSD-current that are free";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
