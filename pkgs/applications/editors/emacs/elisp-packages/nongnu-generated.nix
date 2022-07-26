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
        version = "1.7.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/annotate-1.7.0.tar";
          sha256 = "0bpicd0m9h1n56ywinfa0wykhx86sxn8i1f2j5vwhwcidap42qaa";
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
    autothemer = callPackage ({ cl-lib ? null
                              , dash
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "autothemer";
        ename = "autothemer";
        version = "0.2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/autothemer-0.2.3.tar";
          sha256 = "10r4lf3nl7mk6yzfcyld5k0njslw8ly2sd0iz1zkzywnv31lsxnd";
        };
        packageRequires = [ cl-lib dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/autothemer.html";
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
    boxquote = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "boxquote";
        ename = "boxquote";
        version = "2.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/boxquote-2.2.tar";
          sha256 = "0vcqm78b5fsizkn2xalnzmdci5m02yxxypcr9q2sai04j7lhmwd9";
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
        version = "1.25";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/buttercup-1.25.tar";
          sha256 = "1iadgn56sfakv927g9bk7fq7yjg0f3r10ygrmjpy46vgvfz0fqs6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buttercup.html";
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
    cdlatex = callPackage ({ auctex, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cdlatex";
        ename = "cdlatex";
        version = "4.12";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cdlatex-4.12.tar";
          sha256 = "1m8liqxz76r8f3b8hvyyn7kqgq0fkk5pv4pqgdscbgw36vpcbkry";
        };
        packageRequires = [ auctex ];
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
        version = "1.4.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/cider-1.4.1.tar";
          sha256 = "0l36pqmjqzv6ykmw593h6qd24pygq7171qfinvlp2fh8897ac2nj";
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
        version = "5.14.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/clojure-mode-5.14.0.tar";
          sha256 = "1lirhp6m5r050dm73nrslgzdgy6rdbxn02wal8n52q37m2armra2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clojure-mode.html";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/corfu-terminal-0.4.tar";
          sha256 = "1rmfj2lzdab2s49k9ja79i7xcw74r9cr5kv7rgrisqxwgcnvsi95";
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
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/dockerfile-mode-1.5.tar";
          sha256 = "0dz91i4ak3v0x1v75ibhjjz211k9g6qimz4lxn3x424j7dlpa9f3";
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
    elixir-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "elixir-mode";
        ename = "elixir-mode";
        version = "2.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/elixir-mode-2.4.0.tar";
          sha256 = "0h3ypyxmcpfh8kcwd08rsild4jy8s4mr3zr8va03bbh81pd3nm1m";
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
        version = "3.4.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/elpher-3.4.2.tar";
          sha256 = "0q7a79jnlihjj936wi199pdxl0ydy04354y0mqpxms00r98hzr9d";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elpher.html";
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
        version = "3.0.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-matchit-3.0.0.tar";
          sha256 = "036zf7l8pkhbyk7gz91r00v4fqi2wfdnqv95xkh7jpm2i9xcgg5p";
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
        version = "3.5.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-nerd-commenter-3.5.7.tar";
          sha256 = "1lar8hy9n29gv4cijalyy2ba23y0kyh9ycnsi5dzjs68pk3y4hca";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/flymake-popon-0.3.tar";
          sha256 = "1cmimdkav8cdl7x6qplm4pvj2ifyb3lk8h2q624vh7cxxlh8yq0l";
        };
        packageRequires = [ emacs flymake popon posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-popon.html";
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
    geiser = callPackage ({ elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , project
                          , transient }:
      elpaBuild {
        pname = "geiser";
        ename = "geiser";
        version = "0.24";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-0.24.tar";
          sha256 = "14qnni8ridrg3afh1wy9nvchbk0drn0h7ww5xgc6s03ivvmy7a71";
        };
        packageRequires = [ emacs project transient ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chez = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chez";
        ename = "geiser-chez";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chez-0.17.tar";
          sha256 = "139x7b3q5n04ig0m263jljm4bsjiiyvi3f84pcq3bgnj3dk5dlxh";
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
    geiser-guile = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-guile";
        ename = "geiser-guile";
        version = "0.23.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-guile-0.23.2.tar";
          sha256 = "1z2khagg425y5cfja694zxrj3lyw3awsmqd86b2hpqhrylrb8jaa";
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
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-stklos-1.4.tar";
          sha256 = "18z34x4xmn58080r2ar6wd07kap7f367my2q5ph6cdf0gs6nz4sv";
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
    gruvbox-theme = callPackage ({ autothemer, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gruvbox-theme";
        ename = "gruvbox-theme";
        version = "1.26.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/gruvbox-theme-1.26.0.tar";
          sha256 = "19q5i0jz01hdn09wwg929yva6278fhyvk68id5p9dyi8h2n73djn";
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
    helm = callPackage ({ elpaBuild, fetchurl, helm-core, lib, popup }:
      elpaBuild {
        pname = "helm";
        ename = "helm";
        version = "3.8.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/helm-3.8.6.tar";
          sha256 = "0h0l36wmzxi03viy0jd3zri84big0syiilvjm639nqhzsr1lbvy2";
        };
        packageRequires = [ helm-core popup ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/helm.html";
          license = lib.licenses.free;
        };
      }) {};
    helm-core = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "helm-core";
        ename = "helm-core";
        version = "3.8.6";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/helm-core-3.8.6.tar";
          sha256 = "0yzzwdggd37m7kv0gh4amc7l5x0r5x2pxi3lfs36hq2hfsqlfkza";
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
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/hl-block-mode-0.1.tar";
          sha256 = "08b2n8i0qmjp5r6ijlg66g0j8aiwhrczxyf0ssr9jbga43k4swzq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hl-block-mode.html";
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
        version = "1.1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/idle-highlight-mode-1.1.3.tar";
          sha256 = "05w2rqc71h1f13ysdfjma90s35kj5d5i2szcw54cqyky8rymx5dp";
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
        version = "3.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-clojure-3.2.0.tar";
          sha256 = "1a9hr28l8cxf5j9b5z0mwds4jd36bhdqz9r86c85rylgaibx5ky7";
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
        version = "2.6.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-ruby-2.6.1.tar";
          sha256 = "0z57wwpm7wh04yp7za8fmv4ib56np629kmk4djs8qaz5bv494znr";
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
    keycast = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "keycast";
        ename = "keycast";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/keycast-1.2.0.tar";
          sha256 = "0iiksz8lcz9y5yplw455v2zgvq2jz6jc2ic3ybax10v3wgxnhiad";
        };
        packageRequires = [ emacs ];
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
                          , cl-lib ? null
                          , elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , seq
                          , xml-rpc }:
      elpaBuild {
        pname = "mentor";
        ename = "mentor";
        version = "0.3.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/mentor-0.3.5.tar";
          sha256 = "01zrvfk2njzyzjzkvp5hv5cjl1k1qjrila1ab4bv26gf6bkq5xh3";
        };
        packageRequires = [ async cl-lib emacs seq xml-rpc ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mentor.html";
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
        version = "1.4.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/nix-mode-1.4.4.tar";
          sha256 = "1nn74671273s5mjxzbdqvpwqx6w12zya21sxhzw51k2fs68vwh23";
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
    org-auto-tangle = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-auto-tangle";
        ename = "org-auto-tangle";
        version = "0.5.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-auto-tangle-0.5.1.tar";
          sha256 = "12sy30yr8r3g7gmvcdsrrmy62lhvajg3gp62gj7p836kh9xllpsl";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-contrib-0.4.tar";
          sha256 = "05r7w0h9v1vfhv1dd2vaabq2gm8ra70s1cirlp75s343b0z28ca6";
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
        version = "2.1.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-journal-2.1.2.tar";
          sha256 = "1s5hadcps283c5a1sy8fp1ih064l0hl97frj93jw3fkx6jwbqf0v";
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
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-mime-0.3.1.tar";
          sha256 = "0dm7addyc98kh1lm4d8x7nvnkh6bwkw300ms2zlwm1ii91jzfkkg";
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
        version = "2.8.18";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-tree-slide-2.8.18.tar";
          sha256 = "0xx8svbh6ks5112rac4chms0f8drhiwxnc3knrzaj8i1zb89l0n3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-tree-slide.html";
          license = lib.licenses.free;
        };
      }) {};
    orgit = callPackage ({ elpaBuild, emacs, fetchurl, lib, magit, org }:
      elpaBuild {
        pname = "orgit";
        ename = "orgit";
        version = "1.8.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/orgit-1.8.0.tar";
          sha256 = "03qjhiv3smnpjciz5sfri7v5gzgcnk5g0lhgm06flqnarfrrkn1h";
        };
        packageRequires = [ emacs magit org ];
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
    pdf-tools = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , let-alist
                             , lib
                             , tablist }:
      elpaBuild {
        pname = "pdf-tools";
        ename = "pdf-tools";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/pdf-tools-1.0.tar";
          sha256 = "0cjr7y2ikf2al43wrzlqdpbksj0ww6m0nvmlz97slx8nk94k2qyf";
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
    popon = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "popon";
        ename = "popon";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/popon-0.7.tar";
          sha256 = "0sr0cv9jlaj83sgk1cb7wd6r12g6gmzdjzm077gxa6jy9p4qrv0q";
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
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/scroll-on-jump-0.1.tar";
          sha256 = "0y6r0aa14sv8yh56w46s840bdkgq6y234qz1jbbsgklx42cw6zgg";
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
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/subed-1.0.5.tar";
          sha256 = "1wpkwab6scmc9d3bzp5161d8agmcjacpijs8xqb1mpbyvl1jvavc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/subed.html";
          license = lib.licenses.free;
        };
      }) {};
    swift-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "swift-mode";
        ename = "swift-mode";
        version = "8.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/swift-mode-8.6.0.tar";
          sha256 = "0zasgv311mjc1iih9wv8vb8h53y2pjx24xsbdnn0wk8xcdk4z8j6";
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
        version = "2.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/swsw-2.2.tar";
          sha256 = "0bxcpk5329g4xdfnx8n70q53v4aansxfcs3fdpzssayyyv4fk72m";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/undo-fu-0.4.tar";
          sha256 = "15r0lkzbxgvnwdmaxgiwnik2z8622gdzmpxllv8pfr36y6jmsgs8";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/undo-fu-session-0.2.tar";
          sha256 = "1vxyazcxw2gxvxh96grsff1lijsd5fh3pjzkbkj7axn3myavp374";
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
        version = "20220707";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/vc-fossil-20220707.tar";
          sha256 = "0l33y8mij6rw4h47ryqpjxr1i2xzis98rbi230izkvsc6w7qf89q";
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
        version = "1.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/vcomplete-1.2.1.tar";
          sha256 = "1fcchgv4kdmhzgincfy1jm625lwj3qrjskd0cswag5z15by6b5xf";
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
        version = "2.5";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/visual-fill-column-2.5.tar";
          sha256 = "0mqhm7xkxpzjk96n6qybqg2780kbjg1w7ash88zhnbp8kvy0rrwi";
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
        version = "17.2.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/web-mode-17.2.3.tar";
          sha256 = "1fvkr3yvhx67wkcynid7xppaci3m1d5ggdaii3d4dfp57wwz5c13";
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
        version = "3.2.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/with-editor-3.2.0.tar";
          sha256 = "1rsggbhkngzbcmg3076jbi1sfkzz8p4s5i00sk0ywc6vkmsp6s1k";
        };
        packageRequires = [ emacs ];
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
        version = "17.17.20220709145456";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/xah-fly-keys-17.17.20220709145456.tar";
          sha256 = "1npgdc9f1vj1d9nyfh30vskybqs2lwhd31b2a7i79ifrxs48kqr4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xah-fly-keys.html";
          license = lib.licenses.free;
        };
      }) {};
    xml-rpc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "xml-rpc";
        ename = "xml-rpc";
        version = "1.6.15";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/xml-rpc-1.6.15.tar";
          sha256 = "0z87rn7zbd8335iqfvk16zpvby66l0izzw438pxdr7kf60i5vgwl";
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
