{ callPackage }:
  {
    afternoon-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "afternoon-theme";
        ename = "afternoon-theme";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/afternoon-theme-0.1.tar";
          sha256 = "0aalwn1hf0p756qmiybmxphh4dx8gd5r4jhbl43l6y68fdijr6qg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/afternoon-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    alect-themes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "alect-themes";
        ename = "alect-themes";
        version = "0.10";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/alect-themes-0.10.tar";
          sha256 = "0j5zwmxq1f9hlarr1f0j010kd3n2k8hbhr8pw789j3zlc2kmx5bb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/alect-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    ample-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ample-theme";
        ename = "ample-theme";
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/ample-theme-0.3.0.tar";
          sha256 = "0b5a9pqvmfc3h1l0rsmw57vj5j740ysnlpiig6jx9rkgn7awm5p1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ample-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    anti-zenburn-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "anti-zenburn-theme";
        ename = "anti-zenburn-theme";
        version = "2.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/anti-zenburn-theme-2.5.1.tar";
          sha256 = "06d7nm4l6llv7wjbwnhfaamrcihichljkpwnllny960pi56a8gmr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/anti-zenburn-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    apache-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "apache-mode";
        ename = "apache-mode";
        version = "2.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/apache-mode-2.2.0.tar";
          sha256 = "022s7rw7ary1cx3riszzvb7wi0y078vixkcyggjdg5j2ckjpc8gb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/apache-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    apropospriate-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "apropospriate-theme";
        ename = "apropospriate-theme";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/apropospriate-theme-0.1.1.tar";
          sha256 = "11m80gijxvg4jf9davjja3bvykv161ggsrg7q0bihr0gq0flxgd7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/apropospriate-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    arduino-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, spinner }:
      elpaBuild {
        pname = "arduino-mode";
        ename = "arduino-mode";
        version = "1.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/arduino-mode-1.3.0.tar";
          sha256 = "1270mbjgj0kmmjqqblwaipmd2667yp31mgspib3c5d7d6acs1bfx";
        };
        packageRequires = [ emacs spinner ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/arduino-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    bison-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "bison-mode";
        ename = "bison-mode";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/bison-mode-0.4.tar";
          sha256 = "19n9kz1ycjpxngd3clzr8lzrnnw19l8sfvlx1yqn35hk7017z7ab";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bison-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    caml = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "caml";
        ename = "caml";
        version = "4.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/caml-4.9.tar";
          sha256 = "00ldvz6r10vwwmk6f3az534p0340ywn7knsg2bmvbvh3q51vyl9i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/caml.html";
          license = lib.licenses.free;
        };
      }) {};
    clojure-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "clojure-mode";
        ename = "clojure-mode";
        version = "5.13.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/clojure-mode-5.13.0.tar";
          sha256 = "16xll0sp7mqzwldfsihp7j3dlm6ps1l1awi122ff8w7xph7b0wfh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clojure-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    color-theme-tangotango = callPackage ({ color-theme
                                          , elpaBuild
                                          , fetchurl
                                          , lib }:
      elpaBuild {
        pname = "color-theme-tangotango";
        ename = "color-theme-tangotango";
        version = "0.0.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/color-theme-tangotango-0.0.6.tar";
          sha256 = "0lfr3xg9xvfjb12kcw80d35a1ayn4f5w1dkd2b0kx0wxkq0bykim";
        };
        packageRequires = [ color-theme ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/color-theme-tangotango.html";
          license = lib.licenses.free;
        };
      }) {};
    crux = callPackage ({ elpaBuild, fetchurl, lib, seq }:
      elpaBuild {
        pname = "crux";
        ename = "crux";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/crux-0.4.0.tar";
          sha256 = "01yg54s2l3zr4h7h3nw408bqzrr4yds9rfgc575b76006v5d3ciy";
        };
        packageRequires = [ seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crux.html";
          license = lib.licenses.free;
        };
      }) {};
    cyberpunk-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cyberpunk-theme";
        ename = "cyberpunk-theme";
        version = "1.22";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cyberpunk-theme-1.22.tar";
          sha256 = "1kva129l8vwfvafw329znrsqhm1j645xsyz55il1jhc28fbijp51";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cyberpunk-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    d-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "d-mode";
        ename = "d-mode";
        version = "202003130913";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/d-mode-202003130913.tar";
          sha256 = "1pad0ib8l1zkjmh97n1pkwph1xdbcqidnicm3nwmcbmbi61lddsx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/d-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    dart-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dart-mode";
        ename = "dart-mode";
        version = "1.0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/dart-mode-1.0.7.tar";
          sha256 = "13n0fmnxgnq8vjw0n5vwgdgfm5lznvrm3xkak4snkdw7w3rd3a20";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dart-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    dracula-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dracula-theme";
        ename = "dracula-theme";
        version = "1.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/dracula-theme-1.7.0.tar";
          sha256 = "0vbi9560phdp38x5mfl1f9rp8cw7p7s2mvbww84ka0gfz0zrczpm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dracula-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    editorconfig = callPackage ({ cl-lib ? null
                                , elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , nadvice }:
      elpaBuild {
        pname = "editorconfig";
        ename = "editorconfig";
        version = "0.8.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/editorconfig-0.8.2.tar";
          sha256 = "1ff8hwyzb249lf78j023sbibgfmimmk6mxkjmcnqqnk1jafprk02";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/editorconfig.html";
          license = lib.licenses.free;
        };
      }) {};
    evil = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "evil";
        ename = "evil";
        version = "1.14.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-1.14.0.tar";
          sha256 = "11hzx3ya1119kr8dwlg264biixiqgvi7zwxxksql0a9hqp57rdpx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-kondor = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flymake-kondor";
        ename = "flymake-kondor";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flymake-kondor-0.1.2.tar";
          sha256 = "17mmn9mj4zl5f7byairkgxz6s2mrq73q3219s73c0b2g0g846krn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-kondor.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "geiser";
        ename = "geiser";
        version = "0.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-0.18.tar";
          sha256 = "131j4f82hl4pqj07qsl1f2dz4105v5fyll3bc97ggayzvrdiy58i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chez = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chez";
        ename = "geiser-chez";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chez-0.16.tar";
          sha256 = "016b7n5rv7fyrw4lqcprhhf2rai5vvmmc8a13l4w3a30rwcgm7cd";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chez.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chibi = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chibi";
        ename = "geiser-chibi";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chibi-0.16.tar";
          sha256 = "0j9dgg2q01ya6yawpfc15ywrfykd5gzbh118k1x4mghfkfnqn1zi";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chibi.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chicken = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chicken";
        ename = "geiser-chicken";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chicken-0.16.tar";
          sha256 = "1zmb8c86akrd5f1v59s4xkbpgsqbdcbc6d5f9h6kxa55ylc4dn6a";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chicken.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-gambit = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-gambit";
        ename = "geiser-gambit";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-gambit-0.16.tar";
          sha256 = "0bc38qlqj7a3cnrcnqrb6m3jvjh2ia5iby9i50vcn0jbs52rfsnz";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-gambit.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-gauche = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-gauche";
        ename = "geiser-gauche";
        version = "0.0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-gauche-0.0.2.tar";
          sha256 = "0wd0yddasryy36ms5ghf0gs8wf80sgdxci2hd8k0fvnyi7c3wnj5";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-gauche.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-guile = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-guile";
        ename = "geiser-guile";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-guile-0.17.tar";
          sha256 = "0g4982rfxjp08qi6nxz73lsbdwf388fx511394yw4s7ml6v1m4kd";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-guile.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-kawa = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-kawa";
        ename = "geiser-kawa";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-kawa-0.0.1.tar";
          sha256 = "1qh4qr406ahk4k8g46nzkiic1fidhni0a5zv4i84cdypv1c4473p";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-kawa.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-mit = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-mit";
        ename = "geiser-mit";
        version = "0.13";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-mit-0.13.tar";
          sha256 = "1y2cgrcvdp358x7lpcz8x8nw5g1y4h03d9gbkbd6k85643cwrkbi";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-mit.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-racket = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-racket";
        ename = "geiser-racket";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-racket-0.16.tar";
          sha256 = "0lf2lbgpl8pvx7yhiydb7j5hk3kdx34zvhva4zqnzya6zf30w257";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-racket.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-stklos = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-stklos";
        ename = "geiser-stklos";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-stklos-1.3.tar";
          sha256 = "1wkhnkdhdrhrh0vipgnlmyimi859za6jhf2ldpwfmk8r2aj8ywan";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-stklos.html";
          license = lib.licenses.free;
        };
      }) {};
    git-commit = callPackage ({ dash
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib
                              , transient
                              , with-editor }:
      elpaBuild {
        pname = "git-commit";
        ename = "git-commit";
        version = "3.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/git-commit-3.3.0.tar";
          sha256 = "0lp6r4w1k0idvfc2h0chlplap2i4x2slva9cw3iw1rhhxbcvlmdx";
        };
        packageRequires = [ dash emacs transient with-editor ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/git-commit.html";
          license = lib.licenses.free;
        };
      }) {};
    git-modes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "git-modes";
        ename = "git-modes";
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/git-modes-1.4.0.tar";
          sha256 = "1pag50l0rl361p1617rdvhhdajsmq9b1lyi94g16hibygdn7vaff";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/git-modes.html";
          license = lib.licenses.free;
        };
      }) {};
    gnuplot = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gnuplot";
        ename = "gnuplot";
        version = "0.8.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gnuplot-0.8.0.tar";
          sha256 = "1f27y18ivcdwlkgr3ql4qcbgzdp6vk1bkw2wlryrclpydbb1nya3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnuplot.html";
          license = lib.licenses.free;
        };
      }) {};
    go-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "go-mode";
        ename = "go-mode";
        version = "1.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/go-mode-1.5.0.tar";
          sha256 = "0v4lw5dkijajpxyigin4cd5q4ldrabljaz65zr5f7mgqn5sizj3q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/go-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    goto-chg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "goto-chg";
        ename = "goto-chg";
        version = "1.7.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/goto-chg-1.7.4.tar";
          sha256 = "1sg2gp48b83gq0j821lk241lwyxkhqr6w5d1apbnkm3qf08qjwba";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/goto-chg.html";
          license = lib.licenses.free;
        };
      }) {};
    guru-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "guru-mode";
        ename = "guru-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/guru-mode-1.0.tar";
          sha256 = "18vz80yc7nv6dgyyxmlxslwim7qpb1dx2y5382c2wbdqp0icg41g";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/guru-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    haml-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "haml-mode";
        ename = "haml-mode";
        version = "3.1.10";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haml-mode-3.1.10.tar";
          sha256 = "1qkhm52xr8vh9zp728ass5kxjw7fj65j84m06db084qpavnwvysa";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/haml-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    haskell-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "haskell-mode";
        ename = "haskell-mode";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haskell-mode-4.7.1.tar";
          sha256 = "07x7440xi8dkv1zpzwi7p96jy3zd6pdv1mhs066l8bp325516wyb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/haskell-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    haskell-tng-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, popup }:
      elpaBuild {
        pname = "haskell-tng-mode";
        ename = "haskell-tng-mode";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haskell-tng-mode-0.0.1.tar";
          sha256 = "1dndnxb9bdjnixyl09025065wdrk0h8q721rbwvransq308fijwy";
        };
        packageRequires = [ emacs popup ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/haskell-tng-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    highlight-parentheses = callPackage ({ elpaBuild
                                         , emacs
                                         , fetchurl
                                         , lib }:
      elpaBuild {
        pname = "highlight-parentheses";
        ename = "highlight-parentheses";
        version = "2.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/highlight-parentheses-2.1.0.tar";
          sha256 = "1rsixbvglar0k0x24xkxw80sx9i85q48jdzx6wbyjz2clz974ja5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-parentheses.html";
          license = lib.licenses.free;
        };
      }) {};
    htmlize = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "htmlize";
        ename = "htmlize";
        version = "1.57";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/htmlize-1.57.tar";
          sha256 = "1k4maqkcicvpl4yxkx6ha98x36ppcfdp2clcdg4fjx945yamx80s";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/htmlize.html";
          license = lib.licenses.free;
        };
      }) {};
    idris-mode = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib
                              , prop-menu }:
      elpaBuild {
        pname = "idris-mode";
        ename = "idris-mode";
        version = "0.9.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/idris-mode-0.9.18.tar";
          sha256 = "1z4wsqzxsmn1vdqp44b32m4wzs4bbnsyzv09v9ggr4l4h2j4c3x5";
        };
        packageRequires = [ cl-lib emacs prop-menu ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/idris-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    inf-clojure = callPackage ({ clojure-mode
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "inf-clojure";
        ename = "inf-clojure";
        version = "3.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-clojure-3.1.0.tar";
          sha256 = "0jw6rzplicbv2l7si46naspzp5lqwj20b1nmfs9zal58z1gx6zjk";
        };
        packageRequires = [ clojure-mode emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inf-clojure.html";
          license = lib.licenses.free;
        };
      }) {};
    j-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "j-mode";
        ename = "j-mode";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/j-mode-1.1.1.tar";
          sha256 = "0l0l71z5i725dnw4l9w2cfjhrijwx9z8mgyf2dfcbly1cl2nvnx2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/j-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    julia-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "julia-mode";
        ename = "julia-mode";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/julia-mode-0.4.tar";
          sha256 = "1qi6z6007q2jgcb96iy34m87jsg9ss3jhzlnl2cl8dn26yqmdky4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/julia-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    lua-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lua-mode";
        ename = "lua-mode";
        version = "20210802";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/lua-mode-20210802.tar";
          sha256 = "1yarwai9a0w4yywd0ajdkif4g26z98zw91lg1z78qw0k61qjmnh6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lua-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    macrostep = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "macrostep";
        ename = "macrostep";
        version = "0.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/macrostep-0.9.tar";
          sha256 = "10crvq9xww4nvrswqq888y9ah3fl4prj0ha865aqbyrhhbpg18gd";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/macrostep.html";
          license = lib.licenses.free;
        };
      }) {};
    magit = callPackage ({ dash
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , git-commit
                         , lib
                         , magit-section
                         , transient
                         , with-editor }:
      elpaBuild {
        pname = "magit";
        ename = "magit";
        version = "3.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/magit-3.3.0.tar";
          sha256 = "0ihrds45z12z155c1y7haz1mxc95w6v4rynh0izm159xhz44121z";
        };
        packageRequires = [
          dash
          emacs
          git-commit
          magit-section
          transient
          with-editor
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/magit.html";
          license = lib.licenses.free;
        };
      }) {};
    magit-section = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "magit-section";
        ename = "magit-section";
        version = "3.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/magit-section-3.3.0.tar";
          sha256 = "08ac10vips6f2gy4x4w2wkz2ki3q0d6dhynkmlpdinsdmgagziny";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/magit-section.html";
          license = lib.licenses.free;
        };
      }) {};
    markdown-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "markdown-mode";
        ename = "markdown-mode";
        version = "2.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/markdown-mode-2.4.tar";
          sha256 = "002nvc2p7jzznr743znbml3vj8a3kvdd89rlbi28f5ha14g2567z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markdown-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    material-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "material-theme";
        ename = "material-theme";
        version = "2015";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/material-theme-2015.tar";
          sha256 = "027plf401y3lb5y9hzj8gpy9sm0p1k8hv94pywnagq4kr9hivnb9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/material-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    monokai-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "monokai-theme";
        ename = "monokai-theme";
        version = "3.5.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/monokai-theme-3.5.3.tar";
          sha256 = "15b5ijkb0wrixlw13rj02x7m0r3ldqfs3bb6g48hhbqfapd6rcx0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/monokai-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    multiple-cursors = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "multiple-cursors";
        ename = "multiple-cursors";
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/multiple-cursors-1.4.0.tar";
          sha256 = "0f7rk8vw42bgdf5yb4qpnrc3bxvbaafmdqd7kiiqnj5m029yr14f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multiple-cursors.html";
          license = lib.licenses.free;
        };
      }) {};
    nasm-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nasm-mode";
        ename = "nasm-mode";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/nasm-mode-1.1.1.tar";
          sha256 = "1smndl3mbiaaphy173zc405zg4wv0mv041vzy11fr74r5w4p232j";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nasm-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    nginx-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "nginx-mode";
        ename = "nginx-mode";
        version = "1.1.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/nginx-mode-1.1.9.tar";
          sha256 = "04jy0zx058hj37ab2n6wwbbwyycsbsb2fj8s4a5f1is2in35nqy0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nginx-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contrib = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-contrib";
        ename = "org-contrib";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-contrib-0.3.tar";
          sha256 = "0fqhyby7624drskfsasgvzyxbgjb42rd6vw8l6xgb3h22kaprl0q";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
    php-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "php-mode";
        ename = "php-mode";
        version = "1.24.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/php-mode-1.24.0.tar";
          sha256 = "158850zdmz5irjy6cjai1i8j7qs1vwp95a2dli9f341lbpv2jvzp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/php-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    popup = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "popup";
        ename = "popup";
        version = "0.5.8";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/popup-0.5.8.tar";
          sha256 = "1amwxsymzvzmj8696fa6i0cqx4ac581rvr4dwkri7akkr7amh3yh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/popup.html";
          license = lib.licenses.free;
        };
      }) {};
    projectile = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "projectile";
        ename = "projectile";
        version = "2.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/projectile-2.5.0.tar";
          sha256 = "09gsm6xbqj3357vlshs1w7ygfm004gpgs0pqrvwl6xmccxpqzmi0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/projectile.html";
          license = lib.licenses.free;
        };
      }) {};
    prop-menu = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "prop-menu";
        ename = "prop-menu";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/prop-menu-0.1.2.tar";
          sha256 = "1csx5aycl478v4hia6lyrdb32hs1haf9n39ngfrbx9ysp7gkj0va";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/prop-menu.html";
          license = lib.licenses.free;
        };
      }) {};
    request = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "request";
        ename = "request";
        version = "0.3.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/request-0.3.3.tar";
          sha256 = "168yy902bcjfdaahsbzhzb4wgqbw1mq1lfwdjh66fpzqs75c5q00";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/request.html";
          license = lib.licenses.free;
        };
      }) {};
    rubocop = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rubocop";
        ename = "rubocop";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rubocop-0.6.0.tar";
          sha256 = "1gw30ya6xyi359k9fihjx75h7ahs067i9bvkyla0rbhmc5xdz6ww";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rubocop.html";
          license = lib.licenses.free;
        };
      }) {};
    rust-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rust-mode";
        ename = "rust-mode";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rust-mode-1.0.0.tar";
          sha256 = "0ch3hf954iy5hh5zyjjg68szdk5icppmi8nbap27wfwgvhvyfa67";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rust-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    sass-mode = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , fetchurl
                             , haml-mode
                             , lib }:
      elpaBuild {
        pname = "sass-mode";
        ename = "sass-mode";
        version = "3.0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sass-mode-3.0.16.tar";
          sha256 = "1nkp7cvsc2dbxkfv346hwsly34nhv1hhc8lgcs470xzdxi908p61";
        };
        packageRequires = [ cl-lib haml-mode ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sass-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    scala-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "scala-mode";
        ename = "scala-mode";
        version = "0.23";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/scala-mode-0.23.tar";
          sha256 = "0dmyh5x519f5b9h034a1yjgmr1ai8pd22a032x31zgdkwl2xyrfd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scala-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    slime = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, macrostep }:
      elpaBuild {
        pname = "slime";
        ename = "slime";
        version = "2.26.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/slime-2.26.1.tar";
          sha256 = "0f7absmq0nnhhq0i8nfgn2862ydvwlqyzhcq4s6m91mn72d7dw5i";
        };
        packageRequires = [ cl-lib macrostep ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/slime.html";
          license = lib.licenses.free;
        };
      }) {};
    sly = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sly";
        ename = "sly";
        version = "1.0.43";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sly-1.0.43.tar";
          sha256 = "0qgji539qwk7lv9g1k11w0i2nn7n7nk456gwa0bh556mcqz2ndr8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sly.html";
          license = lib.licenses.free;
        };
      }) {};
    smartparens = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "smartparens";
        ename = "smartparens";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/smartparens-4.7.1.tar";
          sha256 = "0si9wb7j760c4vdv7p049bgppppw5crrh50038bsh8sghq2gdld8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/smartparens.html";
          license = lib.licenses.free;
        };
      }) {};
    solarized-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "solarized-theme";
        ename = "solarized-theme";
        version = "1.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/solarized-theme-1.3.0.tar";
          sha256 = "0wa3wp9r0h4y3kkiw8s4pi1zvg22yhnpsp8ckv1hp4y6js5jbg65";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/solarized-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    subatomic-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "subatomic-theme";
        ename = "subatomic-theme";
        version = "1.8.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/subatomic-theme-1.8.1.tar";
          sha256 = "0j496l7c2rwgxk2srcf1a70z63y48q5bs9cpx95212q7rl20zhip";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/subatomic-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    swift-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "swift-mode";
        ename = "swift-mode";
        version = "8.4.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/swift-mode-8.4.1.tar";
          sha256 = "0f87bjgva0iv818bh2dqvc1svrwh5zm134jpxcmvmzr1yqazx4qp";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swift-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    systemd = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "systemd";
        ename = "systemd";
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/systemd-1.6.tar";
          sha256 = "1khfnx2qmg1i4m6axyya0xbzr3c9j136b8pzmqdnd6jamxh43wcg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/systemd.html";
          license = lib.licenses.free;
        };
      }) {};
    tuareg = callPackage ({ caml, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tuareg";
        ename = "tuareg";
        version = "2.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tuareg-2.3.0.tar";
          sha256 = "0a24q64yk4bbgsvm56j1y68zs9yi25qyl83xydx3ff75sk27f1yb";
        };
        packageRequires = [ caml emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tuareg.html";
          license = lib.licenses.free;
        };
      }) {};
    ujelly-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ujelly-theme";
        ename = "ujelly-theme";
        version = "1.2.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/ujelly-theme-1.2.9.tar";
          sha256 = "04h86s0a44cmxizqi4p5h9gl1aiqwrvkh3xmawvn7z836i3hvxn9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ujelly-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-fossil = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "vc-fossil";
        ename = "vc-fossil";
        version = "20210928";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/vc-fossil-20210928.tar";
          sha256 = "0n4h1cj1336mv5cswq0139bkry5gnv4hrrwzd4bqhrxp5kbhqa5y";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-fossil.html";
          license = lib.licenses.free;
        };
      }) {};
    web-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "web-mode";
        ename = "web-mode";
        version = "17.0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/web-mode-17.0.4.tar";
          sha256 = "0ji40fcw3y2n4dw0cklbvsybv04wmfqfnqnykgp05aai388rp3j1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    wgrep = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "wgrep";
        ename = "wgrep";
        version = "2.3.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/wgrep-2.3.3.tar";
          sha256 = "12w9vsawqnd0rvsahx8vdiabds8rl1zkpmspmcqn28jprbql734r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wgrep.html";
          license = lib.licenses.free;
        };
      }) {};
    with-editor = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "with-editor";
        ename = "with-editor";
        version = "3.0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/with-editor-3.0.5.tar";
          sha256 = "0bri6jr99133k9w0d754rw2f6hgjzndczngfw2lf2rvxks448krm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/with-editor.html";
          license = lib.licenses.free;
        };
      }) {};
    yaml-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "yaml-mode";
        ename = "yaml-mode";
        version = "0.0.15";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/yaml-mode-0.0.15.tar";
          sha256 = "19r2kc894dd59f0r3q4gx52iw5cwj5gi1jjkmi8r9y0dya50rzfx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yaml-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet-snippets = callPackage ({ elpaBuild, fetchurl, lib, yasnippet }:
      elpaBuild {
        pname = "yasnippet-snippets";
        ename = "yasnippet-snippets";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/yasnippet-snippets-1.0.tar";
          sha256 = "0p2a10wfh1dvmxbjlbj6p241xaldjim2h8vrv9aghvm3ryfixcpb";
        };
        packageRequires = [ yasnippet ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet-snippets.html";
          license = lib.licenses.free;
        };
      }) {};
    zenburn-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "zenburn-theme";
        ename = "zenburn-theme";
        version = "2.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/zenburn-theme-2.7.0.tar";
          sha256 = "1x7gd5w0g47kcam88lm605b35y35iq3q5f991a84l050c8syrkpy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zenburn-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    zig-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "zig-mode";
        ename = "zig-mode";
        version = "0.0.8";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/zig-mode-0.0.8.tar";
          sha256 = "1v9qpc86n9zg765cy93365hj942z0gndkz6grjl2pk31087n3axy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zig-mode.html";
          license = lib.licenses.free;
        };
      }) {};
  }
