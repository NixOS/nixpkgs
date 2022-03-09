{ callPackage }:
  {
    ace-window = callPackage ({ avy, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ace-window";
        ename = "ace-window";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ace-window-0.10.0.tar";
          sha256 = "1kfyf7za4zc41gf0k3rq8byvwkw7q5pxnyynh5i0gv686zrzak1i";
        };
        packageRequires = [ avy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ace-window.html";
          license = lib.licenses.free;
        };
      }) {};
    ack = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ack";
        ename = "ack";
        version = "1.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ack-1.10.tar";
          sha256 = "0jz8badhjpzjlrprpzgcm1z6ask1ykc7ab62ixjrj9wcgfjif5qw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ack.html";
          license = lib.licenses.free;
        };
      }) {};
    ada-mode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , uniquify-files
                            , wisi }:
      elpaBuild {
        pname = "ada-mode";
        ename = "ada-mode";
        version = "7.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-mode-7.2.0.tar";
          sha256 = "00mrcn98bah9cld78qz75mmmk1yrs9k4dbzf6r1x07pngz70fxm2";
        };
        packageRequires = [ emacs uniquify-files wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ada-ref-man = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ada-ref-man";
        ename = "ada-ref-man";
        version = "2020.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-ref-man-2020.1.tar";
          sha256 = "1g4brb9g2spd55issyqldfc4azwilbrz8kh8sl0lka2kn42l3qqc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-ref-man.html";
          license = lib.licenses.free;
        };
      }) {};
    adaptive-wrap = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "adaptive-wrap";
        ename = "adaptive-wrap";
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/adaptive-wrap-0.8.tar";
          sha256 = "1gs1pqzywvvw4prj63vpj8abh8h14pjky11xfl23pgpk9l3ldrb0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adaptive-wrap.html";
          license = lib.licenses.free;
        };
      }) {};
    adjust-parens = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "adjust-parens";
        ename = "adjust-parens";
        version = "3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/adjust-parens-3.1.tar";
          sha256 = "059v0njd52vxidr5xwv2jmknm2shnwpj3101069q6lsmz1wq242a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adjust-parens.html";
          license = lib.licenses.free;
        };
      }) {};
    advice-patch = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "advice-patch";
        ename = "advice-patch";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/advice-patch-0.1.el";
          sha256 = "0mb7linzsnf72vzkn9h6w2i2b0h92h6qzkapyrv61vh5a67k1m0s";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/advice-patch.html";
          license = lib.licenses.free;
        };
      }) {};
    aggressive-completion = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "aggressive-completion";
        ename = "aggressive-completion";
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aggressive-completion-1.6.tar";
          sha256 = "0i7kcxd7pbdw57gczbxddr2n4j778x2ccfpkgjhdlpdsyidfh2bq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aggressive-completion.html";
          license = lib.licenses.free;
        };
      }) {};
    aggressive-indent = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "aggressive-indent";
        ename = "aggressive-indent";
        version = "1.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aggressive-indent-1.10.0.tar";
          sha256 = "166jk1z0vw481lfi3gbg7f9vsgwfv8fiyxpkfphgvgcmf5phv4q1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aggressive-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    ahungry-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ahungry-theme";
        ename = "ahungry-theme";
        version = "1.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ahungry-theme-1.10.0.tar";
          sha256 = "14q5yw56n82qph09bk7wmj5b1snhh9w0nk5s1l7yn9ldg71xq6pm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ahungry-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    all = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "all";
        ename = "all";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/all-1.0.el";
          sha256 = "17h4cp0xnh08szh3snbmn1mqq2smgqkn45bq7v0cpsxq1i301hi3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/all.html";
          license = lib.licenses.free;
        };
      }) {};
    ampc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ampc";
        ename = "ampc";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ampc-0.2.el";
          sha256 = "1pdy5mvi6h8m7qjnxiy217fgcp9w91375hq29bacfgh7bix56jlr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ampc.html";
          license = lib.licenses.free;
        };
      }) {};
    arbitools = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "arbitools";
        ename = "arbitools";
        version = "0.977";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/arbitools-0.977.el";
          sha256 = "0nvdy14lqvy2ca4vw2qlr2kg2vv4y4sr8sa7kqrpf8cg7k9q3mbv";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/arbitools.html";
          license = lib.licenses.free;
        };
      }) {};
    ascii-art-to-unicode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ascii-art-to-unicode";
        ename = "ascii-art-to-unicode";
        version = "1.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ascii-art-to-unicode-1.13.el";
          sha256 = "1c0jva3amhl9c5xc5yzdpi58c8m1djym4ccj31z6wmakq7npy07p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ascii-art-to-unicode.html";
          license = lib.licenses.free;
        };
      }) {};
    async = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "async";
        ename = "async";
        version = "1.9.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/async-1.9.5.tar";
          sha256 = "02f43vqlggy4qkqdggkl9mcg3rvagjysj45xgrx41jjx6cnjnm19";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/async.html";
          license = lib.licenses.free;
        };
      }) {};
    auctex = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "auctex";
        ename = "auctex";
        version = "13.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auctex-13.1.1.tar";
          sha256 = "193sqq2wiq3lg99m8hifl9rjxdazpy638r99sqvmxmkfm98cr34r";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auctex.html";
          license = lib.licenses.free;
        };
      }) {};
    aumix-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "aumix-mode";
        ename = "aumix-mode";
        version = "7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aumix-mode-7.el";
          sha256 = "0qyjw2g3pzcxqdg1cpp889nmb524jxqq32dz7b7cg2m903lv5gmv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aumix-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-correct = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "auto-correct";
        ename = "auto-correct";
        version = "1.1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-correct-1.1.4.el";
          sha256 = "1ml35l6lk4sf51sh6cal1ylsn61iddz0s01wwly199i3nim0qnw8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-correct.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-overlays = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "auto-overlays";
        ename = "auto-overlays";
        version = "0.10.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-overlays-0.10.10.tar";
          sha256 = "0wln6b4j3pd3mhx6sx0bnz74c4n6fidmkg77cqfpxs4j5l1zjp2z";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-overlays.html";
          license = lib.licenses.free;
        };
      }) {};
    avy = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "avy";
        ename = "avy";
        version = "0.5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/avy-0.5.0.tar";
          sha256 = "1xfcml38qmrwdd0rkhwrvv2s7dbznwhk3vy9pjd6ljpg22wkb80d";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/avy.html";
          license = lib.licenses.free;
        };
      }) {};
    bbdb = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bbdb";
        ename = "bbdb";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bbdb-3.2.1.tar";
          sha256 = "01vsnifs47krq1srgdkk9agbv3p2fykl9nydr4nrfjxbqpnyh3ij";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bbdb.html";
          license = lib.licenses.free;
        };
      }) {};
    beacon = callPackage ({ elpaBuild, fetchurl, lib, seq }:
      elpaBuild {
        pname = "beacon";
        ename = "beacon";
        version = "1.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/beacon-1.3.3.el";
          sha256 = "10r4fpf8pcf1qn5ncpm5g7skzba749mrc1ggykq92jlha3q98s02";
        };
        packageRequires = [ seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/beacon.html";
          license = lib.licenses.free;
        };
      }) {};
    blist = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "blist";
        ename = "blist";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/blist-0.1.tar";
          sha256 = "0p9jx7m05ynfi3bnd91jghw7101ym8qzm5r42rb1vy85pcf9lbad";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/blist.html";
          license = lib.licenses.free;
        };
      }) {};
    bluetooth = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bluetooth";
        ename = "bluetooth";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bluetooth-0.3.tar";
          sha256 = "1q27hk4j7k0q9vqgn9nq7q0vhn9jdqbygs7d9lv5gwfhdzdnl4az";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bluetooth.html";
          license = lib.licenses.free;
        };
      }) {};
    bnf-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bnf-mode";
        ename = "bnf-mode";
        version = "0.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bnf-mode-0.4.5.tar";
          sha256 = "0bj5ffqi54cdrraj5bp4v2cpbxjzly1p467dx1hzrlwv2b1svy2y";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bnf-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    boxy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "boxy";
        ename = "boxy";
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-1.0.4.tar";
          sha256 = "0cwzjyj8yjg13b63va6pnj01m6kc5g3zx69c9w2ysl2wk24zn6dz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy.html";
          license = lib.licenses.free;
        };
      }) {};
    boxy-headings = callPackage ({ boxy, elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "boxy-headings";
        ename = "boxy-headings";
        version = "2.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-headings-2.1.2.tar";
          sha256 = "0jyfp41jw33kmi7832x5x0mgh5niqvb7dfc7q00kay5q9ixg83dq";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy-headings.html";
          license = lib.licenses.free;
        };
      }) {};
    brief = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "brief";
        ename = "brief";
        version = "5.87";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/brief-5.87.tar";
          sha256 = "02z8fzzf1zsk2r0cnssz3i2nd4qwsnya4i2r4qi4ndc1xjlsvgwc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/brief.html";
          license = lib.licenses.free;
        };
      }) {};
    buffer-expose = callPackage ({ cl-lib ? null
                                 , elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "buffer-expose";
        ename = "buffer-expose";
        version = "0.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buffer-expose-0.4.3.el";
          sha256 = "1blpvan31mvqhzal16sdn564jnfnn7xsfn8zb65ijndh23drljwd";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buffer-expose.html";
          license = lib.licenses.free;
        };
      }) {};
    bug-hunter = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, seq }:
      elpaBuild {
        pname = "bug-hunter";
        ename = "bug-hunter";
        version = "1.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bug-hunter-1.3.1.tar";
          sha256 = "0cgwq8b6jglbg9ydvf80ijgbbccrks3yb9af46sdd6aqdmvdlx21";
        };
        packageRequires = [ cl-lib seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bug-hunter.html";
          license = lib.licenses.free;
        };
      }) {};
    cape = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "cape";
        ename = "cape";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cape-0.6.tar";
          sha256 = "0pc0vvdb0pczz9n50wry6k6wkdaz3bqin07nmlxm8w1aqvapb2pr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cape.html";
          license = lib.licenses.free;
        };
      }) {};
    capf-autosuggest = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "capf-autosuggest";
        ename = "capf-autosuggest";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/capf-autosuggest-0.3.tar";
          sha256 = "05abnvg84248pbqr2hdkyxr1q1qlgsf4nji23nw41bfly795ikpm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/capf-autosuggest.html";
          license = lib.licenses.free;
        };
      }) {};
    caps-lock = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "caps-lock";
        ename = "caps-lock";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/caps-lock-1.0.el";
          sha256 = "1i4hwam81p4dr0bk8257fkiz4xmv6knkjxj7a00fa35kgx5blpva";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/caps-lock.html";
          license = lib.licenses.free;
        };
      }) {};
    captain = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "captain";
        ename = "captain";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/captain-1.0.3.el";
          sha256 = "02b4s4pfnwfwc3xgh4g96wrqll37m35dc2x09pjwkdjxglki7045";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/captain.html";
          license = lib.licenses.free;
        };
      }) {};
    chess = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "chess";
        ename = "chess";
        version = "2.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/chess-2.0.5.tar";
          sha256 = "1a4iwjdh6k348df6qywjws9z9f862d62m0b2sz57z4xhywiyxpr7";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/chess.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-generic = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cl-generic";
        ename = "cl-generic";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-generic-0.3.el";
          sha256 = "0vb338bhjpsnrf60qgxny4z5rjrnifahnrv9axd4shay89d894zq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-generic.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-lib = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cl-lib";
        ename = "cl-lib";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-lib-0.7.tar";
          sha256 = "0s1vkkj1yc5zn6bvc84sr726cm4v3jh2ymm7hc3rr00swwbz35lv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-lib.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-print = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "cl-print";
        ename = "cl-print";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-print-1.0.el";
          sha256 = "0ib8j7rv5f4c4xg3kban58jm6cam756i3xz6j8100846g3jn9zcc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-print.html";
          license = lib.licenses.free;
        };
      }) {};
    clipboard-collector = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "clipboard-collector";
        ename = "clipboard-collector";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/clipboard-collector-0.3.tar";
          sha256 = "09zxbivmc1zhcj8ksac2a0qpqh74rrx2slnj6cwz1n1nixn19743";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clipboard-collector.html";
          license = lib.licenses.free;
        };
      }) {};
    cobol-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cobol-mode";
        ename = "cobol-mode";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cobol-mode-1.0.0.el";
          sha256 = "1zmcfpl7v787yacc7gxm8mkp53fmrznp5mnad628phf3vj4kwnxi";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cobol-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    coffee-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "coffee-mode";
        ename = "coffee-mode";
        version = "0.4.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/coffee-mode-0.4.1.1.el";
          sha256 = "1jffd8rqmc3l597db26rggis6apf91glyzm1qvpf5g3iz55g6slz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/coffee-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    compact-docstrings = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "compact-docstrings";
        ename = "compact-docstrings";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/compact-docstrings-0.2.el";
          sha256 = "0qcxvcwpl263fs1zd6gmbqliwlpkw012p5ba6y05fpm9p10v600h";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/compact-docstrings.html";
          license = lib.licenses.free;
        };
      }) {};
    company = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "company";
        ename = "company";
        version = "0.9.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-0.9.13.tar";
          sha256 = "1c9x9wlzzsn7vrsm57l2l44nqx455saa6wrm853szzg09qn8dlnw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company.html";
          license = lib.licenses.free;
        };
      }) {};
    company-ebdb = callPackage ({ company, ebdb, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "company-ebdb";
        ename = "company-ebdb";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-ebdb-1.1.el";
          sha256 = "146qpiigz12zp1823ggxfrx090g0mxs7gz1ba7sa0iq6ibgzwwm9";
        };
        packageRequires = [ company ebdb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    company-math = callPackage ({ company
                                , elpaBuild
                                , fetchurl
                                , lib
                                , math-symbol-lists }:
      elpaBuild {
        pname = "company-math";
        ename = "company-math";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-math-1.4.tar";
          sha256 = "17p5ib65lg8lj2gwip5qgsznww96pch16pr16b41lls5dx4k6d6z";
        };
        packageRequires = [ company math-symbol-lists ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-math.html";
          license = lib.licenses.free;
        };
      }) {};
    company-statistics = callPackage ({ company
                                      , elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib }:
      elpaBuild {
        pname = "company-statistics";
        ename = "company-statistics";
        version = "0.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-statistics-0.2.3.tar";
          sha256 = "0780xp09f739jys469x4fqpgj1lysi8gnhiaz0735jib07lmh4ww";
        };
        packageRequires = [ company emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-statistics.html";
          license = lib.licenses.free;
        };
      }) {};
    consult = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "consult";
        ename = "consult";
        version = "0.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-0.15.tar";
          sha256 = "0hsmxaiadb8smi1hk90n9napqrygh9rvj7g9a3d9isi47yrbg693";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult.html";
          license = lib.licenses.free;
        };
      }) {};
    context-coloring = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "context-coloring";
        ename = "context-coloring";
        version = "8.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/context-coloring-8.1.0.tar";
          sha256 = "01wm36qgxsg7lgdxkn7avzfmxcpilsmvfwz3s7y04i0sdrsjvzp4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/context-coloring.html";
          license = lib.licenses.free;
        };
      }) {};
    corfu = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "corfu";
        ename = "corfu";
        version = "0.19";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/corfu-0.19.tar";
          sha256 = "0jilhsddzjm0is7kqdklpr2ih50k2c3sik2i9vlgcizxqaqss97c";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/corfu.html";
          license = lib.licenses.free;
        };
      }) {};
    coterm = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "coterm";
        ename = "coterm";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/coterm-1.4.tar";
          sha256 = "0cs9hqffkzlkkpcfhdh67gg3vzvffrjawmi89q7x9p52fk9rcxp6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/coterm.html";
          license = lib.licenses.free;
        };
      }) {};
    counsel = callPackage ({ elpaBuild, emacs, fetchurl, ivy, lib, swiper }:
      elpaBuild {
        pname = "counsel";
        ename = "counsel";
        version = "0.13.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/counsel-0.13.4.tar";
          sha256 = "094zfapfn1l8wjf3djkipk0d9nks0g77sbk107pfsbr3skkzh031";
        };
        packageRequires = [ emacs ivy swiper ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/counsel.html";
          license = lib.licenses.free;
        };
      }) {};
    cpio-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "cpio-mode";
        ename = "cpio-mode";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cpio-mode-0.17.tar";
          sha256 = "144ajbxmz6amb2234a278c9sl4zg69ndswb8vk0mcq8y9s2abm1x";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cpio-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    crdt = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "crdt";
        ename = "crdt";
        version = "0.2.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/crdt-0.2.7.tar";
          sha256 = "0f6v937zbxj4kci07dv0a1h4q1ak0qabkjq2j258ydxyivvqyvsw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crdt.html";
          license = lib.licenses.free;
        };
      }) {};
    crisp = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "crisp";
        ename = "crisp";
        version = "1.3.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/crisp-1.3.6.el";
          sha256 = "0jf4668h0mzh8han2vbvpzz8m02b8rsbdrj0ddar30w5i6v2f8kz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crisp.html";
          license = lib.licenses.free;
        };
      }) {};
    csharp-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "csharp-mode";
        ename = "csharp-mode";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csharp-mode-1.1.1.tar";
          sha256 = "096aj4np1ii60h1kxbff5lkfznd0l0x551x103m5i1ks82kxlv1l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/csharp-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    csv-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "csv-mode";
        ename = "csv-mode";
        version = "1.18";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csv-mode-1.18.tar";
          sha256 = "0fv7hvsfbc9n4hsgg3ywk8qf4ig5a986zfq0lwnjj8pcz1bpmrxj";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/csv-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    cycle-quotes = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cycle-quotes";
        ename = "cycle-quotes";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cycle-quotes-0.1.tar";
          sha256 = "0aa6ykblgb6anqmi4qxakbvyrq9v02skgayhfb2qddffiww404ka";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cycle-quotes.html";
          license = lib.licenses.free;
        };
      }) {};
    darkroom = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "darkroom";
        ename = "darkroom";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/darkroom-0.3.el";
          sha256 = "0l1xg5kqmjw22k78qnsln0ifx2dx74xxqj0qp8xxcpqvzzx0xh86";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/darkroom.html";
          license = lib.licenses.free;
        };
      }) {};
    dash = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dash";
        ename = "dash";
        version = "2.19.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dash-2.19.1.tar";
          sha256 = "0c11lm7wpgmqk8zbdcpmyas12ylml5yhp99mj9h1wqqw0p33xaiw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dash.html";
          license = lib.licenses.free;
        };
      }) {};
    dbus-codegen = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "dbus-codegen";
        ename = "dbus-codegen";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dbus-codegen-0.1.el";
          sha256 = "1gi7jc6rn6hlgh01zfwb7cczb5hi3c05wlnzw6akj1h9kai1lmzw";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dbus-codegen.html";
          license = lib.licenses.free;
        };
      }) {};
    debbugs = callPackage ({ elpaBuild, emacs, fetchurl, lib, soap-client }:
      elpaBuild {
        pname = "debbugs";
        ename = "debbugs";
        version = "0.30";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/debbugs-0.30.tar";
          sha256 = "05yy1hhxd59rhricb14iai71w681222sv0i703yrgg868mphl7sb";
        };
        packageRequires = [ emacs soap-client ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/debbugs.html";
          license = lib.licenses.free;
        };
      }) {};
    delight = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, nadvice }:
      elpaBuild {
        pname = "delight";
        ename = "delight";
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/delight-1.7.el";
          sha256 = "0pihsghrf9xnd1kqlq48qmjcmp5ra95wwwgrb3l8m1wagmmc0bi1";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/delight.html";
          license = lib.licenses.free;
        };
      }) {};
    devdocs = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "devdocs";
        ename = "devdocs";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/devdocs-0.4.tar";
          sha256 = "05xmxqpp1cpf03y7idpqdsmbj30cissscy80ng5hqc3028kr2jqm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devdocs.html";
          license = lib.licenses.free;
        };
      }) {};
    dict-tree = callPackage ({ elpaBuild, fetchurl, heap, lib, tNFA, trie }:
      elpaBuild {
        pname = "dict-tree";
        ename = "dict-tree";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dict-tree-0.16.tar";
          sha256 = "1myf26g3jjk2v8yp3k2n8m45vi20452wd7w2bja8csfkk0qx3300";
        };
        packageRequires = [ heap tNFA trie ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dict-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    diff-hl = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "diff-hl";
        ename = "diff-hl";
        version = "1.8.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diff-hl-1.8.8.tar";
          sha256 = "10g1333xvki8aw5vhyijkpjn62jh9k3n4a5sh1z69hsfvxih5lqk";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diff-hl.html";
          license = lib.licenses.free;
        };
      }) {};
    diffview = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "diffview";
        ename = "diffview";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diffview-1.0.el";
          sha256 = "1gkdmzmgjixz9nak7dxvqy28kz0g7i672gavamwgnc1jl37wkcwi";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diffview.html";
          license = lib.licenses.free;
        };
      }) {};
    diminish = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "diminish";
        ename = "diminish";
        version = "0.46";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diminish-0.46.tar";
          sha256 = "17lsm5khp7cqrva13kn252ab57lw28sibf14615wdjvfqwlwwha4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diminish.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-du = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-du";
        ename = "dired-du";
        version = "0.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-du-0.5.2.tar";
          sha256 = "0vhph7vcicsiq28b10h3b4dvnhckcy4gccpdgsad5j7pwa5k26m1";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-du.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-git-info = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-git-info";
        ename = "dired-git-info";
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-git-info-0.3.1.el";
          sha256 = "1kd0rpw7l32wvwi7q8s0inx4bc66xrl7hkllnlicyczsnzw2z52z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-git-info.html";
          license = lib.licenses.free;
        };
      }) {};
    disk-usage = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "disk-usage";
        ename = "disk-usage";
        version = "1.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/disk-usage-1.3.3.el";
          sha256 = "0h1jwznd41gi0vg830ilfgm01q05zknikzahwasm9cizwm2wyizj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/disk-usage.html";
          license = lib.licenses.free;
        };
      }) {};
    dismal = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dismal";
        ename = "dismal";
        version = "1.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dismal-1.5.2.tar";
          sha256 = "0pl5cnziilm4ps1xzh1fa8irazn7vcp9nsxnxcvjqbkflpcpq5c7";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dismal.html";
          license = lib.licenses.free;
        };
      }) {};
    djvu = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "djvu";
        ename = "djvu";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/djvu-1.1.1.el";
          sha256 = "0z2qk1v4qkvcwl27ycqfb8vyszq5v6b8ci29b4la00yaki16p04i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/djvu.html";
          license = lib.licenses.free;
        };
      }) {};
    docbook = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "docbook";
        ename = "docbook";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/docbook-0.1.el";
          sha256 = "01x0g8dhw65mzp9mk6qhx9p2bsvkw96hz1awrrf2ji17sp8hd1v6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/docbook.html";
          license = lib.licenses.free;
        };
      }) {};
    dtache = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dtache";
        ename = "dtache";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dtache-0.5.tar";
          sha256 = "10gcnkajpw7szd41l6ykkysv00yp93y1z9ajhcmk4wzni93w21z2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dtache.html";
          license = lib.licenses.free;
        };
      }) {};
    dts-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "dts-mode";
        ename = "dts-mode";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dts-mode-0.1.1.tar";
          sha256 = "1hdbf7snfbg3pfg1vhbak1gq5smaklvaqj1y9mjcnxyipqi47q28";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    easy-escape = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "easy-escape";
        ename = "easy-escape";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/easy-escape-0.2.1.tar";
          sha256 = "19blpwka440y6r08hzzaz61gb24jr6a046pai2j1a3jg6x9fr3j5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/easy-escape.html";
          license = lib.licenses.free;
        };
      }) {};
    easy-kill = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "easy-kill";
        ename = "easy-kill";
        version = "0.9.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/easy-kill-0.9.4.tar";
          sha256 = "1pqqv4dhfm00wqch4wy3n2illsvxlz9r6r64925cvq3i7wq4la1x";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/easy-kill.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "ebdb";
        ename = "ebdb";
        version = "0.8.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-0.8.12.tar";
          sha256 = "1k53crdmaw6lzvprsmpdfvg96ck54bzs4z1d4q9x890anglxq5m6";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb-gnorb = callPackage ({ ebdb, elpaBuild, fetchurl, gnorb, lib }:
      elpaBuild {
        pname = "ebdb-gnorb";
        ename = "ebdb-gnorb";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-gnorb-1.0.2.el";
          sha256 = "0bma7mqilp3lfgv0z2mk6nnqzh1nn1prkz2aiwrs4hxwydmda13i";
        };
        packageRequires = [ ebdb gnorb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb-gnorb.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb-i18n-chn = callPackage ({ ebdb, elpaBuild, fetchurl, lib, pyim }:
      elpaBuild {
        pname = "ebdb-i18n-chn";
        ename = "ebdb-i18n-chn";
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-i18n-chn-1.3.2.tar";
          sha256 = "06ii9xi2y157vfbhx75mn80ash22d1xgcyp9kzz1s0lkxwlv74zj";
        };
        packageRequires = [ ebdb pyim ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb-i18n-chn.html";
          license = lib.licenses.free;
        };
      }) {};
    ediprolog = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ediprolog";
        ename = "ediprolog";
        version = "2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ediprolog-2.1.el";
          sha256 = "1piimsmzpirw8plrpy79xbpnvynzzhcxi31g6lg6is8gridiv3md";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ediprolog.html";
          license = lib.licenses.free;
        };
      }) {};
    eev = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "eev";
        ename = "eev";
        version = "20220224";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eev-20220224.tar";
          sha256 = "008750fm7w5k9yrkwyxgank02smxki2857cd2d8qvhsa2qnz6c5n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eev.html";
          license = lib.licenses.free;
        };
      }) {};
    eglot = callPackage ({ eldoc
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , flymake ? null
                         , jsonrpc
                         , lib
                         , project
                         , xref }:
      elpaBuild {
        pname = "eglot";
        ename = "eglot";
        version = "1.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eglot-1.8.tar";
          sha256 = "1n04jnf3wwpxafrzfd02l53wf90brjc8p835f84k0n0rjxin99k5";
        };
        packageRequires = [ eldoc emacs flymake jsonrpc project xref ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eglot.html";
          license = lib.licenses.free;
        };
      }) {};
    el-search = callPackage ({ cl-print
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , stream }:
      elpaBuild {
        pname = "el-search";
        ename = "el-search";
        version = "1.12.6.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/el-search-1.12.6.1.tar";
          sha256 = "150f4rirg107hmzpv8ifa32k2mgf07smbf9z44ln5rh8n17xwqah";
        };
        packageRequires = [ cl-print emacs stream ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/el-search.html";
          license = lib.licenses.free;
        };
      }) {};
    eldoc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "eldoc";
        ename = "eldoc";
        version = "1.11.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eldoc-1.11.0.el";
          sha256 = "1py9l1vl7s90y5kfpglhy11jswam2gcrqap09h6wb5ldnyb8cgq2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc.html";
          license = lib.licenses.free;
        };
      }) {};
    eldoc-eval = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "eldoc-eval";
        ename = "eldoc-eval";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eldoc-eval-0.2.tar";
          sha256 = "09g9y1w1dlq3s8sqzczgaj02y53x616ak9w3kynq53pwgaxq14j4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc-eval.html";
          license = lib.licenses.free;
        };
      }) {};
    electric-spacing = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "electric-spacing";
        ename = "electric-spacing";
        version = "5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/electric-spacing-5.0.el";
          sha256 = "1jk6v84z0n8jljzsz4wk7rgzh7drpfvxf4bp6xis8gapnd3ycfyv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/electric-spacing.html";
          license = lib.licenses.free;
        };
      }) {};
    elisp-benchmarks = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "elisp-benchmarks";
        ename = "elisp-benchmarks";
        version = "1.14";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/elisp-benchmarks-1.14.tar";
          sha256 = "1n9p4kl4d5rcbjgl8yifv0nqnrzxsx937fm0d2j589gg28rzlqpb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elisp-benchmarks.html";
          license = lib.licenses.free;
        };
      }) {};
    embark = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "embark";
        ename = "embark";
        version = "0.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-0.15.tar";
          sha256 = "0dr97549xrs9j1fhnqpdspvbfxnzqvzvpi8qc91fd2v4jsfwlklh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/embark.html";
          license = lib.licenses.free;
        };
      }) {};
    embark-consult = callPackage ({ consult
                                  , elpaBuild
                                  , emacs
                                  , embark
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "embark-consult";
        ename = "embark-consult";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-consult-0.4.tar";
          sha256 = "1z0xc11y59lagfsd2raps4iz68hvw132ff0qynbmvgw63mp1w4yy";
        };
        packageRequires = [ consult emacs embark ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/embark-consult.html";
          license = lib.licenses.free;
        };
      }) {};
    emms = callPackage ({ cl-lib ? null
                        , elpaBuild
                        , fetchurl
                        , lib
                        , nadvice
                        , seq }:
      elpaBuild {
        pname = "emms";
        ename = "emms";
        version = "10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/emms-10.tar";
          sha256 = "1lgjw9p799sl7nqnl2sk4g67ra10z2ldygx9kb8pmxjrx64mi3qm";
        };
        packageRequires = [ cl-lib nadvice seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/emms.html";
          license = lib.licenses.free;
        };
      }) {};
    engrave-faces = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "engrave-faces";
        ename = "engrave-faces";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/engrave-faces-0.2.0.tar";
          sha256 = "1d0hsfg3wvwbs82gjyvfjvy1sszcm7qa50bch1b6jy05kbc543ip";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/engrave-faces.html";
          license = lib.licenses.free;
        };
      }) {};
    enwc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "enwc";
        ename = "enwc";
        version = "2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/enwc-2.0.tar";
          sha256 = "17w35b06am5n19nlq00ni5w3jvys9i7swyw4glb7081d2jbij2mn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/enwc.html";
          license = lib.licenses.free;
        };
      }) {};
    epoch-view = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "epoch-view";
        ename = "epoch-view";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/epoch-view-0.0.1.el";
          sha256 = "1wy25ryyg9f4v83qjym2pwip6g9mszhqkf5a080z0yl47p71avfx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/epoch-view.html";
          license = lib.licenses.free;
        };
      }) {};
    erc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "erc";
        ename = "erc";
        version = "5.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/erc-5.4.1.tar";
          sha256 = "0hghqwqrx11f8qa1zhyhjqp99w01l686azsmd24z9w0l93fz598a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/erc.html";
          license = lib.licenses.free;
        };
      }) {};
    ergoemacs-mode = callPackage ({ cl-lib ? null
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , undo-tree }:
      elpaBuild {
        pname = "ergoemacs-mode";
        ename = "ergoemacs-mode";
        version = "5.16.10.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ergoemacs-mode-5.16.10.12.tar";
          sha256 = "1zfzjmi30lllrbyzicmp11c9lpa82g57wi134q9bajvzn9ryx4jr";
        };
        packageRequires = [ cl-lib emacs undo-tree ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ergoemacs-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    excorporate = callPackage ({ cl-lib ? null
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , fsm
                               , lib
                               , nadvice
                               , soap-client
                               , url-http-ntlm }:
      elpaBuild {
        pname = "excorporate";
        ename = "excorporate";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/excorporate-1.0.0.tar";
          sha256 = "1g0wc2kp15ra323b4rxvdh58q9c4h7m20grw6a0cs53m7l9xi62f";
        };
        packageRequires = [
          cl-lib
          emacs
          fsm
          nadvice
          soap-client
          url-http-ntlm
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/excorporate.html";
          license = lib.licenses.free;
        };
      }) {};
    expand-region = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "expand-region";
        ename = "expand-region";
        version = "0.11.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/expand-region-0.11.0.tar";
          sha256 = "1q6xaqkv40z4c6rgdkxqqkvxgsaj8yjqjrxi40kz5y0ck3bjrk0i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/expand-region.html";
          license = lib.licenses.free;
        };
      }) {};
    exwm = callPackage ({ elpaBuild, fetchurl, lib, xelb }:
      elpaBuild {
        pname = "exwm";
        ename = "exwm";
        version = "0.26";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/exwm-0.26.tar";
          sha256 = "03pg0r8a5vb1wc5grmjgzql74p47fniv47x39gdll5s3cq0haf6q";
        };
        packageRequires = [ xelb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/exwm.html";
          license = lib.licenses.free;
        };
      }) {};
    f90-interface-browser = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "f90-interface-browser";
        ename = "f90-interface-browser";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/f90-interface-browser-1.1.el";
          sha256 = "0mf32w2bgc6b43k0r4a11bywprj7y3rvl21i0ry74v425r6hc3is";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/f90-interface-browser.html";
          license = lib.licenses.free;
        };
      }) {};
    filladapt = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "filladapt";
        ename = "filladapt";
        version = "2.12.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/filladapt-2.12.2.el";
          sha256 = "1cxyxfdjg1dsmn1jrl6b7xy03xr42fb6vyggh27s4dk417ils6yg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/filladapt.html";
          license = lib.licenses.free;
        };
      }) {};
    flylisp = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flylisp";
        ename = "flylisp";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flylisp-0.2.el";
          sha256 = "0hh09qy1xwlv52lsh49nr11h4lk8qlmk06b669q494d79hxyv4v6";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flylisp.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake = callPackage ({ eldoc, elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "flymake";
        ename = "flymake";
        version = "1.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-1.2.2.tar";
          sha256 = "04pa6mayyqrhrijk0rmmrd7k7al9caqyrb5qzkzwbna9ykb1j4zp";
        };
        packageRequires = [ eldoc emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-proselint = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flymake-proselint";
        ename = "flymake-proselint";
        version = "0.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-proselint-0.2.3.tar";
          sha256 = "1384m52zkrlkkkyxg1zimp7dwrxhx8wbvw5ga5vg78yl6cqx9kbc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-proselint.html";
          license = lib.licenses.free;
        };
      }) {};
    frame-tabs = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "frame-tabs";
        ename = "frame-tabs";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/frame-tabs-1.1.el";
          sha256 = "0fx9zc7mvyl703k7sjjcvffm2qw42ncr7r3d4fm0h45p9pi83svz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/frame-tabs.html";
          license = lib.licenses.free;
        };
      }) {};
    frog-menu = callPackage ({ avy, elpaBuild, emacs, fetchurl, lib, posframe }:
      elpaBuild {
        pname = "frog-menu";
        ename = "frog-menu";
        version = "0.2.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/frog-menu-0.2.11.el";
          sha256 = "06iw11z61fd0g4w3562k3smcmzaq3nivvvc6gzm8y8k5pcrqzdff";
        };
        packageRequires = [ avy emacs posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/frog-menu.html";
          license = lib.licenses.free;
        };
      }) {};
    fsm = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "fsm";
        ename = "fsm";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/fsm-0.2.1.el";
          sha256 = "1jyxyqdbfl8nv7c50q0sg3w5p7whp1sqgi7w921k5hfar4d11qqp";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/fsm.html";
          license = lib.licenses.free;
        };
      }) {};
    ftable = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ftable";
        ename = "ftable";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ftable-1.0.tar";
          sha256 = "1qi0fxw94hb7p2s8n2dzbziialbjbjxgpwx2m4mvrmicrq375r5p";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ftable.html";
          license = lib.licenses.free;
        };
      }) {};
    gcmh = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gcmh";
        ename = "gcmh";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gcmh-0.2.1.el";
          sha256 = "0a51bkkfdj3x26yalvk7v35rxbl3m1wk6n0f33zhrhl6i5fsrfin";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gcmh.html";
          license = lib.licenses.free;
        };
      }) {};
    ggtags = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ggtags";
        ename = "ggtags";
        version = "0.9.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ggtags-0.9.0.tar";
          sha256 = "0p79x9g94jynl83ndvqp9349vhgkzxzhnc517r8hn44iqxqf6ghg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ggtags.html";
          license = lib.licenses.free;
        };
      }) {};
    gited = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gited";
        ename = "gited";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gited-0.6.0.tar";
          sha256 = "187asqrxfpxv53hhnrcid1sy46vcy07qx5yqgnrczi54jpcc57j5";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gited.html";
          license = lib.licenses.free;
        };
      }) {};
    gle-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gle-mode";
        ename = "gle-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gle-mode-1.1.el";
          sha256 = "0p9glalhkf8i4486pjwvrb9z4lqxl6jcqfk6jrjl6b1xi72xmdi0";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gle-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gnome-c-style = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gnome-c-style";
        ename = "gnome-c-style";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnome-c-style-0.1.tar";
          sha256 = "09w68jbpzyyhcaqw335qpr840j7xx0j81zxxkxq4ahqv6ck27v4x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnome-c-style.html";
          license = lib.licenses.free;
        };
      }) {};
    gnorb = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gnorb";
        ename = "gnorb";
        version = "1.6.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnorb-1.6.10.tar";
          sha256 = "0kwgpyydnzphlw8rwyw9rim3j1awd0njxssm47db76nwwyxl1ry3";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnorb.html";
          license = lib.licenses.free;
        };
      }) {};
    gnu-elpa = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gnu-elpa";
        ename = "gnu-elpa";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnu-elpa-1.1.tar";
          sha256 = "0b0law1xwwqa42wb09b3w73psq2kx16lkiwxjxl0sshjcmarhv8r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnu-elpa.html";
          license = lib.licenses.free;
        };
      }) {};
    gnu-elpa-keyring-update = callPackage ({ elpaBuild
                                           , fetchurl
                                           , lib }:
      elpaBuild {
        pname = "gnu-elpa-keyring-update";
        ename = "gnu-elpa-keyring-update";
        version = "2019.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update-2019.3.tar";
          sha256 = "1zw65kag25abimg088m4h8vj2nd4y5nc4qal6fsda0dldckfv1w0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update.html";
          license = lib.licenses.free;
        };
      }) {};
    gnugo = callPackage ({ ascii-art-to-unicode
                         , cl-lib ? null
                         , elpaBuild
                         , fetchurl
                         , lib
                         , xpm }:
      elpaBuild {
        pname = "gnugo";
        ename = "gnugo";
        version = "3.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnugo-3.1.2.tar";
          sha256 = "138gzdyi8scqimvs49da66j8f5a43bhgpasn1bxzdj2zffwlwp6g";
        };
        packageRequires = [ ascii-art-to-unicode cl-lib xpm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnugo.html";
          license = lib.licenses.free;
        };
      }) {};
    gnus-mock = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "gnus-mock";
        ename = "gnus-mock";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnus-mock-0.5.tar";
          sha256 = "1lyh1brb68zaasnw2brymsspcyl3jxmnvbvpvrqfxhhl3fq9nbv1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnus-mock.html";
          license = lib.licenses.free;
        };
      }) {};
    gpastel = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gpastel";
        ename = "gpastel";
        version = "0.5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gpastel-0.5.0.el";
          sha256 = "1wky6047071vgyyw2m929nbwg4d9qqp1mjqwk7a5rs8hfr4xqxfw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gpastel.html";
          license = lib.licenses.free;
        };
      }) {};
    greader = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "greader";
        ename = "greader";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/greader-0.1.tar";
          sha256 = "0mwhmidzv9vnmx6xls8pq4ra4m0f4yg677xgv34ivv34vsgg1mhb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/greader.html";
          license = lib.licenses.free;
        };
      }) {};
    greenbar = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "greenbar";
        ename = "greenbar";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/greenbar-1.1.el";
          sha256 = "01ixv3489zdx2b67zqad6h7g8cpnzpzrvvkqyx7csqyrfx0qy27n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/greenbar.html";
          license = lib.licenses.free;
        };
      }) {};
    guess-language = callPackage ({ cl-lib ? null
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , nadvice }:
      elpaBuild {
        pname = "guess-language";
        ename = "guess-language";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/guess-language-0.0.1.el";
          sha256 = "11a6m2337j4ncppaf59yr2vavvvsph2qh51d12zmq58g9wh3d7wz";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/guess-language.html";
          license = lib.licenses.free;
        };
      }) {};
    heap = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "heap";
        ename = "heap";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/heap-0.5.el";
          sha256 = "13qv0w3fi87c85jcy7lv359r6rpsgnp5zzs2f2zq4dl3540wzrxg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/heap.html";
          license = lib.licenses.free;
        };
      }) {};
    hiddenquote = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hiddenquote";
        ename = "hiddenquote";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hiddenquote-1.1.tar";
          sha256 = "1j692ka84z6k9c3bhcn28irym5fga4d1wvhmvzvixdbfwn58ivw5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hiddenquote.html";
          license = lib.licenses.free;
        };
      }) {};
    highlight-escape-sequences = callPackage ({ elpaBuild
                                              , fetchurl
                                              , lib }:
      elpaBuild {
        pname = "highlight-escape-sequences";
        ename = "highlight-escape-sequences";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/highlight-escape-sequences-0.4.el";
          sha256 = "1z8r9rnppn7iy7xv4kprfsqxday16h7c471i7rkyi3rv3l0pfxd0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-escape-sequences.html";
          license = lib.licenses.free;
        };
      }) {};
    hook-helpers = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hook-helpers";
        ename = "hook-helpers";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hook-helpers-1.1.1.tar";
          sha256 = "05nqlshdqh32smav58hzqg8wp04h7w9sxr239qrz4wqxwlxlv9im";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hook-helpers.html";
          license = lib.licenses.free;
        };
      }) {};
    html5-schema = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "html5-schema";
        ename = "html5-schema";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/html5-schema-0.1.tar";
          sha256 = "19k1jal6j64zq78w8h0lw7cljivmp2jzs5sa1ppc0mqkpn2hyq1i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/html5-schema.html";
          license = lib.licenses.free;
        };
      }) {};
    hydra = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "hydra";
        ename = "hydra";
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hydra-0.14.0.tar";
          sha256 = "1r2vl2cpzqzayfzc0bijigxc7c0mkgcv96g4p65gnw99jk8d78kb";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hydra.html";
          license = lib.licenses.free;
        };
      }) {};
    hyperbole = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hyperbole";
        ename = "hyperbole";
        version = "7.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hyperbole-7.1.3.tar";
          sha256 = "0bizibn4qgxqp89fyik6p47s9hss1g932mg8k7pznn3kkhj5c8rh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hyperbole.html";
          license = lib.licenses.free;
        };
      }) {};
    ilist = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ilist";
        ename = "ilist";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ilist-0.1.tar";
          sha256 = "1ihh44276ivgykva805540nkkrqmc61lydv20l99si3amg07q9bh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ilist.html";
          license = lib.licenses.free;
        };
      }) {};
    ioccur = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ioccur";
        ename = "ioccur";
        version = "2.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ioccur-2.6.tar";
          sha256 = "0k7nr73gmd0z5zqkwdacvfsmyflri3f15a15zpr7va28pnxqzsdk";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ioccur.html";
          license = lib.licenses.free;
        };
      }) {};
    isearch-mb = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "isearch-mb";
        ename = "isearch-mb";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/isearch-mb-0.4.tar";
          sha256 = "11q9sdi6l795hspi7hr621bbra66pxsgrkry95k7wxjkmibcbsxr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/isearch-mb.html";
          license = lib.licenses.free;
        };
      }) {};
    iterators = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "iterators";
        ename = "iterators";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/iterators-0.1.1.el";
          sha256 = "1r2cz2n6cr6wal5pqiqi5pn28pams639czgrvd60xcqmlr3li3g5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/iterators.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ivy";
        ename = "ivy";
        version = "0.13.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-0.13.4.tar";
          sha256 = "0qpza1c45mr8fcpnm32cck4v22fnzz1yb7kww05rzgq1k9iivx5v";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-avy = callPackage ({ avy, elpaBuild, emacs, fetchurl, ivy, lib }:
      elpaBuild {
        pname = "ivy-avy";
        ename = "ivy-avy";
        version = "0.13.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-avy-0.13.4.tar";
          sha256 = "1q5caxm4rnh4jy5n88dhkdbx1afsshmfki5dl8xsqbdb3y0zq7yi";
        };
        packageRequires = [ avy emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-avy.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-explorer = callPackage ({ elpaBuild, emacs, fetchurl, ivy, lib }:
      elpaBuild {
        pname = "ivy-explorer";
        ename = "ivy-explorer";
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-explorer-0.3.2.el";
          sha256 = "0q9gy9w22hnq30bfmnpqknk0qc1rcbjcybpjgb8hnlldvcci95l7";
        };
        packageRequires = [ emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-explorer.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-hydra = callPackage ({ elpaBuild, emacs, fetchurl, hydra, ivy, lib }:
      elpaBuild {
        pname = "ivy-hydra";
        ename = "ivy-hydra";
        version = "0.13.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-hydra-0.13.5.tar";
          sha256 = "06rln9bnq5hli5rqlm47fb68b8llpqrmzwqqv4rn7mx3854i9a5x";
        };
        packageRequires = [ emacs hydra ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-hydra.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-posframe = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , ivy
                                , lib
                                , posframe }:
      elpaBuild {
        pname = "ivy-posframe";
        ename = "ivy-posframe";
        version = "0.6.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-posframe-0.6.3.tar";
          sha256 = "0b498qzaydjrhplx4d7zcrs883dlrhfiz812sv4m3pmhfwifcchh";
        };
        packageRequires = [ emacs ivy posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    javaimp = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "javaimp";
        ename = "javaimp";
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/javaimp-0.8.tar";
          sha256 = "1i6k0yz6r7v774qgnkzinia783fwx73y3brxr31sbip3b5dbpmsn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/javaimp.html";
          license = lib.licenses.free;
        };
      }) {};
    jgraph-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "jgraph-mode";
        ename = "jgraph-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jgraph-mode-1.1.el";
          sha256 = "0479irjz5r79x6ngl3lfkl1gqsmvcw8kn6285sm6nkn66m1dfs8l";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jgraph-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    js2-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "js2-mode";
        ename = "js2-mode";
        version = "20211229";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/js2-mode-20211229.tar";
          sha256 = "0qf7z0mmrvlncf1ac6yiza5wmcaf588d53ma41vhj58adaahimz6";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/js2-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    json-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "json-mode";
        ename = "json-mode";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/json-mode-0.2.el";
          sha256 = "16ph6v9snvlmclg9shnyck86dqvlj4lf8205dhqx4l8vmhfy3d14";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/json-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    jsonrpc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jsonrpc";
        ename = "jsonrpc";
        version = "1.0.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jsonrpc-1.0.15.tar";
          sha256 = "0biwvkvd48xqvigzs00yz4mk847xzyzm7p0lkns58fxph9nkg4h5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jsonrpc.html";
          license = lib.licenses.free;
        };
      }) {};
    jumpc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "jumpc";
        ename = "jumpc";
        version = "3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jumpc-3.0.el";
          sha256 = "1vhggw3mzaq33al8f16jbg5qq5f95s8365is9qqyb8yq77gqym6a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jumpc.html";
          license = lib.licenses.free;
        };
      }) {};
    kind-icon = callPackage ({ elpaBuild, emacs, fetchurl, lib, svg-lib }:
      elpaBuild {
        pname = "kind-icon";
        ename = "kind-icon";
        version = "0.1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/kind-icon-0.1.4.tar";
          sha256 = "00pyvnq4dx51l2wbhvm6k6cx5xmy32j4h1lkr5kr8s3j5w83ip25";
        };
        packageRequires = [ emacs svg-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/kind-icon.html";
          license = lib.licenses.free;
        };
      }) {};
    kiwix = callPackage ({ elpaBuild, emacs, fetchurl, lib, request }:
      elpaBuild {
        pname = "kiwix";
        ename = "kiwix";
        version = "1.1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/kiwix-1.1.5.tar";
          sha256 = "17k4aa8s9m24c572qvl5a481iw9ny6wmd5yrg47iv4d2lb2i13h2";
        };
        packageRequires = [ emacs request ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/kiwix.html";
          license = lib.licenses.free;
        };
      }) {};
    kmb = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "kmb";
        ename = "kmb";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/kmb-0.1.el";
          sha256 = "1wjfk28illfd5bkka3rlhhq59r0pad9zik1njlxym0ha8kbhzsj8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/kmb.html";
          license = lib.licenses.free;
        };
      }) {};
    landmark = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "landmark";
        ename = "landmark";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/landmark-1.0.el";
          sha256 = "0mz1l9zc1nvggjhg4jcly8ncw38xkprlrha8l8vfl9k9rg7s1dv4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/landmark.html";
          license = lib.licenses.free;
        };
      }) {};
    leaf = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "leaf";
        ename = "leaf";
        version = "4.5.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/leaf-4.5.5.tar";
          sha256 = "1rdbrf84ijapiqhq72gy8r5xgk54sf0jy31pgd3w4rl1wywh5cas";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/leaf.html";
          license = lib.licenses.free;
        };
      }) {};
    let-alist = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "let-alist";
        ename = "let-alist";
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/let-alist-1.0.6.el";
          sha256 = "0szj7vnjzz4zci5fvz7xqgcpi4pzdyyf4qi2s8xar2hi7v3yaawr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/let-alist.html";
          license = lib.licenses.free;
        };
      }) {};
    lex = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "lex";
        ename = "lex";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lex-1.1.tar";
          sha256 = "1i6ri3k2b2nginhnmwy67mdpv5p75jkxjfwbf42wymza8fxzwbb7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lex.html";
          license = lib.licenses.free;
        };
      }) {};
    lmc = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lmc";
        ename = "lmc";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lmc-1.4.el";
          sha256 = "0fm4sclx9gg0d0615smz105x320sk45y4ivpjk3nbc67c5l0sh2h";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lmc.html";
          license = lib.licenses.free;
        };
      }) {};
    load-dir = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "load-dir";
        ename = "load-dir";
        version = "0.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-dir-0.0.5.el";
          sha256 = "1575ipn155nzzb5yghblxc7v1vpq4i16w1ff7y56qw2498ligpc5";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-dir.html";
          license = lib.licenses.free;
        };
      }) {};
    load-relative = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "load-relative";
        ename = "load-relative";
        version = "1.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-relative-1.3.1.el";
          sha256 = "1m37scr82lqqy954fchjxrmdh4lngrl4d1yzxhp3yfjhsydizhrj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-relative.html";
          license = lib.licenses.free;
        };
      }) {};
    loc-changes = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "loc-changes";
        ename = "loc-changes";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/loc-changes-1.2.el";
          sha256 = "1x8fn8vqasayf1rb8a6nma9n6nbvkx60krmiahyb05vl5rrsw6r3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/loc-changes.html";
          license = lib.licenses.free;
        };
      }) {};
    loccur = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "loccur";
        ename = "loccur";
        version = "1.2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/loccur-1.2.4.el";
          sha256 = "00f1ifa4z5ay90bd2002fmj83d7xqzrcr9018q8crlypmpxkyh7j";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/loccur.html";
          license = lib.licenses.free;
        };
      }) {};
    map = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "map";
        ename = "map";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/map-3.2.1.tar";
          sha256 = "1zj0y3nvkrd2v43za214xr3h9z6wyp7r5s6nf5g1pj272yb871d1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/map.html";
          license = lib.licenses.free;
        };
      }) {};
    marginalia = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "marginalia";
        ename = "marginalia";
        version = "0.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/marginalia-0.12.tar";
          sha256 = "01dy9dg2ac6s84ffcxn2pw1y75pinkdvxg1j2g3vijwjd5hpfakq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/marginalia.html";
          license = lib.licenses.free;
        };
      }) {};
    markchars = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "markchars";
        ename = "markchars";
        version = "0.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/markchars-0.2.2.el";
          sha256 = "09a471c2mcjm6ia37xqz0573sy8f68d5ljgnmhrj0v455g1g44lj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markchars.html";
          license = lib.licenses.free;
        };
      }) {};
    math-symbol-lists = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "math-symbol-lists";
        ename = "math-symbol-lists";
        version = "1.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/math-symbol-lists-1.2.1.el";
          sha256 = "015q44qg9snrpz04syz89f9f79pzg5h7w88nh84p38klynkx2f86";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/math-symbol-lists.html";
          license = lib.licenses.free;
        };
      }) {};
    mct = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "mct";
        ename = "mct";
        version = "0.5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mct-0.5.0.tar";
          sha256 = "0yv0hqkyh5vpmf5i50fdc2rw3ssvrd9pn3n65v3gmb195gzmn6r9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mct.html";
          license = lib.licenses.free;
        };
      }) {};
    memory-usage = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "memory-usage";
        ename = "memory-usage";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/memory-usage-0.2.el";
          sha256 = "03qwb7sprdh1avxv3g7hhnhl41pwvnpxcpnqrikl7picy78h1gwj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/memory-usage.html";
          license = lib.licenses.free;
        };
      }) {};
    metar = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "metar";
        ename = "metar";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/metar-0.3.el";
          sha256 = "07gv0v0xwb5yzynwagmvf0n5c9wljy1jg4ympnxpa2d9r1zqc02g";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/metar.html";
          license = lib.licenses.free;
        };
      }) {};
    midi-kbd = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "midi-kbd";
        ename = "midi-kbd";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/midi-kbd-0.2.el";
          sha256 = "1783k07gyiaq784wqv8qqc89cw5d6q1bdqz68b7n1lx4vmvfrhmh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/midi-kbd.html";
          license = lib.licenses.free;
        };
      }) {};
    mines = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "mines";
        ename = "mines";
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mines-1.6.tar";
          sha256 = "1199s1v4my0qpvc5aaxzbqayjn59vilxbqnywvyhvm7hz088aps2";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mines.html";
          license = lib.licenses.free;
        };
      }) {};
    minibuffer-line = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "minibuffer-line";
        ename = "minibuffer-line";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minibuffer-line-0.1.el";
          sha256 = "1ny4iirp26na5118wfgxlv6fxlrdclzdbd9m0lkrv51w0qw7spil";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minibuffer-line.html";
          license = lib.licenses.free;
        };
      }) {};
    minimap = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "minimap";
        ename = "minimap";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minimap-1.4.el";
          sha256 = "09fm0ziy8cdzzw08l7l6p63dxz2a27p3laia2v51mvbva8177ls1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minimap.html";
          license = lib.licenses.free;
        };
      }) {};
    mmm-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "mmm-mode";
        ename = "mmm-mode";
        version = "0.5.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mmm-mode-0.5.8.tar";
          sha256 = "05ckf4zapdpvnd3sqpw6kxaa567zh536a36m9qzx3sqyjbyn5fb4";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mmm-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    modus-operandi-theme = callPackage ({ elpaBuild
                                        , emacs
                                        , fetchurl
                                        , lib
                                        , modus-themes }:
      elpaBuild {
        pname = "modus-operandi-theme";
        ename = "modus-operandi-theme";
        version = "0.13.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/modus-operandi-theme-0.13.2.tar";
          sha256 = "1sw18ijp9rhaf8y8x8z5rmxy23pxd3gaicgmp2zndcfmm54gwsic";
        };
        packageRequires = [ emacs modus-themes ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-operandi-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    modus-themes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "modus-themes";
        ename = "modus-themes";
        version = "2.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/modus-themes-2.2.0.tar";
          sha256 = "1vgwr9q16d3hjwmqljmmzlpn177gvwbk3wg4l1fmgc5bpb7k78ky";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    modus-vivendi-theme = callPackage ({ elpaBuild
                                       , emacs
                                       , fetchurl
                                       , lib
                                       , modus-themes }:
      elpaBuild {
        pname = "modus-vivendi-theme";
        ename = "modus-vivendi-theme";
        version = "0.13.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/modus-vivendi-theme-0.13.2.tar";
          sha256 = "1qn3kzxwf81zc7gprd9wblhb8b8akdkxwajpgk036y8i4cmvmspn";
        };
        packageRequires = [ emacs modus-themes ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-vivendi-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    multi-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "multi-mode";
        ename = "multi-mode";
        version = "1.14";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/multi-mode-1.14.tar";
          sha256 = "0aslndqr0277ai0iwywbmj07vmz88vpmc0mgydcy4li8fkn8h066";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multi-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    multishell = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "multishell";
        ename = "multishell";
        version = "1.1.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/multishell-1.1.9.tar";
          sha256 = "0gi5qmx27v7kaczr9b3sic69br3l7mcws3sdrs8c14iipcyl5qhb";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multishell.html";
          license = lib.licenses.free;
        };
      }) {};
    muse = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "muse";
        ename = "muse";
        version = "3.20.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/muse-3.20.2.tar";
          sha256 = "0g2ff6x45x2k5dnkp31sk3bjj92jyhhnar7l5hzn8vp22l0rv8wn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/muse.html";
          license = lib.licenses.free;
        };
      }) {};
    myers = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "myers";
        ename = "myers";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/myers-0.1.el";
          sha256 = "0yrxklkksj16cfbvwmdxjj43vngjd6q0fivib1xim3c9g3c9b670";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/myers.html";
          license = lib.licenses.free;
        };
      }) {};
    nadvice = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "nadvice";
        ename = "nadvice";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nadvice-0.3.el";
          sha256 = "0gi3csnxbs8h7iy0scsl35sic3gv90swa89hhdjwb7qvpirfdcgw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nadvice.html";
          license = lib.licenses.free;
        };
      }) {};
    nameless = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nameless";
        ename = "nameless";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nameless-1.0.2.el";
          sha256 = "13c1payc46ry5bf8ia8cwqpshm2ya74fi5r4sxq5n410z5f0pgqx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nameless.html";
          license = lib.licenses.free;
        };
      }) {};
    names = callPackage ({ cl-lib ? null
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , lib
                         , nadvice }:
      elpaBuild {
        pname = "names";
        ename = "names";
        version = "20151201.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/names-20151201.0.tar";
          sha256 = "13smsf039x4yd7pzvllgn1vz8lhkwghnhip9y2bka38vk37w912d";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/names.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-agenda = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nano-agenda";
        ename = "nano-agenda";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-agenda-0.2.1.tar";
          sha256 = "0j29fwc273mjdlj83h1a46sb7z3j066qqnp2i78kn2pmgjg27szb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-agenda.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-modeline = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nano-modeline";
        ename = "nano-modeline";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-modeline-0.5.tar";
          sha256 = "0f6xgrxykd5jmlzf9xmywh0jc2jfq698m4nqk60h40dm6pi0gfi2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-modeline.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nano-theme";
        ename = "nano-theme";
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-theme-0.3.0.tar";
          sha256 = "1nq5x46467vnsfg3fzb0qyg97xpnwsvbqg8frdjil5zq5fhsgmrz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    nhexl-mode = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "nhexl-mode";
        ename = "nhexl-mode";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nhexl-mode-1.5.el";
          sha256 = "0qvxfg7sv4iqyjxzaim6b4v9k5hav36qd4vkf9jwzw6p5fri8w8d";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nhexl-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    nlinum = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "nlinum";
        ename = "nlinum";
        version = "1.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nlinum-1.9.el";
          sha256 = "03zqlz58fvh4cpfl43h7py2fpnc7m37f1ys8zhrc511ccq9cwkdn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nlinum.html";
          license = lib.licenses.free;
        };
      }) {};
    notes-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "notes-mode";
        ename = "notes-mode";
        version = "1.30";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/notes-mode-1.30.tar";
          sha256 = "1aqivlfa0nk0y27gdv68k5rg3m5wschh8cw196a13qb7kaghk9r6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/notes-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ntlm = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ntlm";
        ename = "ntlm";
        version = "2.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ntlm-2.1.0.el";
          sha256 = "01d0bcmh8a36qf871w6bc05kjk9bmnh843m9869xw06zyvqwg9mv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ntlm.html";
          license = lib.licenses.free;
        };
      }) {};
    num3-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "num3-mode";
        ename = "num3-mode";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/num3-mode-1.3.el";
          sha256 = "0x2jpnzvpbj03pbmhsny5gygh63c4dbl4g3k0cfs3vh4qmp2dg6w";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/num3-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    oauth2 = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, nadvice }:
      elpaBuild {
        pname = "oauth2";
        ename = "oauth2";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/oauth2-0.16.tar";
          sha256 = "1rzly2nwjywrfgcmp8zidbmjl2ahyd8l8507lb1mxm4xqryvf316";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/oauth2.html";
          license = lib.licenses.free;
        };
      }) {};
    ob-haxe = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ob-haxe";
        ename = "ob-haxe";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ob-haxe-1.0.tar";
          sha256 = "1x19b3aappv4d3mvpf01r505l1sfndbzbpr5sbid411g9g9k3rwr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ob-haxe.html";
          license = lib.licenses.free;
        };
      }) {};
    objed = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "objed";
        ename = "objed";
        version = "0.8.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/objed-0.8.3.tar";
          sha256 = "1s38d6bvggdk5p45ww1jb4gxifzgjwgw1m6ar920nlg0j4fgbcvr";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/objed.html";
          license = lib.licenses.free;
        };
      }) {};
    omn-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "omn-mode";
        ename = "omn-mode";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/omn-mode-1.2.el";
          sha256 = "0p7lmqabdcn625q9z7libn7q1b6mjc74bkic2kjhhckzvlfjk742";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/omn-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    on-screen = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "on-screen";
        ename = "on-screen";
        version = "1.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/on-screen-1.3.3.el";
          sha256 = "0ga4hw23ki583li2z2hr7l6hk1nc2kdg4afndg06cm9jn158wza7";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/on-screen.html";
          license = lib.licenses.free;
        };
      }) {};
    orderless = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "orderless";
        ename = "orderless";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/orderless-0.7.tar";
          sha256 = "0hvfqxpazan1djpn0qxh609r53jgddpcdih6chkn2zvx29mhdkgg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/orderless.html";
          license = lib.licenses.free;
        };
      }) {};
    org = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "9.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-9.5.2.tar";
          sha256 = "12pvr47b11pq5rncpb3x8y11fhnakk5bi73j9l9w4d4ss3swcrnh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-edna = callPackage ({ elpaBuild, emacs, fetchurl, lib, org, seq }:
      elpaBuild {
        pname = "org-edna";
        ename = "org-edna";
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-edna-1.1.2.tar";
          sha256 = "1a022ssqpxbkp03n2bij78srwjx7kacpsgj9a6wbm0yn946hgjpz";
        };
        packageRequires = [ emacs org seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-edna.html";
          license = lib.licenses.free;
        };
      }) {};
    org-real = callPackage ({ boxy, elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-real";
        ename = "org-real";
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-real-1.0.4.tar";
          sha256 = "0bn9vyx74lki2nggzir02mcrww94dnqpbkryjr7a4i6am0ylf705";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-real.html";
          license = lib.licenses.free;
        };
      }) {};
    org-remark = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-remark";
        ename = "org-remark";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-remark-1.0.2.tar";
          sha256 = "12g9kmr0gfs1pi1410akvcaiax0dswbw09sgqbib58mikb3074nv";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-remark.html";
          license = lib.licenses.free;
        };
      }) {};
    org-transclusion = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-transclusion";
        ename = "org-transclusion";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-transclusion-1.2.0.tar";
          sha256 = "1q36nqxynzh8ygvgw5nmg49c4yq8pgp6lcb6mdqs9paw8pglxcjf";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-transclusion.html";
          license = lib.licenses.free;
        };
      }) {};
    org-translate = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-translate";
        ename = "org-translate";
        version = "0.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-translate-0.1.3.el";
          sha256 = "0m52vv1961kf8f1gw8c4n02hxcvhdw3wgzmcxvjcdijfnjkarm33";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-translate.html";
          license = lib.licenses.free;
        };
      }) {};
    orgalist = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "orgalist";
        ename = "orgalist";
        version = "1.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/orgalist-1.13.el";
          sha256 = "1wkxc5kcy1g4lx6pd78pa8znncjyl9zyhsvz7wpp56qmhq4hlav3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/orgalist.html";
          license = lib.licenses.free;
        };
      }) {};
    osc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "osc";
        ename = "osc";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/osc-0.4.tar";
          sha256 = "0zfrzxalvvf9wwwhwsqgl3v2ca6m2rfl5hd7sz662s6gmbwawqqa";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/osc.html";
          license = lib.licenses.free;
        };
      }) {};
    other-frame-window = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "other-frame-window";
        ename = "other-frame-window";
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/other-frame-window-1.0.6.el";
          sha256 = "04h0jr73xv8inm52h8b8zbc9lsnlzkn40qy99x4x0lkkdqqxw1ny";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/other-frame-window.html";
          license = lib.licenses.free;
        };
      }) {};
    pabbrev = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "pabbrev";
        ename = "pabbrev";
        version = "4.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pabbrev-4.2.1.el";
          sha256 = "19v5adk61y8fpigw7k6wz6dj79jwr450hnbi7fj0jvb21cvjmfxh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pabbrev.html";
          license = lib.licenses.free;
        };
      }) {};
    paced = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "paced";
        ename = "paced";
        version = "1.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/paced-1.1.3.tar";
          sha256 = "1gaszf68h0nnv6p6yzv48m24csw6v479nsq0f02y6slixxaflnwl";
        };
        packageRequires = [ async emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/paced.html";
          license = lib.licenses.free;
        };
      }) {};
    parsec = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "parsec";
        ename = "parsec";
        version = "0.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/parsec-0.1.3.tar";
          sha256 = "032m9iks5a05vbc4159dfs9b7shmqm6mk05jgbs9ndvy400drwd6";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parsec.html";
          license = lib.licenses.free;
        };
      }) {};
    parser-generator = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "parser-generator";
        ename = "parser-generator";
        version = "0.1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/parser-generator-0.1.5.tar";
          sha256 = "06cl9whk321l1q5xcjmgq5c59l10ybwcdsmmbrkrllnbpqxy23bj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parser-generator.html";
          license = lib.licenses.free;
        };
      }) {};
    path-iterator = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "path-iterator";
        ename = "path-iterator";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/path-iterator-1.0.tar";
          sha256 = "0kgl7rhv9x23jyr6ahfy6ql447zpz9fnmfwldkpn69g7jdx6a3cc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/path-iterator.html";
          license = lib.licenses.free;
        };
      }) {};
    peg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "peg";
        ename = "peg";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/peg-1.0.tar";
          sha256 = "0skr5dz9k34r409hisnj37n1b7n62l3md0glnfx578xkbmxlpcxl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/peg.html";
          license = lib.licenses.free;
        };
      }) {};
    persist = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "persist";
        ename = "persist";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/persist-0.4.tar";
          sha256 = "0gpxy41qawzss2526j9a7lys60vqma1lvamn4bfabwza7gfhac0q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/persist.html";
          license = lib.licenses.free;
        };
      }) {};
    phps-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "phps-mode";
        ename = "phps-mode";
        version = "0.4.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/phps-mode-0.4.17.tar";
          sha256 = "1j3whjxhjawl1i5449yf56ljbazx90272gr8zfr36s8h8rijfjn9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/phps-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    pinentry = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "pinentry";
        ename = "pinentry";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pinentry-0.1.el";
          sha256 = "0iiw11prk4w32czk69mvc3x6ja9xbhbvpg9b0nidrsg5njjjh76d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pinentry.html";
          license = lib.licenses.free;
        };
      }) {};
    poker = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "poker";
        ename = "poker";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poker-0.2.el";
          sha256 = "0sikspimvnzvwhyivi1gvr0630zz2pr3q2fwagl57iv06jas9f00";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poker.html";
          license = lib.licenses.free;
        };
      }) {};
    posframe = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "posframe";
        ename = "posframe";
        version = "1.1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/posframe-1.1.7.tar";
          sha256 = "13i2wxx079gfq0vbq0iwmsig5b7x4aspd1q02yqc79846f1dsx4w";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    project = callPackage ({ elpaBuild, emacs, fetchurl, lib, xref }:
      elpaBuild {
        pname = "project";
        ename = "project";
        version = "0.8.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/project-0.8.1.tar";
          sha256 = "0q2js8qihlhchpx2mx0f992ygslsqri2q4iv8kcl4fx31lpp7c1k";
        };
        packageRequires = [ emacs xref ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/project.html";
          license = lib.licenses.free;
        };
      }) {};
    psgml = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "psgml";
        ename = "psgml";
        version = "1.3.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/psgml-1.3.4.tar";
          sha256 = "1pgg9g040zsnvilvmwa73wyrvv9xh7gf6w1rkcx57qzg7yq4yaaj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/psgml.html";
          license = lib.licenses.free;
        };
      }) {};
    pspp-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "pspp-mode";
        ename = "pspp-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pspp-mode-1.1.el";
          sha256 = "1qnwj7r367qs0ykw71c6s96ximgg2wb3hxg5fwsl9q2vfhbh35ca";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pspp-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    pyim = callPackage ({ async, elpaBuild, emacs, fetchurl, lib, xr }:
      elpaBuild {
        pname = "pyim";
        ename = "pyim";
        version = "4.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pyim-4.1.0.tar";
          sha256 = "1q4b3y72gbkl5z31brlnjqjl30lgqm2d1zlqrbkqnnfy5hjgazk9";
        };
        packageRequires = [ async emacs xr ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pyim.html";
          license = lib.licenses.free;
        };
      }) {};
    pyim-basedict = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "pyim-basedict";
        ename = "pyim-basedict";
        version = "0.5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pyim-basedict-0.5.0.tar";
          sha256 = "0h946wsnbbii32kl2kpv0k1kq118ymvpd5q1mphfsf126dz9sv78";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pyim-basedict.html";
          license = lib.licenses.free;
        };
      }) {};
    python = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "python";
        ename = "python";
        version = "0.28";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/python-0.28.tar";
          sha256 = "1kc596b8bbcp8y87kqyxsv3bblz8l0vyc0d645ayb1cmwwvk35d5";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/python.html";
          license = lib.licenses.free;
        };
      }) {};
    quarter-plane = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "quarter-plane";
        ename = "quarter-plane";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/quarter-plane-0.1.el";
          sha256 = "0hj3asdzf05h8j1fsxx9y71arnprg2xwk2dcb81zj04hzggzpwmm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/quarter-plane.html";
          license = lib.licenses.free;
        };
      }) {};
    queue = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "queue";
        ename = "queue";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/queue-0.2.el";
          sha256 = "0cx2848sqnnkkr4zisvqadzxngjyhmb36mh0q3if7q19yjjhmrkb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/queue.html";
          license = lib.licenses.free;
        };
      }) {};
    rainbow-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rainbow-mode";
        ename = "rainbow-mode";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rainbow-mode-1.0.5.el";
          sha256 = "159fps843k5pap9k04a7ll1k3gw6d9c6w08lq4bbc3lqg78aa2l9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rainbow-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    rbit = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rbit";
        ename = "rbit";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rbit-0.1.el";
          sha256 = "0h0f9jx4xmkbyxk39wibrvnj65b1ylkz4sk4np7qcavfjs6dz3lm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rbit.html";
          license = lib.licenses.free;
        };
      }) {};
    rcirc-color = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rcirc-color";
        ename = "rcirc-color";
        version = "0.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-color-0.4.2.tar";
          sha256 = "0pa9p018kwsy44cmkli7x6cz1abxkyi26ac7w3vh99qp7x97dia3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rcirc-color.html";
          license = lib.licenses.free;
        };
      }) {};
    rcirc-menu = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rcirc-menu";
        ename = "rcirc-menu";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-menu-1.1.el";
          sha256 = "0w77qlwlmx59v5894i96fldn6x4lliv4ddv8967vq1kfchn4w5mc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rcirc-menu.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib
                           , load-relative
                           , loc-changes
                           , test-simple }:
      elpaBuild {
        pname = "realgud";
        ename = "realgud";
        version = "1.5.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-1.5.1.tar";
          sha256 = "01155sydricdvxy3djk64w2zc6x0q4j669bvz8m8rd766wsmida8";
        };
        packageRequires = [ emacs load-relative loc-changes test-simple ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-ipdb = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , load-relative
                                , realgud }:
      elpaBuild {
        pname = "realgud-ipdb";
        ename = "realgud-ipdb";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-ipdb-1.0.0.tar";
          sha256 = "1ljh2igm6na92jdvnn4f51019v3klc6k03nayxf6qxzaxwq2w254";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-ipdb.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-jdb = callPackage ({ cl-lib ? null
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib
                               , load-relative
                               , realgud }:
      elpaBuild {
        pname = "realgud-jdb";
        ename = "realgud-jdb";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-jdb-1.0.0.tar";
          sha256 = "081lqsxbg6cxv8hz8s0z2gbdif9drp5b0crbixmwf164i4h8l4gc";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-jdb.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-lldb = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , load-relative
                                , realgud }:
      elpaBuild {
        pname = "realgud-lldb";
        ename = "realgud-lldb";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-lldb-1.0.2.tar";
          sha256 = "0nqbvknhvw5lwf4i44q8wvh4y4s9mvs5kn7lskg3xicl464ag1d0";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-lldb.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-node-debug = callPackage ({ cl-lib ? null
                                      , elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib
                                      , load-relative
                                      , realgud }:
      elpaBuild {
        pname = "realgud-node-debug";
        ename = "realgud-node-debug";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-node-debug-1.0.0.tar";
          sha256 = "1wyh6apy289a3qa1bnwv68x8pjkpqy4m18ygqnr4x759hjkq3nir";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-node-debug.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-node-inspect = callPackage ({ cl-lib ? null
                                        , elpaBuild
                                        , emacs
                                        , fetchurl
                                        , lib
                                        , load-relative
                                        , realgud }:
      elpaBuild {
        pname = "realgud-node-inspect";
        ename = "realgud-node-inspect";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-node-inspect-1.0.0.tar";
          sha256 = "16cx0rq4zx5k0y75j044dbqzrzs1df3r95rissmhfgsi5m2qf1h2";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-node-inspect.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-trepan-ni = callPackage ({ cl-lib ? null
                                     , elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib
                                     , load-relative
                                     , realgud }:
      elpaBuild {
        pname = "realgud-trepan-ni";
        ename = "realgud-trepan-ni";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-trepan-ni-1.0.1.tar";
          sha256 = "0vakfzlk4pgqi66mdvwqhzgdsnks6clgnj7cjjbi80v3ipkfdnak";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-trepan-ni.html";
          license = lib.licenses.free;
        };
      }) {};
    rec-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rec-mode";
        ename = "rec-mode";
        version = "1.8.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rec-mode-1.8.2.tar";
          sha256 = "06mjj1la2v8zdhsflj3mwcp7qnkj7gxzm8wbk2pli1h8vnq2zvd0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rec-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    register-list = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "register-list";
        ename = "register-list";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/register-list-0.1.el";
          sha256 = "1azgfm4yvhp2bqqplmfbz1fij8gda527lks82bslnpnabd8m6sjh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/register-list.html";
          license = lib.licenses.free;
        };
      }) {};
    relint = callPackage ({ elpaBuild, emacs, fetchurl, lib, xr }:
      elpaBuild {
        pname = "relint";
        ename = "relint";
        version = "1.20";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/relint-1.20.tar";
          sha256 = "0r20dim2r4a4bv0fmgbnq3graa7hhlai55h9qyknapqbr2j1v1h7";
        };
        packageRequires = [ emacs xr ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/relint.html";
          license = lib.licenses.free;
        };
      }) {};
    repology = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "repology";
        ename = "repology";
        version = "1.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/repology-1.2.2.tar";
          sha256 = "0ggb0zgz24hs5andhyrlpqm0gda0gf1wynzkarj4z7gpk5p9wrpr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/repology.html";
          license = lib.licenses.free;
        };
      }) {};
    rich-minority = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rich-minority";
        ename = "rich-minority";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rich-minority-1.0.3.tar";
          sha256 = "1w61qvx2rw6a6gmrm61080zghil95nzdv4w06c0pvyb62m4rwab0";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rich-minority.html";
          license = lib.licenses.free;
        };
      }) {};
    rnc-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rnc-mode";
        ename = "rnc-mode";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rnc-mode-0.2.el";
          sha256 = "0xhvcfqjkb010wc7r218xcjidv1c8597vayyv09vk97z4qxqkrbd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rnc-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    rt-liberation = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "rt-liberation";
        ename = "rt-liberation";
        version = "4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rt-liberation-4.tar";
          sha256 = "15vs982cxpc3g8cq2gj3a6dfn9i2r9b44x38ydvcmiy2brkd3psj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rt-liberation.html";
          license = lib.licenses.free;
        };
      }) {};
    rudel = callPackage ({ cl-generic
                         , cl-lib ? null
                         , cl-print
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , lib }:
      elpaBuild {
        pname = "rudel";
        ename = "rudel";
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rudel-0.3.2.tar";
          sha256 = "03hcvpp6ykavidwn5x48gs986w1i5icvh7ks6p74pdaagpgw4jmk";
        };
        packageRequires = [ cl-generic cl-lib cl-print emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rudel.html";
          license = lib.licenses.free;
        };
      }) {};
    satchel = callPackage ({ elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "satchel";
        ename = "satchel";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/satchel-0.2.tar";
          sha256 = "1ajsfrr988nglw2l4kqjbbdq9x8gidv0ymsrg3jm2b9nisfhnixv";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/satchel.html";
          license = lib.licenses.free;
        };
      }) {};
    scanner = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "scanner";
        ename = "scanner";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/scanner-0.2.tar";
          sha256 = "1nbfpgndjkv7mr81bxy58k4y13lc4cidyz9mbwh7433r8rfhymb5";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scanner.html";
          license = lib.licenses.free;
        };
      }) {};
    scroll-restore = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "scroll-restore";
        ename = "scroll-restore";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/scroll-restore-1.0.el";
          sha256 = "0h55szlmkmzmcvd6gvv8l74n7y64i0l78nwwmq7xsbzprlmj6khn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scroll-restore.html";
          license = lib.licenses.free;
        };
      }) {};
    sed-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sed-mode";
        ename = "sed-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sed-mode-1.0.el";
          sha256 = "1zpdai5k9zhy5hw0a5zx7qv3rcf8cn29hncfjnhk9k6sjq0302lg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sed-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    seq = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "seq";
        ename = "seq";
        version = "2.23";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/seq-2.23.tar";
          sha256 = "1lbxnrzq88z8k9dyylg2636pg9vc8bzfprs1hxwp9ah0zkvsn52p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/seq.html";
          license = lib.licenses.free;
        };
      }) {};
    setup = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "setup";
        ename = "setup";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/setup-1.2.0.tar";
          sha256 = "1fyzkm42gsvsjpk3vahfb7asfldarixm0wsw3g66q3ad0r7cbjnz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/setup.html";
          license = lib.licenses.free;
        };
      }) {};
    shelisp = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "shelisp";
        ename = "shelisp";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/shelisp-1.0.0.tar";
          sha256 = "05r26gy1ajl47ir0yz5gn62xw2f31vdq04n3r8ywlzxbqyvzlc0d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shelisp.html";
          license = lib.licenses.free;
        };
      }) {};
    shell-command-plus = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "shell-command-plus";
        ename = "shell-command+";
        version = "2.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/shell-command+-2.3.2.tar";
          sha256 = "03hmk4gr9kjy3238n0ys9na00py035j9s0y8d87c45f5af6c6g2c";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shell-command+.html";
          license = lib.licenses.free;
        };
      }) {};
    shen-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "shen-mode";
        ename = "shen-mode";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/shen-mode-0.1.tar";
          sha256 = "1dr24kkah4hr6vrfxwhl9vzjnwn4n773bw23c3j9bkmlgnbvn0kz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shen-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    sisu-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sisu-mode";
        ename = "sisu-mode";
        version = "7.1.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sisu-mode-7.1.8.el";
          sha256 = "12zs6y4rzng1d7djl9wh3wc0f9fj0bqb7h754rvixvndlr5c10nj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sisu-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    sketch-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sketch-mode";
        ename = "sketch-mode";
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sketch-mode-1.0.4.tar";
          sha256 = "1gv03ykr40laf52hm8p0glfsy895jghkp5a8q599zwg5wpz3zdc9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sketch-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    slime-volleyball = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "slime-volleyball";
        ename = "slime-volleyball";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/slime-volleyball-1.2.0.tar";
          sha256 = "07xavg6xq5ckrfy5sk5k5ldb46m5w8nw1r1k006ck8f23ajaw5z2";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/slime-volleyball.html";
          license = lib.licenses.free;
        };
      }) {};
    sm-c-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sm-c-mode";
        ename = "sm-c-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sm-c-mode-1.1.el";
          sha256 = "1k46628dkmg4bvd5f68lv5kjcjbgm2pd8jc0zhq9n70jwf5z2ip8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sm-c-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    smalltalk-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "smalltalk-mode";
        ename = "smalltalk-mode";
        version = "4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/smalltalk-mode-4.0.tar";
          sha256 = "1i1w2fk241z10mph92lry8ly55rxr24n1v4840cddpiw81nrqpcn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/smalltalk-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    smart-yank = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "smart-yank";
        ename = "smart-yank";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/smart-yank-0.1.1.el";
          sha256 = "1v7hbn8pl4bzal31m132dn04rgsgjjcc7k2knd1jqzk1wq6azpdn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/smart-yank.html";
          license = lib.licenses.free;
        };
      }) {};
    sml-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sml-mode";
        ename = "sml-mode";
        version = "6.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sml-mode-6.10.el";
          sha256 = "01yf0s474r9xhj6nbs14ljn9ccxb5yy758i17c8nmgmqvm8fx7sb";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sml-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    so-long = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "so-long";
        ename = "so-long";
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/so-long-1.1.2.tar";
          sha256 = "0gb5ypl9phhv8sx7akw9xn7njfq86yqngixhxf8qj1fxp57gfpdb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/so-long.html";
          license = lib.licenses.free;
        };
      }) {};
    soap-client = callPackage ({ cl-lib ? null
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "soap-client";
        ename = "soap-client";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/soap-client-3.2.1.tar";
          sha256 = "0v3aj059cvfv5yc9fx8naq8ygphlpbasc1nksgfim8iyk9wg7l3n";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/soap-client.html";
          license = lib.licenses.free;
        };
      }) {};
    sokoban = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sokoban";
        ename = "sokoban";
        version = "1.4.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sokoban-1.4.8.tar";
          sha256 = "1w3vrkg239x1saqka21zbl380fxqmbz3lr7820spxd8p5w9v55pn";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sokoban.html";
          license = lib.licenses.free;
        };
      }) {};
    sotlisp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sotlisp";
        ename = "sotlisp";
        version = "1.6.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sotlisp-1.6.2.el";
          sha256 = "05cr4dmhg4wbmw7jbcfh0yrnbq6dhzp2wrbzvhwrfznz51j03nhi";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sotlisp.html";
          license = lib.licenses.free;
        };
      }) {};
    spinner = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spinner";
        ename = "spinner";
        version = "1.7.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/spinner-1.7.4.tar";
          sha256 = "140kss25ijbwf8hzflbjz67ry76w2cyrh02axk95n6qcxv7jr7pv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spinner.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-beeline = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sql-beeline";
        ename = "sql-beeline";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-beeline-0.1.tar";
          sha256 = "0yvj96aljmyiz8y6xjpypqjfrl1jdcrcc4jx4kbgl6mkv4z2aq1g";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-beeline.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-indent = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sql-indent";
        ename = "sql-indent";
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-indent-1.6.tar";
          sha256 = "000pimlg0k4mrv2wpqq8w8l51wpr1lzlaq6ai8iaximm2a92ap5b";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    ssh-deploy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ssh-deploy";
        ename = "ssh-deploy";
        version = "3.1.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ssh-deploy-3.1.13.tar";
          sha256 = "006jr8yc5qvxdfk0pn40604a2b7a1ah6l6hi6rhxm3p5b08d9i5w";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ssh-deploy.html";
          license = lib.licenses.free;
        };
      }) {};
    stream = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "stream";
        ename = "stream";
        version = "2.2.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/stream-2.2.5.tar";
          sha256 = "00c3n4gyxzv7vczqms0d62kl8zsmjfyxa92mwxn2snyx857a9jfw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/stream.html";
          license = lib.licenses.free;
        };
      }) {};
    svg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "svg";
        ename = "svg";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-1.1.el";
          sha256 = "0j69xsaj0d1pnxjfb5m0yf2vxbrcmr8i3g75km4dzbha46v4xxvg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg.html";
          license = lib.licenses.free;
        };
      }) {};
    svg-clock = callPackage ({ elpaBuild, emacs, fetchurl, lib, svg }:
      elpaBuild {
        pname = "svg-clock";
        ename = "svg-clock";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-clock-1.2.el";
          sha256 = "15pmj07wnlcpv78av9qpnbfwdjlkf237vib8smpa7nvyikdfszfr";
        };
        packageRequires = [ emacs svg ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-clock.html";
          license = lib.licenses.free;
        };
      }) {};
    svg-lib = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "svg-lib";
        ename = "svg-lib";
        version = "0.2.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-lib-0.2.5.tar";
          sha256 = "022jp54w14sv0d71j0z76bnir9bgvysmcpcxpzpiiz77da6rg393";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-lib.html";
          license = lib.licenses.free;
        };
      }) {};
    svg-tag-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, svg-lib }:
      elpaBuild {
        pname = "svg-tag-mode";
        ename = "svg-tag-mode";
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-tag-mode-0.3.2.tar";
          sha256 = "1sg05dg0d9ai21l8rgpqywmwgw29sl21x2zkvlv04rl3hdvdq75y";
        };
        packageRequires = [ emacs svg-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-tag-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    swiper = callPackage ({ elpaBuild, emacs, fetchurl, ivy, lib }:
      elpaBuild {
        pname = "swiper";
        ename = "swiper";
        version = "0.13.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/swiper-0.13.4.tar";
          sha256 = "197pq2cvvskib87aky907wv2am55vilr7y5dabmmm07a8vr9py0v";
        };
        packageRequires = [ emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swiper.html";
          license = lib.licenses.free;
        };
      }) {};
    system-packages = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "system-packages";
        ename = "system-packages";
        version = "1.0.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/system-packages-1.0.11.tar";
          sha256 = "0xf2q5bslxpw0wycgi2k983lnfpw182rgdzq0f99f64kb7ifns9y";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/system-packages.html";
          license = lib.licenses.free;
        };
      }) {};
    tNFA = callPackage ({ elpaBuild, fetchurl, lib, queue }:
      elpaBuild {
        pname = "tNFA";
        ename = "tNFA";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tNFA-0.1.1.el";
          sha256 = "01n4p8lg8f2k55l2z77razb2sl202qisjqm5lff96a2kxnxinsds";
        };
        packageRequires = [ queue ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tNFA.html";
          license = lib.licenses.free;
        };
      }) {};
    taxy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "taxy";
        ename = "taxy";
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/taxy-0.8.tar";
          sha256 = "00pc6lh35gj8vzcsn17fyazb9jsc4m6nr7cvb32w02isadv8qd3m";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/taxy.html";
          license = lib.licenses.free;
        };
      }) {};
    temp-buffer-browse = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "temp-buffer-browse";
        ename = "temp-buffer-browse";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/temp-buffer-browse-1.5.el";
          sha256 = "1drfvqxc6g4vfijmx787b1ygq7x2s5wq26l45qnz4wdrqqmcqx3c";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/temp-buffer-browse.html";
          license = lib.licenses.free;
        };
      }) {};
    tempel = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tempel";
        ename = "tempel";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tempel-0.2.tar";
          sha256 = "0xn2vqaxqv04zmlp5hpb9vxkbs3bv4dk22xs5j5fqjid2hcv3714";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tempel.html";
          license = lib.licenses.free;
        };
      }) {};
    test-simple = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "test-simple";
        ename = "test-simple";
        version = "1.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/test-simple-1.3.0.el";
          sha256 = "1yd61jc9ds95a5n09052kwc5gasy57g4lxr0jsff040brlyi9czz";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/test-simple.html";
          license = lib.licenses.free;
        };
      }) {};
    timerfunctions = callPackage ({ cl-lib ? null
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "timerfunctions";
        ename = "timerfunctions";
        version = "1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/timerfunctions-1.4.2.el";
          sha256 = "122q8nv08pz1mkgilvi9qfrs7rsnc5picr7jyz2jpnvpd9qw6jw5";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/timerfunctions.html";
          license = lib.licenses.free;
        };
      }) {};
    tiny = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "tiny";
        ename = "tiny";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tiny-0.2.1.tar";
          sha256 = "1cr73a8gba549ja55x0c2s554f3zywf69zbnd7v82jz5q1k9wd2v";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tiny.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tramp";
        ename = "tramp";
        version = "2.5.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-2.5.2.2.tar";
          sha256 = "104nn6xdmcviqqv4cx5llhwj1sh4q04w3h9s8gimmi2kg0z8s36r";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp-nspawn = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tramp-nspawn";
        ename = "tramp-nspawn";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-nspawn-1.0.tar";
          sha256 = "1si649vcj4md50p5nzvw431580rcl113rraj6fw636a394485hvx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp-nspawn.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tramp-theme";
        ename = "tramp-theme";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-theme-0.2.el";
          sha256 = "1q1j0vcdyv5gnfbnfl08rnwd5j4ayc1gi1vpinr99ny70wsv7gbf";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    transcribe = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "transcribe";
        ename = "transcribe";
        version = "1.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/transcribe-1.5.2.el";
          sha256 = "08m1n6adab46bfywm47gygswf10vnxcfh16yjxglvcsg4prkn2vh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transcribe.html";
          license = lib.licenses.free;
        };
      }) {};
    transient = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "transient";
        ename = "transient";
        version = "0.3.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/transient-0.3.7.tar";
          sha256 = "0x4xjbaw98dma7232bzw53rbq9q70vms6lvvramng7vfaz0mcy2a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transient.html";
          license = lib.licenses.free;
        };
      }) {};
    trie = callPackage ({ elpaBuild, fetchurl, heap, lib, tNFA }:
      elpaBuild {
        pname = "trie";
        ename = "trie";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/trie-0.5.tar";
          sha256 = "1qbzxw7h3p3k3r3fzq66pj223vjiw20dvaljkb8w3r5q16fnav3p";
        };
        packageRequires = [ heap tNFA ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/trie.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-tree = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "undo-tree";
        ename = "undo-tree";
        version = "0.7.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/undo-tree-0.7.5.el";
          sha256 = "00admi87gqm0akhfqm4dcp9fw8ihpygy030955jswkha4zs7lw2p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/undo-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    uni-confusables = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "uni-confusables";
        ename = "uni-confusables";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/uni-confusables-0.3.tar";
          sha256 = "1grmppbyzvjjz0yiv5vvgpykhalisj9jnh6p9ip9vbnnll63iz4w";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uni-confusables.html";
          license = lib.licenses.free;
        };
      }) {};
    uniquify-files = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "uniquify-files";
        ename = "uniquify-files";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/uniquify-files-1.0.3.tar";
          sha256 = "1i7svplkw9wxiypw52chdry7f5gf992fb4yg8s7jy77v521fd2af";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uniquify-files.html";
          license = lib.licenses.free;
        };
      }) {};
    url-http-ntlm = callPackage ({ cl-lib ? null
                                 , elpaBuild
                                 , fetchurl
                                 , lib
                                 , ntlm ? null }:
      elpaBuild {
        pname = "url-http-ntlm";
        ename = "url-http-ntlm";
        version = "2.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/url-http-ntlm-2.0.4.el";
          sha256 = "1cakq2ykraci7d1gl8rnpv4f2f5ffyaidhqb1282g7i72adwmb98";
        };
        packageRequires = [ cl-lib ntlm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-http-ntlm.html";
          license = lib.licenses.free;
        };
      }) {};
    validate = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , seq }:
      elpaBuild {
        pname = "validate";
        ename = "validate";
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/validate-1.0.4.el";
          sha256 = "0vksssk98hcnz804g62k8kika13argf6p7bx8rf9hwidvzdsv6mi";
        };
        packageRequires = [ cl-lib emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/validate.html";
          license = lib.licenses.free;
        };
      }) {};
    valign = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "valign";
        ename = "valign";
        version = "3.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/valign-3.1.1.tar";
          sha256 = "1nla0zfj0rxwhdjgnsy2c34wzrxfxiwl89cjb6aicyvfxninz7j0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/valign.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-backup = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "vc-backup";
        ename = "vc-backup";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vc-backup-1.1.0.tar";
          sha256 = "1ipkymndxymbayrgr3jz27p64bkjf1nq9h4w3afpzkpqzw237ak5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-backup.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-got = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vc-got";
        ename = "vc-got";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vc-got-1.1.tar";
          sha256 = "1myck30ybq8ggf4yk3s2sqjqj8m1kfl8qxygkk3ynfa6jxxy4x1r";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-got.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-hgcmd = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vc-hgcmd";
        ename = "vc-hgcmd";
        version = "1.14.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vc-hgcmd-1.14.1.tar";
          sha256 = "12izw5ln22xdgwh6mqm6axzdfpcnqq7qcj72nmykrbsgpagp5fy6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-hgcmd.html";
          license = lib.licenses.free;
        };
      }) {};
    vcard = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vcard";
        ename = "vcard";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vcard-0.2.1.tar";
          sha256 = "0nfrh1mz2h7h259kf7sj13z30kmjywfvs83ax5qjkfwxhqm03abf";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vcard.html";
          license = lib.licenses.free;
        };
      }) {};
    vcl-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "vcl-mode";
        ename = "vcl-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vcl-mode-1.1.el";
          sha256 = "1r70pmvr95k5f2xphvhliqvyh7al0qabm7wvkamximcssvs38q1h";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vcl-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    vdiff = callPackage ({ elpaBuild, emacs, fetchurl, hydra, lib }:
      elpaBuild {
        pname = "vdiff";
        ename = "vdiff";
        version = "0.2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vdiff-0.2.4.tar";
          sha256 = "1mgzfrzp6nbb4xv2zjqk4za2dv3r5645jasiwf45wzqq5wbrgq2c";
        };
        packageRequires = [ emacs hydra ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vdiff.html";
          license = lib.licenses.free;
        };
      }) {};
    verilog-mode = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "verilog-mode";
        ename = "verilog-mode";
        version = "2021.10.14.127365406";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/verilog-mode-2021.10.14.127365406.tar";
          sha256 = "1v0ld310rs86vzmlw7phv1b5p59faqs9wg4p8jpbnb9ap9lwidnl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/verilog-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    vertico = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vertico";
        ename = "vertico";
        version = "0.20";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-0.20.tar";
          sha256 = "1hg91f74klbwisxzp74d020v42l28wik9y1lg3hrbdspnhlhsdrl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vertico.html";
          license = lib.licenses.free;
        };
      }) {};
    vertico-posframe = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib
                                    , posframe
                                    , vertico }:
      elpaBuild {
        pname = "vertico-posframe";
        ename = "vertico-posframe";
        version = "0.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-posframe-0.5.2.tar";
          sha256 = "0gzvm0la706kg3aqgrd6crz6353sp47dnpxdj9l2avb31avyqmv9";
        };
        packageRequires = [ emacs posframe vertico ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vertico-posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    vigenere = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vigenere";
        ename = "vigenere";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vigenere-1.0.el";
          sha256 = "1i5s6h1nngcp74gf53dw9pvj5y0ywk9j8pyvkfr7gqq49bz22hmm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vigenere.html";
          license = lib.licenses.free;
        };
      }) {};
    visual-filename-abbrev = callPackage ({ elpaBuild
                                          , emacs
                                          , fetchurl
                                          , lib }:
      elpaBuild {
        pname = "visual-filename-abbrev";
        ename = "visual-filename-abbrev";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/visual-filename-abbrev-1.1.tar";
          sha256 = "1l2wq7q28lcl78flxqvsxc9h96whpynqq8kpmbiy3nzlw2mrgr8g";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/visual-filename-abbrev.html";
          license = lib.licenses.free;
        };
      }) {};
    visual-fill = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "visual-fill";
        ename = "visual-fill";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/visual-fill-0.1.el";
          sha256 = "1y4xqcr1am74y9jy7kdkjigvx7h3208si5lm4p6a0kzxa3xizhvx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/visual-fill.html";
          license = lib.licenses.free;
        };
      }) {};
    vlf = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "vlf";
        ename = "vlf";
        version = "1.7.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vlf-1.7.2.tar";
          sha256 = "0hpri19z6b7dqmrj5ckp8sf0m0l72lkgahqzvfmwhgpgv2p81bny";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vlf.html";
          license = lib.licenses.free;
        };
      }) {};
    wcheck-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "wcheck-mode";
        ename = "wcheck-mode";
        version = "2021";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wcheck-mode-2021.tar";
          sha256 = "0qcj0af0570cssy9b7f74v9pv0pssm6ysnl1lyh8wwvl4yf0zx61";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wcheck-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    wconf = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "wconf";
        ename = "wconf";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wconf-0.2.1.el";
          sha256 = "13p1xycp3mcrg8jv65mcyqvln4h7awhjz35dzr5bi86zb824ryxf";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wconf.html";
          license = lib.licenses.free;
        };
      }) {};
    web-server = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "web-server";
        ename = "web-server";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/web-server-0.1.2.tar";
          sha256 = "10lcsl4dg2yr9zjd99gq9jz150wvvh6r5y9pd88l8y9vz16f2lim";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-server.html";
          license = lib.licenses.free;
        };
      }) {};
    webfeeder = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "webfeeder";
        ename = "webfeeder";
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/webfeeder-1.1.2.tar";
          sha256 = "1l128q424qsq9jv2wk8cv4zli71rk34q5kgwa9axdz0d27p9l6v4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/webfeeder.html";
          license = lib.licenses.free;
        };
      }) {};
    websocket = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "websocket";
        ename = "websocket";
        version = "1.13.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/websocket-1.13.1.tar";
          sha256 = "1x664zswas0fpml7zaj59zy97avrm49zb80zd69rlkqzz1m45psc";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/websocket.html";
          license = lib.licenses.free;
        };
      }) {};
    which-key = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "which-key";
        ename = "which-key";
        version = "3.6.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/which-key-3.6.0.tar";
          sha256 = "05wy147734mlpzwwxdhidnsplrz2vzs1whczzs4jw1i7kp7jvy3v";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/which-key.html";
          license = lib.licenses.free;
        };
      }) {};
    windower = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "windower";
        ename = "windower";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/windower-0.0.1.el";
          sha256 = "19xizbfbnzhhmhlqy20ir1a1y87bjwrq67bcawxy6nxpkwbizsv7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/windower.html";
          license = lib.licenses.free;
        };
      }) {};
    windresize = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "windresize";
        ename = "windresize";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/windresize-0.1.el";
          sha256 = "0b5bfs686nkp7s05zgfqvr1mpagmkd74j1grq8kp2w9arj0qfi3x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/windresize.html";
          license = lib.licenses.free;
        };
      }) {};
    wisi = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "wisi";
        ename = "wisi";
        version = "3.1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisi-3.1.7.tar";
          sha256 = "1xraks3n97axc978qlgcwr4f7ib3lyr4bvb5lq5z099hd2g01qch";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wisi.html";
          license = lib.licenses.free;
        };
      }) {};
    wisitoken-grammar-mode = callPackage ({ elpaBuild
                                          , emacs
                                          , fetchurl
                                          , lib
                                          , mmm-mode
                                          , wisi }:
      elpaBuild {
        pname = "wisitoken-grammar-mode";
        ename = "wisitoken-grammar-mode";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisitoken-grammar-mode-1.2.0.tar";
          sha256 = "0isxmpwys148djjymszdm5nisqjp9xff8kad45l4cpb3c717vsjw";
        };
        packageRequires = [ emacs mmm-mode wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wisitoken-grammar-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    wpuzzle = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "wpuzzle";
        ename = "wpuzzle";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wpuzzle-1.1.el";
          sha256 = "1wjg411dc0fvj2n8ak73igfrzc31nizzvvr2qa87fhq99bgh62kj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wpuzzle.html";
          license = lib.licenses.free;
        };
      }) {};
    xclip = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "xclip";
        ename = "xclip";
        version = "1.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xclip-1.11.tar";
          sha256 = "0hgblj8ng7vfsdb7g1mm9m2qhzfprycdd77836l59prpak5kp55q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xclip.html";
          license = lib.licenses.free;
        };
      }) {};
    xelb = callPackage ({ cl-generic, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xelb";
        ename = "xelb";
        version = "0.18";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xelb-0.18.tar";
          sha256 = "1fp5mzl63sh0h3ws4l5p4qgvi7ny8a3fj6k4dhqa98xgw2bx03v7";
        };
        packageRequires = [ cl-generic emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xelb.html";
          license = lib.licenses.free;
        };
      }) {};
    xpm = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, queue }:
      elpaBuild {
        pname = "xpm";
        ename = "xpm";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xpm-1.0.5.tar";
          sha256 = "13p6s6b2v7h4bnwdkkrd1qz84jd7g2s18w0czhpxv6hvj9sqf5hx";
        };
        packageRequires = [ cl-lib queue ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xpm.html";
          license = lib.licenses.free;
        };
      }) {};
    xr = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xr";
        ename = "xr";
        version = "1.22";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xr-1.22.tar";
          sha256 = "1l3bqgzvbamfs4n628kg789g7vjn4v81q570gzbw2cwjgk4s6xbj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xr.html";
          license = lib.licenses.free;
        };
      }) {};
    xref = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xref";
        ename = "xref";
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xref-1.4.0.tar";
          sha256 = "1ng03fyhpisa1v99sc96mpr7hna1pmg4gdc61p86r8lka9m5gqfx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "yasnippet";
        ename = "yasnippet";
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/yasnippet-0.14.0.tar";
          sha256 = "1lbil3dyz43nmr2lvx9vhpybqynpb7shg7m1xl1f7j4vm4dh0r08";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet-classic-snippets = callPackage ({ elpaBuild
                                              , fetchurl
                                              , lib
                                              , yasnippet }:
      elpaBuild {
        pname = "yasnippet-classic-snippets";
        ename = "yasnippet-classic-snippets";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/yasnippet-classic-snippets-1.0.2.tar";
          sha256 = "1kk1sf9kgj6qp3z2d9nbswigl444sqq11pdrhx0gny2jsgi3283l";
        };
        packageRequires = [ yasnippet ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet-classic-snippets.html";
          license = lib.licenses.free;
        };
      }) {};
    zones = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "zones";
        ename = "zones";
        version = "2019.7.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/zones-2019.7.13.el";
          sha256 = "0qp1ba2pkqx9d35g7z8hf8qs2k455krf2a92l4rka3ipsbnmq5k1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zones.html";
          license = lib.licenses.free;
        };
      }) {};
    ztree = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ztree";
        ename = "ztree";
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ztree-1.0.6.tar";
          sha256 = "1cyd31az566dmh3lyp7czw7kkkih7drr4c88b7da1xzbfkvibm2j";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ztree.html";
          license = lib.licenses.free;
        };
      }) {};
  }
