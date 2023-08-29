{ callPackage }:
  {
    ace-window = callPackage ({ avy
                              , elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "ace-window";
        ename = "ace-window";
        version = "0.10.0.0.20220911.35841";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ace-window-0.10.0.0.20220911.35841.tar";
          sha256 = "1q506qdi55rg2c9z3555klsqy5sxqpii11mx69l8x76a33a0j1f4";
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
        version = "1.11.0.20220924.84123";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ack-1.11.0.20220924.84123.tar";
          sha256 = "1npl618r6g25mzkibj0x4l31kqws73w9aid6ichm0ql9mi6pry5m";
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
                            , gnat-compiler
                            , lib
                            , uniquify-files
                            , wisi }:
      elpaBuild {
        pname = "ada-mode";
        ename = "ada-mode";
        version = "8.0.5.0.20230208.70712";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ada-mode-8.0.5.0.20230208.70712.tar";
          sha256 = "1957w6fynk345iwhgc4iq7zlda3fi211r7vi5420g761568wp4ca";
        };
        packageRequires = [ emacs gnat-compiler uniquify-files wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ada-ref-man = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "ada-ref-man";
        ename = "ada-ref-man";
        version = "2020.1.0.20201129.190419";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ada-ref-man-2020.1.0.20201129.190419.tar";
          sha256 = "0pvlfgq4b2a4d7452b3y0ns3saq8497fq9m62pi4ylqnqwjkfy61";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-ref-man.html";
          license = lib.licenses.free;
        };
      }) {};
    adaptive-wrap = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "adaptive-wrap";
        ename = "adaptive-wrap";
        version = "0.8.0.20210602.91446";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/adaptive-wrap-0.8.0.20210602.91446.tar";
          sha256 = "1fm3bx1qyv1ridj6inzr8qyw2fzj6fzcrzf57zs2lsfkvj7b5knd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adaptive-wrap.html";
          license = lib.licenses.free;
        };
      }) {};
    adjust-parens = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "adjust-parens";
        ename = "adjust-parens";
        version = "3.1.0.20221221.73810";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/adjust-parens-3.1.0.20221221.73810.tar";
          sha256 = "1p56b0pkyw6csl3wy1gi3ys2jzlm867bw3ca04ssm6l1lypirhg8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adjust-parens.html";
          license = lib.licenses.free;
        };
      }) {};
    advice-patch = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "advice-patch";
        ename = "advice-patch";
        version = "0.1.0.20201220.233221";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/advice-patch-0.1.0.20201220.233221.tar";
          sha256 = "09ivqir4b5rr1h7mc5g9czr5d9iig10zxvwjnnx12qzqaqwz2yvr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/advice-patch.html";
          license = lib.licenses.free;
        };
      }) {};
    aggressive-completion = callPackage ({ elpaBuild
                                         , emacs
                                         , fetchurl
                                         , lib }:
      elpaBuild {
        pname = "aggressive-completion";
        ename = "aggressive-completion";
        version = "1.7.0.20220417.71805";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/aggressive-completion-1.7.0.20220417.71805.tar";
          sha256 = "0kizmb64l0dbrgyj0wzbpdxpyr060myval62y5i88an74fvjli60";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aggressive-completion.html";
          license = lib.licenses.free;
        };
      }) {};
    aggressive-indent = callPackage ({ elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "aggressive-indent";
        ename = "aggressive-indent";
        version = "1.10.0.0.20230112.100030";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/aggressive-indent-1.10.0.0.20230112.100030.tar";
          sha256 = "0jjai48mf0j8b9dcxi9rlrpcpbz2cm2y6iqbi2f7q8012166hvgs";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aggressive-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    agitate = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "agitate";
        ename = "agitate";
        version = "0.0.20230101.152816";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/agitate-0.0.20230101.152816.tar";
          sha256 = "0a8xgi19b5zc585mmr23dfif2zfbwgdhybrvk5nkc8lc2ifmnf60";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/agitate.html";
          license = lib.licenses.free;
        };
      }) {};
    ahungry-theme = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "ahungry-theme";
        ename = "ahungry-theme";
        version = "1.10.0.0.20211231.115425";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ahungry-theme-1.10.0.0.20211231.115425.tar";
          sha256 = "0irq26pxgv31ak0wrwy1smhfazsc3nvn99ki3zq21h1d31i2xhcr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ahungry-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    aircon-theme = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "aircon-theme";
        ename = "aircon-theme";
        version = "0.0.6.0.20220827.93355";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/aircon-theme-0.0.6.0.20220827.93355.tar";
          sha256 = "0p2svw1db5km3ks2ywb38lsqh0y54ng8wgmh1s80mzvcflc8gia6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aircon-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    all = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "all";
        ename = "all";
        version = "1.0.0.20221221.74133";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/all-1.0.0.20221221.74133.tar";
          sha256 = "0mg5fhfw8n33whx6yg969jwcxlqjgmxvfrh00mq31hzwhppjy293";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/all.html";
          license = lib.licenses.free;
        };
      }) {};
    altcaps = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "altcaps";
        ename = "altcaps";
        version = "1.1.0.0.20230801.43558";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/altcaps-1.1.0.0.20230801.43558.tar";
          sha256 = "12z37dc7add0lq1fqzjx9ipmzgnpymn4pipk3q1x9sngrg06q8q0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/altcaps.html";
          license = lib.licenses.free;
        };
      }) {};
    ampc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ampc";
        ename = "ampc";
        version = "0.2.0.20221214.153219";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ampc-0.2.0.20221214.153219.tar";
          sha256 = "1smb3217kz0dj495d0hy6zkin30xaba4a574d74va3hv0n5485lb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ampc.html";
          license = lib.licenses.free;
        };
      }) {};
    arbitools = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "arbitools";
        ename = "arbitools";
        version = "0.977.0.20221212.221354";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/arbitools-0.977.0.20221212.221354.tar";
          sha256 = "1fxm44g6ymvzcz784v48c4114kf23h8qylc5fnirla9bk0lhwqpj";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/arbitools.html";
          license = lib.licenses.free;
        };
      }) {};
    ascii-art-to-unicode = callPackage ({ elpaBuild
                                        , fetchurl
                                        , lib }:
      elpaBuild {
        pname = "ascii-art-to-unicode";
        ename = "ascii-art-to-unicode";
        version = "1.13.0.20221221.74335";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ascii-art-to-unicode-1.13.0.20221221.74335.tar";
          sha256 = "0hqaw76say538jzbhizrdm57g0k42jhwirq11hbfc8iwckv26xjp";
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
        version = "1.9.7.0.20230802.104021";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/async-1.9.7.0.20230802.104021.tar";
          sha256 = "1w300q3fgnpibsbgkmxpicxv5ba8xj7cv9i28j7854b49d6xvjb6";
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
        version = "13.2.1.0.20230720.82135";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/auctex-13.2.1.0.20230720.82135.tar";
          sha256 = "0m973vyb37d57309f51rbds3lvf908484p71a4l216q63qzmidnj";
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
        version = "7.0.20221221.74552";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/aumix-mode-7.0.20221221.74552.tar";
          sha256 = "0ksihp1qa9n1290qpf7ahxxpbp4q9pwbpvk6ybgjcjdb4pjgfyms";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aumix-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-correct = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "auto-correct";
        ename = "auto-correct";
        version = "1.1.4.0.20221221.74656";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/auto-correct-1.1.4.0.20221221.74656.tar";
          sha256 = "0w9q0ibghmafbwla8wxnfki1fidb476cvsx37v3bs4pvq2kkcphk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-correct.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-header = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "auto-header";
        ename = "auto-header";
        version = "0.1.2.0.20230407.82136";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/auto-header-0.1.2.0.20230407.82136.tar";
          sha256 = "1h455ikypf1sd082r7i59yldm4p794a3w1ya7qfzcwvfhygdzdgz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-header.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-overlays = callPackage ({ cl-lib ? null
                                 , elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "auto-overlays";
        ename = "auto-overlays";
        version = "0.10.10.0.20201215.220815";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/auto-overlays-0.10.10.0.20201215.220815.tar";
          sha256 = "18lq41am7psh7kbf7yxk5qqhiddjzjqkb1pv0zn0vbps7pka68qh";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-overlays.html";
          license = lib.licenses.free;
        };
      }) {};
    autocrypt = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "autocrypt";
        ename = "autocrypt";
        version = "0.4.1.0.20230505.70117";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/autocrypt-0.4.1.0.20230505.70117.tar";
          sha256 = "1g83wm21a56w056bj97ciqalw464ra3bfhp1m66jiw7v06ppgi56";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/autocrypt.html";
          license = lib.licenses.free;
        };
      }) {};
    avy = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "avy";
        ename = "avy";
        version = "0.5.0.0.20230424.65712";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/avy-0.5.0.0.20230424.65712.tar";
          sha256 = "08kbfjwjbkbgbkkc51nmcbs9qq1hw8gv1z8h1knry8clvh23k735";
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
        version = "3.2.2.2.0.20220705.233849";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/bbdb-3.2.2.2.0.20220705.233849.tar";
          sha256 = "1041nqxs8sp34zvpahn6x603hx8i2zc65jp6ygd611z7rb2mwd5x";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bbdb.html";
          license = lib.licenses.free;
        };
      }) {};
    beacon = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "beacon";
        ename = "beacon";
        version = "1.3.4.0.20220729.220057";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/beacon-1.3.4.0.20220729.220057.tar";
          sha256 = "0wcc9hw6h1b3p1s506mc7zgjhhcb1bc4wq1bplax62lg2jyxiaks";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/beacon.html";
          license = lib.licenses.free;
        };
      }) {};
    beframe = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "beframe";
        ename = "beframe";
        version = "0.3.0.0.20230707.42330";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/beframe-0.3.0.0.20230707.42330.tar";
          sha256 = "12a7hhdjw9fy5mh3sj7jyb249vlmrl45r4wq4faap23mdnbygw49";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/beframe.html";
          license = lib.licenses.free;
        };
      }) {};
    bind-key = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "bind-key";
        ename = "bind-key";
        version = "2.4.1.0.20230804.31751";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/bind-key-2.4.1.0.20230804.31751.tar";
          sha256 = "1h02g1lcl27fsz1jvisdy4fjp4ddknr9d1qj633bkmg3nrr06mr2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bind-key.html";
          license = lib.licenses.free;
        };
      }) {};
    blist = callPackage ({ elpaBuild, emacs, fetchurl, ilist, lib }:
      elpaBuild {
        pname = "blist";
        ename = "blist";
        version = "0.2.0.20220913.173909";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/blist-0.2.0.20220913.173909.tar";
          sha256 = "0sjw36rlz714l3v8wlzk6hjsxvy082dl6wvszbxd60a6avysazip";
        };
        packageRequires = [ emacs ilist ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/blist.html";
          license = lib.licenses.free;
        };
      }) {};
    bluetooth = callPackage ({ dash
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "bluetooth";
        ename = "bluetooth";
        version = "0.3.1.0.20230119.122638";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/bluetooth-0.3.1.0.20230119.122638.tar";
          sha256 = "1wzv7wlpimqiagli02s87i75lj2xb33jld5w9xqnfnks2xvh7srl";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bluetooth.html";
          license = lib.licenses.free;
        };
      }) {};
    bnf-mode = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "bnf-mode";
        ename = "bnf-mode";
        version = "0.4.5.0.20221205.150230";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/bnf-mode-0.4.5.0.20221205.150230.tar";
          sha256 = "0rlg12z0dxy190c15p09inpnms374xxr5zv3h4gn9ilbb5g5r7d4";
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
        version = "1.1.3.0.20230408.95238";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/boxy-1.1.3.0.20230408.95238.tar";
          sha256 = "0hzfrbc20qn9ld51ivkvclphsvc2qqq4ir056d2d9bjxq56zndl6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy.html";
          license = lib.licenses.free;
        };
      }) {};
    boxy-headings = callPackage ({ boxy
                                 , elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib
                                 , org }:
      elpaBuild {
        pname = "boxy-headings";
        ename = "boxy-headings";
        version = "2.1.4.0.20221114.84552";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/boxy-headings-2.1.4.0.20221114.84552.tar";
          sha256 = "1ximn07ri3wga73alglzlfmqly52v2dbr3y1hp6syv5m3mxk248f";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy-headings.html";
          license = lib.licenses.free;
        };
      }) {};
    brief = callPackage ({ cl-lib ? null
                         , elpaBuild
                         , fetchurl
                         , lib
                         , nadvice }:
      elpaBuild {
        pname = "brief";
        ename = "brief";
        version = "5.88.22.2.0.20230818.125719";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/brief-5.88.22.2.0.20230818.125719.tar";
          sha256 = "1h9kqphbzmg0jwms8zd0ch0sgg8z1g847wcggr3842xhdayxds1k";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/brief.html";
          license = lib.licenses.free;
        };
      }) {};
    buffer-env = callPackage ({ compat
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "buffer-env";
        ename = "buffer-env";
        version = "0.4.0.20221130.201504";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/buffer-env-0.4.0.20221130.201504.tar";
          sha256 = "1kf3cns7jqwv2w8laq9avn908yswy32x7q8l7vbidf5qlkj1iy5h";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buffer-env.html";
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
        version = "0.4.3.0.20190429.135558";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/buffer-expose-0.4.3.0.20190429.135558.tar";
          sha256 = "0s11p8dlycv14j94599d33bkp3hhpvjq5a3jrmx9rynamhzvfig9";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buffer-expose.html";
          license = lib.licenses.free;
        };
      }) {};
    bug-hunter = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , fetchurl
                              , lib
                              , seq }:
      elpaBuild {
        pname = "bug-hunter";
        ename = "bug-hunter";
        version = "1.3.1.0.20201128.92354";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/bug-hunter-1.3.1.0.20201128.92354.tar";
          sha256 = "0gis7vrjrh0khjl71mb5vsbfhcwph0yv5c11wmwa3jc4n1wgxiq9";
        };
        packageRequires = [ cl-lib seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bug-hunter.html";
          license = lib.licenses.free;
        };
      }) {};
    buildbot = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "buildbot";
        ename = "buildbot";
        version = "0.0.1.0.20230726.134747";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/buildbot-0.0.1.0.20230726.134747.tar";
          sha256 = "1knkx80fcmxhi8y3ns3vb4zrg8s6la81gr3rbs1v3fss4h1snka1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buildbot.html";
          license = lib.licenses.free;
        };
      }) {};
    calibre = callPackage ({ compat
                           , elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "calibre";
        ename = "calibre";
        version = "1.3.3.0.20230520.233506";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/calibre-1.3.3.0.20230520.233506.tar";
          sha256 = "1r1vc446q1f90vzk74mdygnjfc9qrbc1fc6gwpq7kv8m56n96giw";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/calibre.html";
          license = lib.licenses.free;
        };
      }) {};
    cape = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "cape";
        ename = "cape";
        version = "0.17.0.20230820.160922";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cape-0.17.0.20230820.160922.tar";
          sha256 = "0frqpvjlbnyylfx5l881nwpf2x2r51d967xc7yvn7mda0n2w7030";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cape.html";
          license = lib.licenses.free;
        };
      }) {};
    capf-autosuggest = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "capf-autosuggest";
        ename = "capf-autosuggest";
        version = "0.3.0.20211123.104430";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/capf-autosuggest-0.3.0.20211123.104430.tar";
          sha256 = "17ih1lbsiydazwdn8caqnw8fm31yfyq8aqmcyv85y1w8zlnb6x4j";
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
        version = "1.0.0.20221221.74713";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/caps-lock-1.0.0.20221221.74713.tar";
          sha256 = "1wylgdwfm9pf0fpj53fprn7dknv3ldkf74xibgndh5i8xn11d036";
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
        version = "1.0.3.0.20221221.74732";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/captain-1.0.3.0.20221221.74732.tar";
          sha256 = "03zgffj8lbh4y6gg8dr40kxcm8pnllzfy3jbsapmw98ps9qnahi7";
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
        version = "2.0.5.0.20220926.150547";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/chess-2.0.5.0.20220926.150547.tar";
          sha256 = "0wdyq7a142r57f9qa77gcvdld9mlh3nqjm0jyz8z7xwjz1km395b";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/chess.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-generic = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "cl-generic";
        ename = "cl-generic";
        version = "0.3.0.20221221.74800";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cl-generic-0.3.0.20221221.74800.tar";
          sha256 = "12yqi7fc59rblh4asf94a4fj8qj873qs20bgjydp2djkrh4xas62";
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
        version = "0.7.1.0.20221221.74809";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cl-lib-0.7.1.0.20221221.74809.tar";
          sha256 = "18wfqbdibz62bisphcw91rpd3jacs7i24lib7l3wg9pf2563p98i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-lib.html";
          license = lib.licenses.free;
        };
      }) {};
    clipboard-collector = callPackage ({ elpaBuild
                                       , emacs
                                       , fetchurl
                                       , lib }:
      elpaBuild {
        pname = "clipboard-collector";
        ename = "clipboard-collector";
        version = "0.3.0.20190215.154741";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/clipboard-collector-0.3.0.20190215.154741.tar";
          sha256 = "1hjvwqi089r3wrs5771i1sjgmk63gk9m9a88gxnk99vzvh6r31dq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clipboard-collector.html";
          license = lib.licenses.free;
        };
      }) {};
    cobol-mode = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "cobol-mode";
        ename = "cobol-mode";
        version = "1.1.0.20221221.74904";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cobol-mode-1.1.0.20221221.74904.tar";
          sha256 = "1c3axx65bycr44hjy1cw4c9z89l3sqq16d2yk2animms3iwajvl0";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cobol-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    code-cells = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "code-cells";
        ename = "code-cells";
        version = "0.3.0.20220917.143159";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/code-cells-0.3.0.20220917.143159.tar";
          sha256 = "1amsw75dm7d1iz9cj6nl36acg0im4yjx7x8xrf9a5252jnzz5xsw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/code-cells.html";
          license = lib.licenses.free;
        };
      }) {};
    comint-mime = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "comint-mime";
        ename = "comint-mime";
        version = "0.3.0.20230528.142235";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/comint-mime-0.3.0.20230528.142235.tar";
          sha256 = "0b4mwcfrnydjlqvljw61q2lnc2967lxlfmfz1ypyimcv7ijc2h7d";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/comint-mime.html";
          license = lib.licenses.free;
        };
      }) {};
    compact-docstrings = callPackage ({ elpaBuild
                                      , fetchurl
                                      , lib }:
      elpaBuild {
        pname = "compact-docstrings";
        ename = "compact-docstrings";
        version = "0.2.0.20220305.183958";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/compact-docstrings-0.2.0.20220305.183958.tar";
          sha256 = "0xmhvfrla7la127hkj0jpam0laq495q4gfa3kbw4p3p3m070jxks";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/compact-docstrings.html";
          license = lib.licenses.free;
        };
      }) {};
    company = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "company";
        ename = "company";
        version = "0.9.13.0.20230805.204526";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/company-0.9.13.0.20230805.204526.tar";
          sha256 = "1z9kmx7r8wpy2vvzp6a12q48xcf43i0bqw56j2h0112h19m9zj8k";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company.html";
          license = lib.licenses.free;
        };
      }) {};
    company-ebdb = callPackage ({ company
                                , ebdb
                                , elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "company-ebdb";
        ename = "company-ebdb";
        version = "1.1.0.20221221.74915";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/company-ebdb-1.1.0.20221221.74915.tar";
          sha256 = "1nh7jwlwd8wji5s3ywzlwj7vyqjn6jllrywi6mjk9bwyg5yhyd8a";
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
        version = "1.5.1.0.20221227.132907";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/company-math-1.5.1.0.20221227.132907.tar";
          sha256 = "10jm0vb9z3pkh681vdd2ggi6pvhykghmalgib20pgcnm383kwpcn";
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
        version = "0.2.3.0.20170210.193350";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/company-statistics-0.2.3.0.20170210.193350.tar";
          sha256 = "140281sy7w5pj3dkidlgi130axrzwh0y8z3ivkpk55bypdaardlw";
        };
        packageRequires = [ company emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-statistics.html";
          license = lib.licenses.free;
        };
      }) {};
    compat = callPackage ({ elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , seq }:
      elpaBuild {
        pname = "compat";
        ename = "compat";
        version = "29.1.4.2.0.20230811.71752";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/compat-29.1.4.2.0.20230811.71752.tar";
          sha256 = "19m1cxjyz0gc1dkrdi2qvzglxmj2l4z8y6mxcqaikw40pfdng5ih";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/compat.html";
          license = lib.licenses.free;
        };
      }) {};
    consult = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "consult";
        ename = "consult";
        version = "0.35.0.20230825.84919";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/consult-0.35.0.20230825.84919.tar";
          sha256 = "1mlzmb1mfv5i1hyg5y9l7sxz9w1qsa6xx8xb1v6c4qscsl3nb4gh";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult.html";
          license = lib.licenses.free;
        };
      }) {};
    consult-recoll = callPackage ({ consult
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "consult-recoll";
        ename = "consult-recoll";
        version = "0.8.0.20221014.200255";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/consult-recoll-0.8.0.20221014.200255.tar";
          sha256 = "063l4p54bjmk9x9ajcjpb1qc1lz9w7jfcd5vz95jv17imwy0pzzg";
        };
        packageRequires = [ consult emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult-recoll.html";
          license = lib.licenses.free;
        };
      }) {};
    context-coloring = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "context-coloring";
        ename = "context-coloring";
        version = "8.1.0.0.20201127.182211";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/context-coloring-8.1.0.0.20201127.182211.tar";
          sha256 = "0mbj7awrnifn3jb0i9s25535h41pk45fz6n0m5p5nq3jjyhj6z62";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/context-coloring.html";
          license = lib.licenses.free;
        };
      }) {};
    corfu = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "corfu";
        ename = "corfu";
        version = "0.38.0.20230825.73620";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/corfu-0.38.0.20230825.73620.tar";
          sha256 = "0vn7fvsxqwpi7rqqj6a5w95g7wpyxsg43w16g7s9bhrnc1yz4sjh";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/corfu.html";
          license = lib.licenses.free;
        };
      }) {};
    coterm = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "coterm";
        ename = "coterm";
        version = "1.6.0.20221015.160420";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/coterm-1.6.0.20221015.160420.tar";
          sha256 = "0n5694klkdki9q363mknr4qwvr6q28lb6ss27v3pw0mzh91gavzp";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/coterm.html";
          license = lib.licenses.free;
        };
      }) {};
    counsel = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , ivy
                           , lib
                           , swiper }:
      elpaBuild {
        pname = "counsel";
        ename = "counsel";
        version = "0.14.0.0.20230619.162538";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/counsel-0.14.0.0.20230619.162538.tar";
          sha256 = "0lirnz10p9zyvdhwwqgvc7wasm31syifb2khxdwi4bqqgrmpqvix";
        };
        packageRequires = [ emacs ivy swiper ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/counsel.html";
          license = lib.licenses.free;
        };
      }) {};
    cpio-mode = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "cpio-mode";
        ename = "cpio-mode";
        version = "0.17.0.20211211.193556";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cpio-mode-0.17.0.20211211.193556.tar";
          sha256 = "064yc4hs6ci80a231mlv3688ys9p8z5aabfg2s2ya1kkmpwra4f2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cpio-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    cpupower = callPackage ({ elpaBuild
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "cpupower";
        ename = "cpupower";
        version = "1.0.5.0.20230704.131557";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cpupower-1.0.5.0.20230704.131557.tar";
          sha256 = "03c5lbm9vmgx5m5pmi4a12npmf1v6g7kiryfxx6j2zy1ix9nk4jl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cpupower.html";
          license = lib.licenses.free;
        };
      }) {};
    crdt = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "crdt";
        ename = "crdt";
        version = "0.3.5.0.20230213.22302";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/crdt-0.3.5.0.20230213.22302.tar";
          sha256 = "1hpkxpr88g4lpq7kxb15xhm3gpks5rz4vfdkkrkflh1wm3bpf4ah";
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
        version = "1.3.6.0.20221221.74923";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/crisp-1.3.6.0.20221221.74923.tar";
          sha256 = "1jjl6hv0qib5519p5xigbiydz2f2h0fy773abnga7lvzx57rgppi";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crisp.html";
          license = lib.licenses.free;
        };
      }) {};
    csharp-mode = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "csharp-mode";
        ename = "csharp-mode";
        version = "2.0.0.0.20221205.181941";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/csharp-mode-2.0.0.0.20221205.181941.tar";
          sha256 = "0fl1v45apz448pqnz0psi6w4inakdxv54wydc99sjq8l3lm8ldrm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/csharp-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    csv-mode = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "csv-mode";
        ename = "csv-mode";
        version = "1.22.0.20230208.161318";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/csv-mode-1.22.0.20230208.161318.tar";
          sha256 = "0jzna3i4dbz4lvpnvjm7lsggk71wiq0bdcgq4h2rcs6lqsr559dp";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/csv-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    cursory = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "cursory";
        ename = "cursory";
        version = "1.0.1.0.20230802.44321";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cursory-1.0.1.0.20230802.44321.tar";
          sha256 = "0ih37zhvr5p4q7ijix3fyi5vv26w0gc7vk53ns3n9yv4dnbprxdk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cursory.html";
          license = lib.licenses.free;
        };
      }) {};
    cycle-quotes = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "cycle-quotes";
        ename = "cycle-quotes";
        version = "0.1.0.20221221.75021";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/cycle-quotes-0.1.0.20221221.75021.tar";
          sha256 = "07gp0bbwajm44n24wywj7la1jdy9hrid6j9cj0cxhv3gdg3681z2";
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
        version = "0.3.0.20200507.173652";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/darkroom-0.3.0.20200507.173652.tar";
          sha256 = "1njijhakvxqh6ik3krrz3zz97asfxmaxs7dz3wsnkmmcy9x0bbjb";
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
        version = "2.19.1.0.20230801.124436";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dash-2.19.1.0.20230801.124436.tar";
          sha256 = "009067xiyvh647plqbp7rbsj071rar8609px3byh93649x1k0f2v";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dash.html";
          license = lib.licenses.free;
        };
      }) {};
    dbus-codegen = callPackage ({ cl-lib ? null
                                , elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "dbus-codegen";
        ename = "dbus-codegen";
        version = "0.1.0.20220306.62546";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dbus-codegen-0.1.0.20220306.62546.tar";
          sha256 = "0s2ax0vqbh69dan5vdgy2dc2qfsfbxk4cqnxwysbhhpc7qqd7ljq";
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
        version = "0.36.0.20230619.72121";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/debbugs-0.36.0.20230619.72121.tar";
          sha256 = "1abg80d397ndb7sds8p8d3z9zw2v5m4a87l9jqmi7b6pp07z7ah7";
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
        version = "1.7.0.20200711.42851";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/delight-1.7.0.20200711.42851.tar";
          sha256 = "1s22gr05yqirb4dddafw96kq4ifccncypvr09rxmhdf7iv4096dm";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/delight.html";
          license = lib.licenses.free;
        };
      }) {};
    denote = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "denote";
        ename = "denote";
        version = "2.0.0.0.20230825.44438";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/denote-2.0.0.0.20230825.44438.tar";
          sha256 = "1cb6wj5a8nwzlld4vyb3hypn8jyzym5rmzda38m87m92nlbb76gb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/denote.html";
          license = lib.licenses.free;
        };
      }) {};
    denote-menu = callPackage ({ denote
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "denote-menu";
        ename = "denote-menu";
        version = "1.1.1.0.20230818.141035";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/denote-menu-1.1.1.0.20230818.141035.tar";
          sha256 = "0c9xa089ayy4nmgl0ab8prmpl6gr6p5f3vdpbqy25zlnglykpjyf";
        };
        packageRequires = [ denote emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/denote-menu.html";
          license = lib.licenses.free;
        };
      }) {};
    detached = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "detached";
        ename = "detached";
        version = "0.10.1.0.20221129.143049";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/detached-0.10.1.0.20221129.143049.tar";
          sha256 = "0b6b3q5z983744s5k9k771d0hnnbnrx249cqw4nkgplb2zay9zii";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/detached.html";
          license = lib.licenses.free;
        };
      }) {};
    devdocs = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "devdocs";
        ename = "devdocs";
        version = "0.5.0.20230220.204256";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/devdocs-0.5.0.20230220.204256.tar";
          sha256 = "19vjsvyikyli7f367gh6razvdwgsdvjxy6sfywk272q11wy1imcy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devdocs.html";
          license = lib.licenses.free;
        };
      }) {};
    dict-tree = callPackage ({ elpaBuild
                             , fetchurl
                             , heap
                             , lib
                             , tNFA
                             , trie }:
      elpaBuild {
        pname = "dict-tree";
        ename = "dict-tree";
        version = "0.16.0.20201214.122037";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dict-tree-0.16.0.20201214.122037.tar";
          sha256 = "0ax5xzmaf4zsbg95hf3d4khq1yf1zafc48vrpgfwgm2735mxsins";
        };
        packageRequires = [ heap tNFA trie ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dict-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    diff-hl = callPackage ({ cl-lib ? null
                           , elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "diff-hl";
        ename = "diff-hl";
        version = "1.9.2.0.20230807.151654";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/diff-hl-1.9.2.0.20230807.151654.tar";
          sha256 = "0zzggv9h2943vm3xk1622fgksmczckmckxckgkh58l4wl9zdqm19";
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
        version = "1.0.0.20230224.111651";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/diffview-1.0.0.20230224.111651.tar";
          sha256 = "030lkz0y188frlr8525ka4q26pbrj1rd1i5mn3152wnac3xmzj3q";
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
        version = "0.46.0.20220909.84745";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/diminish-0.46.0.20220909.84745.tar";
          sha256 = "05yv0gvqcha0404spd200rgfw08zww9r5h2rbmykhq7c7chml542";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diminish.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-du = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "dired-du";
        ename = "dired-du";
        version = "0.5.2.0.20221221.75108";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dired-du-0.5.2.0.20221221.75108.tar";
          sha256 = "0hbb6f2ycnn8s5b5wk3zqfwmz56ijgiyggr2rjj3pqvg3hhrdkcx";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-du.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-git-info = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "dired-git-info";
        ename = "dired-git-info";
        version = "0.3.1.0.20191229.192948";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dired-git-info-0.3.1.0.20191229.192948.tar";
          sha256 = "1gkvn9g3nn113qa0fdq3h88fbmjy9498y9zcd5jfyz4kx0iid016";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-git-info.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-preview = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "dired-preview";
        ename = "dired-preview";
        version = "0.1.1.0.20230713.184118";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dired-preview-0.1.1.0.20230713.184118.tar";
          sha256 = "1vrm6k9sdbgsjbx6s0yz250n08sp6pg5rwgly2y0zwxdxmhkx7br";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-preview.html";
          license = lib.licenses.free;
        };
      }) {};
    disk-usage = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "disk-usage";
        ename = "disk-usage";
        version = "1.3.3.0.20220920.80620";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/disk-usage-1.3.3.0.20220920.80620.tar";
          sha256 = "0sf43dx83pa6zk0xv9v7g41xi3jqx5kw7xbdmlabg7xckkzlwk16";
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
        version = "1.5.2.0.20221221.75154";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dismal-1.5.2.0.20221221.75154.tar";
          sha256 = "011lvc7sxy8waqyirgsbf7p0y1n16zc5srlx0yk22x7q7i28svrp";
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
        version = "1.1.2.0.20221221.75224";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/djvu-1.1.2.0.20221221.75224.tar";
          sha256 = "08q6sryvpgl0nx17r3rr2sramgzxgwx9qlwripy1iqcydyz844d1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/djvu.html";
          license = lib.licenses.free;
        };
      }) {};
    doc-toc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "doc-toc";
        ename = "doc-toc";
        version = "1.2.0.20230409.212954";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/doc-toc-1.2.0.20230409.212954.tar";
          sha256 = "1y5i6669416llpkpnqnhkckvbwy493gfbcjlq1hh1mwy508bq2va";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/doc-toc.html";
          license = lib.licenses.free;
        };
      }) {};
    docbook = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "docbook";
        ename = "docbook";
        version = "0.1.0.20221221.75233";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/docbook-0.1.0.20221221.75233.tar";
          sha256 = "0zp2hhgxi4ab6ijxfinjay34jjbwn36iy1laaxp65cb7dy6k2aas";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/docbook.html";
          license = lib.licenses.free;
        };
      }) {};
    dts-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dts-mode";
        ename = "dts-mode";
        version = "1.0.0.20221221.75311";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/dts-mode-1.0.0.20221221.75311.tar";
          sha256 = "0jmvg2gi43iaqq82s1ahzymday7i9gihhv9affjxcs97ydzwzaj2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    easy-escape = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "easy-escape";
        ename = "easy-escape";
        version = "0.2.1.0.20210917.85414";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/easy-escape-0.2.1.0.20210917.85414.tar";
          sha256 = "08npj12pd9jjmwvzadxxs6ldkyqm40355by1q9xq0wdmnh60lcpg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/easy-escape.html";
          license = lib.licenses.free;
        };
      }) {};
    easy-kill = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "easy-kill";
        ename = "easy-kill";
        version = "0.9.5.0.20220511.55730";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/easy-kill-0.9.5.0.20220511.55730.tar";
          sha256 = "0lwj2x09a8rmanymk25cgx4wlqlnq9zxwzymc9bsv9pxg0svcira";
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
        version = "0.8.17.0.20230720.84151";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ebdb-0.8.17.0.20230720.84151.tar";
          sha256 = "1nd0jd4y8zg5i4ng7k40h6j00hr416i07cmnqqpxvh6h3kycahsw";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb-gnorb = callPackage ({ ebdb
                              , elpaBuild
                              , fetchurl
                              , gnorb
                              , lib }:
      elpaBuild {
        pname = "ebdb-gnorb";
        ename = "ebdb-gnorb";
        version = "1.0.2.0.20221221.75324";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ebdb-gnorb-1.0.2.0.20221221.75324.tar";
          sha256 = "1g71ycs0z0ac2011wazfm2caqh5gly82dxj88kcwh4pbcx4p6ywn";
        };
        packageRequires = [ ebdb gnorb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb-gnorb.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb-i18n-chn = callPackage ({ ebdb
                                 , elpaBuild
                                 , fetchurl
                                 , lib
                                 , pyim }:
      elpaBuild {
        pname = "ebdb-i18n-chn";
        ename = "ebdb-i18n-chn";
        version = "1.3.2.0.20221221.75334";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ebdb-i18n-chn-1.3.2.0.20221221.75334.tar";
          sha256 = "087fc78fczrmv73nigvxy25x8k69l57v67big5p8kaddp2z756l8";
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
        version = "2.2.0.20221026.91800";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ediprolog-2.2.0.20221026.91800.tar";
          sha256 = "0hgqwscykw0030w9vlkrxvid2li93v5z6js829nfmssmqvzibic2";
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
        version = "20230127.0.20230521.54745";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/eev-20230127.0.20230521.54745.tar";
          sha256 = "09s6r6xjyfhdiy7j3wnw53gyjbjr8347ikzhi6xxzkna3r5fc1mx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eev.html";
          license = lib.licenses.free;
        };
      }) {};
    ef-themes = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "ef-themes";
        ename = "ef-themes";
        version = "1.3.0.0.20230825.34525";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ef-themes-1.3.0.0.20230825.34525.tar";
          sha256 = "0qqmghz3jsyyqf5gs8pas5d7my6pfdqycfzfslw5cmfyljmwaz28";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ef-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    eglot = callPackage ({ eldoc
                         , elpaBuild
                         , emacs
                         , external-completion
                         , fetchurl
                         , flymake ? null
                         , jsonrpc
                         , lib
                         , project
                         , seq
                         , xref }:
      elpaBuild {
        pname = "eglot";
        ename = "eglot";
        version = "1.15.0.20230819.140915";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/eglot-1.15.0.20230819.140915.tar";
          sha256 = "06k80zw2wkh7rphkcgsfqzrhns8bk9bslxdylg1y5v8nsa81navq";
        };
        packageRequires = [
          eldoc
          emacs
          external-completion
          flymake
          jsonrpc
          project
          seq
          xref
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eglot.html";
          license = lib.licenses.free;
        };
      }) {};
    el-search = callPackage ({ cl-print ? null
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , stream }:
      elpaBuild {
        pname = "el-search";
        ename = "el-search";
        version = "1.12.6.1.0.20221221.75346";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/el-search-1.12.6.1.0.20221221.75346.tar";
          sha256 = "08r2hw47ijwb7y1amhn49r9l9kh2kv0y631rg4f8xjqfd38msh45";
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
        version = "1.14.0.0.20230602.82442";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/eldoc-1.14.0.0.20230602.82442.tar";
          sha256 = "1wz7m96i4kdhijfcgim58w23znq1r5g9q0l0ivyjik550lmr69c7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc.html";
          license = lib.licenses.free;
        };
      }) {};
    eldoc-eval = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "eldoc-eval";
        ename = "eldoc-eval";
        version = "0.2.0.20220106.195151";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/eldoc-eval-0.2.0.20220106.195151.tar";
          sha256 = "0lidijrg9ylwl80dljhkhsqdmrspfz5n3wdvrnibzvhlqyan7vd1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc-eval.html";
          license = lib.licenses.free;
        };
      }) {};
    electric-spacing = callPackage ({ elpaBuild
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "electric-spacing";
        ename = "electric-spacing";
        version = "5.0.0.20201201.154407";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/electric-spacing-5.0.0.20201201.154407.tar";
          sha256 = "1iaw30bxjzxkvnqvcw10vxyjfbxabr0cb04kmwy0ibzh8dim25i0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/electric-spacing.html";
          license = lib.licenses.free;
        };
      }) {};
    elisp-benchmarks = callPackage ({ elpaBuild
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "elisp-benchmarks";
        ename = "elisp-benchmarks";
        version = "1.14.0.20221221.75401";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/elisp-benchmarks-1.14.0.20221221.75401.tar";
          sha256 = "14gvzrcp32yg594g7pzxp7kic2zyrfqwn6a8ansil9adqsz8yarx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elisp-benchmarks.html";
          license = lib.licenses.free;
        };
      }) {};
    emacs-gc-stats = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "emacs-gc-stats";
        ename = "emacs-gc-stats";
        version = "1.4.1.0.20230721.81431";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/emacs-gc-stats-1.4.1.0.20230721.81431.tar";
          sha256 = "044q2xviir38m467fs22mfx5p0s42dp7758fikwfqawqcsggr7hp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/emacs-gc-stats.html";
          license = lib.licenses.free;
        };
      }) {};
    embark = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "embark";
        ename = "embark";
        version = "0.22.1.0.20230824.80305";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/embark-0.22.1.0.20230824.80305.tar";
          sha256 = "1mdl8nczdhswr4i6mx0vay35b474kcvfbanzxqiy5d7jkjnlqki3";
        };
        packageRequires = [ compat emacs ];
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
        version = "0.7.0.20230824.80305";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/embark-consult-0.7.0.20230824.80305.tar";
          sha256 = "01nck4h8n54zy5hfir3fqhyggd6fyrif55fnlqf0xmhd19qrvy3b";
        };
        packageRequires = [ consult emacs embark ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/embark-consult.html";
          license = lib.licenses.free;
        };
      }) {};
    ement = callPackage ({ elpaBuild
                         , emacs
                         , fetchurl
                         , lib
                         , map
                         , persist
                         , plz
                         , svg-lib
                         , taxy
                         , taxy-magit-section
                         , transient }:
      elpaBuild {
        pname = "ement";
        ename = "ement";
        version = "0.12pre0.20230824.161156";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ement-0.12pre0.20230824.161156.tar";
          sha256 = "0ny9ihcdwf9g7l4b4mjx6qb14mxfsyzw6a6lasx59hgzr71fldd1";
        };
        packageRequires = [
          emacs
          map
          persist
          plz
          svg-lib
          taxy
          taxy-magit-section
          transient
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ement.html";
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
        version = "16.0.20230818.103820";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/emms-16.0.20230818.103820.tar";
          sha256 = "0p6dhvh5790q5qfyb3wm0jbbxhr3zkycnk64p6lx7r9jz03h5qxb";
        };
        packageRequires = [ cl-lib nadvice seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/emms.html";
          license = lib.licenses.free;
        };
      }) {};
    engrave-faces = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "engrave-faces";
        ename = "engrave-faces";
        version = "0.3.1.0.20230115.70118";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/engrave-faces-0.3.1.0.20230115.70118.tar";
          sha256 = "19cg0ksh1v3yhvknpf18q21y0wbhf55ll8p67vvlqaaikwlmbpxz";
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
        version = "2.0.0.20171007.121321";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/enwc-2.0.0.20171007.121321.tar";
          sha256 = "13lj4br2r845zwg491y9f2m5zxi2gj4qkihwcsrnc1ybf3zdlpfy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/enwc.html";
          license = lib.licenses.free;
        };
      }) {};
    epoch-view = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "epoch-view";
        ename = "epoch-view";
        version = "0.0.1.0.20221221.75416";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/epoch-view-0.0.1.0.20221221.75416.tar";
          sha256 = "0lhs1i02rl8mb7m56bsmv942pq7dgdp5qjp1zs7flv0zgyi8ip5c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/epoch-view.html";
          license = lib.licenses.free;
        };
      }) {};
    erc = callPackage ({ compat
                       , elpaBuild
                       , emacs
                       , fetchurl
                       , lib }:
      elpaBuild {
        pname = "erc";
        ename = "erc";
        version = "5.6snapshot0.20230722.73307";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/erc-5.6snapshot0.20230722.73307.tar";
          sha256 = "0r0w4275ssbmb40jnnyxdyykb38xl3lkrj9swfc60j22lzcwk2df";
        };
        packageRequires = [ compat emacs ];
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
                                  , nadvice }:
      elpaBuild {
        pname = "ergoemacs-mode";
        ename = "ergoemacs-mode";
        version = "5.16.10.12.0.20230207.95118";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ergoemacs-mode-5.16.10.12.0.20230207.95118.tar";
          sha256 = "1gf8mn2g453kwgibpawj6gjmd707p33lfkx6dq9wba66zh4cgp4a";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ergoemacs-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ess = callPackage ({ elpaBuild
                       , emacs
                       , fetchurl
                       , lib }:
      elpaBuild {
        pname = "ess";
        ename = "ess";
        version = "18.10.3snapshot0.20230807.142202";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ess-18.10.3snapshot0.20230807.142202.tar";
          sha256 = "0fcshc4smb3dj47rbnz21zdwxikhj1al3nism17sxchmfxx3x2sb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ess.html";
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
                               , url-http-ntlm
                               , url-http-oauth }:
      elpaBuild {
        pname = "excorporate";
        ename = "excorporate";
        version = "1.1.1.0.20230529.173200";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/excorporate-1.1.1.0.20230529.173200.tar";
          sha256 = "1485cy2a8vzws2k796cj8a6dydjf8dagyid1ns04krzafvkfdnh4";
        };
        packageRequires = [
          cl-lib
          emacs
          fsm
          nadvice
          soap-client
          url-http-ntlm
          url-http-oauth
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/excorporate.html";
          license = lib.licenses.free;
        };
      }) {};
    expand-region = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "expand-region";
        ename = "expand-region";
        version = "0.11.0.0.20200225.132539";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/expand-region-0.11.0.0.20200225.132539.tar";
          sha256 = "1fvjm2741q51zrd6i6smsg8l5vz1z2xiwwq2bhaq9dc1b8avpd2z";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/expand-region.html";
          license = lib.licenses.free;
        };
      }) {};
    expreg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "expreg";
        ename = "expreg";
        version = "1.0.0.0.20230821.183608";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/expreg-1.0.0.0.20230821.183608.tar";
          sha256 = "0jsdnwy30s89xc9hwldfbd1713aa06ih7x5y91dnf2w9zbmy9bgz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/expreg.html";
          license = lib.licenses.free;
        };
      }) {};
    external-completion = callPackage ({ elpaBuild
                                       , fetchurl
                                       , lib }:
      elpaBuild {
        pname = "external-completion";
        ename = "external-completion";
        version = "0.1.0.20230101.53112";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/external-completion-0.1.0.20230101.53112.tar";
          sha256 = "042mjdaia5c267qlpc1s3cy3qhxdsa4hygqjbfir5z1mrks28z1v";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/external-completion.html";
          license = lib.licenses.free;
        };
      }) {};
    exwm = callPackage ({ elpaBuild, fetchurl, lib, xelb }:
      elpaBuild {
        pname = "exwm";
        ename = "exwm";
        version = "0.27.0.20230609.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/exwm-0.27.0.20230609.0.tar";
          sha256 = "0igqkdx2lwmwx9llidhk716lv9v5k1sd4r3j15c3qzaq5fzzqv2w";
        };
        packageRequires = [ xelb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/exwm.html";
          license = lib.licenses.free;
        };
      }) {};
    f90-interface-browser = callPackage ({ cl-lib ? null
                                         , elpaBuild
                                         , fetchurl
                                         , lib }:
      elpaBuild {
        pname = "f90-interface-browser";
        ename = "f90-interface-browser";
        version = "1.1.0.20221221.75553";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/f90-interface-browser-1.1.0.20221221.75553.tar";
          sha256 = "1xbrm524dadmww961m4n2dqi1gplbflfldxwc6cs0cas2cf4ydal";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/f90-interface-browser.html";
          license = lib.licenses.free;
        };
      }) {};
    face-shift = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "face-shift";
        ename = "face-shift";
        version = "0.2.1.0.20230426.73945";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/face-shift-0.2.1.0.20230426.73945.tar";
          sha256 = "0h33w6n1sj0g4ji8ckdd9pgxq3gj4kn0mqlazrs82sf32hsjfi5w";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/face-shift.html";
          license = lib.licenses.free;
        };
      }) {};
    filladapt = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "filladapt";
        ename = "filladapt";
        version = "2.12.2.0.20221221.75607";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/filladapt-2.12.2.0.20221221.75607.tar";
          sha256 = "0izqqh2dlp9p6kbkmn5qp9lbqdf8ps3f38lclc9fm2652mssvddv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/filladapt.html";
          license = lib.licenses.free;
        };
      }) {};
    firefox-javascript-repl = callPackage ({ elpaBuild
                                           , emacs
                                           , fetchurl
                                           , lib }:
      elpaBuild {
        pname = "firefox-javascript-repl";
        ename = "firefox-javascript-repl";
        version = "0.9.5.0.20230605.161924";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/firefox-javascript-repl-0.9.5.0.20230605.161924.tar";
          sha256 = "1fwi01mqyz0mvy27rxz4k97mww02gv6njhb4p7wxj1wrx1xsmm1z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/firefox-javascript-repl.html";
          license = lib.licenses.free;
        };
      }) {};
    flylisp = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flylisp";
        ename = "flylisp";
        version = "0.2.0.20221221.75619";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/flylisp-0.2.0.20221221.75619.tar";
          sha256 = "0b48wd2isf5nqfgscpd311hwisp9gs77lsinpdrs40swvwnflyfb";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flylisp.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake = callPackage ({ eldoc
                           , elpaBuild
                           , emacs
                           , fetchurl
                           , lib
                           , project }:
      elpaBuild {
        pname = "flymake";
        ename = "flymake";
        version = "1.3.4.0.20230713.135815";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/flymake-1.3.4.0.20230713.135815.tar";
          sha256 = "1fdlmb6pyp6j03gh10zzml4ljgr6zvdvyfshnvbvvcw2zrp028lh";
        };
        packageRequires = [ eldoc emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-proselint = callPackage ({ elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "flymake-proselint";
        ename = "flymake-proselint";
        version = "0.3.0.0.20230325.160756";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/flymake-proselint-0.3.0.0.20230325.160756.tar";
          sha256 = "09r9karqm7f8s8wmbfai8nrawpxcn5f7lwpfp5vz1j7w068zn3mi";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-proselint.html";
          license = lib.licenses.free;
        };
      }) {};
    fontaine = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "fontaine";
        ename = "fontaine";
        version = "1.0.0.0.20230523.95022";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/fontaine-1.0.0.0.20230523.95022.tar";
          sha256 = "0s8fbjvkcz0627fdpf28myjhzw6bwlclwf4v9shld9vhsg7brhxk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/fontaine.html";
          license = lib.licenses.free;
        };
      }) {};
    frame-tabs = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "frame-tabs";
        ename = "frame-tabs";
        version = "1.1.0.20221221.75627";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/frame-tabs-1.1.0.20221221.75627.tar";
          sha256 = "0c9sbfqnl2vmrw9ziaybd7dmzw23a9p5b8nl1g5w4kkwwh7kwl35";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/frame-tabs.html";
          license = lib.licenses.free;
        };
      }) {};
    frog-menu = callPackage ({ avy
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , posframe }:
      elpaBuild {
        pname = "frog-menu";
        ename = "frog-menu";
        version = "0.2.11.0.20201115.95734";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/frog-menu-0.2.11.0.20201115.95734.tar";
          sha256 = "1rvvkzd639x8rddkbcxwqi6f29y4zybiryvp1is9f68jj6dn3y98";
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
        version = "0.2.1.0.20221212.223608";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/fsm-0.2.1.0.20221212.223608.tar";
          sha256 = "1q7i32b3kx1cp1yag2mijab36b289hpv1vx7fby8n35agbnqabh8";
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
        version = "1.1.0.20230102.145125";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ftable-1.1.0.20230102.145125.tar";
          sha256 = "0bhzxrhl87fyv9ynlxp0c3nschpbamkkxzh5gzakdigbm79602ir";
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
        version = "0.2.1.0.20201116.225142";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gcmh-0.2.1.0.20201116.225142.tar";
          sha256 = "1xfpms62svxmvhpdprhb68bsa27m8m8z8wmq3sn42rjf8fi9hrqf";
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
        version = "0.9.0.0.20230602.13355";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ggtags-0.9.0.0.20230602.13355.tar";
          sha256 = "1d8d4shaf3rkan48vpqjc32qms6n90f912wdxsy7nz9fqadv31cz";
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
        version = "0.6.0.0.20221221.75709";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gited-0.6.0.0.20221221.75709.tar";
          sha256 = "1pl8chdmnpfby8ap3lirjc837nns5bdgsqms4v86g3acgyz1zd8d";
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
        version = "1.1.0.20221221.75729";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gle-mode-1.1.0.20221221.75729.tar";
          sha256 = "1icjvfrh7j1jp31fhgazai9xdm1s2wk0b3zs3n44km9v2gfy4gcc";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gle-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gnat-compiler = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib
                                 , wisi }:
      elpaBuild {
        pname = "gnat-compiler";
        ename = "gnat-compiler";
        version = "1.0.2.0.20230124.51334";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnat-compiler-1.0.2.0.20230124.51334.tar";
          sha256 = "0kqzqw2dbsmcmrqkb5rsjmkpznfj1licnbfjbp1ifs0kaf2cigqy";
        };
        packageRequires = [ emacs wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnat-compiler.html";
          license = lib.licenses.free;
        };
      }) {};
    gnome-c-style = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "gnome-c-style";
        ename = "gnome-c-style";
        version = "0.1.0.20160130.1526";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnome-c-style-0.1.0.20160130.1526.tar";
          sha256 = "0jj6xxn35iijzxipqna3kpks6ffg7gpp566riy7icifcq1pxkws1";
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
        version = "1.6.11.0.20230108.110132";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnorb-1.6.11.0.20230108.110132.tar";
          sha256 = "0w14v19idq2njgb80ry0qa7dv9hhj5lg488acxx0pz5cxk606rgh";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnorb.html";
          license = lib.licenses.free;
        };
      }) {};
    gnu-elpa = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gnu-elpa";
        ename = "gnu-elpa";
        version = "1.1.0.20221212.224322";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnu-elpa-1.1.0.20221212.224322.tar";
          sha256 = "1aglbzgvprqws45xybs7cfajgkgbcl8pk61nqdja7qhgr7a68ymx";
        };
        packageRequires = [ emacs ];
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
        version = "2022.12.0.20221228.123117";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnu-elpa-keyring-update-2022.12.0.20221228.123117.tar";
          sha256 = "1aa9lwjd4cll6qm5909dg2dgx34sai3w3jg76xjlax3afg4vak2v";
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
        version = "3.1.2.0.20221212.224439";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnugo-3.1.2.0.20221212.224439.tar";
          sha256 = "1hkwbpy9nar0wxnvbcycjbn3k1ga9kg6jk8f4nfhvm0rxdvp53ig";
        };
        packageRequires = [ ascii-art-to-unicode cl-lib xpm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnugo.html";
          license = lib.licenses.free;
        };
      }) {};
    gnus-mock = callPackage ({ elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "gnus-mock";
        ename = "gnus-mock";
        version = "0.5.0.20210503.105756";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gnus-mock-0.5.0.20210503.105756.tar";
          sha256 = "1p4znd3hzzlxwzxja764vfdy4vb6lf39m6hhvm8knqikq823y26d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnus-mock.html";
          license = lib.licenses.free;
        };
      }) {};
    gpastel = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "gpastel";
        ename = "gpastel";
        version = "0.5.0.0.20181231.183754";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gpastel-0.5.0.0.20181231.183754.tar";
          sha256 = "19byv5l09h8zdsgpifsc0j7np0iq1md4l0y7865g95xbax60i9id";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gpastel.html";
          license = lib.licenses.free;
        };
      }) {};
    gpr-mode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , gnat-compiler
                            , lib
                            , wisi }:
      elpaBuild {
        pname = "gpr-mode";
        ename = "gpr-mode";
        version = "1.0.3.0.20230119.135149";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gpr-mode-1.0.3.0.20230119.135149.tar";
          sha256 = "1qd4wdmjlhj325q5qjhdx2l4z1bqpv4giwvsgd29s9k3sh7n8m2h";
        };
        packageRequires = [ emacs gnat-compiler wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gpr-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gpr-query = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , gnat-compiler
                             , lib
                             , wisi }:
      elpaBuild {
        pname = "gpr-query";
        ename = "gpr-query";
        version = "1.0.3.0.20230128.112055";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gpr-query-1.0.3.0.20230128.112055.tar";
          sha256 = "0fnq3zdzlcfc54m5ix01ix78drfmzvfiicjp9cvsw78s0sd05p9x";
        };
        packageRequires = [ emacs gnat-compiler wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gpr-query.html";
          license = lib.licenses.free;
        };
      }) {};
    graphql = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "graphql";
        ename = "graphql";
        version = "0.1.2.0.20221202.2453";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/graphql-0.1.2.0.20221202.2453.tar";
          sha256 = "175ss2ln21j0s83fy5yydb05rgsawgc7f8qbahc6ahc1sclppk26";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/graphql.html";
          license = lib.licenses.free;
        };
      }) {};
    greader = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "greader";
        ename = "greader";
        version = "0.1.0.20230815.3721";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/greader-0.1.0.20230815.3721.tar";
          sha256 = "1322f0i6v1bmv89nqdp194n3ypvqj8rkn29w5h1c5yywyw2nkyr1";
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
        version = "1.1.0.20221221.80217";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/greenbar-1.1.0.20221221.80217.tar";
          sha256 = "1cm2fj2arhgxc5dl6yw03xjyipgk2skaamyy8gybbb4zdglhpd0m";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/greenbar.html";
          license = lib.licenses.free;
        };
      }) {};
    gtags-mode = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "gtags-mode";
        ename = "gtags-mode";
        version = "1.0.0.20221205.52414";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/gtags-mode-1.0.0.20221205.52414.tar";
          sha256 = "0y6dsyrm91yb63bmm6cpjzffq4314saqfryz790h8jm19x5nc4m2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gtags-mode.html";
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
        version = "0.0.1.0.20190417.81229";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/guess-language-0.0.1.0.20190417.81229.tar";
          sha256 = "0xzaq5wm20jkbimg60na2if7zpxlbddqbr9hadg3qqswkg4zp1v7";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/guess-language.html";
          license = lib.licenses.free;
        };
      }) {};
    hcel = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hcel";
        ename = "hcel";
        version = "1.0.0.0.20221012.11633";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/hcel-1.0.0.0.20221012.11633.tar";
          sha256 = "0hmrb914pilsqvqlw28iy93mkw0h3isyxd0dmw5k3sf9x8zlifh9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hcel.html";
          license = lib.licenses.free;
        };
      }) {};
    heap = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "heap";
        ename = "heap";
        version = "0.5.0.20201214.121301";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/heap-0.5.0.20201214.121301.tar";
          sha256 = "0i16nc0rc5q2hrqamdqfrf8rzw9msi1a9sad2jq68dlbyv113l6n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/heap.html";
          license = lib.licenses.free;
        };
      }) {};
    hiddenquote = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "hiddenquote";
        ename = "hiddenquote";
        version = "1.2.0.20221206.105559";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/hiddenquote-1.2.0.20221206.105559.tar";
          sha256 = "0jmlby1ic1sfymiz5rxpq7l7zfxp5hkmcik4ax62q1vnqm67gvq4";
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
        version = "0.4.0.20201214.173014";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/highlight-escape-sequences-0.4.0.20201214.173014.tar";
          sha256 = "1av3fzavy83xjbd52dnql6i95993gyxfhkd1san6c3hi0lcnh3vw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-escape-sequences.html";
          license = lib.licenses.free;
        };
      }) {};
    hook-helpers = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "hook-helpers";
        ename = "hook-helpers";
        version = "1.1.1.0.20201201.93957";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/hook-helpers-1.1.1.0.20201201.93957.tar";
          sha256 = "01iimwwy274kpc0vpy9barfq1rakfrj0d4v3akrzwscnfkxzm1ms";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hook-helpers.html";
          license = lib.licenses.free;
        };
      }) {};
    html5-schema = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "html5-schema";
        ename = "html5-schema";
        version = "0.1.0.20221221.80245";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/html5-schema-0.1.0.20221221.80245.tar";
          sha256 = "1k3a653n3whprkhc1pc7q1dsc00g2w6923p74ap64ymdv6sx6pw2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/html5-schema.html";
          license = lib.licenses.free;
        };
      }) {};
    hydra = callPackage ({ elpaBuild, emacs, fetchurl, lib, lv }:
      elpaBuild {
        pname = "hydra";
        ename = "hydra";
        version = "0.15.0.0.20221030.224757";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/hydra-0.15.0.0.20221030.224757.tar";
          sha256 = "1ici53s3h7syvzrvz4l5q8790fgfl9wfhdrx2mc0wdhc9jwgxif0";
        };
        packageRequires = [ emacs lv ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hydra.html";
          license = lib.licenses.free;
        };
      }) {};
    hyperbole = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "hyperbole";
        ename = "hyperbole";
        version = "8.0.1pre0.20230825.105451";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/hyperbole-8.0.1pre0.20230825.105451.tar";
          sha256 = "018krzc1fikjxipdqv3cg4wmhzr3z81xgiy9m8wc05pakjk11kc3";
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
        version = "0.1.0.20220115.130125";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ilist-0.1.0.20220115.130125.tar";
          sha256 = "088g1ybcvphlgjyl7n7y81m0q2g77brabdbj479j2s8rbidw26va";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ilist.html";
          license = lib.licenses.free;
        };
      }) {};
    inspector = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "inspector";
        ename = "inspector";
        version = "0.33.0.20230821.101343";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/inspector-0.33.0.20230821.101343.tar";
          sha256 = "15x73qhdkwsdh3dg8n1051jrcvyjdygpx44c4k23vfrsgjwkd66i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inspector.html";
          license = lib.licenses.free;
        };
      }) {};
    ioccur = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ioccur";
        ename = "ioccur";
        version = "2.6.0.20211231.163129";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ioccur-2.6.0.20211231.163129.tar";
          sha256 = "0vgb0p6gb2djrqviq2ifvkkd7zyp094z2jsly52i14j153cvi9pd";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ioccur.html";
          license = lib.licenses.free;
        };
      }) {};
    isearch-mb = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "isearch-mb";
        ename = "isearch-mb";
        version = "0.7.0.20230218.111405";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/isearch-mb-0.7.0.20230218.111405.tar";
          sha256 = "1bvizhy320yln1h34dn31v9cwh0k83iwyqcqspj6qly89wnhn3zm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/isearch-mb.html";
          license = lib.licenses.free;
        };
      }) {};
    iterators = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "iterators";
        ename = "iterators";
        version = "0.1.1.0.20221221.80300";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/iterators-0.1.1.0.20221221.80300.tar";
          sha256 = "14psdlyar90zhq091w39z2zkfi99x4dq2zrnhnbzwll0sr5q7j7z";
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
        version = "0.14.0.0.20230714.75746";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ivy-0.14.0.0.20230714.75746.tar";
          sha256 = "166nysfapnz1b15dmag9hlfx26j0k882k5wmx7fpbm4mdj20y6q0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-avy = callPackage ({ avy
                           , elpaBuild
                           , emacs
                           , fetchurl
                           , ivy
                           , lib }:
      elpaBuild {
        pname = "ivy-avy";
        ename = "ivy-avy";
        version = "0.14.0.0.20230410.182616";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ivy-avy-0.14.0.0.20230410.182616.tar";
          sha256 = "1s749025jyd5qy5yhxnnd71bj1qcwa6ah0ddl2cs16h9mdbf87qy";
        };
        packageRequires = [ avy emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-avy.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-explorer = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , ivy
                                , lib }:
      elpaBuild {
        pname = "ivy-explorer";
        ename = "ivy-explorer";
        version = "0.3.2.0.20190909.192125";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ivy-explorer-0.3.2.0.20190909.192125.tar";
          sha256 = "1h4yp4xp5kqirlxhbg425v7fh9zphwkqflvf4qf0xf275w4i8g88";
        };
        packageRequires = [ emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-explorer.html";
          license = lib.licenses.free;
        };
      }) {};
    ivy-hydra = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , hydra
                             , ivy
                             , lib }:
      elpaBuild {
        pname = "ivy-hydra";
        ename = "ivy-hydra";
        version = "0.14.0.0.20230410.182324";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ivy-hydra-0.14.0.0.20230410.182324.tar";
          sha256 = "10sd554k3qb81am3jvg7l084i031c133a24cgh0g44vjj2s76nra";
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
        version = "0.6.3.0.20211217.23411";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ivy-posframe-0.6.3.0.20211217.23411.tar";
          sha256 = "1d1yhydqcbdsya7rnkxd2c05p7vd6iixkx814cl9j1k14amvl46w";
        };
        packageRequires = [ emacs ivy posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    jarchive = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "jarchive";
        ename = "jarchive";
        version = "0.10.0.0.20230118.130252";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jarchive-0.10.0.0.20230118.130252.tar";
          sha256 = "19mfqk255bj6f56r9flgx07s4ylf144l08w5id89qn4l6rbmjvrg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jarchive.html";
          license = lib.licenses.free;
        };
      }) {};
    javaimp = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "javaimp";
        ename = "javaimp";
        version = "0.9.1.0.20221221.80314";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/javaimp-0.9.1.0.20221221.80314.tar";
          sha256 = "07qmxqsp9gbdr7pxv4f8826l50gbwcxs2f5zw3v88h64rgrkll5c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/javaimp.html";
          license = lib.licenses.free;
        };
      }) {};
    jgraph-mode = callPackage ({ cl-lib ? null
                               , elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "jgraph-mode";
        ename = "jgraph-mode";
        version = "1.1.0.20221221.80333";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jgraph-mode-1.1.0.20221221.80333.tar";
          sha256 = "1dljzr1f0vdhsrw8wksz4gq1q0vwl0136diwzrxh4hwya97mvsrn";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jgraph-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    jinx = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jinx";
        ename = "jinx";
        version = "0.9.0.20230816.204512";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jinx-0.9.0.20230816.204512.tar";
          sha256 = "1qpd4n70822fwbg0cb8jdg4zahzwm8jlh3fq9m5482m2dk45fywb";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jinx.html";
          license = lib.licenses.free;
        };
      }) {};
    jit-spell = callPackage ({ compat
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "jit-spell";
        ename = "jit-spell";
        version = "0.3.0.20230330.165659";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jit-spell-0.3.0.20230330.165659.tar";
          sha256 = "1qlk3srh34sqvl0vnm1r3vjm5qn9jxvzp60zl8hrhrip8cwi9l9j";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jit-spell.html";
          license = lib.licenses.free;
        };
      }) {};
    js2-mode = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "js2-mode";
        ename = "js2-mode";
        version = "20230408.0.20230628.23819";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/js2-mode-20230408.0.20230628.23819.tar";
          sha256 = "1yr3nyy28wwvmrbm3zl6hvwzja1qspvw92jzddydgjdws1xwwmfc";
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
        version = "0.2.0.20221221.80401";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/json-mode-0.2.0.20221221.80401.tar";
          sha256 = "10rgam19spjrqfmpvxnhp4akgz1ya6l4kvzdyhavgi03bd8c8gxn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/json-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    jsonrpc = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "jsonrpc";
        ename = "jsonrpc";
        version = "1.0.17.0.20230729.112319";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jsonrpc-1.0.17.0.20230729.112319.tar";
          sha256 = "0id8pih1svkp1ipnb92kh2avmb8cwrldxgj4b0kli4bi2q9i58x6";
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
        version = "3.0.0.20221221.80412";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/jumpc-3.0.0.20221221.80412.tar";
          sha256 = "17phcxzqf2drxjmg19iyn9r8mlrzbj26c834p76p9887k05xcjyg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jumpc.html";
          license = lib.licenses.free;
        };
      }) {};
    kind-icon = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , svg-lib }:
      elpaBuild {
        pname = "kind-icon";
        ename = "kind-icon";
        version = "0.2.0.0.20230824.91306";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/kind-icon-0.2.0.0.20230824.91306.tar";
          sha256 = "0v1ic3q6cc5l09b6yx3dm9xd1wc0n5n6xc5f9vakak0xnjw8c88i";
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
        version = "1.1.5.0.20220316.84759";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/kiwix-1.1.5.0.20220316.84759.tar";
          sha256 = "1w0701chsjxnc19g7qd8aipb9vsncfmccgpkw9w65fcmcr7v0ipf";
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
        version = "0.1.0.20221221.80420";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/kmb-0.1.0.20221221.80420.tar";
          sha256 = "03jgn57h4i3rdfk4qankz3fivrglbxd1y86bm2k7ansdq8a5f7kn";
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
        version = "1.0.0.20221221.80428";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/landmark-1.0.0.20221221.80428.tar";
          sha256 = "1jab8b832x4zf6kxfk7n80rc6jhzxsdnmck9jx3asxw9013cc6c8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/landmark.html";
          license = lib.licenses.free;
        };
      }) {};
    latex-table-wizard = callPackage ({ auctex
                                      , elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib
                                      , transient }:
      elpaBuild {
        pname = "latex-table-wizard";
        ename = "latex-table-wizard";
        version = "1.5.3.0.20230821.110703";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/latex-table-wizard-1.5.3.0.20230821.110703.tar";
          sha256 = "0sbzmi279hni1rk02jg6jz2gfhl0q53vgm0ck0d6444yfdd9a3cg";
        };
        packageRequires = [ auctex emacs transient ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/latex-table-wizard.html";
          license = lib.licenses.free;
        };
      }) {};
    leaf = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "leaf";
        ename = "leaf";
        version = "4.5.5.0.20230803.74443";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/leaf-4.5.5.0.20230803.74443.tar";
          sha256 = "1ixyiy2zq3v0vz1jbazba41x3m3azb6zvpjm0721dakkqv8k7idj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/leaf.html";
          license = lib.licenses.free;
        };
      }) {};
    let-alist = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "let-alist";
        ename = "let-alist";
        version = "1.0.6.0.20230101.53112";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/let-alist-1.0.6.0.20230101.53112.tar";
          sha256 = "068hdnbqr2jwfscwspf6zch0gwkcdpwj80zmrvi6dmixrnz65a9w";
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
        version = "1.1.0.20221221.80437";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/lex-1.1.0.20221221.80437.tar";
          sha256 = "1f13cijb1pgna364yp7kssnxka7n7wmswsi63pprljxh8mf8p2w5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lex.html";
          license = lib.licenses.free;
        };
      }) {};
    lin = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lin";
        ename = "lin";
        version = "1.0.0.0.20230617.191618";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/lin-1.0.0.0.20230617.191618.tar";
          sha256 = "1q3gz7i83v5v6y5plf8z1llq9r6bdjaj1ml6vl70z3jribrib8ga";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lin.html";
          license = lib.licenses.free;
        };
      }) {};
    lmc = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lmc";
        ename = "lmc";
        version = "1.4.0.20230105.113402";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/lmc-1.4.0.20230105.113402.tar";
          sha256 = "0pw31akqdf59y9cxk25y8z5643szd4ybhbcmj91i1k9gkhdqhh1x";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lmc.html";
          license = lib.licenses.free;
        };
      }) {};
    load-dir = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "load-dir";
        ename = "load-dir";
        version = "0.0.5.0.20221221.80456";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/load-dir-0.0.5.0.20221221.80456.tar";
          sha256 = "1hdyy212iz057q2znp8pb6ns8gyi6f5xbr6kvs02rybsd9wjv40s";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-dir.html";
          license = lib.licenses.free;
        };
      }) {};
    load-relative = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "load-relative";
        ename = "load-relative";
        version = "1.3.2.0.20230214.53224";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/load-relative-1.3.2.0.20230214.53224.tar";
          sha256 = "027mlcg38x2yb3j9lnjzfg84fj8hah7sd9nnndf6fkpabi7bbysq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-relative.html";
          license = lib.licenses.free;
        };
      }) {};
    loc-changes = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "loc-changes";
        ename = "loc-changes";
        version = "1.2.0.20201201.94106";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/loc-changes-1.2.0.20201201.94106.tar";
          sha256 = "1jrjqn5600l245vhr5h6zwg6g72k0n721ck94mji755bqd231yxs";
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
        version = "1.2.4.0.20201130.183958";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/loccur-1.2.4.0.20201130.183958.tar";
          sha256 = "1skpv5pmbkhn5vx2c4dqqx4ds3pj4z2lg6ka0pas9xkijdbfy7v0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/loccur.html";
          license = lib.licenses.free;
        };
      }) {};
    logos = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "logos";
        ename = "logos";
        version = "1.1.1.0.20230621.190031";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/logos-1.1.1.0.20230621.190031.tar";
          sha256 = "10bbjidfma7xsmh1gmv6qfnv315r9bvbik0hqdx9kd75sl7fvdj7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/logos.html";
          license = lib.licenses.free;
        };
      }) {};
    luwak = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "luwak";
        ename = "luwak";
        version = "1.0.0.0.20221125.50733";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/luwak-1.0.0.0.20221125.50733.tar";
          sha256 = "06kl3c6b7z9wzw44c6l49vnj4k25g4az8lps8q7kd7w7f0cjn3yx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/luwak.html";
          license = lib.licenses.free;
        };
      }) {};
    lv = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "lv";
        ename = "lv";
        version = "0.15.0.0.20221030.224757";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/lv-0.15.0.0.20221030.224757.tar";
          sha256 = "0xjizznzwsydwqs2hvcbi8nqcyzvca0w3m48dpi2xwvnm22a7v48";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lv.html";
          license = lib.licenses.free;
        };
      }) {};
    map = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "map";
        ename = "map";
        version = "3.3.1.0.20230730.132027";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/map-3.3.1.0.20230730.132027.tar";
          sha256 = "07mwm2y6h9q2c8058s1wg752rsi4hqpg2wr9apigvldli5fdwn72";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/map.html";
          license = lib.licenses.free;
        };
      }) {};
    marginalia = callPackage ({ compat
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "marginalia";
        ename = "marginalia";
        version = "1.3.0.20230805.91509";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/marginalia-1.3.0.20230805.91509.tar";
          sha256 = "1xxx64vfx6i2ghnhk79fm33mqlmg8y1jjl9365wgsq51f5422041";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/marginalia.html";
          license = lib.licenses.free;
        };
      }) {};
    markchars = callPackage ({ elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "markchars";
        ename = "markchars";
        version = "0.2.2.0.20221221.80510";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/markchars-0.2.2.0.20221221.80510.tar";
          sha256 = "0snw8hc65mkmmlaj1x87gwkyrz43qdm5ahnnjh09dad5pfd1s0v0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markchars.html";
          license = lib.licenses.free;
        };
      }) {};
    math-symbol-lists = callPackage ({ elpaBuild
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "math-symbol-lists";
        ename = "math-symbol-lists";
        version = "1.3.0.20220828.204754";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/math-symbol-lists-1.3.0.20220828.204754.tar";
          sha256 = "11n6lmh9q6j0aamd4wbij0ymdfpdmqm0iqysqvk2vnnq6ly4hw3f";
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
        version = "0.5.0.0.20230329.161705";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/mct-0.5.0.0.20230329.161705.tar";
          sha256 = "0wrxhlcwgbpkfp1p0djhqj09s6q484vyr3sxlvg9vvqk75v73brv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mct.html";
          license = lib.licenses.free;
        };
      }) {};
    memory-usage = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "memory-usage";
        ename = "memory-usage";
        version = "0.2.0.20201201.223908";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/memory-usage-0.2.0.20201201.223908.tar";
          sha256 = "1klpmxgkmc9rb8daldllfwvwagg9sc01kq2jp1vq2wsbrvgpai6d";
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
        version = "0.3.0.20221221.80722";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/metar-0.3.0.20221221.80722.tar";
          sha256 = "18hzsasajy00m4lvb8pqmpipb3a4m3g9mn151vqndd5hnk08wafn";
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
        version = "0.2.0.20221221.80736";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/midi-kbd-0.2.0.20221221.80736.tar";
          sha256 = "1ssr8srsdd3f0ijyrx7mcyshb4jdcdi9klm9akablnwzx9z2scm8";
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
        version = "1.6.0.20201130.184335";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/mines-1.6.0.20201130.184335.tar";
          sha256 = "0xcb0faxsqzrjqxj5z3r8b3hyd8czb5vadzy6shfzkp5xk6w0bny";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mines.html";
          license = lib.licenses.free;
        };
      }) {};
    minibuffer-header = callPackage ({ elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "minibuffer-header";
        ename = "minibuffer-header";
        version = "0.5.0.20220921.71345";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/minibuffer-header-0.5.0.20220921.71345.tar";
          sha256 = "0d3mj2j6bkvci78yx9gidgkig6qvg99zhh3g4z5fqsymyndi1l1w";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minibuffer-header.html";
          license = lib.licenses.free;
        };
      }) {};
    minibuffer-line = callPackage ({ elpaBuild
                                   , fetchurl
                                   , lib }:
      elpaBuild {
        pname = "minibuffer-line";
        ename = "minibuffer-line";
        version = "0.1.0.20221221.80745";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/minibuffer-line-0.1.0.20221221.80745.tar";
          sha256 = "1zq1y69wwci8r840ns3izq59hr95b8ncyha0q06gqrv989jamrjw";
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
        version = "1.4.0.20201201.162630";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/minimap-1.4.0.20201201.162630.tar";
          sha256 = "1r062v8a4r4d78biz9d3jk5y8w3ahhamr05cnhfwh2aib4byplf1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minimap.html";
          license = lib.licenses.free;
        };
      }) {};
    mmm-mode = callPackage ({ cl-lib ? null
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "mmm-mode";
        ename = "mmm-mode";
        version = "0.5.9.0.20221228.193134";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/mmm-mode-0.5.9.0.20221228.193134.tar";
          sha256 = "0hmj27q8b10dsf3scjq9nslybpdip8bivd0h5dd5bc29mhazld8g";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mmm-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    modus-themes = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "modus-themes";
        ename = "modus-themes";
        version = "4.2.0.0.20230825.33718";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/modus-themes-4.2.0.0.20230825.33718.tar";
          sha256 = "12f5xqxcwi0zaf3zy7anazj8xc11w0cvx6yca7hbf7anckawjqdk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    multi-mode = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "multi-mode";
        ename = "multi-mode";
        version = "1.14.0.20221221.80812";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/multi-mode-1.14.0.20221221.80812.tar";
          sha256 = "0054sb4jp1xp6bf0zh42k6blhvlpw5yr38fg5pm5gv8a6iw3gc9x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multi-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    multishell = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "multishell";
        ename = "multishell";
        version = "1.1.10.0.20220605.120254";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/multishell-1.1.10.0.20220605.120254.tar";
          sha256 = "1vs9w1v8hqwfhypk0nz7l2n7q1rf7nx2nwlljqn8clx817glqlfm";
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
        version = "3.20.2.0.20201128.92545";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/muse-3.20.2.0.20201128.92545.tar";
          sha256 = "0n201dzka0r2fwjjfklzif8kgbkh102pw83irb0y93sjsj6kkm9l";
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
        version = "0.1.0.20221221.80834";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/myers-0.1.0.20221221.80834.tar";
          sha256 = "1hk1587bni5sn9q91yv43s1i5dvbirbh2md46cx7c9y69bshyaqh";
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
        version = "0.4.0.20230111.104526";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nadvice-0.4.0.20230111.104526.tar";
          sha256 = "0kcgdrcsjf4rqcb9k95amcvx3qx8qx7msnwjy21a87vc0w8gpv3r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nadvice.html";
          license = lib.licenses.free;
        };
      }) {};
    nameless = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "nameless";
        ename = "nameless";
        version = "1.0.2.0.20230112.95905";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nameless-1.0.2.0.20230112.95905.tar";
          sha256 = "0a8zjsm75k02ixynd5jxxniyj5yn4gbcvidi03jkk9z3vxr19vi7";
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
        version = "20151201.0.0.20220425.173515";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/names-20151201.0.0.20220425.173515.tar";
          sha256 = "1rd7v5yvb2d5zxcqmdjg7hmhgd12lhcrg03wm6sd1lq3jw0hbxhr";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/names.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-agenda = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "nano-agenda";
        ename = "nano-agenda";
        version = "0.3.0.20230417.100538";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nano-agenda-0.3.0.20230417.100538.tar";
          sha256 = "1v7dx53zl0mw8ap91kvzwqb4kiikg14dsw3r49n0j5766nc320fv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-agenda.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-modeline = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "nano-modeline";
        ename = "nano-modeline";
        version = "1.0.1.0.20230712.92019";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nano-modeline-1.0.1.0.20230712.92019.tar";
          sha256 = "10zq3zm8yv5gmi9kgw742zb52swzi09c4npvqjh31hmrzprvp4nn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-modeline.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-theme = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "nano-theme";
        ename = "nano-theme";
        version = "0.3.4.0.20230421.53238";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nano-theme-0.3.4.0.20230421.53238.tar";
          sha256 = "04fmfzy965d6wbaxgpkgyxaw9qv6103gc9g8kw1gcvbxdgq0rf56";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    nftables-mode = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "nftables-mode";
        ename = "nftables-mode";
        version = "1.1.0.20221221.80909";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nftables-mode-1.1.0.20221221.80909.tar";
          sha256 = "11a38dgnnvzsh6k7l8n1fzkn8ma4mj3sv17r2614g4jjkmwkaz0i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nftables-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    nhexl-mode = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "nhexl-mode";
        ename = "nhexl-mode";
        version = "1.5.0.20221215.152407";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nhexl-mode-1.5.0.20221215.152407.tar";
          sha256 = "10jxk0n8x8lr7chfnr562gmyfmcsh25xc1vsqw802c0y3l8z3jw1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nhexl-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    nlinum = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "nlinum";
        ename = "nlinum";
        version = "1.9.0.20221221.80940";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/nlinum-1.9.0.20221221.80940.tar";
          sha256 = "1vifq3rlh9zwrqq0zkhdqv1g2pzgndyxjdr21xis6kxdc50s59l1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nlinum.html";
          license = lib.licenses.free;
        };
      }) {};
    notes-mode = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "notes-mode";
        ename = "notes-mode";
        version = "1.30.0.20201201.121157";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/notes-mode-1.30.0.20201201.121157.tar";
          sha256 = "0jliwzbmn89qfjfd096sa5gia52mqvivg8kif41mrmczbhzgqp6a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/notes-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    notmuch-indicator = callPackage ({ elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "notmuch-indicator";
        ename = "notmuch-indicator";
        version = "1.0.1.0.20230801.130142";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/notmuch-indicator-1.0.1.0.20230801.130142.tar";
          sha256 = "0c3iwgfaw4qy8a7s86nn82lqv1bw3cypmnr1bmyz4iyjdwfzb8xd";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/notmuch-indicator.html";
          license = lib.licenses.free;
        };
      }) {};
    ntlm = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ntlm";
        ename = "ntlm";
        version = "2.1.0.0.20230506.82958";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ntlm-2.1.0.0.20230506.82958.tar";
          sha256 = "0y4jd98bwv8bzypai2ahspknxgq0a90bn6pqfn9d65ddf611rswl";
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
        version = "1.5.0.20221221.81242";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/num3-mode-1.5.0.20221221.81242.tar";
          sha256 = "0pwlklfmz0brsq2l4zkvmg18hryc9cszsbyn0ky9n8nz0m9nfxsw";
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
        version = "0.16.0.20221221.81302";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/oauth2-0.16.0.20221221.81302.tar";
          sha256 = "1hxmwsb56m73qr4nqfh32bhbd8b0bl5yfccsk754sjywpn1wnlpq";
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
        version = "1.0.0.20210211.73431";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ob-haxe-1.0.0.20210211.73431.tar";
          sha256 = "18i9wmchnaz0hnh1bb3sydawxrcxqy1gfp150i69p0miwsfmz7ip";
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
        version = "0.8.3.0.20201002.84752";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/objed-0.8.3.0.20201002.84752.tar";
          sha256 = "1ar3i58cb55958dnj88bxa5wnmlz4dnfh76m7nf0kf5sld71l0vf";
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
        version = "1.2.0.20221221.81322";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/omn-mode-1.2.0.20221221.81322.tar";
          sha256 = "0bpp3aj93srdmqbh33k36q9762dzzagymh1rxca2axdfb7q7xsa2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/omn-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    on-screen = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "on-screen";
        ename = "on-screen";
        version = "1.3.3.0.20201127.191411";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/on-screen-1.3.3.0.20201127.191411.tar";
          sha256 = "123kq277vcm4backwdpmnmkkqiplnnbpf62ppn5cg8zl09r87cl6";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/on-screen.html";
          license = lib.licenses.free;
        };
      }) {};
    openpgp = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "openpgp";
        ename = "openpgp";
        version = "1.0.1.0.20230325.141904";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/openpgp-1.0.1.0.20230325.141904.tar";
          sha256 = "1zpdxm8s7kd936klrsyf72g7my4ffci74cc9gwasgff4r383f000";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/openpgp.html";
          license = lib.licenses.free;
        };
      }) {};
    orderless = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "orderless";
        ename = "orderless";
        version = "1.0.0.20230801.201828";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/orderless-1.0.0.20230801.201828.tar";
          sha256 = "1yn7rs9i2x75pv0nvwhm4dwrp7zj6lxgw8k516pari864ksk06zh";
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
        version = "9.7pre0.20230825.112644";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-9.7pre0.20230825.112644.tar";
          sha256 = "118ydjrn7sahn1x1qv2hyb3z4ijci370i1y6h2jxrxiv7lw87rsb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contacts = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , org }:
      elpaBuild {
        pname = "org-contacts";
        ename = "org-contacts";
        version = "1.1.0.20230227.141730";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-contacts-1.1.0.20230227.141730.tar";
          sha256 = "0y78hwcranqdlm9lip623v5qaj15gv335lnxaakxra9dfri703fm";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contacts.html";
          license = lib.licenses.free;
        };
      }) {};
    org-edna = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , org
                            , seq }:
      elpaBuild {
        pname = "org-edna";
        ename = "org-edna";
        version = "1.1.2.0.20200902.94459";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-edna-1.1.2.0.20200902.94459.tar";
          sha256 = "0s7485x4dblrz2gnnd9qxaq3jph16z5ylp1na3b0mi60v0ibnwa4";
        };
        packageRequires = [ emacs org seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-edna.html";
          license = lib.licenses.free;
        };
      }) {};
    org-modern = callPackage ({ compat
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "org-modern";
        ename = "org-modern";
        version = "0.10.0.20230816.203404";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-modern-0.10.0.20230816.203404.tar";
          sha256 = "0i6vqjd8cwpy2rphzx1gid1rln9ipk6pr3xclm5l44fq5lg1r075";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-modern.html";
          license = lib.licenses.free;
        };
      }) {};
    org-notify = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "org-notify";
        ename = "org-notify";
        version = "0.1.0.0.20221102.174044";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-notify-0.1.0.0.20221102.174044.tar";
          sha256 = "1jp3d7f63jkqhamihc7x1pmcj0k2bg1y8hp4akjdv5sfwxm2gr9q";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-notify.html";
          license = lib.licenses.free;
        };
      }) {};
    org-real = callPackage ({ boxy
                            , elpaBuild
                            , emacs
                            , fetchurl
                            , lib
                            , org }:
      elpaBuild {
        pname = "org-real";
        ename = "org-real";
        version = "1.0.6.0.20221114.84409";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-real-1.0.6.0.20221114.84409.tar";
          sha256 = "1xmix5ldxxkh249fgyqlp31yndl14gz3ylpcsh6l9hmwqagzg20x";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-real.html";
          license = lib.licenses.free;
        };
      }) {};
    org-remark = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib
                              , org }:
      elpaBuild {
        pname = "org-remark";
        ename = "org-remark";
        version = "1.2.1.0.20230821.73531";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-remark-1.2.1.0.20230821.73531.tar";
          sha256 = "1cfhfxm0rg3nnzdnkb85m5020fw4kg0kffzbh9s3lknlfvwvgs28";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-remark.html";
          license = lib.licenses.free;
        };
      }) {};
    org-transclusion = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib
                                    , org }:
      elpaBuild {
        pname = "org-transclusion";
        ename = "org-transclusion";
        version = "1.3.2.0.20230819.63913";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-transclusion-1.3.2.0.20230819.63913.tar";
          sha256 = "06kyqaaa7lw7sv0nznq7ln14dcnl8j2f31xdxzv0dn4la0fgl6mn";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-transclusion.html";
          license = lib.licenses.free;
        };
      }) {};
    org-translate = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib
                                 , org }:
      elpaBuild {
        pname = "org-translate";
        ename = "org-translate";
        version = "0.1.4.0.20220312.90634";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/org-translate-0.1.4.0.20220312.90634.tar";
          sha256 = "1lgnr4swyh1irq7q8x6di1kmglr1h4ph864mz3491pxks9y0hxjx";
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
        version = "1.13.0.20221221.81335";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/orgalist-1.13.0.20221221.81335.tar";
          sha256 = "0blq29dbzxssrmxs31q51z5085z6ym2iyr5bjjp81ar3qpa0v86f";
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
        version = "0.4.0.20221221.81343";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/osc-0.4.0.20221221.81343.tar";
          sha256 = "1q4sd2pf492gyqhdrkj7qn4zh1x3jhwb1mxgs811k28fl16hanqh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/osc.html";
          license = lib.licenses.free;
        };
      }) {};
    osm = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "osm";
        ename = "osm";
        version = "0.13.0.20230825.91944";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/osm-0.13.0.20230825.91944.tar";
          sha256 = "13z4pz9q181jr9z66w2cn9ixh240x5dsyqjbjh455bqv2wf4kizl";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/osm.html";
          license = lib.licenses.free;
        };
      }) {};
    other-frame-window = callPackage ({ elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib }:
      elpaBuild {
        pname = "other-frame-window";
        ename = "other-frame-window";
        version = "1.0.6.0.20221221.81352";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/other-frame-window-1.0.6.0.20221221.81352.tar";
          sha256 = "1w0lqbrgjkf5l7n1zrqlbldznhzb1xshhdg68mxydq97rhbl1msg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/other-frame-window.html";
          license = lib.licenses.free;
        };
      }) {};
    pabbrev = callPackage ({ elpaBuild
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "pabbrev";
        ename = "pabbrev";
        version = "4.2.2.0.20230101.115226";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pabbrev-4.2.2.0.20230101.115226.tar";
          sha256 = "0wx9833z07riclppprjwf08s7kybwg1145rzxwxrk1gjv2glq4lj";
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
        version = "1.1.3.0.20190227.204125";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/paced-1.1.3.0.20190227.204125.tar";
          sha256 = "09ain2dq42j6bvvchddr077z9dbsmx09qg88yklqi3pc4rc7f3rv";
        };
        packageRequires = [ async emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/paced.html";
          license = lib.licenses.free;
        };
      }) {};
    package-fixes = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "package-fixes";
        ename = "package-fixes";
        version = "0.0.20221221.81359";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/package-fixes-0.0.20221221.81359.tar";
          sha256 = "0n86dq8l2hwknilrx0871w8w4i9hnkndjj6q0yas5gm8jm4w0wfq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/package-fixes.html";
          license = lib.licenses.free;
        };
      }) {};
    parsec = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "parsec";
        ename = "parsec";
        version = "0.1.3.0.20180729.171626";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/parsec-0.1.3.0.20180729.171626.tar";
          sha256 = "1icrhga35n6nvwa8dy939cc2cc1phvqh27xr1blqdxgcyyzm9ava";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parsec.html";
          license = lib.licenses.free;
        };
      }) {};
    parser-generator = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "parser-generator";
        ename = "parser-generator";
        version = "0.1.6.0.20220512.173154";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/parser-generator-0.1.6.0.20220512.173154.tar";
          sha256 = "16kl8r8mgq17230gi2v61cqhxwawp1m6xjrbhc3qdlhy6plgidcy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/parser-generator.html";
          license = lib.licenses.free;
        };
      }) {};
    path-iterator = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "path-iterator";
        ename = "path-iterator";
        version = "1.0.0.20221221.81414";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/path-iterator-1.0.0.20221221.81414.tar";
          sha256 = "12ap8ij593dkba4kahqwzvpd9d62894z4hlplwz0c59qpy90lyxb";
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
        version = "1.0.1.0.20221221.81502";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/peg-1.0.1.0.20221221.81502.tar";
          sha256 = "1m5wl30zdq6fxllxkqblil6r1dqqsprdnqvlxivka6f0khbc6wdk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/peg.html";
          license = lib.licenses.free;
        };
      }) {};
    perl-doc = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "perl-doc";
        ename = "perl-doc";
        version = "0.81.0.20230805.210315";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/perl-doc-0.81.0.20230805.210315.tar";
          sha256 = "0p4vryw3by2g9kqmmdn6vi01cqgj5pwgfjcimivcxvq7vzvdafz0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/perl-doc.html";
          license = lib.licenses.free;
        };
      }) {};
    persist = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "persist";
        ename = "persist";
        version = "0.5.0.20220622.42135";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/persist-0.5.0.20220622.42135.tar";
          sha256 = "1vgrj3b6iblj5mkzd3lv9dx4h12pbia89gpab02w774i4yq13k9d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/persist.html";
          license = lib.licenses.free;
        };
      }) {};
    phpinspect = callPackage ({ compat, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "phpinspect";
        ename = "phpinspect";
        version = "0.0.20230824.182634";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/phpinspect-0.0.20230824.182634.tar";
          sha256 = "1rz8f59bwg4glrm5xjmg7xpssmlc9gb2s1wg65w0zi2lxakxz7fv";
        };
        packageRequires = [ compat ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/phpinspect.html";
          license = lib.licenses.free;
        };
      }) {};
    phps-mode = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "phps-mode";
        ename = "phps-mode";
        version = "0.4.46.0.20230414.164307";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/phps-mode-0.4.46.0.20230414.164307.tar";
          sha256 = "14m5gl1scj9rbn83wp35460vn71nc6fjmmmqw3pz5lzjcwxarvpq";
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
        version = "0.1.0.20180116.131526";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pinentry-0.1.0.20180116.131526.tar";
          sha256 = "152g6d7b084rzqpm7fw49rmgxx6baivhhjbb0q3ci0c3b4k01lbq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pinentry.html";
          license = lib.licenses.free;
        };
      }) {};
    plz = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "plz";
        ename = "plz";
        version = "0.8pre0.20230709.214633";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/plz-0.8pre0.20230709.214633.tar";
          sha256 = "1gzwzqjr0rkpcqbjfadn3rhj01ar6m66xws8cvlvjm8qfb5j4740";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/plz.html";
          license = lib.licenses.free;
        };
      }) {};
    poke = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "poke";
        ename = "poke";
        version = "3.2.0.20230517.100500";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/poke-3.2.0.20230517.100500.tar";
          sha256 = "0y5qrnqlhvvynvd1fknl0xp9d8bq55bnn2ms6lpbr0sd7ixh24qq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poke.html";
          license = lib.licenses.free;
        };
      }) {};
    poke-mode = callPackage ({ elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "poke-mode";
        ename = "poke-mode";
        version = "3.0.0.20230312.110305";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/poke-mode-3.0.0.20230312.110305.tar";
          sha256 = "0zm1kgvf8qypzjg2c256s0lhp3idybl0dzwszaa1yjpv7hs792ky";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poke-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    poker = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "poker";
        ename = "poker";
        version = "0.2.0.20221221.81510";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/poker-0.2.0.20221221.81510.tar";
          sha256 = "048i3l2z7pkxaphmb731cks0bw3w07arnpls2smm4dv51js14g5j";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poker.html";
          license = lib.licenses.free;
        };
      }) {};
    polymode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "polymode";
        ename = "polymode";
        version = "0.2.2.0.20230317.121821";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/polymode-0.2.2.0.20230317.121821.tar";
          sha256 = "129k592y80jixsff2h0bjvn1z1mcl9lwl4gc2sk1fg3vdq6984ng";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/polymode.html";
          license = lib.licenses.free;
        };
      }) {};
    posframe = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "posframe";
        ename = "posframe";
        version = "1.4.2.0.20230714.22752";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/posframe-1.4.2.0.20230714.22752.tar";
          sha256 = "0v3g4z36gm87z4ar7r4q86alscl6r64wd7y3wf55ngbhb84fh02r";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    pq = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pq";
        ename = "pq";
        version = "0.1.0.20220719.42000";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pq-0.1.0.20220719.42000.tar";
          sha256 = "11anvvmsjrfcfcz5sxfd40gsm6mlmc9llrvdnwhp4dsvi2llqv65";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pq.html";
          license = lib.licenses.free;
        };
      }) {};
    prefixed-core = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "prefixed-core";
        ename = "prefixed-core";
        version = "0.0.20221212.225529";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/prefixed-core-0.0.20221212.225529.tar";
          sha256 = "10a58xidv1b9yz8bps4ihhx5fl4w337695jmm66dpmphjvmr0hi4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/prefixed-core.html";
          license = lib.licenses.free;
        };
      }) {};
    project = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib
                           , xref }:
      elpaBuild {
        pname = "project";
        ename = "project";
        version = "0.9.8.0.20230824.122600";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/project-0.9.8.0.20230824.122600.tar";
          sha256 = "07ssbvs9hmqcivjxyq1lycpjjdw7dvbxgw2ndw200jsrww7y065x";
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
        version = "1.3.5.0.20221229.184738";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/psgml-1.3.5.0.20221229.184738.tar";
          sha256 = "055dpaylampjl53vby2b2lvmyfgjqjy64mpda6inmbc93jd3rq90";
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
        version = "1.1.0.20221221.81719";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pspp-mode-1.1.0.20221221.81719.tar";
          sha256 = "0awha64p3dyqpahsyr7dbhkprq3mizv239g6q4jiws6laqk54gqz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pspp-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    pulsar = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pulsar";
        ename = "pulsar";
        version = "1.0.1.0.20230824.40645";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pulsar-1.0.1.0.20230824.40645.tar";
          sha256 = "113rcvnajrj6nnqzlj9fk5sc59sqn2z1ipp6xflq7q92lh8h1g3a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pulsar.html";
          license = lib.licenses.free;
        };
      }) {};
    pyim = callPackage ({ async, elpaBuild, emacs, fetchurl, lib, xr }:
      elpaBuild {
        pname = "pyim";
        ename = "pyim";
        version = "5.3.2.0.20230814.41841";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pyim-5.3.2.0.20230814.41841.tar";
          sha256 = "05075hy3q5li3qha1g6cz86aycc3fahk67p5f7r7a6pvmbfc3vch";
        };
        packageRequires = [ async emacs xr ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pyim.html";
          license = lib.licenses.free;
        };
      }) {};
    pyim-basedict = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "pyim-basedict";
        ename = "pyim-basedict";
        version = "0.5.4.0.20220614.110824";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/pyim-basedict-0.5.4.0.20220614.110824.tar";
          sha256 = "0bf6fwjid16xhdyxaj229xra94qv5zaqwajqccd0y32bpw3ldf9f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pyim-basedict.html";
          license = lib.licenses.free;
        };
      }) {};
    python = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "python";
        ename = "python";
        version = "0.28.0.20230808.170856";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/python-0.28.0.20230808.170856.tar";
          sha256 = "1q72n1m1bkxgxs93ma4084wn3b53cssjqg3li89g8fpicd137i7b";
        };
        packageRequires = [ compat emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/python.html";
          license = lib.licenses.free;
        };
      }) {};
    quarter-plane = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "quarter-plane";
        ename = "quarter-plane";
        version = "0.1.0.20221221.81727";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/quarter-plane-0.1.0.20221221.81727.tar";
          sha256 = "17ahmyi0jih6jxplw5lpw50yq2rji8y7irgpxsd65xxj3fzydjrr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/quarter-plane.html";
          license = lib.licenses.free;
        };
      }) {};
    queue = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "queue";
        ename = "queue";
        version = "0.2.0.20210306.173709";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/queue-0.2.0.20210306.173709.tar";
          sha256 = "0sp42hjqdhyc3jayjrn2zrcz4rqn3ww9yqhq9nl8rwxh9b9xk4x4";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/queue.html";
          license = lib.licenses.free;
        };
      }) {};
    rainbow-mode = callPackage ({ elpaBuild
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "rainbow-mode";
        ename = "rainbow-mode";
        version = "1.0.6.0.20221221.81735";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rainbow-mode-1.0.6.0.20221221.81735.tar";
          sha256 = "1rwng66c7439m6dngl3b99162ranx6bwliy214vvv7i1qb92j3g7";
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
        version = "0.1.0.20201128.182847";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rbit-0.1.0.20201128.182847.tar";
          sha256 = "0n16yy2qbgiv1ykzhga62j8w8dwawb1b8z7qq7mkpxwbyd44c1i3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rbit.html";
          license = lib.licenses.free;
        };
      }) {};
    rcirc-color = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "rcirc-color";
        ename = "rcirc-color";
        version = "0.4.5.0.20230414.195045";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rcirc-color-0.4.5.0.20230414.195045.tar";
          sha256 = "0d0q5nvndpzxl0f8q6ahbia2j4mk4k9h1krw09n44i7jg45277v4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rcirc-color.html";
          license = lib.licenses.free;
        };
      }) {};
    rcirc-menu = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "rcirc-menu";
        ename = "rcirc-menu";
        version = "1.1.0.20221221.81818";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rcirc-menu-1.1.0.20221221.81818.tar";
          sha256 = "08cqb3p76qanii46vvpn31ngz4zjqwfplnrfwdlg12pnhz75fx0m";
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
        version = "1.5.1.0.20230704.91526";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-1.5.1.0.20230704.91526.tar";
          sha256 = "1cjpil5zdxwskw1r1in3w2zwqy9gyidz0wppzpxnfpfvk79vyf16";
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
        version = "1.0.0.0.20230320.62057";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-ipdb-1.0.0.0.20230320.62057.tar";
          sha256 = "0h5j1n835mm4y8rg0j52gvbkdp5r722hk7sxphhci09smjwncg1l";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-ipdb.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-jdb = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib
                               , load-relative
                               , realgud }:
      elpaBuild {
        pname = "realgud-jdb";
        ename = "realgud-jdb";
        version = "1.0.0.0.20200722.72030";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-jdb-1.0.0.0.20200722.72030.tar";
          sha256 = "1dmgw2bdwh20wr4yi66aamj48pkzmaz3ilhdx68qsirw5n48qg83";
        };
        packageRequires = [ emacs load-relative realgud ];
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
        version = "1.0.2.0.20230319.171320";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-lldb-1.0.2.0.20230319.171320.tar";
          sha256 = "15azvxwq861i6j61sj0240mxdq725wbln1wpim5pn45wzqh56zmv";
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
        version = "1.0.0.0.20190525.123417";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-node-debug-1.0.0.0.20190525.123417.tar";
          sha256 = "1w4n28pv65yzkz8lzn3sicz4il7gx4gxwgzwc6sp21yhb05kfz09";
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
        version = "1.0.0.0.20190526.154549";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-node-inspect-1.0.0.0.20190526.154549.tar";
          sha256 = "1ds40vq756b8vkc7yqacrgm72jj09kq92dprqlmr215r7s8fdglk";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-node-inspect.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-trepan-ni = callPackage ({ elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib
                                     , load-relative
                                     , realgud }:
      elpaBuild {
        pname = "realgud-trepan-ni";
        ename = "realgud-trepan-ni";
        version = "1.0.1.0.20210513.183733";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-trepan-ni-1.0.1.0.20210513.183733.tar";
          sha256 = "1gly5hvndc0hg1dfn9b12hbxa0wnlbz8zw9jzjzz5kj2d0fzjswx";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-trepan-ni.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-trepan-xpy = callPackage ({ elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib
                                      , load-relative
                                      , realgud }:
      elpaBuild {
        pname = "realgud-trepan-xpy";
        ename = "realgud-trepan-xpy";
        version = "1.0.1.0.20230322.184556";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/realgud-trepan-xpy-1.0.1.0.20230322.184556.tar";
          sha256 = "01h2v8jy0dl1xf7k938iinwkfb4zxrfr73z9s6jc59rrbybsqvha";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-trepan-xpy.html";
          license = lib.licenses.free;
        };
      }) {};
    rec-mode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "rec-mode";
        ename = "rec-mode";
        version = "1.9.1.0.20221220.80844";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rec-mode-1.9.1.0.20221220.80844.tar";
          sha256 = "0wzc76phg755q47qrin32i7a6d3g5qrsvlnl3kfzhncmjcb118lh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rec-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    register-list = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "register-list";
        ename = "register-list";
        version = "0.1.0.20221212.230034";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/register-list-0.1.0.20221212.230034.tar";
          sha256 = "1b0099yhvjd69xvcdvn65nx49xay06n2qzafw6fnn7qi22nbvah7";
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
        version = "1.23.0.20230801.104158";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/relint-1.23.0.20230801.104158.tar";
          sha256 = "0hkkvcrir5abar89gz2zqckpnnfr3v5l0in8d0nfqphfin30xwid";
        };
        packageRequires = [ emacs xr ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/relint.html";
          license = lib.licenses.free;
        };
      }) {};
    repology = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "repology";
        ename = "repology";
        version = "1.2.3.0.20220320.111223";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/repology-1.2.3.0.20220320.111223.tar";
          sha256 = "01gxmfr5v2zj0mj0i9ffk824qxdjfwc773vh4fyv67im2m17i8wc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/repology.html";
          license = lib.licenses.free;
        };
      }) {};
    rich-minority = callPackage ({ cl-lib ? null
                                 , elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "rich-minority";
        ename = "rich-minority";
        version = "1.0.3.0.20190419.83620";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rich-minority-1.0.3.0.20190419.83620.tar";
          sha256 = "08xdd9gmay0xi2dzk08n30asfzqkhxqfrlvs099pxdd0klgsz60m";
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
        version = "0.3.0.20221221.81910";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rnc-mode-0.3.0.20221221.81910.tar";
          sha256 = "1jyi7z0y31c994x9l6pv2j4bkc7m1lrhzk92xdvar003zvll32q9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rnc-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    rt-liberation = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "rt-liberation";
        ename = "rt-liberation";
        version = "5.0.20220503.141657";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rt-liberation-5.0.20220503.141657.tar";
          sha256 = "0bx4zh21pfl6df5hj3ny6p3b6askjkk8jkqajj8lldwd8x5fyz6c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rt-liberation.html";
          license = lib.licenses.free;
        };
      }) {};
    ruby-end = callPackage ({ elpaBuild
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "ruby-end";
        ename = "ruby-end";
        version = "0.4.3.0.20230205.12506";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ruby-end-0.4.3.0.20230205.12506.tar";
          sha256 = "0l2dbpmhimqb8q5zjjmrf0lriwff4vwwrsba61fiyd3lzk0v0hl2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ruby-end.html";
          license = lib.licenses.free;
        };
      }) {};
    rudel = callPackage ({ cl-generic
                         , cl-lib ? null
                         , cl-print ? null
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , lib }:
      elpaBuild {
        pname = "rudel";
        ename = "rudel";
        version = "0.3.2.0.20221212.230154";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/rudel-0.3.2.0.20221212.230154.tar";
          sha256 = "1q3a4j14ww5wjyxr8b7ksqcckvm8cx44jy9sl117s7g9if48yn03";
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
        version = "0.2.0.20220223.202624";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/satchel-0.2.0.20220223.202624.tar";
          sha256 = "0akcfjfw69r504qkcwr81vrxjhvkpmf19vy9d0dzlgc9v5m3p1h1";
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
        version = "0.2.0.20210104.105054";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/scanner-0.2.0.20210104.105054.tar";
          sha256 = "1az7rg4n744ya0ba9fcggqhm3mjhpzwzhygyracsx7n5gry5slgv";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/scanner.html";
          license = lib.licenses.free;
        };
      }) {};
    scroll-restore = callPackage ({ elpaBuild
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "scroll-restore";
        ename = "scroll-restore";
        version = "1.0.0.20221221.81959";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/scroll-restore-1.0.0.20221221.81959.tar";
          sha256 = "08x45fk4m4pg33rdy911hhmnp5kvx2l1dq94s108nk5wznbzx578";
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
        version = "1.1.0.20230721.154631";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sed-mode-1.1.0.20230721.154631.tar";
          sha256 = "1mp4xyca7g29vn5c7dl3dw3ng9n5kiryvdgrmqrha13ppyqqzd5x";
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
        version = "2.23.0.20221221.82021";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/seq-2.23.0.20221221.82021.tar";
          sha256 = "0v9zg4csf8r6ficdc9y418dw6w3zc2vmr4m6ayxybh5iawzpnlrg";
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
        version = "1.3.2.0.20230316.95834";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/setup-1.3.2.0.20230316.95834.tar";
          sha256 = "1vbl9hxhy4nf4an4ibgcmv06l74a32rzi8qv7bjfh8k5f10h5ndv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/setup.html";
          license = lib.licenses.free;
        };
      }) {};
    shelisp = callPackage ({ elpaBuild
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "shelisp";
        ename = "shelisp";
        version = "1.0.0.0.20221212.230255";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/shelisp-1.0.0.0.20221212.230255.tar";
          sha256 = "0n673afq17fp3h3chs0acszv72dkqj9yd5x2ll6jgkyk74dka0fm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shelisp.html";
          license = lib.licenses.free;
        };
      }) {};
    shell-command-plus = callPackage ({ elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib }:
      elpaBuild {
        pname = "shell-command-plus";
        ename = "shell-command+";
        version = "2.4.2.0.20230311.131100";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/shell-command+-2.4.2.0.20230311.131100.tar";
          sha256 = "03nlyl4r5dm2hr3j0z1qw3s2v4zf0qvij350caalm08qmc9apama";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shell-command+.html";
          license = lib.licenses.free;
        };
      }) {};
    shell-quasiquote = callPackage ({ elpaBuild
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "shell-quasiquote";
        ename = "shell-quasiquote";
        version = "0.0.20221221.82030";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/shell-quasiquote-0.0.20221221.82030.tar";
          sha256 = "1mvz4y9jkkp96cf0ppmpzdzh86q1xrhx6yb9l93941qm33j0z4p8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shell-quasiquote.html";
          license = lib.licenses.free;
        };
      }) {};
    shen-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "shen-mode";
        ename = "shen-mode";
        version = "0.1.0.20221221.82050";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/shen-mode-0.1.0.20221221.82050.tar";
          sha256 = "1r0kgk46hk2dk0923az6g44bmikrb2dxn9p5v4a9r1680yfgf0bn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/shen-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    sisu-mode = callPackage ({ elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "sisu-mode";
        ename = "sisu-mode";
        version = "7.1.8.0.20221221.82114";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sisu-mode-7.1.8.0.20221221.82114.tar";
          sha256 = "18l11bvwp57gjh4v5w6pdslqbdc250hidrj5nlm4p5rfll5647ri";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sisu-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    site-lisp = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "site-lisp";
        ename = "site-lisp";
        version = "0.1.1.0.20230423.152517";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/site-lisp-0.1.1.0.20230423.152517.tar";
          sha256 = "1kx5zcd38m806piz3k1zqjykw5m5rwgs7lmz43rr46d3q920kniw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/site-lisp.html";
          license = lib.licenses.free;
        };
      }) {};
    sketch-mode = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "sketch-mode";
        ename = "sketch-mode";
        version = "1.0.4.0.20230420.122954";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sketch-mode-1.0.4.0.20230420.122954.tar";
          sha256 = "1vyzwrph9ifqbwlqprglk1fnlx9hnxm0caq9bxk9az8h021zzzha";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sketch-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    slime-volleyball = callPackage ({ cl-lib ? null
                                    , elpaBuild
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "slime-volleyball";
        ename = "slime-volleyball";
        version = "1.2.0.0.20221221.82156";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/slime-volleyball-1.2.0.0.20221221.82156.tar";
          sha256 = "0ys6r0vg43x0hdfc9kl2s8djk8zd4253x93prhbcakpsa7p4jb5v";
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
        version = "1.1.0.20221221.82204";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sm-c-mode-1.1.0.20221221.82204.tar";
          sha256 = "0zdzncy64b2d2kp7bnlr6vk30ajbhmzzmvvdkbbacc3n03bpdv7d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sm-c-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    smalltalk-mode = callPackage ({ elpaBuild
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "smalltalk-mode";
        ename = "smalltalk-mode";
        version = "4.0.0.20221221.82225";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/smalltalk-mode-4.0.0.20221221.82225.tar";
          sha256 = "0na04h27bxy6mqdx7mp5ys4bjvpmxfp19nh40jh6j584dchb8y3k";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/smalltalk-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    smart-yank = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "smart-yank";
        ename = "smart-yank";
        version = "0.1.1.0.20221221.82231";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/smart-yank-0.1.1.0.20221221.82231.tar";
          sha256 = "1dhnzvw3igrzp12lcbqp9dpmzidawhyc9a5ryyp29qxqh539c2qm";
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
        version = "6.12.0.20230411.5343";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sml-mode-6.12.0.20230411.5343.tar";
          sha256 = "0qq1naxx7hhfi5q78vnw0s9vw6aign8kb08vlcj45xz4sp2w4nlj";
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
        version = "1.1.2.0.20230101.53112";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/so-long-1.1.2.0.20230101.53112.tar";
          sha256 = "03difjd7hd72a01b97sr30y2wk49nrh4imrlf0vfzgfii96n8k6i";
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
        version = "3.2.3.0.20230512.51050";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/soap-client-3.2.3.0.20230512.51050.tar";
          sha256 = "0cghw13gh8ck7p1kb5bxffqj98i4dnsvw6qbzl3fnh61libfpx7a";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/soap-client.html";
          license = lib.licenses.free;
        };
      }) {};
    sokoban = callPackage ({ cl-lib ? null
                           , elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "sokoban";
        ename = "sokoban";
        version = "1.4.9.0.20220928.185052";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sokoban-1.4.9.0.20220928.185052.tar";
          sha256 = "19df4wdhrpn1rb927jg131hjwackaldra1rvxaq31zfd3rlj4dp8";
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
        version = "1.6.2.0.20220909.50328";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sotlisp-1.6.2.0.20220909.50328.tar";
          sha256 = "14jlvdhncm7fp5ajnzp931gbpnqg97ysiis0ajwkmwan3mmxlv89";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sotlisp.html";
          license = lib.licenses.free;
        };
      }) {};
    spacious-padding = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "spacious-padding";
        ename = "spacious-padding";
        version = "0.1.0.0.20230606.175440";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/spacious-padding-0.1.0.0.20230606.175440.tar";
          sha256 = "01541k8j5g920vnj3ds6ancqyi36n6ak00g4rq5vc6ia1ybxiijh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spacious-padding.html";
          license = lib.licenses.free;
        };
      }) {};
    spinner = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spinner";
        ename = "spinner";
        version = "1.7.4.0.20220915.94959";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/spinner-1.7.4.0.20220915.94959.tar";
          sha256 = "0n5xmq7iay11pxlj5av4wnx477jz48ac87838pppks9mmsaj24a7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spinner.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-beeline = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "sql-beeline";
        ename = "sql-beeline";
        version = "0.2.0.20221221.82329";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sql-beeline-0.2.0.20221221.82329.tar";
          sha256 = "0lfn5nvv2xns1l71as5vvsiyspn1d50rh9ki2sihhjs6rx8mprnw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-beeline.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-cassandra = callPackage ({ elpaBuild
                                 , emacs
                                 , fetchurl
                                 , lib }:
      elpaBuild {
        pname = "sql-cassandra";
        ename = "sql-cassandra";
        version = "0.2.2.0.20221221.82336";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sql-cassandra-0.2.2.0.20221221.82336.tar";
          sha256 = "1daljwlbs6ng64rcmpgzf5ac8diaapraqwc7j2f3v6z6rw261f97";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-cassandra.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-indent = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "sql-indent";
        ename = "sql-indent";
        version = "1.6.0.20220728.130257";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sql-indent-1.6.0.20220728.130257.tar";
          sha256 = "0l9dl2h7c034frdk59yh443zxblj2ry43v8dwp3mf6d3zgllvnwk";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-smie = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sql-smie";
        ename = "sql-smie";
        version = "0.0.20221221.82351";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sql-smie-0.0.20221221.82351.tar";
          sha256 = "0pl47qr62gxjnwhf5ryc9xkbf75pr8fvqzi050c1g17jxjmbjfqa";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-smie.html";
          license = lib.licenses.free;
        };
      }) {};
    srht = callPackage ({ elpaBuild, emacs, fetchurl, lib, plz }:
      elpaBuild {
        pname = "srht";
        ename = "srht";
        version = "0.2.0.20221114.63606";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/srht-0.2.0.20221114.63606.tar";
          sha256 = "0y3xl9l0c7mjppsglwnbawrq4wx402mjvgnim2ilw1d7568ahi9i";
        };
        packageRequires = [ emacs plz ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/srht.html";
          license = lib.licenses.free;
        };
      }) {};
    ssh-deploy = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "ssh-deploy";
        ename = "ssh-deploy";
        version = "3.1.16.0.20230702.92809";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ssh-deploy-3.1.16.0.20230702.92809.tar";
          sha256 = "1kbwvfkz74q8qfk6735hhi1mwdijvgrhqvwjfnfv8x8sr73yldkp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ssh-deploy.html";
          license = lib.licenses.free;
        };
      }) {};
    standard-themes = callPackage ({ elpaBuild
                                   , emacs
                                   , fetchurl
                                   , lib }:
      elpaBuild {
        pname = "standard-themes";
        ename = "standard-themes";
        version = "1.2.0.0.20230825.34554";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/standard-themes-1.2.0.0.20230825.34554.tar";
          sha256 = "10w1mwfzlcbmss6pm9yph5gq2xz5bcgqy9ji4ssazcg76dyj3r75";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/standard-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    stream = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "stream";
        ename = "stream";
        version = "2.2.5.0.20221221.82401";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/stream-2.2.5.0.20221221.82401.tar";
          sha256 = "0m23a2dmhj37z3x42s3fxaq2r6n6zbic89vqd38w22ww6pm8i47d";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/stream.html";
          license = lib.licenses.free;
        };
      }) {};
    substitute = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "substitute";
        ename = "substitute";
        version = "0.2.1.0.20230704.110210";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/substitute-0.2.1.0.20230704.110210.tar";
          sha256 = "0r3fwndzgz1xl0r607mnvjjmw5g1cf7qg2gvwsyrzdn6hrs786zj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/substitute.html";
          license = lib.licenses.free;
        };
      }) {};
    svg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "svg";
        ename = "svg";
        version = "1.1.0.20230101.53112";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/svg-1.1.0.20230101.53112.tar";
          sha256 = "0hd4xha8fhxx7ahirp3s03ylz13xdsdgy4bix6d0vhmz0hpiiwk8";
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
        version = "1.2.0.20221221.82408";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/svg-clock-1.2.0.20221221.82408.tar";
          sha256 = "1ymg49fkacpay624dr0b5ggha68j83qlcca7jnidmm1v6cxq753j";
        };
        packageRequires = [ emacs svg ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-clock.html";
          license = lib.licenses.free;
        };
      }) {};
    svg-lib = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib }:
      elpaBuild {
        pname = "svg-lib";
        ename = "svg-lib";
        version = "0.2.7.0.20230619.143402";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/svg-lib-0.2.7.0.20230619.143402.tar";
          sha256 = "1h4knhasimf496qhlvm132cghpam303vl9mbdg4p3ld5jcd6ghz5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-lib.html";
          license = lib.licenses.free;
        };
      }) {};
    svg-tag-mode = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , svg-lib }:
      elpaBuild {
        pname = "svg-tag-mode";
        ename = "svg-tag-mode";
        version = "0.3.2.0.20230824.94303";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/svg-tag-mode-0.3.2.0.20230824.94303.tar";
          sha256 = "18pdzq1k3qign1rjfasfv4wfhiacgn2afycpfw5cxpdazx6hycv3";
        };
        packageRequires = [ emacs svg-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-tag-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    swiper = callPackage ({ elpaBuild
                          , emacs
                          , fetchurl
                          , ivy
                          , lib }:
      elpaBuild {
        pname = "swiper";
        ename = "swiper";
        version = "0.14.0.0.20230410.182739";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/swiper-0.14.0.0.20230410.182739.tar";
          sha256 = "10vqxmqdzvr7rg6wg5whzl4w9y4j47m330fx7qgvzi5zw28b69f3";
        };
        packageRequires = [ emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swiper.html";
          license = lib.licenses.free;
        };
      }) {};
    switchy-window = callPackage ({ compat
                                  , elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "switchy-window";
        ename = "switchy-window";
        version = "1.3.0.20230411.180529";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/switchy-window-1.3.0.20230411.180529.tar";
          sha256 = "1x2y6rgbkj11c53kxybz3xslbaszm3pr6xzsx4s17sq1w4vv6dc4";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/switchy-window.html";
          license = lib.licenses.free;
        };
      }) {};
    sxhkdrc-mode = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "sxhkdrc-mode";
        ename = "sxhkdrc-mode";
        version = "1.0.0.0.20230210.123052";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/sxhkdrc-mode-1.0.0.0.20230210.123052.tar";
          sha256 = "00449dipkxpl4ddv5cjzvsahig23wl2f9p42zpqjfsvvg2gcklk8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sxhkdrc-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    system-packages = callPackage ({ elpaBuild
                                   , emacs
                                   , fetchurl
                                   , lib }:
      elpaBuild {
        pname = "system-packages";
        ename = "system-packages";
        version = "1.0.12.0.20230805.22742";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/system-packages-1.0.12.0.20230805.22742.tar";
          sha256 = "08y4iclq1gapp8xcdnx9znyxjjj1msv9kac87r3fi2vis3kyhn5n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/system-packages.html";
          license = lib.licenses.free;
        };
      }) {};
    systemd = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "systemd";
        ename = "systemd";
        version = "0.0.20221221.82418";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/systemd-0.0.20221221.82418.tar";
          sha256 = "0df7y6ymx7gwlksa79h36ds6ap0c6mdnvw4nlj5qr54r2ri2rv1z";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/systemd.html";
          license = lib.licenses.free;
        };
      }) {};
    tNFA = callPackage ({ elpaBuild, fetchurl, lib, queue }:
      elpaBuild {
        pname = "tNFA";
        ename = "tNFA";
        version = "0.1.1.0.20170804.211606";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tNFA-0.1.1.0.20170804.211606.tar";
          sha256 = "0h282s6lkpsxvjgajfraj9dbj3ac1amg3s0q3d6knr1xfwhi29zz";
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
        version = "0.10.1.0.20220919.160646";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/taxy-0.10.1.0.20220919.160646.tar";
          sha256 = "03f3rwj01jqfz9pyr2wnd1qkg8165276l1pqlcdyaw7idvd4fc2i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/taxy.html";
          license = lib.licenses.free;
        };
      }) {};
    taxy-magit-section = callPackage ({ elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib
                                      , magit-section
                                      , taxy }:
      elpaBuild {
        pname = "taxy-magit-section";
        ename = "taxy-magit-section";
        version = "0.12.2.0.20230223.182024";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/taxy-magit-section-0.12.2.0.20230223.182024.tar";
          sha256 = "1gd2z5rhns8d2bkz86h2j51xhxcpiqfmzllpz7mn3s7pfnfrva8w";
        };
        packageRequires = [ emacs magit-section taxy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/taxy-magit-section.html";
          license = lib.licenses.free;
        };
      }) {};
    temp-buffer-browse = callPackage ({ elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib }:
      elpaBuild {
        pname = "temp-buffer-browse";
        ename = "temp-buffer-browse";
        version = "1.5.0.20160804.124501";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/temp-buffer-browse-1.5.0.20160804.124501.tar";
          sha256 = "060pbrrb33n5ghmyhblkl0paqj4m3g4028nwz65zxbd7irrj0fxz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/temp-buffer-browse.html";
          license = lib.licenses.free;
        };
      }) {};
    tempel = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tempel";
        ename = "tempel";
        version = "0.8.0.20230810.233751";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tempel-0.8.0.20230810.233751.tar";
          sha256 = "0m982zs65vpk1sp9sasy4jpy3l4npqw6hzxn7687d0gplnjs1agw";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tempel.html";
          license = lib.licenses.free;
        };
      }) {};
    test-simple = callPackage ({ cl-lib ? null
                               , elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "test-simple";
        ename = "test-simple";
        version = "1.3.0.0.20200722.214339";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/test-simple-1.3.0.0.20200722.214339.tar";
          sha256 = "0q7b6y7qw8arhcx0cmhx0y1bmj84zk0nqjlgvra9bav07wb9xxm9";
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
        version = "1.4.2.0.20221221.82440";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/timerfunctions-1.4.2.0.20221221.82440.tar";
          sha256 = "1bsqyf7v7ngk1pwxk4cgf35r019bnbvx6wrs3l1fvgmw1zgkqkqv";
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
        version = "0.2.1.0.20220910.192941";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tiny-0.2.1.0.20220910.192941.tar";
          sha256 = "17wp68apkd57g4sm7lvr6iv527rkb8x3smz2lqns6yggrg64c1j2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tiny.html";
          license = lib.licenses.free;
        };
      }) {};
    tmr = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tmr";
        ename = "tmr";
        version = "0.4.0.0.20230228.202513";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tmr-0.4.0.0.20230228.202513.tar";
          sha256 = "0xll0inryq2ajavnshpxrn3pjcraqbfmhyb0r9k15w3m6x4g38xk";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tmr.html";
          license = lib.licenses.free;
        };
      }) {};
    tomelr = callPackage ({ elpaBuild, emacs, fetchurl, lib, map, seq }:
      elpaBuild {
        pname = "tomelr";
        ename = "tomelr";
        version = "0.4.3.0.20220511.213722";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tomelr-0.4.3.0.20220511.213722.tar";
          sha256 = "15rx89phls3hk0f2rfwpzb7igzyjvaiqasn9yvhwrmpq92dpd6hn";
        };
        packageRequires = [ emacs map seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tomelr.html";
          license = lib.licenses.free;
        };
      }) {};
    topspace = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "topspace";
        ename = "topspace";
        version = "0.3.1.0.20230106.94110";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/topspace-0.3.1.0.20230106.94110.tar";
          sha256 = "188q0jw3frbk6y37qxrq17dx3lfrwcac501z90cq8px6d0j3aq4k";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/topspace.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp = callPackage ({ elpaBuild
                         , emacs
                         , fetchurl
                         , lib }:
      elpaBuild {
        pname = "tramp";
        ename = "tramp";
        version = "2.6.1.1.1.0.20230807.151320";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tramp-2.6.1.1.1.0.20230807.151320.tar";
          sha256 = "03ng854qza04hqdi6bl3wa1ppi6djlv1bq6ws2g36gi11drbd5d2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp-nspawn = callPackage ({ elpaBuild
                                , emacs
                                , fetchurl
                                , lib }:
      elpaBuild {
        pname = "tramp-nspawn";
        ename = "tramp-nspawn";
        version = "1.0.1.0.20220923.120957";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tramp-nspawn-1.0.1.0.20220923.120957.tar";
          sha256 = "11pjgxxyx5gx8xqj8nd8blg0998m57n3s7ydg17z4flfpizbycck";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp-nspawn.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp-theme = callPackage ({ elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "tramp-theme";
        ename = "tramp-theme";
        version = "0.2.0.20221221.82451";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tramp-theme-0.2.0.20221221.82451.tar";
          sha256 = "1bjfxs20gicn71q8lznmxj4665hv8vc5spj19jkvvhm16r7nh7mp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tramp-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    transcribe = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "transcribe";
        ename = "transcribe";
        version = "1.5.2.0.20221221.82457";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/transcribe-1.5.2.0.20221221.82457.tar";
          sha256 = "0a5ld8ylsp4ahw4blxchbsynhr8ph651a1lhs0nrx6j2fh85jxqh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transcribe.html";
          license = lib.licenses.free;
        };
      }) {};
    transient = callPackage ({ compat
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "transient";
        ename = "transient";
        version = "0.4.3.0.20230825.201957";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/transient-0.4.3.0.20230825.201957.tar";
          sha256 = "1g39zmlpk2rc49m4swjsq321hpdrkgxaxw4jlw9rwky0q9s8q39y";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transient.html";
          license = lib.licenses.free;
        };
      }) {};
    transient-cycles = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "transient-cycles";
        ename = "transient-cycles";
        version = "1.0.0.20220410.130412";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/transient-cycles-1.0.0.20220410.130412.tar";
          sha256 = "19pxd5s4ms9izj22v5abar7g12pn72vh870pmgh80d6kd8l9ifam";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transient-cycles.html";
          license = lib.licenses.free;
        };
      }) {};
    tree-inspector = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib
                                  , treeview }:
      elpaBuild {
        pname = "tree-inspector";
        ename = "tree-inspector";
        version = "0.3.0.20230505.172252";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/tree-inspector-0.3.0.20230505.172252.tar";
          sha256 = "0hk961pkpnyyk9jxsd52hqhhx7gvgp8680ypc2d96ylxs6mfvkjx";
        };
        packageRequires = [ emacs treeview ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tree-inspector.html";
          license = lib.licenses.free;
        };
      }) {};
    trie = callPackage ({ elpaBuild, fetchurl, heap, lib, tNFA }:
      elpaBuild {
        pname = "trie";
        ename = "trie";
        version = "0.5.0.20201214.113408";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/trie-0.5.0.20201214.113408.tar";
          sha256 = "0z7nagf0fyd0qi4fnc04b2dp03xiwaw97c8lrqd6ii2vvnbxiw84";
        };
        packageRequires = [ heap tNFA ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/trie.html";
          license = lib.licenses.free;
        };
      }) {};
    triples = callPackage ({ elpaBuild
                           , emacs
                           , fetchurl
                           , lib
                           , seq }:
      elpaBuild {
        pname = "triples";
        ename = "triples";
        version = "0.3.5.0.20230809.231343";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/triples-0.3.5.0.20230809.231343.tar";
          sha256 = "0fhwwagwghygg64p05r5vzj6vd2n9inv8v53y2mfjxvsbbz463rc";
        };
        packageRequires = [ emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/triples.html";
          license = lib.licenses.free;
        };
      }) {};
    typo = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "typo";
        ename = "typo";
        version = "1.0.1.0.20230725.200324";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/typo-1.0.1.0.20230725.200324.tar";
          sha256 = "01280xwdm1n0x1n4avhy0zh6xl8dhxvzskhdarknszqz6yhxrc9x";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/typo.html";
          license = lib.licenses.free;
        };
      }) {};
    ulisp-repl = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "ulisp-repl";
        ename = "ulisp-repl";
        version = "1.0.3.0.20230604.111559";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ulisp-repl-1.0.3.0.20230604.111559.tar";
          sha256 = "1lay2sqi2ncwvrzs39wjd9fl66vsnxis9q6g7cyjqi4y667jg62s";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ulisp-repl.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-tree = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib
                             , queue }:
      elpaBuild {
        pname = "undo-tree";
        ename = "undo-tree";
        version = "0.8.2.0.20220312.180415";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/undo-tree-0.8.2.0.20220312.180415.tar";
          sha256 = "0ldvyaim7n8gs8775fv9a0q6lp67ynkapj82pnqywniqy2p2vr1m";
        };
        packageRequires = [ emacs queue ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/undo-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    uni-confusables = callPackage ({ elpaBuild
                                   , fetchurl
                                   , lib }:
      elpaBuild {
        pname = "uni-confusables";
        ename = "uni-confusables";
        version = "0.3.0.20221212.230830";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/uni-confusables-0.3.0.20221212.230830.tar";
          sha256 = "0xa7byw8b371wm35g0250mz7xvcgbdms1x32grwqp4zhm9dh7jg8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uni-confusables.html";
          license = lib.licenses.free;
        };
      }) {};
    uniquify-files = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "uniquify-files";
        ename = "uniquify-files";
        version = "1.0.4.0.20221221.82507";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/uniquify-files-1.0.4.0.20221221.82507.tar";
          sha256 = "1hhf0zb85y1p1a54y8jq6jzlmdgd23rja2pp461lwf0i1wkfjibq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uniquify-files.html";
          license = lib.licenses.free;
        };
      }) {};
    urgrep = callPackage ({ compat
                          , elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , project }:
      elpaBuild {
        pname = "urgrep";
        ename = "urgrep";
        version = "0.2.0snapshot0.20230821.140956";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/urgrep-0.2.0snapshot0.20230821.140956.tar";
          sha256 = "0qx2qhd9dckagzj1vssi9kbmnzylj08d5sqhfr75pah05bb3b1sq";
        };
        packageRequires = [ compat emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/urgrep.html";
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
        version = "2.0.4.0.20221221.82537";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/url-http-ntlm-2.0.4.0.20221221.82537.tar";
          sha256 = "0j67dwalw22ykdkvp5qf03b54gimx855c0aasfdi271hq9hi8jm2";
        };
        packageRequires = [ cl-lib ntlm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-http-ntlm.html";
          license = lib.licenses.free;
        };
      }) {};
    url-http-oauth = callPackage ({ elpaBuild
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "url-http-oauth";
        ename = "url-http-oauth";
        version = "0.8.3.0.20230510.175959";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/url-http-oauth-0.8.3.0.20230510.175959.tar";
          sha256 = "02ml5wsqzzwxaf779hkgbbdjp7hvf6x43cr1j2aciw2hn29ikbcg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-http-oauth.html";
          license = lib.licenses.free;
        };
      }) {};
    url-scgi = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "url-scgi";
        ename = "url-scgi";
        version = "0.9.0.20230130.74744";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/url-scgi-0.9.0.20230130.74744.tar";
          sha256 = "1y8amwx2pdcnzd0ywfxlh2wzjfb3kan9wdy5cgibzvrqgc85npxi";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-scgi.html";
          license = lib.licenses.free;
        };
      }) {};
    use-package = callPackage ({ bind-key
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "use-package";
        ename = "use-package";
        version = "2.4.5.0.20230115.133305";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/use-package-2.4.5.0.20230115.133305.tar";
          sha256 = "1xjyhd6wkf1z4jx7ffh1y6kk8yi44h4qrckwybwfj6zhiil42cjq";
        };
        packageRequires = [ bind-key emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/use-package.html";
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
        version = "1.0.4.0.20180215.204244";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/validate-1.0.4.0.20180215.204244.tar";
          sha256 = "0mmfwv5g4661r300d8lj907ynkdhjddvm5nca3s5zq7zv4ii0sd0";
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
        version = "3.1.1.0.20210501.211155";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/valign-3.1.1.0.20210501.211155.tar";
          sha256 = "1k9kqfbcc3glwn3n9l4hfflzqwl144r4zrxgprha3ya04y9ka91x";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/valign.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-backup = callPackage ({ compat
                             , elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "vc-backup";
        ename = "vc-backup";
        version = "1.1.0.0.20220825.144758";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vc-backup-1.1.0.0.20220825.144758.tar";
          sha256 = "1mrk1f9ajdpdkqmwwha4qw4d8dxxbx3k7la31z118j04g8x5lqh4";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-backup.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-got = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vc-got";
        ename = "vc-got";
        version = "1.2.0.20230129.104658";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vc-got-1.2.0.20230129.104658.tar";
          sha256 = "0r3jny1yhl9swrpbif46mjx6c2c84pwnh4byffasmgdamic9w5w8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vc-got.html";
          license = lib.licenses.free;
        };
      }) {};
    vc-hgcmd = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "vc-hgcmd";
        ename = "vc-hgcmd";
        version = "1.14.1.0.20230605.161947";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vc-hgcmd-1.14.1.0.20230605.161947.tar";
          sha256 = "0mv2n5xhilq5vc0k4iahk3fs0skdcshvmdyynqyy6ii764zmmg87";
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
        version = "0.2.2.0.20230718.145809";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vcard-0.2.2.0.20230718.145809.tar";
          sha256 = "0b3pxl03kjdyi70hnnf5sb2jvrkhnk0srsn2gr555y9kfbgzwwj1";
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
        version = "1.1.0.20201127.191542";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vcl-mode-1.1.0.20201127.191542.tar";
          sha256 = "0ps87hxxm99wilc3ylv9i4b0035lg5i5df0i491m10z3x02i503p";
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
        version = "0.2.4.0.20230620.220116";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vdiff-0.2.4.0.20230620.220116.tar";
          sha256 = "17767yyim333xwgzn3kb2l58z1w4wh55s45a5y1jv12ilfi08cnq";
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
        version = "2023.6.6.141322628.0.20230606.214619";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/verilog-mode-2023.6.6.141322628.0.20230606.214619.tar";
          sha256 = "1gm5p32kcg9nisbic5pfnbyy5hmj598s6wma285x8hpd0fhypgn5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/verilog-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    vertico = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vertico";
        ename = "vertico";
        version = "1.4.0.20230825.92114";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vertico-1.4.0.20230825.92114.tar";
          sha256 = "16kqsc82fas9pnhhmhgdnn0nqp26syl974yfczxc3qpfbapvh5nj";
        };
        packageRequires = [ compat emacs ];
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
        version = "0.7.3.0.20230818.15224";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vertico-posframe-0.7.3.0.20230818.15224.tar";
          sha256 = "0q23yw8dy9abawqlcpwjrk668kvxyffv972j0s6579z37i643gv6";
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
        version = "1.0.0.20221221.82600";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vigenere-1.0.0.20221221.82600.tar";
          sha256 = "1snis37kp1zabydrwsvb7fh15ps4cs2vhn80xhxj4dcyp597q44v";
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
        version = "1.2.0.20221221.82606";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/visual-filename-abbrev-1.2.0.20221221.82606.tar";
          sha256 = "1jq6c1fzm6r73j6g2m7in6cly3pm9zyqldc67paqldalhg9kfda5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/visual-filename-abbrev.html";
          license = lib.licenses.free;
        };
      }) {};
    visual-fill = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "visual-fill";
        ename = "visual-fill";
        version = "0.1.0.20201201.173845";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/visual-fill-0.1.0.20201201.173845.tar";
          sha256 = "10wf6w2mjmhj7blxh76j0k0czjv4ww307pa99vp9xgcg63pcbbp6";
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
        version = "1.7.2.0.20201128.5141";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vlf-1.7.2.0.20201128.5141.tar";
          sha256 = "12m43ykq92hfnq91z27sabzj7gbjpl624k7acpg641909hm5nq1b";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vlf.html";
          license = lib.licenses.free;
        };
      }) {};
    vundo = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vundo";
        ename = "vundo";
        version = "2.1.0.0.20230619.221715";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/vundo-2.1.0.0.20230619.221715.tar";
          sha256 = "1vl1wfk68fy9jcr8dm673g8qbf5ax557fpb5wwpijffrsyss9qzk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vundo.html";
          license = lib.licenses.free;
        };
      }) {};
    wcheck-mode = callPackage ({ elpaBuild
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "wcheck-mode";
        ename = "wcheck-mode";
        version = "2021.0.20220101.81620";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/wcheck-mode-2021.0.20220101.81620.tar";
          sha256 = "0bk9w274k0rfmlxv5m9mxqy7ab8zdzk0sw4baqh73hvn8z3li8sp";
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
        version = "0.2.1.0.20201202.220257";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/wconf-0.2.1.0.20201202.220257.tar";
          sha256 = "06ghn72l2fwn0ys2iakgw1xqalip31yi0449c26rad8gaz6y7vxl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wconf.html";
          license = lib.licenses.free;
        };
      }) {};
    web-server = callPackage ({ cl-lib ? null
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "web-server";
        ename = "web-server";
        version = "0.1.2.0.20210811.22503";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/web-server-0.1.2.0.20210811.22503.tar";
          sha256 = "0pvmlv74hy7ybnl0014ml7c314an2vc2z6fkizw06zr27x22jpvl";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-server.html";
          license = lib.licenses.free;
        };
      }) {};
    webfeeder = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "webfeeder";
        ename = "webfeeder";
        version = "1.1.2.0.20210605.74155";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/webfeeder-1.1.2.0.20210605.74155.tar";
          sha256 = "0716x9a83wv41p3hz4qllrrv2w5jrw4xvb2fhi8kxaxrjhq989d9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/webfeeder.html";
          license = lib.licenses.free;
        };
      }) {};
    websocket = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "websocket";
        ename = "websocket";
        version = "1.15.0.20230808.230535";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/websocket-1.15.0.20230808.230535.tar";
          sha256 = "1li62x00jirf3z0llx262j6galpsvbcrq4daybnfkskmj4br5lhp";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/websocket.html";
          license = lib.licenses.free;
        };
      }) {};
    which-key = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "which-key";
        ename = "which-key";
        version = "3.6.0.0.20230712.175108";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/which-key-3.6.0.0.20230712.175108.tar";
          sha256 = "1m28fq9swmzwh5vqhg79zjwis6yxyjc3z48xp0m1m97aw2r63n33";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/which-key.html";
          license = lib.licenses.free;
        };
      }) {};
    window-commander = callPackage ({ elpaBuild
                                    , emacs
                                    , fetchurl
                                    , lib }:
      elpaBuild {
        pname = "window-commander";
        ename = "window-commander";
        version = "3.0.2.0.20230630.142949";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/window-commander-3.0.2.0.20230630.142949.tar";
          sha256 = "0sr29bslv9b2avsb6s0ln7j19zbrfvk2xbxgylxi3r43nhm4lmy5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/window-commander.html";
          license = lib.licenses.free;
        };
      }) {};
    windower = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , lib }:
      elpaBuild {
        pname = "windower";
        ename = "windower";
        version = "0.0.1.0.20200212.91532";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/windower-0.0.1.0.20200212.91532.tar";
          sha256 = "0005r5xgi7h7i0lbdxbsfs7hvdx4isan6df283xflxs0qv3hwpql";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/windower.html";
          license = lib.licenses.free;
        };
      }) {};
    windresize = callPackage ({ elpaBuild
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "windresize";
        ename = "windresize";
        version = "0.1.0.20221221.82616";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/windresize-0.1.0.20221221.82616.tar";
          sha256 = "16s4vxzjcjl5ahpfwzrr4z59mq0w0vb56ip3r5ky13xs3p5q2xl8";
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
        version = "4.2.2.0.20230126.2042";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/wisi-4.2.2.0.20230126.2042.tar";
          sha256 = "0b70yipm6wmz5034f5l7f78c2bgscm2c8lph75jgd5x1qwzngw47";
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
        version = "1.3.0.0.20230125.102656";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/wisitoken-grammar-mode-1.3.0.0.20230125.102656.tar";
          sha256 = "1h5pnghxg01f0hgxw7284b4rm5c43r48nbsxj19dcypxrzz3w1qw";
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
        version = "1.1.0.20221221.82918";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/wpuzzle-1.1.0.20221221.82918.tar";
          sha256 = "16mdd7cyzbhipr934cps8qjpgsr9wwnrd81yaca356wq0cwafhvb";
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
        version = "1.11.0.20221221.82941";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xclip-1.11.0.20221221.82941.tar";
          sha256 = "09dkxgd3bcn8pfw441jq73k49l6m467w89l2xwzb2zb24qpd78ic";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xclip.html";
          license = lib.licenses.free;
        };
      }) {};
    xeft = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xeft";
        ename = "xeft";
        version = "3.3.0.20230724.143339";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xeft-3.3.0.20230724.143339.tar";
          sha256 = "1q440lab148nwvvix29iyzjmknf243wam9cqsfz0vk1az7rp7pmb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xeft.html";
          license = lib.licenses.free;
        };
      }) {};
    xelb = callPackage ({ cl-generic, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xelb";
        ename = "xelb";
        version = "0.18.0.20200719.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xelb-0.18.0.20200719.0.tar";
          sha256 = "195zxjkrw9rmnzprvdr21pngfkwl7lcn0bnjqzywwaq19zb4c2rs";
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
        version = "1.0.5.0.20221221.82958";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xpm-1.0.5.0.20221221.82958.tar";
          sha256 = "0c1hrqb203cl44z0sasfx6d315n2cqwf3lc0l29r63lsh0sd5gfp";
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
        version = "1.24.0.20230816.133012";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xr-1.24.0.20230816.133012.tar";
          sha256 = "0fpj8sp2g54is8cz6sj93jc6cfsxfjzn8nzxz73r3fj66lcklcxz";
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
        version = "1.6.3.0.20230812.3932";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xref-1.6.3.0.20230812.3932.tar";
          sha256 = "0dd6mmacpf1bv605dghbanilv86aaqwikbq8il3p27zcld94q8jb";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref.html";
          license = lib.licenses.free;
        };
      }) {};
    xref-union = callPackage ({ elpaBuild
                              , emacs
                              , fetchurl
                              , lib }:
      elpaBuild {
        pname = "xref-union";
        ename = "xref-union";
        version = "0.1.1.0.20230325.142012";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/xref-union-0.1.1.0.20230325.142012.tar";
          sha256 = "0y879hqq9l6siiyl84k12a943j3130cdfxw34m8hhgpmxn2qccky";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref-union.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet = callPackage ({ cl-lib ? null
                             , elpaBuild
                             , fetchurl
                             , lib }:
      elpaBuild {
        pname = "yasnippet";
        ename = "yasnippet";
        version = "0.14.0.0.20210502.75302";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/yasnippet-0.14.0.0.20210502.75302.tar";
          sha256 = "17xaw27b7sjpb6j4jhfdr9vgd5r6gqhavwfn2zwhqnnc4qmvnj4k";
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
        version = "1.0.2.0.20221221.83103";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/yasnippet-classic-snippets-1.0.2.0.20221221.83103.tar";
          sha256 = "1gy67f796pvaqckhbb9p05pn7f7d70ps7z0f1bg35156m3dfj7ff";
        };
        packageRequires = [ yasnippet ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet-classic-snippets.html";
          license = lib.licenses.free;
        };
      }) {};
    zones = callPackage ({ elpaBuild
                         , fetchurl
                         , lib }:
      elpaBuild {
        pname = "zones";
        ename = "zones";
        version = "2019.7.13.0.20221212.231608";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/zones-2019.7.13.0.20221212.231608.tar";
          sha256 = "1z7r295c2l1hxpz587szzbyxhig3b9siicwf3j1b31s8csdjzkvl";
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
        version = "1.0.6.0.20230617.194317";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/ztree-1.0.6.0.20230617.194317.tar";
          sha256 = "1sgii6lf06dqhld67vhac1319nbjrrd9npm2z8aysxg6hs26hfab";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ztree.html";
          license = lib.licenses.free;
        };
      }) {};
    zuul = callPackage ({ elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "zuul";
        ename = "zuul";
        version = "0.4.0.0.20230524.131806";
        src = fetchurl {
          url = "https://elpa.gnu.org/devel/zuul-0.4.0.0.20230524.131806.tar";
          sha256 = "0yand8b9givmwr8b3y8da4qwxq2j0kjyfzigwydf0lmc96nix777";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zuul.html";
          license = lib.licenses.free;
        };
      }) {};
  }
