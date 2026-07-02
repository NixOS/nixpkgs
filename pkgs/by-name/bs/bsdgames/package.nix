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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bsd-games";
  version = "2.17";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/games/bsd-games-${finalAttrs.version}.tar.gz";
    hash = "sha256-Bm+SSu9sHF6pRvWI428wMCH138CTlEc48CXY7bxv/2A=";
  };

  buildInputs = [
    ncurses
    openssl
    flex
    bison
  ];

  patches = [
    # Follow All patches from http://t2sde.org/packages/bsd-games.html
    # May be removed in the next version
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/delay_output-sym.patch";
      hash = "sha256-qbtp2cJVmEuxbTgpXM2gRHSNLE25OCmNxK+aeBBPRBw=";
    })
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/dm-noutmpx.patch";
      hash = "sha256-oioJ5M7DAUVzX8k998p2h/APn8azw9Z8txmBuly2ouw=";
    })
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/hotfix-gcc43.patch";
      hash = "sha256-9pkJmEOmM5vd/5nm3AlsbJNX0oX1kCtFrmciGpStvlA=";
    })
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/hotfix-glibc.patch";
      hash = "sha256-yNL88XORTXl2qSYTlYCYDN2G++TzBxywBpYdK+ufwrA=";
    })
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/hotfix.patch";
      hash = "sha256-UFXvtfVzJLRWvzbv0gaoVdt0vZOUj4UWWqoCZL/BDqE=";
    })
    (fetchpatch {
      url = "http://svn.exactcode.de/t2/trunk/package/games/bsd-games/postfix-bsd.patch";
      hash = "sha256-Noqq+FpSJb3heejGGHyLYYkHB3fC4qCv/p1XMfEGdx8=";
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

    sed -e '/sigpause/d' -i hunt/hunt/otto.c
  '';

  postConfigure = ''
    sed -i -e 's,/usr,'$out, \
       -e "s,-o root -g root, ," \
       -e "s,-o root -g games, ," \
       -e "s,.*chown.*,true," \
       -e 's/install -c -m 2755/install -Dm755/' \
       -e 's/INSTALL_VARDATA.*/INSTALL_VARDATA := true/' \
       -e 's/INSTALL_HACKDIR.*/INSTALL_HACKDIR := true/' \
       -e 's/INSTALL_DM.*/INSTALL_DM := true/' \
       -e 's/INSTALL_SCORE_FILE.*/INSTALL_SCORE_FILE := true/' \
       Makeconfig install-man
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "http://www.t2-project.org/packages/bsd-games.html";
    description = "Ports of all the games from NetBSD-current that are free";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
})
