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
    annotate = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "annotate";
        ename = "annotate";
        version = "2.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/annotate-2.0.1.tar";
          sha256 = "1z7s75xcjnkvn7ik7cqylf5c2cih372k1rg4wwxkz3f217d9qjlf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/annotate.html";
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
    anzu = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "anzu";
        ename = "anzu";
        version = "0.64";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/anzu-0.64.tar";
          sha256 = "1znw7wlpjb3d8wsijqziiq21j966x95q9g5j16wx48xyrrzr1mcs";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/anzu.html";
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
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/apropospriate-theme-0.2.0.tar";
          sha256 = "1s4cvh24zj3wpdqc3lklvi1dkba3jf87nxrzq0s3l1rzhg21pfpj";
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
    auto-dim-other-buffers = callPackage ({ elpaBuild
                                          , fetchurl
                                          , lib }:
      elpaBuild {
        pname = "auto-dim-other-buffers";
        ename = "auto-dim-other-buffers";
        version = "2.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/auto-dim-other-buffers-2.1.1.tar";
          sha256 = "0a7xdp25bny5ykf7808jwmziad8myf8yp01p07f20bsrl4m0bzz6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-dim-other-buffers.html";
          license = lib.licenses.free;
        };
      }) {};
    autothemer = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "autothemer";
        ename = "autothemer";
        version = "0.2.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/autothemer-0.2.18.tar";
          sha256 = "1gn7n8xd07sks49xirwah1y039s2hn02p0y1j4lmqh7m47l0fvl2";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/autothemer.html";
          license = lib.licenses.free;
        };
      }) {};
    bash-completion = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bash-completion";
        ename = "bash-completion";
        version = "3.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/bash-completion-3.1.1.tar";
          sha256 = "19vs0rflqm1z4r17pv1qx6v60g03x4n2b7503rjr2d0ljrwkbpcp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bash-completion.html";
          license = lib.licenses.free;
        };
      }) {};
    better-jumper = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "better-jumper";
        ename = "better-jumper";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/better-jumper-1.0.1.tar";
          sha256 = "0jykcz4g0q29k7rawsp2n5zmx88kdh3kbh0497vvpks74vvk2c9f";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/better-jumper.html";
          license = lib.licenses.free;
        };
      }) {};
    bind-map = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bind-map";
        ename = "bind-map";
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/bind-map-1.1.2.tar";
          sha256 = "1x98pgalnpl45h63yw6zz6q16x00phijyx2pf4jrf93s18lx33z5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bind-map.html";
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
    blow = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "blow";
        ename = "blow";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/blow-1.0.tar";
          sha256 = "0z2y3vq8m4x9ihn84x7p2vgkxprrrvhavcgwll897gsc9khp1xda";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/blow.html";
          license = lib.licenses.free;
        };
      }) {};
    boxquote = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "boxquote";
        ename = "boxquote";
        version = "2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/boxquote-2.3.tar";
          sha256 = "1d072qls4ywl71wi29khlq4w6yw9idp55vf811nvbmiihn6lwmiv";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxquote.html";
          license = lib.licenses.free;
        };
      }) {};
    buttercup = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "buttercup";
        ename = "buttercup";
        version = "1.31";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/buttercup-1.31.tar";
          sha256 = "1aw9k3dfscqpq2jkk1yqh6i3682yjs85fnm7rzc5i9qawrl9db6h";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buttercup.html";
          license = lib.licenses.free;
        };
      }) {};
    camera = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "camera";
        ename = "camera";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/camera-0.2.tar";
          sha256 = "1hdq24xy685wzjz3hfxwqmcmsvajcrkr4va4lmvgvdmkvmfk92cj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/camera.html";
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
    cdlatex = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cdlatex";
        ename = "cdlatex";
        version = "4.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cdlatex-4.18.tar";
          sha256 = "15jmy0m1rnpnldl5kwfkipzphgyw4l3fyh30ig3kmzyj8jnpfy4q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cdlatex.html";
          license = lib.licenses.free;
        };
      }) {};
    cider = callPackage ({ clojure-mode
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , lib
                         , parseedn
                         , queue
                         , seq
                         , sesman
                         , spinner }:
      elpaBuild {
        pname = "cider";
        ename = "cider";
        version = "1.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cider-1.7.0.tar";
          sha256 = "0x0acszamylmmly6h8s56lskd5l7lm8hdnf8rbvjd89v0j2anb0l";
        };
        packageRequires = [
          clojure-mode
          emacs
          parseedn
          queue
          seq
          sesman
          spinner
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cider.html";
          license = lib.licenses.free;
        };
      }) {};
    clojure-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "clojure-mode";
        ename = "clojure-mode";
        version = "5.16.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/clojure-mode-5.16.2.tar";
          sha256 = "08bqacpdxkapga163fcjyq0r131a5xjhi85j8v470v0gpvfwvm61";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clojure-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    clojure-ts-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "clojure-ts-mode";
        ename = "clojure-ts-mode";
        version = "0.1.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/clojure-ts-mode-0.1.4.tar";
          sha256 = "1swgcwn5wn23lbi4kjf4f1k7bayyprqm2bqvhdln7vghr5414pi0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clojure-ts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    coffee-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "coffee-mode";
        ename = "coffee-mode";
        version = "0.6.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/coffee-mode-0.6.3.tar";
          sha256 = "1yv1b5rzlj7cpz7gsv2j07mr8z6lkwxp1cldkrc6xlhcbqh8795a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/coffee-mode.html";
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
    corfu-terminal = callPackage ({ corfu
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , popon }:
      elpaBuild {
        pname = "corfu-terminal";
        ename = "corfu-terminal";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/corfu-terminal-0.7.tar";
          sha256 = "1vva3wwmczdph8dlhvwy1vlan8nmzlz6370zia6hz3adwc496a4s";
        };
        packageRequires = [ corfu emacs popon ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/corfu-terminal.html";
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
    cycle-at-point = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , recomplete }:
      elpaBuild {
        pname = "cycle-at-point";
        ename = "cycle-at-point";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cycle-at-point-0.1.tar";
          sha256 = "0097w7nw8d1q7ad4b4qjk0svwxqg80jr2p27540vkir7289w59j3";
        };
        packageRequires = [ emacs recomplete ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cycle-at-point.html";
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
    denote-refs = callPackage ({ denote, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "denote-refs";
        ename = "denote-refs";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/denote-refs-0.1.2.tar";
          sha256 = "1s2q9j2xg2g293ip7w2bq2kjk6pasaf6cmvzcbh0k00yx8aa2alp";
        };
        packageRequires = [ denote emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/denote-refs.html";
          license = lib.licenses.free;
        };
      }) {};
    devhelp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "devhelp";
        ename = "devhelp";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/devhelp-1.0.tar";
          sha256 = "16zx748n24diqqk3jhgyz74s71kqzl7h7l6j9nkz40cpcn18ddiz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devhelp.html";
          license = lib.licenses.free;
        };
      }) {};
    devil = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "devil";
        ename = "devil";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/devil-0.6.0.tar";
          sha256 = "01n552pvr598igmd2q6w9kgjrwgzrgrb4w59mxpsylcv6wy2v2h5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devil.html";
          license = lib.licenses.free;
        };
      }) {};
    diff-ansi = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "diff-ansi";
        ename = "diff-ansi";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/diff-ansi-0.2.tar";
          sha256 = "1fcy89m6wkhc5hy4lqcd60ckrf9qwimilydjx083nackppdz1xlw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diff-ansi.html";
          license = lib.licenses.free;
        };
      }) {};
    doc-show-inline = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "doc-show-inline";
        ename = "doc-show-inline";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/doc-show-inline-0.1.tar";
          sha256 = "11khy906vmhz445ryrdb63v0hjq0x59dn152j96vv9jlg5gqdi3b";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/doc-show-inline.html";
          license = lib.licenses.free;
        };
      }) {};
    dockerfile-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dockerfile-mode";
        ename = "dockerfile-mode";
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/dockerfile-mode-1.7.tar";
          sha256 = "1kb768kv48ypw7fm5xcvkw4pq9mfkvv0bg1inlhfifkb4i9kmz3l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dockerfile-mode.html";
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
    drupal-mode = callPackage ({ elpaBuild, fetchurl, lib, php-mode }:
      elpaBuild {
        pname = "drupal-mode";
        ename = "drupal-mode";
        version = "0.7.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/drupal-mode-0.7.4.tar";
          sha256 = "1cglipmwx5v8vaqkkc7f5ka3dpxlrmmqrqhi885mm625kh2r27j1";
        };
        packageRequires = [ php-mode ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/drupal-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    eat = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "eat";
        ename = "eat";
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/eat-0.8.tar";
          sha256 = "1nvwd8iryjdcbm3v2xjgnf4ifcbs4d8hxn7xydxw6i7c5l8vya9f";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eat.html";
          license = lib.licenses.free;
        };
      }) {};
    edit-indirect = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "edit-indirect";
        ename = "edit-indirect";
        version = "0.1.10";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/edit-indirect-0.1.10.tar";
          sha256 = "0mk6s5hc8n9s5c434im6r06mfgmdf5s44zlr9j3hfkjaic1lf45b";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/edit-indirect.html";
          license = lib.licenses.free;
        };
      }) {};
    editorconfig = callPackage ({ elpaBuild, emacs, fetchurl, lib, nadvice }:
      elpaBuild {
        pname = "editorconfig";
        ename = "editorconfig";
        version = "0.10.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/editorconfig-0.10.1.tar";
          sha256 = "0x6qij98rwq2yra7c0qa01rjb10pg23nwnnsb2fb76d5yhk1dcqw";
        };
        packageRequires = [ emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/editorconfig.html";
          license = lib.licenses.free;
        };
      }) {};
    elixir-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "elixir-mode";
        ename = "elixir-mode";
        version = "2.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/elixir-mode-2.5.0.tar";
          sha256 = "0j4rkwmzb3grs7c56m1f6h3mcxvf4cskxf2qw9jw4fc88j5135ym";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elixir-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    elpher = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "elpher";
        ename = "elpher";
        version = "3.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/elpher-3.5.0.tar";
          sha256 = "10b4s3anbm4afs5i7rkv9qm5f5y9lzyj9dzajb1x654df4l0m4w4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elpher.html";
          license = lib.licenses.free;
        };
      }) {};
    engine-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "engine-mode";
        ename = "engine-mode";
        version = "2.2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/engine-mode-2.2.3.tar";
          sha256 = "07r5g2xrss175m622npna7c51ra4im7l69mkqp6689m2954g23wk";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/engine-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    evil = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "evil";
        ename = "evil";
        version = "1.15.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-1.15.0.tar";
          sha256 = "0xp31w5mr6sprimd2rwy7mpa3kca5ivwf57jmaqyzpd96gh66pg1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-anzu = callPackage ({ anzu, elpaBuild, evil, fetchurl, lib }:
      elpaBuild {
        pname = "evil-anzu";
        ename = "evil-anzu";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-anzu-0.2.tar";
          sha256 = "0fv7kan67g24imhbgggrg8r4pjhpmicpq3g8g1wnq8p9zkwxbm7s";
        };
        packageRequires = [ anzu evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-anzu.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-args = callPackage ({ elpaBuild, evil, fetchurl, lib }:
      elpaBuild {
        pname = "evil-args";
        ename = "evil-args";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-args-1.1.tar";
          sha256 = "0lgwrhjsy098h2lhsiasm39kzkdfqcjnapc2q6f2gyf7zll37761";
        };
        packageRequires = [ evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-args.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-exchange = callPackage ({ cl-lib ? null
                                 , elpaBuild
                                 , evil
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "evil-exchange";
        ename = "evil-exchange";
        version = "0.41";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-exchange-0.41.tar";
          sha256 = "1i07c0zc75mbgb6hzj6py248gxzy0mk3xyaskvwlc371fyyn6v6c";
        };
        packageRequires = [ cl-lib evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-exchange.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-goggles = callPackage ({ elpaBuild, emacs, evil, fetchurl, lib }:
      elpaBuild {
        pname = "evil-goggles";
        ename = "evil-goggles";
        version = "0.0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-goggles-0.0.2.tar";
          sha256 = "0cpxbl2vls52dydaa1x4jkizhnd3vmvs30ivihdl964vmpb1s7yl";
        };
        packageRequires = [ emacs evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-goggles.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-iedit-state = callPackage ({ elpaBuild, evil, fetchurl, iedit, lib }:
      elpaBuild {
        pname = "evil-iedit-state";
        ename = "evil-iedit-state";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-iedit-state-1.3.tar";
          sha256 = "1dsdlhi58xsdsgkdhpnlkx1gkwc4m5sks99ph8lbj179vd1gszn6";
        };
        packageRequires = [ evil iedit ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-iedit-state.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-indent-plus = callPackage ({ cl-lib ? null
                                    , elpaBuild
                                    , evil
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "evil-indent-plus";
        ename = "evil-indent-plus";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-indent-plus-1.0.1.tar";
          sha256 = "0wnn5xjdbc70cxwllz1gf6xf91ijlfhlps7gkb9c3v1kwpsfp3s3";
        };
        packageRequires = [ cl-lib evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-indent-plus.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-lisp-state = callPackage ({ bind-map
                                   , elpaBuild
                                   , evil
                                   , fetchurl
                                   , lib
                                   , smartparens }:
      elpaBuild {
        pname = "evil-lisp-state";
        ename = "evil-lisp-state";
        version = "8.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-lisp-state-8.2.tar";
          sha256 = "0hwv39rkwadm3jri84nf9mw48ybd5a0y02yzjp5cayy7alpf6zcn";
        };
        packageRequires = [ bind-map evil smartparens ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-lisp-state.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-matchit = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "evil-matchit";
        ename = "evil-matchit";
        version = "3.0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-matchit-3.0.2.tar";
          sha256 = "02sim8hkclkp7lzj3hybjky75lyvf452wc7hmbkx1rjb3cx9j5m5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-matchit.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-nerd-commenter = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "evil-nerd-commenter";
        ename = "evil-nerd-commenter";
        version = "3.6.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-nerd-commenter-3.6.1.tar";
          sha256 = "0ixyn669fk7gcnl3nhjma67zvnavikn75yzsa4sx850s5i4i1b2a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-nerd-commenter.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-numbers = callPackage ({ elpaBuild, emacs, evil, fetchurl, lib }:
      elpaBuild {
        pname = "evil-numbers";
        ename = "evil-numbers";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-numbers-0.7.tar";
          sha256 = "1kd60kc8762i9vyig179dnbmrjyw30bm06g26abndw2kjxaqjhr8";
        };
        packageRequires = [ emacs evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-numbers.html";
          license = lib.licenses.free;
        };
      }) {};
    evil-visualstar = callPackage ({ elpaBuild, evil, fetchurl, lib }:
      elpaBuild {
        pname = "evil-visualstar";
        ename = "evil-visualstar";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-visualstar-0.2.0.tar";
          sha256 = "0vjhwdp2ms7k008mm68vzlkxrq0zyrsf4r10w57w77qg5a96151c";
        };
        packageRequires = [ evil ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil-visualstar.html";
          license = lib.licenses.free;
        };
      }) {};
    flx = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "flx";
        ename = "flx";
        version = "0.6.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flx-0.6.2.tar";
          sha256 = "0xmxin1k758nskrxhmvi4m5vbcfi2ncfp5n9q18mlc1j45vwawpx";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flx.html";
          license = lib.licenses.free;
        };
      }) {};
    flx-ido = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, flx, lib }:
      elpaBuild {
        pname = "flx-ido";
        ename = "flx-ido";
        version = "0.6.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flx-ido-0.6.2.tar";
          sha256 = "1jdk87v605m4brvf0pxfd6bz0j2r217cw9pmrpl38nrszbngh67l";
        };
        packageRequires = [ cl-lib flx ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flx-ido.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-kondor = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flymake-kondor";
        ename = "flymake-kondor";
        version = "0.1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flymake-kondor-0.1.3.tar";
          sha256 = "07k8b3wayp1h4hir98zs5srjjsnh6w0h9pzn4vnq9s2jr355509n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-kondor.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-popon = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , flymake ? null
                                 , lib
                                 , popon
                                 , posframe }:
      elpaBuild {
        pname = "flymake-popon";
        ename = "flymake-popon";
        version = "0.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flymake-popon-0.5.1.tar";
          sha256 = "0vk20affwb7qcg7nm6n2ssrrgljisqn45a8jagrf947l2kgaccvd";
        };
        packageRequires = [ emacs flymake popon posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-popon.html";
          license = lib.licenses.free;
        };
      }) {};
    focus = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "focus";
        ename = "focus";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/focus-1.0.1.tar";
          sha256 = "1kiyvbdbjhjfkl5cq6q78lfgbir7iayswwm2qnj4df95nbm8shsz";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/focus.html";
          license = lib.licenses.free;
        };
      }) {};
    forth-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "forth-mode";
        ename = "forth-mode";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/forth-mode-0.2.tar";
          sha256 = "0qk6kg8d38fcvbxa4gfsdyllzrrp9712w74sj29b90fppa11b530";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/forth-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    free-keys = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "free-keys";
        ename = "free-keys";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/free-keys-1.0.tar";
          sha256 = "1w0dslygz098bddap1shwa8pn55ggavz2jn131rmdnbfjy6plglv";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/free-keys.html";
          license = lib.licenses.free;
        };
      }) {};
    gc-buffers = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gc-buffers";
        ename = "gc-buffers";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gc-buffers-1.0.tar";
          sha256 = "15zpg4j25bk7y2wgqsd57c4c6h3xvigf39hjnzh3g1hlrqk2lv0g";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gc-buffers.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser = callPackage ({ elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "geiser";
        ename = "geiser";
        version = "0.29.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-0.29.1.tar";
          sha256 = "0k9jvnaci23swyf3zy67f9msz205d9vdm90rgidnl81w7hg8gjm4";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chez = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chez";
        ename = "geiser-chez";
        version = "0.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chez-0.18.tar";
          sha256 = "01pkcf0lpzmazah3ddd16yf2la4zd5x4mmi5lwpbsyvyfqhxhsca";
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
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chibi-0.17.tar";
          sha256 = "1mpbkv48y1ij762f61hp1zjg3lx8k5b9bbsm5lfb7xzvmk5k3zf0";
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
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chicken-0.17.tar";
          sha256 = "13jhh0083fjx4xq0k31vw5v3ffbmn3jkb2608bimm9xlw6acgn4s";
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
        version = "0.18.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-gambit-0.18.1.tar";
          sha256 = "03cv51war65yrg5qswwlx755byn2nlm1qvbzqqminnidz64kfd3v";
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
    geiser-guile = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , geiser
                                , lib
                                , transient }:
      elpaBuild {
        pname = "geiser-guile";
        ename = "geiser-guile";
        version = "0.28.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-guile-0.28.1.tar";
          sha256 = "0imh2vdc757vimwxi7pjdv09f83js76nbk7dg861qg0bcqf21g3i";
        };
        packageRequires = [ emacs geiser transient ];
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
        version = "0.15";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-mit-0.15.tar";
          sha256 = "11agp5k79g0w5596x98kbwijvqnb1hwrbqx680mh1svd1l8374q0";
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
        version = "1.8";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-stklos-1.8.tar";
          sha256 = "1bz7ggq5pl08pr68nmn82sdpb2vqi7zvsjnai8zvr93dai7p3isa";
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
    git-modes = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "git-modes";
        ename = "git-modes";
        version = "1.4.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/git-modes-1.4.1.tar";
          sha256 = "0zxab7rjy5rh8y0ln9h04pvcim8a4qdpj1zs0c0dwbxcsa7v7hz1";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/git-modes.html";
          license = lib.licenses.free;
        };
      }) {};
    gnu-apl-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gnu-apl-mode";
        ename = "gnu-apl-mode";
        version = "1.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gnu-apl-mode-1.5.1.tar";
          sha256 = "0almjbh35d0myyjaavmqi7yzk3jpqdcqrhsb2x6vcp6pb199g7z8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnu-apl-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gnu-indent = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gnu-indent";
        ename = "gnu-indent";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gnu-indent-1.0.tar";
          sha256 = "0h2kj19k3b9sw1bp0fk37kmc4xwvd3ajlgfa8s13jnvggx77nn8a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnu-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    gnuplot = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gnuplot";
        ename = "gnuplot";
        version = "0.8.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gnuplot-0.8.1.tar";
          sha256 = "015b8ly4wmz03bcysbwy4d63r42sicwqa0j2j4aiis1kpy4lj3xw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnuplot.html";
          license = lib.licenses.free;
        };
      }) {};
    go-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "go-mode";
        ename = "go-mode";
        version = "1.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/go-mode-1.6.0.tar";
          sha256 = "1j83i56ldkf79l7dyjbv9rvy3ki2xlvgj2y7jnap92hbd2q50jsy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/go-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gotham-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gotham-theme";
        ename = "gotham-theme";
        version = "1.1.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gotham-theme-1.1.9.tar";
          sha256 = "0ikczh9crs02hlvnpdknxfbpqmpiicdbshjhi5pz3v7ynizj64vm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gotham-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    goto-chg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "goto-chg";
        ename = "goto-chg";
        version = "1.7.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/goto-chg-1.7.5.tar";
          sha256 = "08wdrwmgy5hanir6py6wiq0pq4lbv9jiyz1m3h947kb35kxalmks";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/goto-chg.html";
          license = lib.licenses.free;
        };
      }) {};
    graphql-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "graphql-mode";
        ename = "graphql-mode";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/graphql-mode-1.0.0.tar";
          sha256 = "11vn02vwiqbkzl9gxsm3gvybkbac13xnzzv2y227j3y8aq5kbwss";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/graphql-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gruber-darker-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gruber-darker-theme";
        ename = "gruber-darker-theme";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gruber-darker-theme-0.7.tar";
          sha256 = "0k2njsg7bwy4i7ll5d9dpqawylgkfvp74bany8g487xvspjscrji";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gruber-darker-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    gruvbox-theme = callPackage ({ autothemer, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gruvbox-theme";
        ename = "gruvbox-theme";
        version = "1.30.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gruvbox-theme-1.30.1.tar";
          sha256 = "19r3ffkyq779jjz0jvyxdf2zhm1yd1lax9sh0qsj1r5xrcmb15l7";
        };
        packageRequires = [ autothemer ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gruvbox-theme.html";
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
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haml-mode-3.2.1.tar";
          sha256 = "10pnpx4x5wjk4yq4kgynkhfv4xg8nzwmfwf1bappivrdii47hbiq";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/haml-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    haskell-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "haskell-mode";
        ename = "haskell-mode";
        version = "17.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haskell-mode-17.4.tar";
          sha256 = "0xf8smasbb53ddg4vxckpg5w48dnm16v2k5vimfqr73cig49z87f";
        };
        packageRequires = [ emacs ];
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
    helm = callPackage ({ elpaBuild, fetchurl, helm-core, lib, popup, wfnames }:
      elpaBuild {
        pname = "helm";
        ename = "helm";
        version = "3.9.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/helm-3.9.4.tar";
          sha256 = "1x0nvzm7xx3xik3znfhsmgbprysrapviv6lf7ndqxgi2cj27jfv3";
        };
        packageRequires = [ helm-core popup wfnames ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/helm.html";
          license = lib.licenses.free;
        };
      }) {};
    helm-core = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "helm-core";
        ename = "helm-core";
        version = "3.9.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/helm-core-3.9.4.tar";
          sha256 = "11aa019d5impf6c3apaz44hv5hjfg3g4wn4a1m7a5svr6isfa79w";
        };
        packageRequires = [ async emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/helm-core.html";
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
        version = "2.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/highlight-parentheses-2.1.1.tar";
          sha256 = "1r0sk4da3apgbik8d84vknwna45k1ks3n0s1fspj5c88b4r7xnsx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-parentheses.html";
          license = lib.licenses.free;
        };
      }) {};
    hl-block-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hl-block-mode";
        ename = "hl-block-mode";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/hl-block-mode-0.2.tar";
          sha256 = "1qrq238arblk8v8nf98kcdckfhwzi27w5zbl31yvf36xz69l9y8n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hl-block-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    hl-column = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hl-column";
        ename = "hl-column";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/hl-column-1.0.tar";
          sha256 = "00y4g912s341p30xnb0qgj0gmzsqm696v06kjgy9yva5qgw51f03";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hl-column.html";
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
    idle-highlight-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "idle-highlight-mode";
        ename = "idle-highlight-mode";
        version = "1.1.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/idle-highlight-mode-1.1.4.tar";
          sha256 = "1j7y03b90gf3pl0xbfirm973k31l7nx90is69m3jrfai2f9qnflr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/idle-highlight-mode.html";
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
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/idris-mode-1.1.0.tar";
          sha256 = "00xbb63kidkygs2zp334nw38gn5mrbky3ii0g8c9k9si4k1dn5gq";
        };
        packageRequires = [ cl-lib emacs prop-menu ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/idris-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    iedit = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "iedit";
        ename = "iedit";
        version = "0.9.9.9.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/iedit-0.9.9.9.9.tar";
          sha256 = "1ic780gd7n2qrpbqr0vy62p7wsrskyvyr571m8m3j25fii8v8cxg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/iedit.html";
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
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-clojure-3.2.1.tar";
          sha256 = "0p1q51wn67abwhn6qa01f190czaq33nmy4ir1jrcxsny4vnbxvx4";
        };
        packageRequires = [ clojure-mode emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inf-clojure.html";
          license = lib.licenses.free;
        };
      }) {};
    inf-ruby = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "inf-ruby";
        ename = "inf-ruby";
        version = "2.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-ruby-2.7.0.tar";
          sha256 = "0wzzhr10q8mnai024g5nprsnl0bcdlqfrh4nxf8qq43paah28i6f";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inf-ruby.html";
          license = lib.licenses.free;
        };
      }) {};
    inkpot-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "inkpot-theme";
        ename = "inkpot-theme";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inkpot-theme-0.1.tar";
          sha256 = "0ik7vkwqlsgxmdckd154kh82zg8jr41vwc0a200x9920l5mnfjq2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inkpot-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    iwindow = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "iwindow";
        ename = "iwindow";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/iwindow-1.0.tar";
          sha256 = "076i0p9kq48hxkkwzzapnni6cpdr25hdrw9bs2cly8w4v5rmd6rj";
        };
        packageRequires = [ compat emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/iwindow.html";
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
    jade-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "jade-mode";
        ename = "jade-mode";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/jade-mode-1.0.1.tar";
          sha256 = "1kkf5ayqzs1rs7b3jqwb21r2mikds3lillfrs3pkcca7lj76313n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jade-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    jinja2-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "jinja2-mode";
        ename = "jinja2-mode";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/jinja2-mode-0.3.tar";
          sha256 = "1zkyac4akwnz8a136xyn6915j6jgpf0xilbf4krw7q6k8nkks2m4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jinja2-mode.html";
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
    keycast = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "keycast";
        ename = "keycast";
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/keycast-1.3.2.tar";
          sha256 = "0z8q1xxx02di0788kgc4xpvl43iyknkj57l9cwf6qq6hi032c9kj";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/keycast.html";
          license = lib.licenses.free;
        };
      }) {};
    kotlin-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "kotlin-mode";
        ename = "kotlin-mode";
        version = "2.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/kotlin-mode-2.0.0.tar";
          sha256 = "0q1pfjcsk6c17hs5xg7wb6f4i29hn3zxgznjcr3v11dm4xmrj9iv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/kotlin-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    lorem-ipsum = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "lorem-ipsum";
        ename = "lorem-ipsum";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/lorem-ipsum-0.4.tar";
          sha256 = "05zk11g0w3bnabxf5937hrkc3k58vlrh1bk61dar9gfbfdq3ijyg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lorem-ipsum.html";
          license = lib.licenses.free;
        };
      }) {};
    lua-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lua-mode";
        ename = "lua-mode";
        version = "20221027";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/lua-mode-20221027.tar";
          sha256 = "1irdlw77ny0a28msrbn4lm66ixrlf2grsj4izhpdm1n0yv66xvfc";
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
        version = "0.9.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/macrostep-0.9.2.tar";
          sha256 = "1257vz50k69wka756c9sjq86apvw876myl3wml55x5m8q328wbcf";
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
        version = "2.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/markdown-mode-2.5.tar";
          sha256 = "195p4bz2k5rs6222pfxv6rk2r22snx33gvc1x3rs020lacppbhik";
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
    mentor = callPackage ({ async
                          , elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , seq
                          , url-scgi
                          , xml-rpc }:
      elpaBuild {
        pname = "mentor";
        ename = "mentor";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/mentor-0.5.tar";
          sha256 = "1kkzm881fxhc5hb83x0j12lv22b72nzw45qrypbl1jf2siispz9l";
        };
        packageRequires = [ async emacs seq url-scgi xml-rpc ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mentor.html";
          license = lib.licenses.free;
        };
      }) {};
    meow = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "meow";
        ename = "meow";
        version = "1.4.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/meow-1.4.4.tar";
          sha256 = "013nmc0jcvwfh6s1l59kld8393ld4sy5icbah9hzd0chj6l72mgh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/meow.html";
          license = lib.licenses.free;
        };
      }) {};
    minibar = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "minibar";
        ename = "minibar";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/minibar-0.3.tar";
          sha256 = "1mgkkjaav9hkg1c0lvn887armxv18hn99zd3dy1dx2lnjv2kfdcp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minibar.html";
          license = lib.licenses.free;
        };
      }) {};
    moe-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "moe-theme";
        ename = "moe-theme";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/moe-theme-1.0.2.tar";
          sha256 = "1hdbm6hw94yyw5cdgfmc5fgnfc2glf0ba8a9ch2y33nzjawklb8x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/moe-theme.html";
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
    mpv = callPackage ({ cl-lib ? null
                       , elpaBuild
                       , emacs
                       , fetchurl
                       , json ? null
                       , lib
                       , org }:
      elpaBuild {
        pname = "mpv";
        ename = "mpv";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/mpv-0.2.0.tar";
          sha256 = "14d5376y9b3jxxhzjcscx03ss61yd129dkb0ki9gmp2sk7cns3n5";
        };
        packageRequires = [ cl-lib emacs json org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mpv.html";
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
    nix-mode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , magit-section
                            , transient }:
      elpaBuild {
        pname = "nix-mode";
        ename = "nix-mode";
        version = "1.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/nix-mode-1.5.0.tar";
          sha256 = "0zi7xmh777pqzgcv18jqwywvidpa984p0m705p6a9fns7dvv53j7";
        };
        packageRequires = [ emacs magit-section transient ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nix-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    oblivion-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "oblivion-theme";
        ename = "oblivion-theme";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/oblivion-theme-0.1.tar";
          sha256 = "0095sc82nl5qxz5nlf2bxbynkxa3plcqr8dq187r70p0775jw46m";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/oblivion-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    opam-switch-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "opam-switch-mode";
        ename = "opam-switch-mode";
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/opam-switch-mode-1.7.tar";
          sha256 = "19mg0k6ish0grhh4d9d9m634jkgbx80bgfwf4xh0q42piypyrmrj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/opam-switch-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    org-auto-tangle = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-auto-tangle";
        ename = "org-auto-tangle";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-auto-tangle-0.6.0.tar";
          sha256 = "07g1cwsr8j1sd8whshi9y2b69qx10g9vd77pmwki9ba4sy0m7b0p";
        };
        packageRequires = [ async emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-auto-tangle.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contrib = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-contrib";
        ename = "org-contrib";
        version = "0.4.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-contrib-0.4.1.tar";
          sha256 = "0xhlsbqjj1zivlz44hdlkcwqalfjwds5fv2pcwn0rskfhr73xp9a";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
    org-drill = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , org
                             , persist
                             , seq }:
      elpaBuild {
        pname = "org-drill";
        ename = "org-drill";
        version = "2.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-drill-2.7.0.tar";
          sha256 = "0f61cfw7qy8w5835hh0rh33ai5i50dzliymdpkvmvffgkx7mikx5";
        };
        packageRequires = [ emacs org persist seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-drill.html";
          license = lib.licenses.free;
        };
      }) {};
    org-journal = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-journal";
        ename = "org-journal";
        version = "2.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-journal-2.2.0.tar";
          sha256 = "1pikz9aqdch11zsya8j3gx44wfl2y5r0kym093pl7w6bjx9bgija";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-journal.html";
          license = lib.licenses.free;
        };
      }) {};
    org-mime = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-mime";
        ename = "org-mime";
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-mime-0.3.2.tar";
          sha256 = "12crmbrjxac1ml2x1jh3wbpgh0fddhnl3gdmb5r9dlpkay1c5dxs";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-mime.html";
          license = lib.licenses.free;
        };
      }) {};
    org-present = callPackage ({ elpaBuild, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-present";
        ename = "org-present";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-present-0.1.tar";
          sha256 = "1b32faz4nv5s4fv0rxkr70dkjlmpiwzds513wpkwr6fvqmcz4kdy";
        };
        packageRequires = [ org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-present.html";
          license = lib.licenses.free;
        };
      }) {};
    org-superstar = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-superstar";
        ename = "org-superstar";
        version = "1.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-superstar-1.5.1.tar";
          sha256 = "0qwnjd6i3mzkvwdwpm3hn8hp3jwza43x1xq1hfi8d6fa9mwzw9nl";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-superstar.html";
          license = lib.licenses.free;
        };
      }) {};
    org-tree-slide = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-tree-slide";
        ename = "org-tree-slide";
        version = "2.8.20";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-tree-slide-2.8.20.tar";
          sha256 = "0aiqiawflgpf56mgr6pkkkqzdc7pwaw575q0yc6f6bvg7idn14qd";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-tree-slide.html";
          license = lib.licenses.free;
        };
      }) {};
    orgit = callPackage ({ compat
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , lib
                         , magit
                         , org }:
      elpaBuild {
        pname = "orgit";
        ename = "orgit";
        version = "1.9.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/orgit-1.9.0.tar";
          sha256 = "1lwvmd0mri1vxqp5d8fqam1qhznfjq0bn5i5jjv15nqzcklsw7bm";
        };
        packageRequires = [ compat emacs magit org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/orgit.html";
          license = lib.licenses.free;
        };
      }) {};
    pacmacs = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pacmacs";
        ename = "pacmacs";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/pacmacs-0.1.1.tar";
          sha256 = "0ni4jmvkdqiiw2xync6raxvq4gr2hc7b65cbil66z7g7vlw5y56y";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pacmacs.html";
          license = lib.licenses.free;
        };
      }) {};
    paredit = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "paredit";
        ename = "paredit";
        version = "26";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/paredit-26.tar";
          sha256 = "08f8nm3qyk0b4x7mkgra0zjpn9mmfnpr5g7yrvdzvms38y919qlh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/paredit.html";
          license = lib.licenses.free;
        };
      }) {};
    parseclj = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "parseclj";
        ename = "parseclj";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/parseclj-1.1.0.tar";
          sha256 = "0h6fia59crqb1y83a04sjlhlpm6349s6c14zsiqsfi73m97dli6p";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parseclj.html";
          license = lib.licenses.free;
        };
      }) {};
    parseedn = callPackage ({ elpaBuild, emacs, fetchurl, lib, map, parseclj }:
      elpaBuild {
        pname = "parseedn";
        ename = "parseedn";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/parseedn-1.1.0.tar";
          sha256 = "1by9cy7pn12124vbg59c9qmn2k8v5dbqq4c8if81fclrccjqhrz4";
        };
        packageRequires = [ emacs map parseclj ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parseedn.html";
          license = lib.licenses.free;
        };
      }) {};
    pcmpl-args = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pcmpl-args";
        ename = "pcmpl-args";
        version = "0.1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/pcmpl-args-0.1.3.tar";
          sha256 = "1p9y80k2rb9vlkqbmwdmzw279wlk8yk8ii5kqgkyr1yg224qpaw7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pcmpl-args.html";
          license = lib.licenses.free;
        };
      }) {};
    pcre2el = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pcre2el";
        ename = "pcre2el";
        version = "1.11";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/pcre2el-1.11.tar";
          sha256 = "147da1iqlgsjsnfffk4iwfjsrv98xz5s4wjdys9r98n0j723js7r";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pcre2el.html";
          license = lib.licenses.free;
        };
      }) {};
    pdf-tools = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , let-alist
                             , lib
                             , tablist }:
      elpaBuild {
        pname = "pdf-tools";
        ename = "pdf-tools";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/pdf-tools-1.1.0.tar";
          sha256 = "0gb8c7y55mmz69agg0rkdjrxg0abznl2mj2x8vw12x4x1ggmykkf";
        };
        packageRequires = [ emacs let-alist tablist ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pdf-tools.html";
          license = lib.licenses.free;
        };
      }) {};
    php-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "php-mode";
        ename = "php-mode";
        version = "1.25.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/php-mode-1.25.0.tar";
          sha256 = "05n53risvyzgyqr0r7v7bgd267dh30wq266mmfhj2q37v1gkfjiv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/php-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    popon = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "popon";
        ename = "popon";
        version = "0.13";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/popon-0.13.tar";
          sha256 = "1ifwkiq8viic4ymph0xrpyrmr946brp2cx48yqf4jrhknafqv5qf";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/popon.html";
          license = lib.licenses.free;
        };
      }) {};
    popup = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "popup";
        ename = "popup";
        version = "0.5.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/popup-0.5.9.tar";
          sha256 = "0zyn6q3fwj20y7zdk49jbid2h3yf8l5x8y1kv9mj717kjbxiw063";
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
        version = "2.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/projectile-2.7.0.tar";
          sha256 = "1ibxsa1lv9aiplkfplamyn2wc2c6vfwfszyaicfx79aq2w9427bg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/projectile.html";
          license = lib.licenses.free;
        };
      }) {};
    proof-general = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "proof-general";
        ename = "proof-general";
        version = "4.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/proof-general-4.5.tar";
          sha256 = "13zy339yz6ijgkcnqxzcyg909z77w3capb3gim1riy3sqikvv04x";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/proof-general.html";
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
    racket-mode = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "racket-mode";
        ename = "racket-mode";
        version = "1.0.20230628.162612";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/racket-mode-1.0.20230628.162612.tar";
          sha256 = "1if790s2dr9n1jql0mjnb4jbimff3as8112c6p47w7pbcjfjasch";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/racket-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    rainbow-delimiters = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rainbow-delimiters";
        ename = "rainbow-delimiters";
        version = "2.1.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rainbow-delimiters-2.1.5.tar";
          sha256 = "0bb7sqjgpm3041srr44l23p3mcjhvnpxl594ma25pbs11qqipz5w";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rainbow-delimiters.html";
          license = lib.licenses.free;
        };
      }) {};
    raku-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "raku-mode";
        ename = "raku-mode";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/raku-mode-0.2.1.tar";
          sha256 = "01ygn20pbq18rciczbb0mkszr33pifs6i74rajxz03bcgx2j3q6f";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/raku-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    recomplete = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "recomplete";
        ename = "recomplete";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/recomplete-0.2.tar";
          sha256 = "09n21mx90wr53xlhy5mlca675ah9ynnnc2afzjjml98ll81f4k23";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/recomplete.html";
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
    rfc-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rfc-mode";
        ename = "rfc-mode";
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rfc-mode-1.4.0.tar";
          sha256 = "0036ypsjm35x8vwrlm346wcqmh85kbjmw0813q65z6k0gvmnwldj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rfc-mode.html";
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
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rust-mode-1.0.5.tar";
          sha256 = "16dw4mfgfazslsf8n9fir2xc3v3jpw9i7bbgcfbhgclm0g2w9j83";
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
    scad-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "scad-mode";
        ename = "scad-mode";
        version = "93.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/scad-mode-93.2.tar";
          sha256 = "0gp7ghmch5wkbby0avmlgj5kajiccbarjrx1szh9r3f3gi1ahawj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scad-mode.html";
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
    scroll-on-drag = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "scroll-on-drag";
        ename = "scroll-on-drag";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/scroll-on-drag-0.1.tar";
          sha256 = "06bpxfhdhsf6awhjcj21x8kb3g9n6j14s43cd03fp5gb0m5bs478";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scroll-on-drag.html";
          license = lib.licenses.free;
        };
      }) {};
    scroll-on-jump = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "scroll-on-jump";
        ename = "scroll-on-jump";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/scroll-on-jump-0.2.tar";
          sha256 = "09yndis96ps18i252h66ins1hi3zn27410s5hahkj2989q4cqi1s";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scroll-on-jump.html";
          license = lib.licenses.free;
        };
      }) {};
    sesman = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sesman";
        ename = "sesman";
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sesman-0.3.2.tar";
          sha256 = "1nv0xh6dklpw1jq8b9biv70gzqa7par5jbqacx2lx0xhkyf0c7c1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sesman.html";
          license = lib.licenses.free;
        };
      }) {};
    shellcop = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "shellcop";
        ename = "shellcop";
        version = "0.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/shellcop-0.1.0.tar";
          sha256 = "0z0aml86y1m11lz8a8wdjfad5dzynjsqw69qin0a4vv2b8gy8mhr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shellcop.html";
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
        version = "1.11.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/smartparens-1.11.0.tar";
          sha256 = "1179wicy5nrjk2iq73rxkx6c44k9ybs1vz6llw0qbwc5l10diyvr";
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
        version = "2.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/solarized-theme-2.0.1.tar";
          sha256 = "1kz34a7133l2dl09mvb8v79k693ypxk01bmqwm8cfa7icqq2ka98";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/solarized-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    spacemacs-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spacemacs-theme";
        ename = "spacemacs-theme";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/spacemacs-theme-0.2.tar";
          sha256 = "07lkaj6gm5iz503p5l6sm1y62mc5wk13nrwzv81f899jw99jcgml";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spacemacs-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    spell-fu = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spell-fu";
        ename = "spell-fu";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/spell-fu-0.3.tar";
          sha256 = "0yr7m0i89ymp93p4qx8a0y1ghg7ydg1479xgvsz71n35x4sbiwba";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spell-fu.html";
          license = lib.licenses.free;
        };
      }) {};
    sqlite3 = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sqlite3";
        ename = "sqlite3";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sqlite3-0.17.tar";
          sha256 = "04m53vn5cvcycv580q6zn5vw54ml7xmhs7bc88cwqj1z5vi3a85x";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sqlite3.html";
          license = lib.licenses.free;
        };
      }) {};
    stylus-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "stylus-mode";
        ename = "stylus-mode";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/stylus-mode-1.0.1.tar";
          sha256 = "0vihp241msg8f0ph8w3w9fkad9b12pmpwg0q5la8nbw7gfy41mz5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/stylus-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    subatomic-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "subatomic-theme";
        ename = "subatomic-theme";
        version = "1.8.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/subatomic-theme-1.8.2.tar";
          sha256 = "0h2ln37ir6w4q44vznlkw4kzaisfpvkgs02dnb2x9b1wdg5qfqw4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/subatomic-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    subed = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "subed";
        ename = "subed";
        version = "1.2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/subed-1.2.3.tar";
          sha256 = "0np4wp7pmpayz8r9p3cl7z1i7yfq8xmkn862n9d104szf4ffk0if";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/subed.html";
          license = lib.licenses.free;
        };
      }) {};
    sweeprolog = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sweeprolog";
        ename = "sweeprolog";
        version = "0.23.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sweeprolog-0.23.0.tar";
          sha256 = "0l2n3411ljbsfy2b2akp30488yi2hbhkyhm8jr1fs39n9k8aks48";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sweeprolog.html";
          license = lib.licenses.free;
        };
      }) {};
    swift-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "swift-mode";
        ename = "swift-mode";
        version = "9.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/swift-mode-9.0.0.tar";
          sha256 = "1s69mm7yhz1dhxz118ik7nxqw6gliivbwv1qvylk8nz2lhr8sf9n";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swift-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    swsw = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "swsw";
        ename = "swsw";
        version = "2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/swsw-2.3.tar";
          sha256 = "0qwdv174bh9k1bpd5szzmhk7hw89xf7rz2i2hzdrmlpvcs3ps653";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swsw.html";
          license = lib.licenses.free;
        };
      }) {};
    symbol-overlay = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "symbol-overlay";
        ename = "symbol-overlay";
        version = "4.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/symbol-overlay-4.1.tar";
          sha256 = "07gcg45y712dblidak2kxp7w0h0gf39hwzwbkpna66k4c4xjpig8";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/symbol-overlay.html";
          license = lib.licenses.free;
        };
      }) {};
    systemd = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "systemd";
        ename = "systemd";
        version = "1.6.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/systemd-1.6.1.tar";
          sha256 = "0h6iwdi3j2ypgcwnyjs8rdlz5f8j25cya6z4v3n2phnkqbncmgx6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/systemd.html";
          license = lib.licenses.free;
        };
      }) {};
    tablist = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tablist";
        ename = "tablist";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tablist-1.0.tar";
          sha256 = "1r37vk31ddiahhd11ric00py9ay9flgmsv368j47pl9653g9i6d9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tablist.html";
          license = lib.licenses.free;
        };
      }) {};
    tangotango-theme = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "tangotango-theme";
        ename = "tangotango-theme";
        version = "0.0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tangotango-theme-0.0.7.tar";
          sha256 = "0xl90c7hzzd2wanz41mb5ikjgrfga28qb893yvdcy0pa6mgdmpmx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tangotango-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    telephone-line = callPackage ({ cl-generic
                                  , cl-lib ? null
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , seq }:
      elpaBuild {
        pname = "telephone-line";
        ename = "telephone-line";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/telephone-line-0.5.tar";
          sha256 = "09glq2ljd10mqx54i3vflk7yjb1abhykzm9kng4wrw5156ssn6zs";
        };
        packageRequires = [ cl-generic cl-lib emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/telephone-line.html";
          license = lib.licenses.free;
        };
      }) {};
    testcover-mark-line = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "testcover-mark-line";
        ename = "testcover-mark-line";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/testcover-mark-line-0.3.tar";
          sha256 = "18nlkm7p6fmaziqqbb4jmhpypn0b6233qd0c19xp16kjbxpg7ifh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/testcover-mark-line.html";
          license = lib.licenses.free;
        };
      }) {};
    textile-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "textile-mode";
        ename = "textile-mode";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/textile-mode-1.0.0.tar";
          sha256 = "14ssqiw8x1pvjlw76h12vrk2w5qmhvp11v4h3cddqi96fddr95sq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/textile-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    toc-org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "toc-org";
        ename = "toc-org";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/toc-org-1.1.tar";
          sha256 = "1wy48z4x756r7k6v9znn3f6bfxh867vy58wal7wmhxxig6sn9bk3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/toc-org.html";
          license = lib.licenses.free;
        };
      }) {};
    treeview = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "treeview";
        ename = "treeview";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/treeview-1.1.1.tar";
          sha256 = "0ryycz2n1kam3ji0ibpy99ll5l6xnx1mx9i9bgfvma61f0ppcppd";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/treeview.html";
          license = lib.licenses.free;
        };
      }) {};
    tuareg = callPackage ({ caml, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tuareg";
        ename = "tuareg";
        version = "3.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tuareg-3.0.1.tar";
          sha256 = "0y98gwnbrcj3csd9yilk1izgzmp1ds5dh3y1bxgb2fzrjir3i13f";
        };
        packageRequires = [ caml emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tuareg.html";
          license = lib.licenses.free;
        };
      }) {};
    typescript-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "typescript-mode";
        ename = "typescript-mode";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/typescript-mode-0.4.tar";
          sha256 = "1102c35w2b66q5acvhsk6yigzhp6n3rl0s28xnvb74ansk4rz35k";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/typescript-mode.html";
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
    undo-fu = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "undo-fu";
        ename = "undo-fu";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/undo-fu-0.5.tar";
          sha256 = "0akn8gw3wavsfhxa9m426jkjacsw3k8vaxymhqrzy18lpvg5hysw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/undo-fu.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-fu-session = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "undo-fu-session";
        ename = "undo-fu-session";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/undo-fu-session-0.6.tar";
          sha256 = "0l54zqr481xlldfjllhsq4z6ccyzx0k3h7gm59pz32m7bd7zxggl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/undo-fu-session.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-fossil = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "vc-fossil";
        ename = "vc-fossil";
        version = "20230504";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/vc-fossil-20230504.tar";
          sha256 = "0s7mxi9qq5axv1prqgfi1d7yyrn0abal8y25d4l7n38qszixjlcd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-fossil.html";
          license = lib.licenses.free;
        };
      }) {};
    vcomplete = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vcomplete";
        ename = "vcomplete";
        version = "2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/vcomplete-2.0.tar";
          sha256 = "0fh5rfvhjmpfdhp4k4b1y57zlsixiabhzca9329id48p8jm4rqyp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vcomplete.html";
          license = lib.licenses.free;
        };
      }) {};
    visual-fill-column = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "visual-fill-column";
        ename = "visual-fill-column";
        version = "2.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/visual-fill-column-2.5.1.tar";
          sha256 = "1q2cimrcr4knh716cdnhs8nspk08w8x7bsbhx69s9hpzgr7mjq58";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/visual-fill-column.html";
          license = lib.licenses.free;
        };
      }) {};
    web-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "web-mode";
        ename = "web-mode";
        version = "17.3.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/web-mode-17.3.9.tar";
          sha256 = "1c01ilqk5bblcgz5xn3x8yvhfwk5p6z79035qj26ivpd4qjivcps";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    webpaste = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , request }:
      elpaBuild {
        pname = "webpaste";
        ename = "webpaste";
        version = "3.2.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/webpaste-3.2.2.tar";
          sha256 = "0vviv062v46mlssz8627623g1b2nq4n4x3yiv8c882gvgvfvi2bi";
        };
        packageRequires = [ cl-lib emacs request ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/webpaste.html";
          license = lib.licenses.free;
        };
      }) {};
    wfnames = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "wfnames";
        ename = "wfnames";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/wfnames-1.1.tar";
          sha256 = "04plvqn4srv1v7d7zx6qb0xm62c1hwkiqpq34w17daw9si2pvpan";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wfnames.html";
          license = lib.licenses.free;
        };
      }) {};
    wgrep = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "wgrep";
        ename = "wgrep";
        version = "3.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/wgrep-3.0.0.tar";
          sha256 = "0vg23ydwkqrmhlll45gf2fjdxj9chx9bl9m0pgwrlkjw0ncxj3qp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wgrep.html";
          license = lib.licenses.free;
        };
      }) {};
    why-this = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "why-this";
        ename = "why-this";
        version = "2.0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/why-this-2.0.4.tar";
          sha256 = "0hqvqix9hqaki23vw3xilkcr84ak2vz4lwczr54s87x13idrg4px";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/why-this.html";
          license = lib.licenses.free;
        };
      }) {};
    with-editor = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "with-editor";
        ename = "with-editor";
        version = "3.3.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/with-editor-3.3.1.tar";
          sha256 = "0pwmwx1mw8mzj45ikfz30j91765rwbkmji5j4pmgq9djcz46hn85";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/with-editor.html";
          license = lib.licenses.free;
        };
      }) {};
    with-simulated-input = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "with-simulated-input";
        ename = "with-simulated-input";
        version = "3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/with-simulated-input-3.0.tar";
          sha256 = "0ws8z82kb0bh6z4yvw2kz3ib0j7v47c5l5dxlrn3kr1qk99z65l6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/with-simulated-input.html";
          license = lib.licenses.free;
        };
      }) {};
    workroom = callPackage ({ compat
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , project }:
      elpaBuild {
        pname = "workroom";
        ename = "workroom";
        version = "2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/workroom-2.3.tar";
          sha256 = "0c05pbxkrcgsjk7zcyxiacxrpxyvf85rf38nhaqhxbywh4j071fg";
        };
        packageRequires = [ compat emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/workroom.html";
          license = lib.licenses.free;
        };
      }) {};
    writegood-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "writegood-mode";
        ename = "writegood-mode";
        version = "2.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/writegood-mode-2.2.0.tar";
          sha256 = "08b1650v6qsb3x1s5k4n5m2aqx1n26gc4wj822fm9s49k8vcpzl8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/writegood-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ws-butler = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ws-butler";
        ename = "ws-butler";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/ws-butler-0.6.tar";
          sha256 = "1mm1c2awq2vs5fz773f1pa6ham29ws1agispxfjvj5nx15a0kqzl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ws-butler.html";
          license = lib.licenses.free;
        };
      }) {};
    xah-fly-keys = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "xah-fly-keys";
        ename = "xah-fly-keys";
        version = "24.8.20230825161727";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/xah-fly-keys-24.8.20230825161727.tar";
          sha256 = "018qp7gg1nm4b54gmp8q6w5hn5d2266pvg7m574js0jjbcnai8mv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xah-fly-keys.html";
          license = lib.licenses.free;
        };
      }) {};
    xkcd = callPackage ({ elpaBuild, fetchurl, json ? null, lib }:
      elpaBuild {
        pname = "xkcd";
        ename = "xkcd";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/xkcd-1.1.tar";
          sha256 = "1yszrba4cvisiy7m16rzpj7plbnafj4c7bdgxvqwxwhsasfmh6ag";
        };
        packageRequires = [ json ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xkcd.html";
          license = lib.licenses.free;
        };
      }) {};
    xml-rpc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "xml-rpc";
        ename = "xml-rpc";
        version = "1.6.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/xml-rpc-1.6.16.tar";
          sha256 = "0gglrrnicbsf1lrk4pwmif5658yrhx80ixgi5hm85p8yxarn3ynm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xml-rpc.html";
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
        version = "2.8.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/zenburn-theme-2.8.0.tar";
          sha256 = "1jbkh09r6sxb0iv9cdxi6k33kz3hldc6hcvyqljf733rdxykpskv";
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
