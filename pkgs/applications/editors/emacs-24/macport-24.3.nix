{ stdenv, fetchurl, ncurses, pkgconfig, texinfo, libxml2, gnutls
}:

stdenv.mkDerivation rec {
  emacsName = "emacs-24.3";
  name = "${emacsName}-mac-4.8";

  #builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://gnu/emacs/${emacsName}.tar.xz";
    sha256 = "1385qzs3bsa52s5rcncbrkxlydkw0ajzrvfxgv8rws5fx512kakh";
  };

  macportSrc = fetchurl {
    url = "ftp://ftp.math.s.chiba-u.ac.jp/emacs/${name}.tar.gz";
    sha256 = "194y341zrpjp75mc3099kjc0inr1d379wwsnav257bwsc967h8yx";
  };

  patches = [ ./darwin-new-sections.patch ];

  buildInputs = [ ncurses pkgconfig texinfo libxml2 gnutls ];

  postUnpack = ''
    mv $emacsName $name
    tar xzf $macportSrc
    mv $name $emacsName
  '';

  preConfigure = ''
    patch -p0 < patch-mac

    # The search for 'tputs' will fail because it's in ncursesw within the
    # ncurses package, yet Emacs' configure script only looks in ncurses.
    # Further, we need to make sure that the -L option occurs before mention
    # of the library, so that it finds it within the Nix store.
    sed -i 's/tinfo ncurses/tinfo ncursesw/' configure
    ncurseslib=$(echo ${ncurses}/lib | sed 's#/#\\/#g')
    sed -i "s/OLIBS=\$LIBS/OLIBS=\"-L$ncurseslib \$LIBS\"/" configure
    sed -i 's/LIBS="\$LIBS_TERMCAP \$LIBS"/LIBS="\$LIBS \$LIBS_TERMCAP"/' configure

    configureFlagsArray=(
      LDFLAGS=-L${ncurses}/lib
      --with-xml2=yes
      --with-gnutls=yes
      --with-mac
      --enable-mac-app=$out/Applications
    )
    makeFlagsArray=(
      CFLAGS=-O3
      LDFLAGS="-O3 -L${ncurses}/lib"
    );
  '';

  postInstall = ''
    cat >$out/share/emacs/site-lisp/site-start.el <<EOF
    ;; nixos specific load-path
    (when (getenv "NIX_PROFILES") (setq load-path
                          (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                             (split-string (getenv "NIX_PROFILES"))))
                    load-path)))

    ;; make tramp work for NixOS machines
    (eval-after-load 'tramp '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))
    EOF
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ jwiegley ];
    platforms   = platforms.darwin;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.

      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.

      This is "Mac port" addition to GNU Emacs 24. This provides a native
      GUI support for Mac OS X 10.4 - 10.9. Note that Emacs 23 and later
      already contain the official GUI support via the NS (Cocoa) port for
      Mac OS X 10.4 and later. So if it is good enough for you, then you
      don't need to try this.
    '';
  };
}
