{ stdenv, lib, bundlerEnv, gpgme, ruby, ncurses, writeText, zlib, xapian, pkgconfig, which }:

bundlerEnv {
  name = "sup-0.20.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  fixes.gpgme = attrs: {
    buildInputs = [ gpgme ];
  };

  fixes.ncursesw = attrs: {
    buildInputs = [ ncurses ];
    buildArgs = [
      "--with-cflags=-I${ncurses}/include"
      "--with-ldflags=-L${ncurses}/lib"
    ];
  };

  fixes.xapian-ruby = attrs: {
    # use the system xapian
    buildInputs = [ xapian pkgconfig zlib ];
    postPatch = ''
      cp ${./xapian-Rakefile} Rakefile
    '';
    preInstall = ''
      export XAPIAN_CONFIG=${xapian}/bin/xapian-config
    '';
  };

  fixes.sup = attrs: {
    # prevent sup from trying to dynamically install `xapian-ruby`.
    postPatch = ''
      cp ${./mkrf_conf_xapian.rb} ext/mkrf_conf_xapian.rb

      substituteInPlace lib/sup/crypto.rb \
        --replace 'which gpg2' \
                  '${which}/bin/which gpg2'
    '';
  };

  meta = with lib; {
    description = "A curses threads-with-tags style email client";
    homepage    = http://supmua.org;
    license     = with licenses; gpl2;
    maintainers = with maintainers; [ cstrahan lovek323 ];
    platforms   = platforms.unix;
  };
}
