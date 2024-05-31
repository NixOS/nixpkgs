{ callPackage }:
  {
    ace-window = callPackage ({ avy, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ace-window";
        ename = "ace-window";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ace-window-0.10.0.tar";
          sha256 = "1sdzk1hgi3axqqbxf6aq1v5j3d8bybkz40dk8zqn49xxxfmzbdv4";
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
        version = "1.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ack-1.11.tar";
          sha256 = "1ji02v3qis5sx7hpaaxksgh2jqxzzilagz6z33kjb1lds1sq4z2c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ack.html";
          license = lib.licenses.free;
        };
      }) {};
    activities = callPackage ({ elpaBuild, emacs, fetchurl, lib, persist }:
      elpaBuild {
        pname = "activities";
        ename = "activities";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/activities-0.7.tar";
          sha256 = "1775cdk9hv257m6l7icg247fc36g7lwgjg8iivj52m6qg7p7cz9g";
        };
        packageRequires = [ emacs persist ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/activities.html";
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
        version = "8.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-mode-8.1.0.tar";
          sha256 = "10k514al716qjx3qg1m4k1rnf70fa73vrmmx3pp75zrw1d0db9y6";
        };
        packageRequires = [ emacs gnat-compiler uniquify-files wisi ];
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
          sha256 = "0ijgl9lnmn8n3pllgh3apl2shbl38f3fxn8z5yy4q6pqqx0vr3fn";
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
          sha256 = "1dz5mi21v2wqh969m3xggxbzq3qf78hps418rzl73bb57l837qp8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adaptive-wrap.html";
          license = lib.licenses.free;
        };
      }) {};
    adjust-parens = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "adjust-parens";
        ename = "adjust-parens";
        version = "3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/adjust-parens-3.2.tar";
          sha256 = "1gdlykg7ix3833s40152p1ji4r1ycp18niqjr1f994y4ydqxq8yl";
        };
        packageRequires = [ emacs ];
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
          url = "https://elpa.gnu.org/packages/advice-patch-0.1.tar";
          sha256 = "0km891648k257k4d6hbrv6jyz9663kww8gfarvzf9lv8i4qa5scp";
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
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aggressive-completion-1.7.tar";
          sha256 = "0d388w0yjpjzhqlar9fjrxsjxma09j8as6758sswv01r084gpdbk";
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
          sha256 = "1c27g9qhqc4bh96bkxdcjbrhiwi7kzki1l4yhxvyvwwarisl6c7b";
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
          sha256 = "16k6wm1qss5bk45askhq5vswrqsjic5dijpkgnmwgvm8xsdlvni6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ahungry-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    aircon-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "aircon-theme";
        ename = "aircon-theme";
        version = "0.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aircon-theme-0.0.6.tar";
          sha256 = "0dcnlk3q95bcghlwj8ii40xxhspnfbqcr9mvj1v3adl1s623fyp0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aircon-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    all = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "all";
        ename = "all";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/all-1.1.tar";
          sha256 = "067c5ynklw1inbjwd1l6dkbpx3vw487qv39y7mdl55a6nqx7hgk4";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/all.html";
          license = lib.licenses.free;
        };
      }) {};
    altcaps = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "altcaps";
        ename = "altcaps";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/altcaps-1.2.0.tar";
          sha256 = "1smqvq21jparnph03kyyzm47rv5kia6bna1m1pf8ibpkph64rykw";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ampc-0.2.tar";
          sha256 = "17l2c5hr7cq0vf4qc8s2adwlhqp74glc4v909h0jcavrnbn8yn80";
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
          url = "https://elpa.gnu.org/packages/arbitools-0.977.tar";
          sha256 = "0s5dpprx24fxm0qk8nzm39c16ydiq97wzz3l7zi69r3l9wf31rb3";
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
          url = "https://elpa.gnu.org/packages/ascii-art-to-unicode-1.13.tar";
          sha256 = "0qlh8zi691gz7s1ayp1x5ga3sj3rfy79y21r6hqf696mrkgpz1d8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ascii-art-to-unicode.html";
          license = lib.licenses.free;
        };
      }) {};
    assess = callPackage ({ elpaBuild, emacs, fetchurl, lib, m-buffer }:
      elpaBuild {
        pname = "assess";
        ename = "assess";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/assess-0.7.tar";
          sha256 = "1wka2idr63bn8fgh0cz4lf21jvlhkr895y0xnh3syp9vrss5hzsp";
        };
        packageRequires = [ emacs m-buffer ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/assess.html";
          license = lib.licenses.free;
        };
      }) {};
    async = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "async";
        ename = "async";
        version = "1.9.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/async-1.9.8.tar";
          sha256 = "0m9w7f8rgpcljsv2p6a9gwqx12whf66mbjranwwzacn98rwchh4v";
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
        version = "14.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auctex-14.0.4.tar";
          sha256 = "14rfv7xlwdqp42dilmpg11d58q8pzw15fv01hq80iv9kyzsfvxd7";
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
          url = "https://elpa.gnu.org/packages/aumix-mode-7.tar";
          sha256 = "08baz31hm0nhikqg5h294kg5m4qkiayjhirhb57v57g5722jfk3m";
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
          url = "https://elpa.gnu.org/packages/auto-correct-1.1.4.tar";
          sha256 = "05ky3qxbvxrkywpqj6syl7ll6za74fhjzrcia6wdmxsnjya5qbf1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-correct.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-header = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "auto-header";
        ename = "auto-header";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-header-0.1.2.tar";
          sha256 = "0p22bpdy29i7ff8rzjh1qzvj4d8igl36gs1981kmds4qz23qn447";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-header.html";
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
          sha256 = "0jn7lk8vzdrf0flxwwx295z0mrghd3lyspfadwz35c6kygvy8078";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-overlays.html";
          license = lib.licenses.free;
        };
      }) {};
    autocrypt = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "autocrypt";
        ename = "autocrypt";
        version = "0.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/autocrypt-0.4.2.tar";
          sha256 = "0mc4vb6x7qzn29dg9m05zgli6mwh9cj4vc5n6hvarzkn9lxl6mr3";
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
        version = "3.2.2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bbdb-3.2.2.4.tar";
          sha256 = "1ymjydf54z3rbkxk4irvan5s8lc8wdhk01691741vfznx0nsc4a2";
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
        version = "1.3.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/beacon-1.3.4.tar";
          sha256 = "1hxb6vyvpppj7yzphknmh8m4a1h89lg6jr98g4d62k0laxazvdza";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/beframe-1.0.1.tar";
          sha256 = "1p8zglpdcss0p307i4h2zpqbsiipmgmk0a2fx6j9w3lx0zgaf2xj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/beframe.html";
          license = lib.licenses.free;
        };
      }) {};
    bicep-ts-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "bicep-ts-mode";
        ename = "bicep-ts-mode";
        version = "0.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bicep-ts-mode-0.1.3.tar";
          sha256 = "02377gsdnfvvydjw014p2y6y74nd5zfh1ghq5l9ayq0ilvv8fmx7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bicep-ts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    bind-key = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "bind-key";
        ename = "bind-key";
        version = "2.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bind-key-2.4.1.tar";
          sha256 = "0jrbm2l6h4r7qjcdcsfczbijmbf3njzzzrymv08zanchmy7lvsv2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bind-key.html";
          license = lib.licenses.free;
        };
      }) {};
    blist = callPackage ({ elpaBuild, emacs, fetchurl, ilist, lib }:
      elpaBuild {
        pname = "blist";
        ename = "blist";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/blist-0.3.tar";
          sha256 = "1p10d9q14px19m3vajqmm71lmnbxxsc7qczgq11vhg485c20y3va";
        };
        packageRequires = [ emacs ilist ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/blist.html";
          license = lib.licenses.free;
        };
      }) {};
    bluetooth = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bluetooth";
        ename = "bluetooth";
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bluetooth-0.3.1.tar";
          sha256 = "1yjqjm6cis6bq18li63hbhc4qzki3486xvdjkzs2gj4chc1yw1x4";
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
          sha256 = "1x6km8rhhb5bkas3yfmjfpyxlhyxkqnzviw1pqlq88c95j88h3d4";
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
        version = "1.1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-1.1.4.tar";
          sha256 = "0mwj1qc626f1iaq5iaqm1f4iwyz91hzqhzfk5f53gsqka7yz2fnf";
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
        version = "2.1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-headings-2.1.5.tar";
          sha256 = "0w3cy2r8iqsb79r33lllj08v719hq0xniq5pbr9sl8kn2raxcjhr";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy-headings.html";
          license = lib.licenses.free;
        };
      }) {};
    breadcrumb = callPackage ({ elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "breadcrumb";
        ename = "breadcrumb";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/breadcrumb-1.0.1.tar";
          sha256 = "1s69a2z183mla4d4b5pcsswbwa3hjvsg1xj7r3hdw6j841b0l9dw";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/breadcrumb.html";
          license = lib.licenses.free;
        };
      }) {};
    brief = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, nadvice }:
      elpaBuild {
        pname = "brief";
        ename = "brief";
        version = "5.91";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/brief-5.91.tar";
          sha256 = "106xm23045l3ds5q04s7c6wa00ffv7rw495cjqp99nzqvvbmivcb";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/brief.html";
          license = lib.licenses.free;
        };
      }) {};
    buffer-env = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "buffer-env";
        ename = "buffer-env";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buffer-env-0.6.tar";
          sha256 = "08qaw4y1sszhh97ih13vfrm0r1nn1k410f2wwvffvncxhqgxz5lv";
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
        version = "0.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buffer-expose-0.4.3.tar";
          sha256 = "1ymjjjrbknp3hdfwd8zyzfrsn5n267245ffmplm7yk2s34kgxr0n";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buffer-expose.html";
          license = lib.licenses.free;
        };
      }) {};
    bufferlo = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "bufferlo";
        ename = "bufferlo";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bufferlo-0.6.tar";
          sha256 = "0gvg1mag8ngjmjl4d6zr99k7mq368l1m6dxy9mk6icgxm3sqr1yk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bufferlo.html";
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
    buildbot = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "buildbot";
        ename = "buildbot";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buildbot-0.0.1.tar";
          sha256 = "056jakpyslizsp8sik5f7m90dpcga8y38hb5rh1yfa7k1xwcrrk2";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/buildbot.html";
          license = lib.licenses.free;
        };
      }) {};
    calibre = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "calibre";
        ename = "calibre";
        version = "1.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/calibre-1.4.1.tar";
          sha256 = "1ak05y3cmmwpg8bijkwl97kvfxhxh9xxc74askyafc50n0jvaq87";
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
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cape-1.5.tar";
          sha256 = "1kg5a2x23gmdcv8kwzmz8qjfr05r9rfzwb7cj38ambpqpppxl7ij";
        };
        packageRequires = [ compat emacs ];
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
          sha256 = "18cwiv227m8y1xqvsnjrzgd6f6kvvih742h8y38pphljssl109fk";
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
          url = "https://elpa.gnu.org/packages/caps-lock-1.0.tar";
          sha256 = "1yy4kjc1zlpzkam0jj8h3v5h23wyv1yfvwj2drknn59d8amc1h4y";
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
          url = "https://elpa.gnu.org/packages/captain-1.0.3.tar";
          sha256 = "0l8z8bqk705jdl7gvd2x7nhs0z6gn3swk5yzp3mnhjcfda6whz8l";
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
          sha256 = "0dgmp7ymjyb5pa93n05s0d4ql7wk98r9s4f9w35yahgqk9xvqclj";
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
          url = "https://elpa.gnu.org/packages/cl-generic-0.3.tar";
          sha256 = "0dqn484xb25ifiqd9hqdrs954c74akrf95llx23b2kzf051pqh1k";
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
        version = "0.7.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-lib-0.7.1.tar";
          sha256 = "1wpdg2zwhzxv4bkx9ldiwd16l6244wakv8yphrws4mnymkxvf2q1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-lib.html";
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
          sha256 = "0v70f9pljq3jar3d1vpaj48nhrg90jzsvqcbzgv54989w8rvvcd6";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cobol-mode-1.1.tar";
          sha256 = "0aicx6vvhgn0fvikbq74vnvvwh228pxdqf52sbiffhzgb7pkbvcj";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cobol-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    code-cells = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "code-cells";
        ename = "code-cells";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/code-cells-0.4.tar";
          sha256 = "0kxpnydxlj8pqh54c4c80jlyc6jcplf89bkh3jmm509fmyr7sf20";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/code-cells.html";
          license = lib.licenses.free;
        };
      }) {};
    comint-mime = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "comint-mime";
        ename = "comint-mime";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/comint-mime-0.4.tar";
          sha256 = "13vi973p0ahpvssv5m1pb63f2wkca0lz0nw3nsj6p4s3jzp46npa";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/comint-mime.html";
          license = lib.licenses.free;
        };
      }) {};
    compact-docstrings = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "compact-docstrings";
        ename = "compact-docstrings";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/compact-docstrings-0.2.tar";
          sha256 = "00fjhfysjyqigkg0icxlqw6imzhjk5xhlxmxxs1jiafhn55dbcpj";
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
        version = "0.10.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-0.10.2.tar";
          sha256 = "1708cqrcw26y8z7inm4nzbn2y8gkan5nv5bjzc4ry8zhqz94sxkz";
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
          url = "https://elpa.gnu.org/packages/company-ebdb-1.1.tar";
          sha256 = "1ym0r7y90n4d6grd4l02rxk096gsjmw9j81slig0pq1ky33rb6ks";
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
        version = "1.5.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-math-1.5.1.tar";
          sha256 = "16ya3yscxxmz9agi0nc5pi43wkfv45lh1zd89yqfc7zcw02nsnld";
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
          sha256 = "1gfwhgv7q9d3xjgaim25diyd6jfl9w3j07qrssphcrdxv0q24d14";
        };
        packageRequires = [ company emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-statistics.html";
          license = lib.licenses.free;
        };
      }) {};
    compat = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "compat";
        ename = "compat";
        version = "29.1.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/compat-29.1.4.5.tar";
          sha256 = "0i57hs3ak5y0fsfdwg87ib64ny0ar1nk67f5dy2qrm8x3i0h086s";
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
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-1.5.tar";
          sha256 = "1gx4cjrcaq5dn3rrd2dm30jz07zrnddf0y33qi0dmiqlsyg7l9qw";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult.html";
          license = lib.licenses.free;
        };
      }) {};
    consult-hoogle = callPackage ({ elpaBuild
                                  , emacs
                                  , fetchurl
                                  , haskell-mode
                                  , lib }:
      elpaBuild {
        pname = "consult-hoogle";
        ename = "consult-hoogle";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-hoogle-0.2.1.tar";
          sha256 = "15am29sn0qx6yn8xcmdafzh1ijph10yd65cphcax02yx782hv6pr";
        };
        packageRequires = [ emacs haskell-mode ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult-hoogle.html";
          license = lib.licenses.free;
        };
      }) {};
    consult-recoll = callPackage ({ consult, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "consult-recoll";
        ename = "consult-recoll";
        version = "0.8.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-recoll-0.8.1.tar";
          sha256 = "1zdmkq9cjb6kb0hf3ngm07r3mhrjal27x34i1bm7ri3089wbsp8v";
        };
        packageRequires = [ consult emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult-recoll.html";
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
          sha256 = "0mqdl34g493pps85ckin5i3iz8kwlqkcwjvsf2sj4nldjvvfk1ng";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/corfu-1.3.tar";
          sha256 = "13y0dws1k4682v039ab6b0xxqlg7anknscqs20bmj8lfm2z48znx";
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
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/coterm-1.6.tar";
          sha256 = "0kgsg99dggirz6asyppwx1ydc0jh62xd1bfhnm2hyby5qkqz1yvk";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/coterm.html";
          license = lib.licenses.free;
        };
      }) {};
    counsel = callPackage ({ elpaBuild, emacs, fetchurl, ivy, lib, swiper }:
      elpaBuild {
        pname = "counsel";
        ename = "counsel";
        version = "0.14.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/counsel-0.14.2.tar";
          sha256 = "10jajfl2vhqj2awy991kqrf1hcsj8nkvn760cbxjsm2lhzvqqhj3";
        };
        packageRequires = [ emacs ivy swiper ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/counsel.html";
          license = lib.licenses.free;
        };
      }) {};
    cpio-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cpio-mode";
        ename = "cpio-mode";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cpio-mode-0.17.tar";
          sha256 = "13jay5c36svq2r78gwp7d1slpkkzrx749q28554mxd855fr6pvaj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cpio-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    cpupower = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cpupower";
        ename = "cpupower";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cpupower-1.0.5.tar";
          sha256 = "155fhf38p95a5ws6jzpczw0z03zwbsqzdwj50v3grjivyp74pddz";
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
        version = "0.3.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/crdt-0.3.5.tar";
          sha256 = "038qivbw02h1i98ym0fwx72x05gm0j4h93a54v1l7g25drm5zm83";
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
          url = "https://elpa.gnu.org/packages/crisp-1.3.6.tar";
          sha256 = "0am7gwadjp0nwlvf7y4sp9brbm0234k55bnxfv44lkwdf502mq8y";
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
        version = "2.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csharp-mode-2.0.0.tar";
          sha256 = "1jjxq5vkqq2v8rkcm2ygggpg355aqmrl2hdhh1xma3jlnj5carnf";
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
        version = "1.23";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csv-mode-1.23.tar";
          sha256 = "0b5qcxdp7y78mfgcvh9plfc0l5qbwsvrj1bswyimrzg210zhk4zm";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cursory-1.0.1.tar";
          sha256 = "09ddn7rlmznq833nsm6s6zhzrq94lrbmm1vln43hax9yf784pqbr";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cursory.html";
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
          sha256 = "1glf8sd3gqp9qbd238vxd3aprdz93f887893xji3ybqli36i2xs1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cycle-quotes.html";
          license = lib.licenses.free;
        };
      }) {};
    dape = callPackage ({ elpaBuild, emacs, fetchurl, jsonrpc, lib }:
      elpaBuild {
        pname = "dape";
        ename = "dape";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dape-0.10.0.tar";
          sha256 = "1x6mbis4vmghp3vf4pxyzdp68nnrraw9ayx3gzbp1bvcmr62qdig";
        };
        packageRequires = [ emacs jsonrpc ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dape.html";
          license = lib.licenses.free;
        };
      }) {};
    darkroom = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "darkroom";
        ename = "darkroom";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/darkroom-0.3.tar";
          sha256 = "0gxixkai8awc77vzckwljmyapdnxw5j9ajxmlr8rq42994gjr4fm";
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
          sha256 = "1c7yibfikkwlip8zh4kiamh3kljil3hyl250g8fkxpdyhljjdk6m";
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
          url = "https://elpa.gnu.org/packages/dbus-codegen-0.1.tar";
          sha256 = "0d3sbqs5r8578629inx8nhqvx0kshf41d00c8dpc75v4b2vx0h6w";
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
        version = "0.40";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/debbugs-0.40.tar";
          sha256 = "1agms2il38lgz02g4fswil9x5j1xwpl8kvhbd48jcx57nq18a7bl";
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
          url = "https://elpa.gnu.org/packages/delight-1.7.tar";
          sha256 = "1j7srr0i7s9hcny45m8zmj33nl9g6zi55cbkdzzlbx6si2rqwwlj";
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
        version = "2.3.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/denote-2.3.5.tar";
          sha256 = "1l8nlr8q7c51j2f528a0568pa3ywfv8pr47fzpd6pk2scc0y372b";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/denote.html";
          license = lib.licenses.free;
        };
      }) {};
    denote-menu = callPackage ({ denote, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "denote-menu";
        ename = "denote-menu";
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/denote-menu-1.2.0.tar";
          sha256 = "042avabc97wgkz85x40dq7rmv4h9n5kmq935lrg9s20klbs9axs1";
        };
        packageRequires = [ denote emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/denote-menu.html";
          license = lib.licenses.free;
        };
      }) {};
    detached = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "detached";
        ename = "detached";
        version = "0.10.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/detached-0.10.1.tar";
          sha256 = "0w6xgidi0g1pc13xfm8hcgmc7i2h5brj443cykwgvr5wkqnpmp9m";
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
        version = "0.6.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/devdocs-0.6.1.tar";
          sha256 = "04m3jd3wymrsdlb1i7z6dz9pf1q8q38ihkbn3jisdca6xkk9jd6p";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devdocs.html";
          license = lib.licenses.free;
        };
      }) {};
    devicetree-ts-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "devicetree-ts-mode";
        ename = "devicetree-ts-mode";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/devicetree-ts-mode-0.3.tar";
          sha256 = "06j385pvlhd7hp9isqp5gcf378m8p6578q6nz81r8dx93ymaak79";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/devicetree-ts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    dict-tree = callPackage ({ elpaBuild
                             , emacs
                             , fetchurl
                             , heap
                             , lib
                             , tNFA
                             , trie }:
      elpaBuild {
        pname = "dict-tree";
        ename = "dict-tree";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dict-tree-0.17.tar";
          sha256 = "0p4j0m3b9i38l4rcgzdps95wqk27zz156d4q73vq054kpcphrfpp";
        };
        packageRequires = [ emacs heap tNFA trie ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dict-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    diff-hl = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "diff-hl";
        ename = "diff-hl";
        version = "1.9.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diff-hl-1.9.2.tar";
          sha256 = "0skla012qw55qhzykgrk3zk5x76dfsj11kq8q2msyrq3jxcbyq6p";
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
          sha256 = "1xqd6ldxl93l281ncddik1lfxjngi2drq61mv7v18r756c7bqr5r";
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
          sha256 = "066yjy9vdbf20adcqdcknk5b0ml18fy2bm9gkgcp0qfg37yy1yjg";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-du.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-duplicates = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-duplicates";
        ename = "dired-duplicates";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-duplicates-0.4.tar";
          sha256 = "1srih47bq7szg6n3qlz4yzzcijg79p8xpwmi5c4v9xscl94nnc4z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-duplicates.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-git-info = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-git-info";
        ename = "dired-git-info";
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-git-info-0.3.1.tar";
          sha256 = "0rryvlbqx1j48wafja15yc39jd0fzgz9i6bzmq9jpql3w9445772";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-git-info.html";
          license = lib.licenses.free;
        };
      }) {};
    dired-preview = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-preview";
        ename = "dired-preview";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-preview-0.1.1.tar";
          sha256 = "08c9bvsdb7w9ggav9yrpz12nf9zlq4h1zq8ssdf9pwrx2nzy06p7";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-preview.html";
          license = lib.licenses.free;
        };
      }) {};
    disk-usage = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "disk-usage";
        ename = "disk-usage";
        version = "1.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/disk-usage-1.3.3.tar";
          sha256 = "02i7i7mrn6ky3lzhcadvq7wlznd0b2ay107h2b3yh4wwwxjxymyg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/disk-usage.html";
          license = lib.licenses.free;
        };
      }) {};
    dismal = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "dismal";
        ename = "dismal";
        version = "1.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dismal-1.5.2.tar";
          sha256 = "1706m5ya6q0jf8mzfkqn47aqd7ygm88fm7pvzbd4cry30mjs5vki";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dismal.html";
          license = lib.licenses.free;
        };
      }) {};
    djvu = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "djvu";
        ename = "djvu";
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/djvu-1.1.2.tar";
          sha256 = "0z74aicvy680m1d6v5zk5pcpkd310jqqdxadpjcbnjcybzp1zisq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/djvu.html";
          license = lib.licenses.free;
        };
      }) {};
    do-at-point = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "do-at-point";
        ename = "do-at-point";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/do-at-point-0.1.1.tar";
          sha256 = "1lqnarb9jiig85j3dv37jsqkmmfbcwb52i2akimzf9r57pypiylk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/do-at-point.html";
          license = lib.licenses.free;
        };
      }) {};
    doc-toc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "doc-toc";
        ename = "doc-toc";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/doc-toc-1.2.tar";
          sha256 = "09xwa0xgnzlaff0j5zy3kam6spcnw0npppc3gf6ka5bizbk4dq99";
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
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/docbook-0.1.tar";
          sha256 = "1kn71kpyb1maww414zgpc1ccgb02mmaiaix06jyqhf75hfxms2lv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/docbook.html";
          license = lib.licenses.free;
        };
      }) {};
    drepl = callPackage ({ comint-mime, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "drepl";
        ename = "drepl";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/drepl-0.2.tar";
          sha256 = "1vf61d6iihpnr3h4cyxksd64qj8rw2a9ihjm3krvjmigxr2r6awx";
        };
        packageRequires = [ comint-mime emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/drepl.html";
          license = lib.licenses.free;
        };
      }) {};
    dts-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dts-mode";
        ename = "dts-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dts-mode-1.0.tar";
          sha256 = "16ads9xjbqgmgwzj63anhc6yb1j79qpcnxjafqrzdih1p5j7hrr9";
        };
        packageRequires = [ emacs ];
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
          sha256 = "0mwam1a7sl90aqgz6mj3zm0w1dq15b5jpxmwxv21xs1imyv696ci";
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
        version = "0.9.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/easy-kill-0.9.5.tar";
          sha256 = "1nwhqidy5zq6j867b21zng5ppb7n56drnhn3wjs7hjmkf23r63qy";
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
        version = "0.8.22";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-0.8.22.tar";
          sha256 = "0nmrhjk2ddml115ibsy8j4crw5hzq9fa94v8y41iyj9h3gf8irzc";
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
          url = "https://elpa.gnu.org/packages/ebdb-gnorb-1.0.2.tar";
          sha256 = "1kwcrg268vmskls9p4ccs6ybdip30cb4fw3xzq11gqjch1nssh18";
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
          sha256 = "1qyia40z6ssvnlpra116avakyf81vqn42860ny21g0zsl99a58j2";
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
        version = "2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ediprolog-2.2.tar";
          sha256 = "13g8y51lvdphi1v6rdca36c0r9v35lldx5979yrccsf07h0hw5gm";
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
        version = "20240309";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eev-20240309.tar";
          sha256 = "0nn6jdc37n2nx3i97ljl5a37dwxv5qx12ar15yr702hbsgaxyfa5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eev.html";
          license = lib.licenses.free;
        };
      }) {};
    ef-themes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ef-themes";
        ename = "ef-themes";
        version = "1.6.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ef-themes-1.6.1.tar";
          sha256 = "0wkiqjnqnxwzskpxam44qxxz13fbpgnf17c1qrin8ad8i9b49bvq";
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
        version = "1.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eglot-1.17.tar";
          sha256 = "1cnx522wb49f1dkm80sigz3kvzrblmq5b1lnfyq9wdnh6zdm4l00";
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
        version = "1.12.6.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/el-search-1.12.6.1.tar";
          sha256 = "1vq8cp2icpl8vkc9r8brzbn0mpaj03mnvdz1bdqn8nqrzc3w0h24";
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
        version = "1.15.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eldoc-1.15.0.tar";
          sha256 = "05fgk3y2rp0xrm3x0xmf9fm72l442y7ydxxg3xk006d9cq06h8kz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc.html";
          license = lib.licenses.free;
        };
      }) {};
    electric-spacing = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "electric-spacing";
        ename = "electric-spacing";
        version = "5.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/electric-spacing-5.0.tar";
          sha256 = "1gr35nri25ycxr0wwkypky8zv43nnfrilx4jaj66mb9jsyix6smi";
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
          sha256 = "050wja4axngnxggfxhg4b4lcbf1q674zr933r9qkc3ww731f42qa";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/elisp-benchmarks.html";
          license = lib.licenses.free;
        };
      }) {};
    ellama = callPackage ({ elpaBuild, emacs, fetchurl, lib, llm, spinner }:
      elpaBuild {
        pname = "ellama";
        ename = "ellama";
        version = "0.9.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ellama-0.9.1.tar";
          sha256 = "1kyylhavqa2wsgjgqybg25aiz0fyw4njpady2k2xhry5jw9i78vs";
        };
        packageRequires = [ emacs llm spinner ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ellama.html";
          license = lib.licenses.free;
        };
      }) {};
    emacs-gc-stats = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "emacs-gc-stats";
        ename = "emacs-gc-stats";
        version = "1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/emacs-gc-stats-1.4.2.tar";
          sha256 = "055ma32r92ksjnqy8xbzv0a79r7aap12h61dj860781fapfnifa3";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-1.1.tar";
          sha256 = "074ggh7dkr5jdkwcndl6znhkq48jmc62rp7mc6vjidr6yxf8d1rn";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/embark.html";
          license = lib.licenses.free;
        };
      }) {};
    embark-consult = callPackage ({ compat
                                  , consult
                                  , elpaBuild
                                  , emacs
                                  , embark
                                  , fetchurl
                                  , lib }:
      elpaBuild {
        pname = "embark-consult";
        ename = "embark-consult";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-consult-1.1.tar";
          sha256 = "06yh6w4zgvvkfllmcr0szsgjrfhh9rpjwgmcrf6h2gai2ps9xdqr";
        };
        packageRequires = [ compat consult emacs embark ];
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
        version = "0.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ement-0.15.tar";
          sha256 = "0mphkvmsmrfyr3prr5a2x6ijr27z96ixpaxs9871kn7f1x0brn5r";
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
        version = "19";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/emms-19.tar";
          sha256 = "1k0hybw826f2hlw8m0aihkydlkdzjsgvrfibpsqrxxcn9d7zxwjd";
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
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/engrave-faces-0.3.1.tar";
          sha256 = "0nl5wx61192dqd0191dvaszgjc7b2adrxsyc75f529fcyrfwgqfa";
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
          sha256 = "0y8154ykrashgg0bina5ambdrxw2qpimycvjldrk9d67hrccfh3m";
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
    erc = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "erc";
        ename = "erc";
        version = "5.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/erc-5.5.tar";
          sha256 = "02649ijnpyalk0k1yq1dcinj92awhbnkia2x9sdb9xjk80xw1gqp";
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
                                  , undo-tree }:
      elpaBuild {
        pname = "ergoemacs-mode";
        ename = "ergoemacs-mode";
        version = "5.16.10.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ergoemacs-mode-5.16.10.12.tar";
          sha256 = "0s4lwb76c67npbcnvbxdawnj02zkc85sbm392lym1qccjmj9d02f";
        };
        packageRequires = [ cl-lib emacs undo-tree ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ergoemacs-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ess = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ess";
        ename = "ess";
        version = "24.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ess-24.1.1.tar";
          sha256 = "11hn571q8vpjy1kx8d1hn8mm2sna0ar1q2z4vmb6rwqi9wsda6a0";
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
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/excorporate-1.1.2.tar";
          sha256 = "111wvkn0ks7syfgf1cydq5s0kymha0j280xvnp09zcfbj706yhbw";
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
    expand-region = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "expand-region";
        ename = "expand-region";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/expand-region-1.0.0.tar";
          sha256 = "1rjx7w4gss8sbsjaljraa6cjpb57kdpx9zxmr30kbifb5lp511rd";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/expand-region.html";
          license = lib.licenses.free;
        };
      }) {};
    expreg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "expreg";
        ename = "expreg";
        version = "1.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/expreg-1.3.1.tar";
          sha256 = "12msng4ypmw6s3pja66kkjxkbadla0fxmak1r3drxiihpwmh5zm6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/expreg.html";
          license = lib.licenses.free;
        };
      }) {};
    external-completion = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "external-completion";
        ename = "external-completion";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/external-completion-0.1.tar";
          sha256 = "1bw2kvz7zf1s60d37j31krakryc1kpyial2idjy6ac6w7n1h0jzc";
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
        version = "0.28";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/exwm-0.28.tar";
          sha256 = "11j1ciyrnzkbcb7ffgs670mxqd1xbxf41c6jwnwwqjfzmqhsm0m4";
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
    face-shift = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "face-shift";
        ename = "face-shift";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/face-shift-0.2.1.tar";
          sha256 = "14sbafkxr7kmv6sd5rw7d7hcsh0hhx92wkh6arfbchxad8jzimr6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/face-shift.html";
          license = lib.licenses.free;
        };
      }) {};
    filechooser = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "filechooser";
        ename = "filechooser";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/filechooser-0.2.0.tar";
          sha256 = "1fjf8bmdrrrgbv4sgx4nry5pl8plg9kyzyfd038985v3dsqasi9q";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/filechooser.html";
          license = lib.licenses.free;
        };
      }) {};
    filladapt = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "filladapt";
        ename = "filladapt";
        version = "2.12.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/filladapt-2.12.2.tar";
          sha256 = "0nmgw6v2krxn5palddqj1jzqxrajhpyq9v2x9lw12cdcldm9ab4k";
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
        version = "0.9.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/firefox-javascript-repl-0.9.5.tar";
          sha256 = "07qmp6hfzgljrl9gkwy673xk67b3bgxq4kkw2kzr8ma4a7lx7a8l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/firefox-javascript-repl.html";
          license = lib.licenses.free;
        };
      }) {};
    flylisp = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "flylisp";
        ename = "flylisp";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flylisp-0.2.tar";
          sha256 = "1agny4hc75xc8a9f339bynsazmxw8ccvyb03qx1d6nvwh9d7v1b9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flylisp.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake = callPackage ({ eldoc, elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "flymake";
        ename = "flymake";
        version = "1.3.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-1.3.7.tar";
          sha256 = "15ikzdqyh77cgx94jaigfrrzfvwvpca8s2120gi82i9aaiypr7jl";
        };
        packageRequires = [ eldoc emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-codespell = callPackage ({ compat
                                     , elpaBuild
                                     , emacs
                                     , fetchurl
                                     , lib }:
      elpaBuild {
        pname = "flymake-codespell";
        ename = "flymake-codespell";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-codespell-0.1.tar";
          sha256 = "1x1bmdjmdaciknd702z54002bi1a5n51vvn9g7j6rnzjc1dxw97f";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-codespell.html";
          license = lib.licenses.free;
        };
      }) {};
    flymake-proselint = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "flymake-proselint";
        ename = "flymake-proselint";
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-proselint-0.3.0.tar";
          sha256 = "0bq7nc1qiqwxi848xy7wg1ig8k38nmq1w13xws10scjvndlbcjpl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/flymake-proselint.html";
          license = lib.licenses.free;
        };
      }) {};
    fontaine = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "fontaine";
        ename = "fontaine";
        version = "2.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/fontaine-2.0.0.tar";
          sha256 = "1h3hsqfx16ff0s776xvnafrlmj0m0r66hjra1mq2j55ahvh0aavk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/fontaine.html";
          license = lib.licenses.free;
        };
      }) {};
    frame-tabs = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "frame-tabs";
        ename = "frame-tabs";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/frame-tabs-1.1.tar";
          sha256 = "1a7hklir19inai68azgyfiw1bzq5z57kkp33lj6qbxxvfcqvw62w";
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
          url = "https://elpa.gnu.org/packages/frog-menu-0.2.11.tar";
          sha256 = "1iwyg9z8i03p9kkz6vhv00bzsqrsgl4xqqh08icial29c80q939l";
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
          url = "https://elpa.gnu.org/packages/fsm-0.2.1.tar";
          sha256 = "0kvm16077bn6bpbyw3k5935fhiq86ry2j1zcx9sj7dvb9w737qz4";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ftable-1.1.tar";
          sha256 = "052vqw8892wv8lh5slm90gcvfk7ws5sgl1mzbdi4d3sy4kc4q48h";
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
          url = "https://elpa.gnu.org/packages/gcmh-0.2.1.tar";
          sha256 = "030w493ilmc7w13jizwqsc33a424qjgicy1yxvlmy08yipnw3587";
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
          sha256 = "02gj8ghkk35clyscbvp1p1nlhmgm5h9g2cy4mavnfmx7jikmr4m3";
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
          sha256 = "1s2h6y1adh28pvm3h5bivfja2nqnzm8w9sfza894pxf96kwk3pg2";
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
          url = "https://elpa.gnu.org/packages/gle-mode-1.1.tar";
          sha256 = "12vbif4b4j87z7fg18dlcmzmbs2fp1g8bgsk5rch9h6dblg72prq";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gle-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    gnat-compiler = callPackage ({ elpaBuild, emacs, fetchurl, lib, wisi }:
      elpaBuild {
        pname = "gnat-compiler";
        ename = "gnat-compiler";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnat-compiler-1.0.3.tar";
          sha256 = "1chydgswab2m81m3kbd31b1akyw4v1c9468wlfxpg2yydy8fc7vs";
        };
        packageRequires = [ emacs wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnat-compiler.html";
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
        version = "1.6.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnorb-1.6.11.tar";
          sha256 = "1y0xpbifb8dm8hd5i9g8jph4jm76wviphszl5x3zi6w053jpss9b";
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
          sha256 = "01cw1r5y86q1aardpvcwvwq161invrzxd0kv4qqi5agaff2nbp26";
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
        version = "2022.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update-2022.12.tar";
          sha256 = "0pabqsfw0d9knfigpcsrwfw7qrf2vlg9h0i582212gsqd7snlnxb";
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
          sha256 = "0wingn5v4wa1xgsgmqqls28cifnff8mvm098kn8clw42mxr40257";
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
          sha256 = "1yl624wzs4kw45zpnxh04dxn1kkpb6c2jl3i0sm1bijyhm303l4h";
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
          url = "https://elpa.gnu.org/packages/gpastel-0.5.0.tar";
          sha256 = "12y1ysgnqjvsdp5gal90mp2wplif7rq1cj61393l6gf3pgv6jkzc";
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
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gpr-mode-1.0.5.tar";
          sha256 = "1qdk2pkdxggfhj8gm39jb2b29g0gbw50vgil6rv3z0q7nlhpm2fp";
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
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gpr-query-1.0.4.tar";
          sha256 = "1y283x549w544x37lmh25n19agyah2iz0b052hx8br4rnjdd9ii3";
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
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/graphql-0.1.2.tar";
          sha256 = "1blpsj6sav3z9gj733cccdhpdnyvnvxp48z1hnjh0f0fl5avvkix";
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
        version = "0.9.20";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/greader-0.9.20.tar";
          sha256 = "11n88xmr2qa5as5kpy4yy616nlh08nw5rkcbgmf9skgka3g1hmip";
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
          url = "https://elpa.gnu.org/packages/greenbar-1.1.tar";
          sha256 = "14azd170xq602fy4mcc770x5063rvpms8ilbzzn8kwyfvmijlbbx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/greenbar.html";
          license = lib.licenses.free;
        };
      }) {};
    gtags-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gtags-mode";
        ename = "gtags-mode";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gtags-mode-1.5.tar";
          sha256 = "15jmynzm2xrvb410vka3jzzdcxbsm3vkihz27yzym708jb0bd8ji";
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
    hcel = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hcel";
        ename = "hcel";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hcel-1.0.0.tar";
          sha256 = "1pm3d0nz2mpf667jkjlmlidh203i4d4gk0n8xd3r66bzwc4l042b";
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
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/heap-0.5.tar";
          sha256 = "1q42v9mzmlhl4pr3wr94nsis7a9977f35w0qsyx2r982kwgmbndw";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hiddenquote-1.2.tar";
          sha256 = "051aqiq77n487lnsxxwa8q0vyzk6m2fwi3l7xwvrl49p5xpia6zr";
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
          url = "https://elpa.gnu.org/packages/highlight-escape-sequences-0.4.tar";
          sha256 = "1gs662vvvzrqdlb1z73jf6wykjzs1jskcdksk8akqmply4sjvbpr";
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
          sha256 = "018zvdjhdrkcy8yrsqqqikhl6drmqm1fs0y50m8q8vx42p0cyi1p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/html5-schema.html";
          license = lib.licenses.free;
        };
      }) {};
    hydra = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, lv }:
      elpaBuild {
        pname = "hydra";
        ename = "hydra";
        version = "0.15.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hydra-0.15.0.tar";
          sha256 = "082wdr2nsfz8jhh7ic4nq4labz0pq8lcdwnxdmw79ppm20p2jipk";
        };
        packageRequires = [ cl-lib lv ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hydra.html";
          license = lib.licenses.free;
        };
      }) {};
    hyperbole = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "hyperbole";
        ename = "hyperbole";
        version = "9.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hyperbole-9.0.1.tar";
          sha256 = "0gjscqa0zagbymm6wfilvc8g68f8myv90ryd8kqfcpy81fh4dhiz";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ilist-0.3.tar";
          sha256 = "01a522sqx7j5m6b1k8xn71963igm93cd7ms1aawh1v2wmb09vbhm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ilist.html";
          license = lib.licenses.free;
        };
      }) {};
    inspector = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "inspector";
        ename = "inspector";
        version = "0.36";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/inspector-0.36.tar";
          sha256 = "0hbh4a71w4yxicn7v7v492i7iv0ncv5sxwwsbwknbl9ixm482h2z";
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
        version = "2.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ioccur-2.6.tar";
          sha256 = "0xyx5xd46n5x078k7pv022h84xmxv7fkh31ddib872bmnirhk6ln";
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
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/isearch-mb-0.8.tar";
          sha256 = "1b4929vr5gib406p51zcvq1ysmzvnz6bs1lqwjp517kzp6r4gc5y";
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
          url = "https://elpa.gnu.org/packages/iterators-0.1.1.tar";
          sha256 = "1xcqvj9dail1irvj2nbfx9x106mcav104pp89jz2diamrky6ja49";
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
        version = "0.14.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-0.14.2.tar";
          sha256 = "1h9gfkkcw9nfw85m0mh08qfmi2y0jkvdk54qx0iy5p04ysmhs6k1";
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
        version = "0.14.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-avy-0.14.2.tar";
          sha256 = "12s5z3h8bpa6vdk7f54i2dy18hd3p782pq3x6mkclkvlxijv7d11";
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
          url = "https://elpa.gnu.org/packages/ivy-explorer-0.3.2.tar";
          sha256 = "0wv7gp2kznc6f6g9ky1gvq72i78ihp582kyks82h13w25rvh6f0a";
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
        version = "0.14.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-hydra-0.14.2.tar";
          sha256 = "1p08rpj3ac2rwjcqbzkq9r5pmc1d9ci7s9bl0qv5cj5r8wpl69mx";
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
          sha256 = "027lbddg4rc44jpvxsqyw9n9pi1bnsssfislg2il3hbr86v88va9";
        };
        packageRequires = [ emacs ivy posframe ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy-posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    jami-bot = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jami-bot";
        ename = "jami-bot";
        version = "0.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jami-bot-0.0.4.tar";
          sha256 = "1dp4k5y7qy793m3fyxvkk57bfy42kac2w5wvy7zqzd4lckm0a93z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jami-bot.html";
          license = lib.licenses.free;
        };
      }) {};
    jarchive = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jarchive";
        ename = "jarchive";
        version = "0.11.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jarchive-0.11.0.tar";
          sha256 = "17klpdrv74hgpwnhknbihg90j6sbikf4j62lq0vbfv3s7r0a0gb8";
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
        version = "0.9.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/javaimp-0.9.1.tar";
          sha256 = "1gy7qys9mzpgbqm5798fncmblmi32b350q51ccsyydq67yh69s3z";
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
          url = "https://elpa.gnu.org/packages/jgraph-mode-1.1.tar";
          sha256 = "1ryxbszp15dy2chch2irqy7rmcspfjw717w4rd0vxjpwvgkjgiql";
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
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jinx-1.6.tar";
          sha256 = "0jy2g587930d4jqi4asrci3411bby9j6wrxczyskacvjs41vqyip";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jinx.html";
          license = lib.licenses.free;
        };
      }) {};
    jit-spell = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jit-spell";
        ename = "jit-spell";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jit-spell-0.4.tar";
          sha256 = "0p9nf2n0x6c6xl32aczghzipx8n5aq7a1x6r2s78xvpwr299k998";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/jit-spell.html";
          license = lib.licenses.free;
        };
      }) {};
    js2-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "js2-mode";
        ename = "js2-mode";
        version = "20231224";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/js2-mode-20231224.tar";
          sha256 = "023z76zxh5q6g26x7qlgf9476lj95sj84d5s3aqhy6xyskkyyg6c";
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
          url = "https://elpa.gnu.org/packages/json-mode-0.2.tar";
          sha256 = "1ix8nq9rjfgbq8vzzjp179j2wa11il0ys8fjjy9gnlqwk6lnk86h";
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
        version = "1.0.25";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jsonrpc-1.0.25.tar";
          sha256 = "18f0g8j1rd2fpa707w6fll6ryj7mg6hbcy2pc3xff2a4ps8zv12b";
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
        version = "3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jumpc-3.1.tar";
          sha256 = "1c6wzwrr1ydpn5ah5xnk159xcn4v1gv5rjm4iyfj83dss2ygirzp";
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
        version = "0.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/kind-icon-0.2.2.tar";
          sha256 = "1zafx7rvfyahb7zzl2n9gpb2lc8x3k0bkcap2fl0n54aw4j98i69";
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
          sha256 = "1krmlyfjs8b7ibixbmv41vhg1gm7prck6lpp61v17fgig92a9k2s";
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
          url = "https://elpa.gnu.org/packages/kmb-0.1.tar";
          sha256 = "12klfmdjjlyjvrzz3rx8dmamnag1fwljhs05jqwd0dv4a2q11gg5";
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
          url = "https://elpa.gnu.org/packages/landmark-1.0.tar";
          sha256 = "1nnmnvyfjmkk5ddw4q24py1bqzykr29klip61n16bqpr39v56gpg";
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
        version = "1.5.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/latex-table-wizard-1.5.4.tar";
          sha256 = "1999kh5yi0cg1k0al3np3zi2qhrmcpzxqsfvwg0mgrg3mww4gqlw";
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
        version = "4.5.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/leaf-4.5.5.tar";
          sha256 = "1nvpl9ffma0ybbr7vlpcj7q33ja17zrswvl91bqljlmb4lb5121m";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/leaf.html";
          license = lib.licenses.free;
        };
      }) {};
    lentic = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib, m-buffer }:
      elpaBuild {
        pname = "lentic";
        ename = "lentic";
        version = "0.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lentic-0.12.tar";
          sha256 = "0pszjhgy9dlk3h5gc8wnlklgl30ha3ig9bpmw2j1ps713vklfms7";
        };
        packageRequires = [ dash emacs m-buffer ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lentic.html";
          license = lib.licenses.free;
        };
      }) {};
    lentic-server = callPackage ({ elpaBuild
                                 , fetchurl
                                 , lentic
                                 , lib
                                 , web-server }:
      elpaBuild {
        pname = "lentic-server";
        ename = "lentic-server";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lentic-server-0.2.tar";
          sha256 = "1r0jcfylvhlihwm6pm4f8pzvsmnlspfkph1hgi5qjkv311045244";
        };
        packageRequires = [ lentic web-server ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lentic-server.html";
          license = lib.licenses.free;
        };
      }) {};
    let-alist = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "let-alist";
        ename = "let-alist";
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/let-alist-1.0.6.tar";
          sha256 = "1fk1yl2cg4gxcn02n2gki289dgi3lv56n0akkm2h7dhhbgfr6gqm";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lex-1.2.tar";
          sha256 = "1pqjrlw558l4z4k40jmli8lmcqlzddhkr0mfm38rbycp7ghdr4zx";
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
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lin-1.0.0.tar";
          sha256 = "1yxvpgh3sbw0d0zkjfgbhjc2bziqvkyj7fgwcl3814q7hh8m4146";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lin.html";
          license = lib.licenses.free;
        };
      }) {};
    listen = callPackage ({ elpaBuild
                          , emacs
                          , fetchurl
                          , lib
                          , persist
                          , taxy
                          , taxy-magit-section
                          , transient }:
      elpaBuild {
        pname = "listen";
        ename = "listen";
        version = "0.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/listen-0.9.tar";
          sha256 = "1g1sv8fs8vl93fah7liaqzgwvc4b1chasx5151ayizz4q2qgwwbp";
        };
        packageRequires = [ emacs persist taxy taxy-magit-section transient ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/listen.html";
          license = lib.licenses.free;
        };
      }) {};
    llm = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "llm";
        ename = "llm";
        version = "0.12.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/llm-0.12.3.tar";
          sha256 = "19c3i8jfhvc0zqha2mlynk16ws4wgc1hdjrp7gp290bacvr560vg";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/llm.html";
          license = lib.licenses.free;
        };
      }) {};
    lmc = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "lmc";
        ename = "lmc";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lmc-1.4.tar";
          sha256 = "0c8sd741a7imn1im4j17m99bs6zmppndsxpn23k33lmcqj1rfhsk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lmc.html";
          license = lib.licenses.free;
        };
      }) {};
    load-dir = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "load-dir";
        ename = "load-dir";
        version = "0.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-dir-0.0.5.tar";
          sha256 = "1yxnckd7s4alkaddfs672g0jnsxir7c70crnm6rsc5vhmw6310nx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-dir.html";
          license = lib.licenses.free;
        };
      }) {};
    load-relative = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "load-relative";
        ename = "load-relative";
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-relative-1.3.2.tar";
          sha256 = "04ppqfzlqz7156aqm56yccizv0n71qir7yyp7xfiqq6vgj322rqv";
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
          url = "https://elpa.gnu.org/packages/loccur-1.2.4.tar";
          sha256 = "1b8rmbl03k8fdy217ngbxsc0a3jxxmqnwshf72f4iay8ln4hasgk";
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
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/logos-1.1.1.tar";
          sha256 = "0dyy1y6225kbmsl5zy4hp0bdnnp06l05m8zqxc22alsivy2qvkjb";
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
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/luwak-1.0.0.tar";
          sha256 = "0z6h1cg7nshv87zl4fia6l5gwf9ax6f4wgxijf2smi8cpwmv6j79";
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
        version = "0.15.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lv-0.15.0.tar";
          sha256 = "1wb8whyj8zpsd7nm7r0yjvkfkr2ml80di7alcafpadzli808j2l4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lv.html";
          license = lib.licenses.free;
        };
      }) {};
    m-buffer = callPackage ({ elpaBuild, fetchurl, lib, seq }:
      elpaBuild {
        pname = "m-buffer";
        ename = "m-buffer";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/m-buffer-0.16.tar";
          sha256 = "16drbgamp7yd1ndw2qrycrgmnknv5k7h4d7svcdhv9az6fg1vzn4";
        };
        packageRequires = [ seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/m-buffer.html";
          license = lib.licenses.free;
        };
      }) {};
    map = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "map";
        ename = "map";
        version = "3.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/map-3.3.1.tar";
          sha256 = "1za8wjdvyxsxvmzla823f7z0s4wbl22l8k08v8b4h4m6i7w356lp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/map.html";
          license = lib.licenses.free;
        };
      }) {};
    marginalia = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "marginalia";
        ename = "marginalia";
        version = "1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/marginalia-1.6.tar";
          sha256 = "0an3ayka1f7n511bjfwz42h9g5b1vhb6x47jy0k9psscr7pbhszg";
        };
        packageRequires = [ compat emacs ];
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
          url = "https://elpa.gnu.org/packages/markchars-0.2.2.tar";
          sha256 = "0jagp5s2kk8ijwxbg5ccq31bjlcxkqpqhsg7a1hbyp3p5z3j73m0";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/math-symbol-lists-1.3.tar";
          sha256 = "1r2acaf79kwwvndqn9xbvq9dc12vr3lryc25yp0w0gksp86p8cfa";
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
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mct-1.0.0.tar";
          sha256 = "0f8znz4basrdh56pcldsazxv3mwqir807lsaza2g5bfqws0c7h8k";
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
          url = "https://elpa.gnu.org/packages/memory-usage-0.2.tar";
          sha256 = "04bylvy86x8w96g7zil3jzyac0fijvb5lz4830ja5yabpvsnk3vq";
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
          url = "https://elpa.gnu.org/packages/metar-0.3.tar";
          sha256 = "07nf14zm5y6ma6wqnyw5bf7cvk3ybw7hvlrwcnri10s8vh3rqd0r";
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
          url = "https://elpa.gnu.org/packages/midi-kbd-0.2.tar";
          sha256 = "0jd92rainjd1nx72z7mrvsxs3az6axxiw1v9sbpsj03x8qq0129q";
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
          sha256 = "0j52n43mv963hpgdh5kk1k9wi821r6w3diwdp47rfwsijdd0wnhs";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mines.html";
          license = lib.licenses.free;
        };
      }) {};
    minibuffer-header = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "minibuffer-header";
        ename = "minibuffer-header";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minibuffer-header-0.5.tar";
          sha256 = "1qic33wsdba5xw3qxigq18nibwhj45ggk0ragy4zj9cfy1l2ni44";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minibuffer-header.html";
          license = lib.licenses.free;
        };
      }) {};
    minibuffer-line = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "minibuffer-line";
        ename = "minibuffer-line";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minibuffer-line-0.1.tar";
          sha256 = "0sg9vhv7bi82a90ziiwsabnfvw8zp544v0l93hbl42cj432bpwfx";
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
          url = "https://elpa.gnu.org/packages/minimap-1.4.tar";
          sha256 = "0n27wp65x5n21qy6x5dhzms8inf0248kzninp56kfx1bbf9w4x66";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/minimap.html";
          license = lib.licenses.free;
        };
      }) {};
    mmm-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "mmm-mode";
        ename = "mmm-mode";
        version = "0.5.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mmm-mode-0.5.11.tar";
          sha256 = "0dh76lk0am07j2zi7hhbmr6cnnss7l0b9rhi9is0w0n5i7j4i0p2";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mmm-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    modus-themes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "modus-themes";
        ename = "modus-themes";
        version = "4.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/modus-themes-4.4.0.tar";
          sha256 = "1bqvyf8xq55dligwqhw4d6z9bv529rhnijxv5y5gdlzap973bf71";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-themes.html";
          license = lib.licenses.free;
        };
      }) {};
    mpdired = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "mpdired";
        ename = "mpdired";
        version = "1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mpdired-1.tar";
          sha256 = "08lc0j25kxisykd2l9v4iamalmm5hzsnsm026v808krny28wwbp3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mpdired.html";
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
          sha256 = "0i2l50lcsj3mm9k38kfmh2hnb437pjbk2yxv26p6na1g1n44lkil";
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
        version = "1.1.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/multishell-1.1.10.tar";
          sha256 = "1khqc7a04ynl63lpv898361sv37jgpd1fzvl0ryphprv9shnhw10";
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
          url = "https://elpa.gnu.org/packages/myers-0.1.tar";
          sha256 = "0a053w7nj0qfryvsh1ss854wxwbk5mhkl8a5nprcfgsh4qh2m487";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nadvice-0.4.tar";
          sha256 = "19dx07v4z2lyyp18v45c5hgp65akw58bdqg5lcrzyb9mrlji8js6";
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
          url = "https://elpa.gnu.org/packages/nameless-1.0.2.tar";
          sha256 = "0m3z701j2i13zmr4g0wjd3ms6ajr6w371n5kx95n9ssxyjwjppcm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nameless.html";
          license = lib.licenses.free;
        };
      }) {};
    names = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "names";
        ename = "names";
        version = "20151201.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/names-20151201.0.tar";
          sha256 = "0nf6n8hk58a7r56d899s5dsva3jjvh3qx9g2d1hra403fwlds74k";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/names.html";
          license = lib.licenses.free;
        };
      }) {};
    nano-agenda = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nano-agenda";
        ename = "nano-agenda";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-agenda-0.3.tar";
          sha256 = "12sh6wqqd13sv966wj4k4djidn238fdb6l4wg3z9ib0dx36nygcr";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-modeline-1.0.1.tar";
          sha256 = "0frvg9zy9i8qqb6il0csxmgxsd373n696kwz1xqq28jikvhzkwyy";
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
        version = "0.3.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-theme-0.3.4.tar";
          sha256 = "0x49lk0kx8mz72a81li6gwg3kivn7bn4ld0mml28smzqqfr3873a";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nano-theme.html";
          license = lib.licenses.free;
        };
      }) {};
    nftables-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "nftables-mode";
        ename = "nftables-mode";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nftables-mode-1.1.tar";
          sha256 = "1wjw6n60kj84j8gj62mr6s97xd0aqvr4v7npyxwmhckw9z13xcqv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nftables-mode.html";
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
          url = "https://elpa.gnu.org/packages/nhexl-mode-1.5.tar";
          sha256 = "1i1by5bp5dby2r2jhzr0jvnchrybgnzmc5ln84w66180shk2s3yk";
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
          url = "https://elpa.gnu.org/packages/nlinum-1.9.tar";
          sha256 = "1cpyg6cxaaaaq6hc066l759dlas5mhn1fi398myfglnwrglia3lm";
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
        version = "1.31";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/notes-mode-1.31.tar";
          sha256 = "0lwja53cknd1w432mcbfrcshmxmk23dqrbr9k2101pqfzbw8nri2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/notes-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    notmuch-indicator = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "notmuch-indicator";
        ename = "notmuch-indicator";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/notmuch-indicator-1.1.0.tar";
          sha256 = "1g30hzb238w9cnxqw8w7gw5l8sl4rx122napmm9rx974hdk3zk9k";
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
        version = "2.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ntlm-2.1.0.tar";
          sha256 = "0kivmb6b57qjrwd41zwlfdq7l9nisbh4mgd96rplrkxpzw6dq0j7";
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
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/num3-mode-1.5.tar";
          sha256 = "1a7w2qd210zp199c1js639xbv2kmqmgvcqi5dn1vsazasp2dwlj2";
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
          sha256 = "0bz4gqg5bhv6zk875q7sb0y56yvylnv0chj77ivjjpkha6rdp311";
        };
        packageRequires = [ cl-lib nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/oauth2.html";
          license = lib.licenses.free;
        };
      }) {};
    ob-asymptote = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ob-asymptote";
        ename = "ob-asymptote";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ob-asymptote-1.0.tar";
          sha256 = "1hmqbkrqg18w454xg37rg5cg0q3vd0b0fm14n5chihqrwwnwrf4l";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ob-asymptote.html";
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
          sha256 = "095qcvxpanw6fh96dfkdydn10xikbrjwih7i05iiyvazpk4x6nbz";
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
          sha256 = "1shgpha6f1pql95v86whsw6w6j7v35cas98fyygwrpkcrxx9a56r";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/omn-mode-1.3.tar";
          sha256 = "01yg4ifbz7jfhvq6r6naf50vx00wpjsr44mmlj580bylfrmdc839";
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
          url = "https://elpa.gnu.org/packages/on-screen-1.3.3.tar";
          sha256 = "0w5cv3bhb6cyjhvglp5y6cy51ppsh2xd1x53i4w0gm44g5n8l6bd";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/on-screen.html";
          license = lib.licenses.free;
        };
      }) {};
    openpgp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "openpgp";
        ename = "openpgp";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/openpgp-1.0.1.tar";
          sha256 = "052wh38q6r09avxa0bgc5gn4769763zmgijza76mb0b3lzj66syv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/openpgp.html";
          license = lib.licenses.free;
        };
      }) {};
    orderless = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "orderless";
        ename = "orderless";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/orderless-1.1.tar";
          sha256 = "1qjxln21ydc86kabk5kwa6ky40qjqcrk5nmc92w42x3ypxs711f3";
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
        version = "9.6.28";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-9.6.28.tar";
          sha256 = "1slh28vjwhb65q0630p1syv6ampdsqgrdmisyj4f328g3j2brpkw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contacts = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-contacts";
        ename = "org-contacts";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-contacts-1.1.tar";
          sha256 = "0gqanhnrxajx5cf7g9waks23sclbmvmwjqrs0q4frcih3gs2nhix";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contacts.html";
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
          sha256 = "1pifs5mbcjab21ylclck4kjdcds1xkvym27ncn9wwr8fl3fff2yl";
        };
        packageRequires = [ emacs org seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-edna.html";
          license = lib.licenses.free;
        };
      }) {};
    org-jami-bot = callPackage ({ elpaBuild, emacs, fetchurl, jami-bot, lib }:
      elpaBuild {
        pname = "org-jami-bot";
        ename = "org-jami-bot";
        version = "0.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-jami-bot-0.0.5.tar";
          sha256 = "1fiv0a7k6alvfvb7c6av0kbkwbw58plw05hhcf1vnkr9gda3s13y";
        };
        packageRequires = [ emacs jami-bot ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-jami-bot.html";
          license = lib.licenses.free;
        };
      }) {};
    org-modern = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-modern";
        ename = "org-modern";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-modern-1.2.tar";
          sha256 = "1bm8kkcrn0glsb69sapj1zmb2ygd4sxksb3gag4hw1v5w3g51jjh";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-modern.html";
          license = lib.licenses.free;
        };
      }) {};
    org-notify = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-notify";
        ename = "org-notify";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-notify-0.1.1.tar";
          sha256 = "1vg0h32x5lc3p5n71m23q8mfdd1fq9ffmy9rsm5rcdphfk8s9x5l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-notify.html";
          license = lib.licenses.free;
        };
      }) {};
    org-real = callPackage ({ boxy, elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-real";
        ename = "org-real";
        version = "1.0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-real-1.0.8.tar";
          sha256 = "03g12czy833yzj7idkharsbl2zd1ajnsf7ay8qxqljwqrz8m91gw";
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
        version = "1.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-remark-1.2.2.tar";
          sha256 = "01iprzgbyvbfpxp6fls4lfx2lxx7xkff80m35s9kc0ih5jlxc5qs";
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
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-transclusion-1.3.2.tar";
          sha256 = "14w9n10s6nh3nylkx3xzbqjb9pp4dja85agh0h2bzlbkaq4j7vij";
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
        version = "0.1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-translate-0.1.4.tar";
          sha256 = "0s0vqpncb6rvhpxdir5ghanjyhpw7bplqfh3bpgri5ay2b46kj4f";
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
        version = "1.14";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/orgalist-1.14.tar";
          sha256 = "02diwanqldzr42aaa5kqcj1xgxmf1k6rqhk9zv40psqpzgd1yms5";
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
          sha256 = "1ls6v0mkh7z90amrlczrvv6mgpv6hzzjw0zlxjlzsj2vr1gz3vca";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/osm-1.3.tar";
          sha256 = "0s5k6akdvbm9gsgzjlz795vgfy3pkl4qdk45p16p40f59dr49g4r";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/osm.html";
          license = lib.licenses.free;
        };
      }) {};
    other-frame-window = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "other-frame-window";
        ename = "other-frame-window";
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/other-frame-window-1.0.6.tar";
          sha256 = "1x8i6hbl48vmp5h43drr35lwaiwhcyr3vnk7rcyim5jl2ijw8yc0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/other-frame-window.html";
          license = lib.licenses.free;
        };
      }) {};
    pabbrev = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pabbrev";
        ename = "pabbrev";
        version = "4.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pabbrev-4.3.0.tar";
          sha256 = "1fplbmzqz066gsmvmf2indg4n348vdgs2m34dm32gnrjghfrxxhs";
        };
        packageRequires = [ emacs ];
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
          sha256 = "0j2362zq22j6qma6bb6jh6qpd12zrc161pgl9cfhnq5m3s9i1sz4";
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
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/parser-generator-0.2.1.tar";
          sha256 = "1vrgkvcj16550frq2jivw31cmq6rhwrifmdk4rf0266br3jdarpf";
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
          sha256 = "0v9gasc0wlqd7pks6k3695md7mdfnaknh6xinmp4pkvvalfh7shv";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/peg-1.0.1.tar";
          sha256 = "14ll56fn9n11nydydslp7xyn79122dprm89i181ks170v0qcsps3";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/peg.html";
          license = lib.licenses.free;
        };
      }) {};
    perl-doc = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "perl-doc";
        ename = "perl-doc";
        version = "0.81";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/perl-doc-0.81.tar";
          sha256 = "1828jfl5dwk1751jsrpr2gr8hs1x315xlb9vhiis8frzvqmsribw";
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
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/persist-0.6.tar";
          sha256 = "1p6h211xk0lrk4zqlm51rsms5lza9ymx6ayh9ij0afqrjqgffw77";
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
        version = "0.4.49";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/phps-mode-0.4.49.tar";
          sha256 = "1zxzv6h2075s0ldwr9izfy3sxrrg3x5y5vilnlgnwd7prcq8qa8y";
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
          url = "https://elpa.gnu.org/packages/pinentry-0.1.tar";
          sha256 = "0i5g4yj2qva3rp8ay2fl9gcmp7q42caqryjyni8r5h4f3misviwq";
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
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/plz-0.8.tar";
          sha256 = "0kg275kq5hi83ry0n83w8pi0qn2lmlv9gnxcbwf1dcqk7n9i2v64";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/plz.html";
          license = lib.licenses.free;
        };
      }) {};
    plz-see = callPackage ({ elpaBuild, emacs, fetchurl, lib, plz }:
      elpaBuild {
        pname = "plz-see";
        ename = "plz-see";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/plz-see-0.1.tar";
          sha256 = "1mi35d9b26d425v1kkmmbh477klcxf76fnyg154ddjm0nkgqq90d";
        };
        packageRequires = [ emacs plz ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/plz-see.html";
          license = lib.licenses.free;
        };
      }) {};
    poke = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "poke";
        ename = "poke";
        version = "3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poke-3.2.tar";
          sha256 = "15j4g5y427d9mja2irv3ak6x60ik4kpnscnwl9pqym7qly7sa3v9";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poke.html";
          license = lib.licenses.free;
        };
      }) {};
    poke-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "poke-mode";
        ename = "poke-mode";
        version = "3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poke-mode-3.1.tar";
          sha256 = "0g4vd26ahkmjxlcvqwd0mbk60qaf6c9zba9x7bb9pqabka9438y1";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poker-0.2.tar";
          sha256 = "10lfc6i4f08ydxanidwiq9404h4nxfa0vh4av5rrj6snqzqvd1bw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/poker.html";
          license = lib.licenses.free;
        };
      }) {};
    popper = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "popper";
        ename = "popper";
        version = "0.4.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/popper-0.4.6.tar";
          sha256 = "0xwy4p9g0lfd4ybamsl5gsppmx79yv16s4lh095x5y5qfmgcvq2c";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/popper.html";
          license = lib.licenses.free;
        };
      }) {};
    posframe = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "posframe";
        ename = "posframe";
        version = "1.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/posframe-1.4.3.tar";
          sha256 = "1kw37dhyd6qxj0h2qpzi539jrgc0pj90psf2k58z4jc9199bgsax";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pq-0.2.tar";
          sha256 = "0d8ylsbmypaj29w674a4k445zr6hnggic8rsv7wx7jml6p2zph2n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/pq.html";
          license = lib.licenses.free;
        };
      }) {};
    project = callPackage ({ elpaBuild, emacs, fetchurl, lib, xref }:
      elpaBuild {
        pname = "project";
        ename = "project";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/project-0.10.0.tar";
          sha256 = "07lv41asdah2v3k6nrc73z3pjhsm7viygr12ly9p96g2yw11irg6";
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
        version = "1.3.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/psgml-1.3.5.tar";
          sha256 = "1lfk95kr43az6ykfyhj7ygccw3ms2ifyyp43w9lwm5fcawgc8952";
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
    pulsar = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "pulsar";
        ename = "pulsar";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pulsar-1.0.1.tar";
          sha256 = "0xljxkls6lckfg5whx2kb44dp67q2jfs7cbk6ih5b3zm6h599d4k";
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
        version = "5.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pyim-5.3.3.tar";
          sha256 = "03khpd3skv7ijmnn721dvila8x6pvg9pl4p7djyz8m59xgvv55dp";
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
        version = "0.5.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pyim-basedict-0.5.4.tar";
          sha256 = "0i42i9jr0p940w17fjjrzd258winjl7sv4g423ihd6057xmdpyd8";
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
          sha256 = "042jhg87bnc750wwjwvp32ici3pyswx1pza2qz014ykdqqnsx0aq";
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
          url = "https://elpa.gnu.org/packages/quarter-plane-0.1.tar";
          sha256 = "06syayqdmh4nb7ys52g1mw01wnz5hjv710dari106fk8fm9cy18c";
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
          url = "https://elpa.gnu.org/packages/queue-0.2.tar";
          sha256 = "117g6sl5dh7ssp6m18npvrqik5rs2mnr16129cfpnbi3crsw23c8";
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
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rainbow-mode-1.0.6.tar";
          sha256 = "0xv39jix1gbwq6f8laj93sqkf2j5hwda3l7mjqc7vsqjw1lkhmjv";
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
          url = "https://elpa.gnu.org/packages/rbit-0.1.tar";
          sha256 = "1xfl3m53bdi25h8mp7s0zp1yy7436cfydxrgkfc31fsxkh009l9h";
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
        version = "0.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-color-0.4.5.tar";
          sha256 = "0sfwmi0sspj7sx1psij4fzq1knwva8706w0204mbjxsq2nh5s9f3";
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
    rcirc-sqlite = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rcirc-sqlite";
        ename = "rcirc-sqlite";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-sqlite-1.0.1.tar";
          sha256 = "0n0492s500gplmv7l8n8l7s3rpm1nli3n706n9f91qc15z6p6mcv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rcirc-sqlite.html";
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
          sha256 = "1iisvzxvdsifxkz7b2wacw85dkjagrmbcdhcfsnswnfbp3r3kg35";
        };
        packageRequires = [ emacs load-relative loc-changes test-simple ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud.html";
          license = lib.licenses.free;
        };
      }) {};
    realgud-ipdb = callPackage ({ elpaBuild, emacs, fetchurl, lib, realgud }:
      elpaBuild {
        pname = "realgud-ipdb";
        ename = "realgud-ipdb";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-ipdb-1.0.0.tar";
          sha256 = "0zmgsrb15rmgszidx4arjazb6fz523q5w516z5k5cn92wfzfyncr";
        };
        packageRequires = [ emacs realgud ];
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
          sha256 = "1g4spjrldyi9rrh5dwrcqpz5qm37fq2qpvmirxvdqgfbwl6gapzj";
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
          sha256 = "09vllklpfc0q28ankp2s1v10kwnxab4g6hb9zn63d1rfa92qy44k";
        };
        packageRequires = [ cl-lib emacs load-relative realgud ];
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-trepan-xpy-1.0.1.tar";
          sha256 = "13fll0c6p2idg56q0czgv6s00vvb585b40dn3b14hdpy0givrc0x";
        };
        packageRequires = [ emacs load-relative realgud ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud-trepan-xpy.html";
          license = lib.licenses.free;
        };
      }) {};
    rec-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rec-mode";
        ename = "rec-mode";
        version = "1.9.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rec-mode-1.9.3.tar";
          sha256 = "00hps4pi7r20qqqlfl8g5dqwipgyqqrhxc4hi5igl0rg563jc1wx";
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
          url = "https://elpa.gnu.org/packages/register-list-0.1.tar";
          sha256 = "01w2yyvbmnkjrmx5f0dk0327c0k7fvmgi928j6hbvlrp5wk6s394";
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
        version = "1.24";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/relint-1.24.tar";
          sha256 = "0pnv2pkx5jq30049zplrmspkm1cc7p6vy9xfv215d27v8nas0374";
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
        version = "1.2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/repology-1.2.4.tar";
          sha256 = "0nj4dih9mv8crqq8rd4k8dzgq7l0195syfxsf2gyikmqz9sjbr85";
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
          sha256 = "0npk6gnr2m4mfv40y2m265lxk1dyn8fd6d90vs3j2xrhpybgbln2";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rnc-mode-0.3.tar";
          sha256 = "1p03g451888v86k9z6g8gj375p1pcdvikgk1phxkhipwi5hbf5g8";
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
        version = "7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rt-liberation-7.tar";
          sha256 = "0bi1qyc4n4ar0rblnddmlrlrkdvdrvv54wg4ii39hhxij4p6niif";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rt-liberation.html";
          license = lib.licenses.free;
        };
      }) {};
    ruby-end = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "ruby-end";
        ename = "ruby-end";
        version = "0.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ruby-end-0.4.3.tar";
          sha256 = "07175v9fy96lmkfa0007lhx7v3fkk77iwca3rjl94dgdp4b8lbk5";
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
        version = "0.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rudel-0.3.2.tar";
          sha256 = "00rs2fy64ybam26szpc93miwajq42acyh0dkg0ixr95mg49sc46j";
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
          sha256 = "115rkq2ygawsg8ph44zfqwsd9ykm4370v0whgjwhc1wx2iyn5ir9";
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
          sha256 = "1c42mg7m6fa7xw3svv741sgrc9zjl1zcq0vg45k61iqmnx8d44vp";
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
          url = "https://elpa.gnu.org/packages/scroll-restore-1.0.tar";
          sha256 = "1i9ld1l5h2cpzf8bzk7nlk2bcln48gya8zrq79v6rawbrwdlz2z4";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sed-mode-1.1.tar";
          sha256 = "0zhga0xsffdcinh10di046n6wbx35gi1zknnqzgm9wvnm2iqxlyn";
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
        version = "2.24";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/seq-2.24.tar";
          sha256 = "13x8l1m5if6jpc8sbrbx9r64fyhh450ml6vfm92p6i5wv6gl74w6";
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
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/setup-1.4.0.tar";
          sha256 = "0id7j8xvbkbpfiv7m55dl64y27dpiczljagldf4p9q6qwlhf42f7";
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
          sha256 = "0zhkk04nj25lmpdlqblfhx3rb415w2f58f7wb19k1s2ry4k7m15g";
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
        version = "2.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/shell-command+-2.4.2.tar";
          sha256 = "1kjj8n3nws7dl7k3ksnfx0s0kwvqb9wzy9k42xs5s51k7xrp1l18";
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
          sha256 = "0xskyd0d3krwgrpca10m7l7c0l60qq7jjn2q207n61yw5yx71pqn";
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
          url = "https://elpa.gnu.org/packages/sisu-mode-7.1.8.tar";
          sha256 = "02cfyrjynwvf2rlnkfy8285ga9kzbg1b614sch0xnxqw81mp7drp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sisu-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    site-lisp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "site-lisp";
        ename = "site-lisp";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/site-lisp-0.1.2.tar";
          sha256 = "1w27nd061y7a5qhdmij2056751wx9nwv89qx3hxcl473iz03b09l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/site-lisp.html";
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
          sha256 = "1vrbmyhf9bffy2fkz91apzxla6v8nbv2wb25vxcr9x3smbag9kal";
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
          sha256 = "1qlmsxnhja8p873rvb1qj4xsf938bs3hl8qqqsmrm0csvlb9737p";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sm-c-mode-1.2.tar";
          sha256 = "0xykl8wkbw5y7ah79zlfzz1k0di9ghfsv2xjxwx7rrb37wny5184";
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
          sha256 = "0ly2qmsbmzd5nd7iaighws10y0yj7p2356fw32pkp0cmzzvc3d54";
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
          url = "https://elpa.gnu.org/packages/smart-yank-0.1.1.tar";
          sha256 = "08dc4c60jcjyiixyzckxk5qk6s2pl1jmrp4h1bj53ssd1kn4208m";
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
        version = "6.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sml-mode-6.12.tar";
          sha256 = "10zp0gi5rbjjxjzn9k6klvdms9k3yxx0qry0wa75a68sj5x2rdzh";
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
          sha256 = "01qdxlsllpj5ajixkqf7v9p95zn9qnvjdnp30v54ymj2pd0d9a32";
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
        version = "3.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/soap-client-3.2.3.tar";
          sha256 = "1yhs661g0vqxpxqcxgsxvljmrpcqzl0y52lz6jvfilmshw7r6k2s";
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
        version = "1.4.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sokoban-1.4.9.tar";
          sha256 = "1l3d4al96252kdhyn4dr88ir67kay57n985w0qy8p930ncrs846v";
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
          url = "https://elpa.gnu.org/packages/sotlisp-1.6.2.tar";
          sha256 = "0q65iwr89cwwqnc1kndf2agq5wp48a7k02qsksgaj0n6zv7i4dfn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sotlisp.html";
          license = lib.licenses.free;
        };
      }) {};
    spacious-padding = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spacious-padding";
        ename = "spacious-padding";
        version = "0.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/spacious-padding-0.4.1.tar";
          sha256 = "0w9f19sxpbaagwxfnsg3qmk95v8vnkfcyd3l6i9ns9ww26sb2fgl";
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
        version = "1.7.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/spinner-1.7.4.tar";
          sha256 = "0lq8q62q5an8199p8pyafg5l6hdnnqi6i6sybnk60sdcqy62pa6r";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-beeline-0.2.tar";
          sha256 = "0ngvvfhs1fj3ca5g563bssaz9ac5fiqkqzv09s4ramalp2q6axq9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-beeline.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-cassandra = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sql-cassandra";
        ename = "sql-cassandra";
        version = "0.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-cassandra-0.2.2.tar";
          sha256 = "154rymq0k6869cw7sc7nhx3di5qv1ffgf8shkxc22gvkrj2s7p9b";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-cassandra.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-indent = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "sql-indent";
        ename = "sql-indent";
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-indent-1.7.tar";
          sha256 = "1yfb01wh5drgvrwbn0hgzyi0rc4zlr1w23d065x4qrld31jbka8i";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    srht = callPackage ({ elpaBuild, emacs, fetchurl, lib, plz, transient }:
      elpaBuild {
        pname = "srht";
        ename = "srht";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/srht-0.4.tar";
          sha256 = "0ps49syzlaf4lxvji61y6y7r383r65v96d57hj75xkn6hvyrz74n";
        };
        packageRequires = [ emacs plz transient ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/srht.html";
          license = lib.licenses.free;
        };
      }) {};
    ssh-deploy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ssh-deploy";
        ename = "ssh-deploy";
        version = "3.1.16";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ssh-deploy-3.1.16.tar";
          sha256 = "0fb88l3270d7l808q8x16zcvjgsjbyhgifgv17syfsj0ja63x28p";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ssh-deploy.html";
          license = lib.licenses.free;
        };
      }) {};
    standard-themes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "standard-themes";
        ename = "standard-themes";
        version = "2.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/standard-themes-2.0.1.tar";
          sha256 = "0cyr3n9w359sa8ylcgzsvhxrk9f1rl1scb5339ci2la7zpg5vxwr";
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
        version = "2.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/stream-2.3.0.tar";
          sha256 = "0224hjcxvy3cxv1c3pz9j2laxld2cxqbs5sigr02fcdcb9qn7hay";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/stream.html";
          license = lib.licenses.free;
        };
      }) {};
    substitute = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "substitute";
        ename = "substitute";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/substitute-0.2.1.tar";
          sha256 = "09cqxfp9az6cckh0bq1155g6xh9rjn0ppjyc6879ihx6ba61li53";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-1.1.tar";
          sha256 = "10x2rry349ibzd9awy4rg18cd376yvkzqsyq0fm4i05kq4dzqp4a";
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
          url = "https://elpa.gnu.org/packages/svg-clock-1.2.tar";
          sha256 = "0r0wayb1q0dd2yi1nqa0m4jfy36lydxxa6xvvd6amgh9sy499qs8";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-lib-0.3.tar";
          sha256 = "1s7n3j1yzprs9frb554c66pcrv3zss1y26y6qgndii4bbzpa7jh8";
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
          sha256 = "0wzcq00kbjpbwz7acn4d7jd98v5kicq3iwgf6dnmz2kflvkfwkvr";
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
        version = "0.14.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/swiper-0.14.2.tar";
          sha256 = "1rzp78ix19ddm7fx7p4i5iybd5lw244kqvf3nrafz3r7q6hi8yds";
        };
        packageRequires = [ emacs ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/swiper.html";
          license = lib.licenses.free;
        };
      }) {};
    switchy-window = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "switchy-window";
        ename = "switchy-window";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/switchy-window-1.3.tar";
          sha256 = "0ym5cy6czsrd15f8rgh3dad8fwn8pb2xrvhlmdikc59cc29zamrv";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/switchy-window.html";
          license = lib.licenses.free;
        };
      }) {};
    sxhkdrc-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sxhkdrc-mode";
        ename = "sxhkdrc-mode";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sxhkdrc-mode-1.0.0.tar";
          sha256 = "0gfv5l71md2ica9jfa8ynwfag3zvayc435pl91lzcz92qy5n0hlj";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sxhkdrc-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    system-packages = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "system-packages";
        ename = "system-packages";
        version = "1.0.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/system-packages-1.0.13.tar";
          sha256 = "0xlbq44c7f2assp36g5z9hn5gldq76wzpcinp782whqzpgz2k4sy";
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
    tam = callPackage ({ elpaBuild, emacs, fetchurl, lib, queue }:
      elpaBuild {
        pname = "tam";
        ename = "tam";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tam-0.1.tar";
          sha256 = "16ms55cwm2cwixl03a3bbsqs159c3r3dv5kaazvsghby6c511bx8";
        };
        packageRequires = [ emacs queue ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tam.html";
          license = lib.licenses.free;
        };
      }) {};
    taxy = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "taxy";
        ename = "taxy";
        version = "0.10.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/taxy-0.10.1.tar";
          sha256 = "0r4kv0lqjk720p8kfah256370miqg68598jp5466sc6v9qax4wd9";
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
        version = "0.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/taxy-magit-section-0.13.tar";
          sha256 = "06sivl4rc06qr67qw2gqpw7lsaqf3j78llkrljwby7a77yzlhbrj";
        };
        packageRequires = [ emacs magit-section taxy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/taxy-magit-section.html";
          license = lib.licenses.free;
        };
      }) {};
    temp-buffer-browse = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "temp-buffer-browse";
        ename = "temp-buffer-browse";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/temp-buffer-browse-1.5.tar";
          sha256 = "00hbh25fj5fm9dsp8fpdk8lap3gi5jlva6f0m6kvjqnmvc06q36r";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tempel-1.1.tar";
          sha256 = "01zrp3wi4nvp67wda1b5fyjfxd0akhk7aqc2nqh1sk4mjp5zpnsq";
        };
        packageRequires = [ compat emacs ];
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
          url = "https://elpa.gnu.org/packages/test-simple-1.3.0.tar";
          sha256 = "065jfps5ixpy5d4l2xgwhkpafdwiziqh4msbjcascwpac3j5c5yp";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/test-simple.html";
          license = lib.licenses.free;
        };
      }) {};
    theme-buffet = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "theme-buffet";
        ename = "theme-buffet";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/theme-buffet-0.1.2.tar";
          sha256 = "1cfrrl41rlxdbybvxs8glkgmgkznwgpq70h58rkvwm6b5jfs8wv0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/theme-buffet.html";
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
    tmr = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tmr";
        ename = "tmr";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tmr-0.4.0.tar";
          sha256 = "0vvsanjs6b9m3gxm84qr0ywwdj0378y5jkv1nzqdn980rfgfimsv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tmr.html";
          license = lib.licenses.free;
        };
      }) {};
    tomelr = callPackage ({ elpaBuild, emacs, fetchurl, lib, map, seq }:
      elpaBuild {
        pname = "tomelr";
        ename = "tomelr";
        version = "0.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tomelr-0.4.3.tar";
          sha256 = "0r2f4dl10fl75ygvbmb4vkqixy24k0z2wpr431ljzp5m29bn74kh";
        };
        packageRequires = [ emacs map seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tomelr.html";
          license = lib.licenses.free;
        };
      }) {};
    topspace = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "topspace";
        ename = "topspace";
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/topspace-0.3.1.tar";
          sha256 = "0m8z2q1gdi0zfh1df5xb2v0sg1v5fysrl00fv2qqgnd61c2n0hhz";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/topspace.html";
          license = lib.licenses.free;
        };
      }) {};
    track-changes = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "track-changes";
        ename = "track-changes";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/track-changes-1.1.tar";
          sha256 = "04srqkpyc6l3s95jyf2p5pqqf1z67i7k89334r6ybqj1l91h2prn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/track-changes.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tramp";
        ename = "tramp";
        version = "2.6.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-2.6.3.tar";
          sha256 = "0z44mfpvn4qy2xc2fsiahw3xir140ljna8aq45dcb7qnmr044xjb";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-nspawn-1.0.1.tar";
          sha256 = "0cy8l389s6pi135gxcygv1vna6k3gizqd33avf3wsdbnqdf2pjnc";
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
          url = "https://elpa.gnu.org/packages/tramp-theme-0.2.tar";
          sha256 = "0dz8ndnmwc38g1gy30f3jcjqg5nzdi6721x921r4s5a8i1mx2kpm";
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
          url = "https://elpa.gnu.org/packages/transcribe-1.5.2.tar";
          sha256 = "1v1bvcv3zqrj073l3vw7gz20rpa9p86rf1yv219n47kmh27c80hq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transcribe.html";
          license = lib.licenses.free;
        };
      }) {};
    transient = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "transient";
        ename = "transient";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/transient-0.6.0.tar";
          sha256 = "0rk4gafx3yylzawiny86ml4jzrs8x6cf2bvmnv36p8l13wgp0w9p";
        };
        packageRequires = [ compat emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transient.html";
          license = lib.licenses.free;
        };
      }) {};
    transient-cycles = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "transient-cycles";
        ename = "transient-cycles";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/transient-cycles-1.0.tar";
          sha256 = "0s6cxagqxj4i3qf4kx8mdrihciz3v6ga7zw19jcv896rdhx75bx5";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/transient-cycles.html";
          license = lib.licenses.free;
        };
      }) {};
    tree-inspector = callPackage ({ elpaBuild, emacs, fetchurl, lib, treeview }:
      elpaBuild {
        pname = "tree-inspector";
        ename = "tree-inspector";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tree-inspector-0.4.tar";
          sha256 = "0v59kp1didml9k245m1v0s0ahh2r79cc0hp5ika93iamrdxkxaiz";
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
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/trie-0.6.tar";
          sha256 = "1jvhvvxkxbbpy93x9kpznvp2hqkkbdbbjaj27fd0wkbijg0k03ln";
        };
        packageRequires = [ heap tNFA ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/trie.html";
          license = lib.licenses.free;
        };
      }) {};
    triples = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "triples";
        ename = "triples";
        version = "0.3.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/triples-0.3.5.tar";
          sha256 = "1wvmfw8yc7nh42f1skmpxqz5f57vkhg7x2cdngpq11lqbgvypj7m";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/typo-1.0.1.tar";
          sha256 = "1w4m2admlgmx7d661l70rryyxbaahfvrvhxc1b9sq41nx88bmgn1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/typo.html";
          license = lib.licenses.free;
        };
      }) {};
    ulisp-repl = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "ulisp-repl";
        ename = "ulisp-repl";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ulisp-repl-1.0.3.tar";
          sha256 = "1c23d66vydfp29px2dlvgl5xg91a0rh4w4b79q8ach533nfag3ia";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ulisp-repl.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-tree = callPackage ({ elpaBuild, fetchurl, lib, queue }:
      elpaBuild {
        pname = "undo-tree";
        ename = "undo-tree";
        version = "0.8.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/undo-tree-0.8.2.tar";
          sha256 = "0ad1zhkjdf73j3b2i8nd7f10jlqqvcaa852yycms4jr636xw6ms6";
        };
        packageRequires = [ queue ];
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
          sha256 = "08150kgqsbcpykvf8m2b25y386h2b4pj08vffm6wh4f000wr72k3";
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
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/uniquify-files-1.0.4.tar";
          sha256 = "0xw2l49xhdy5qgwja8bkiq2ibdppl45xzqlr17z92l1vfq4akpzp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uniquify-files.html";
          license = lib.licenses.free;
        };
      }) {};
    urgrep = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "urgrep";
        ename = "urgrep";
        version = "0.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/urgrep-0.4.1.tar";
          sha256 = "046096vk8d5xy33icv4s0s101lrx3xan9ppvh77rqxd95gglhgap";
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
                                 , nadvice
                                 , ntlm ? null }:
      elpaBuild {
        pname = "url-http-ntlm";
        ename = "url-http-ntlm";
        version = "2.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/url-http-ntlm-2.0.5.tar";
          sha256 = "02b65z70kw37mzj2hh8q6z0zhhacf9sc4hlczpfxdfsy05b8yri9";
        };
        packageRequires = [ cl-lib nadvice ntlm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-http-ntlm.html";
          license = lib.licenses.free;
        };
      }) {};
    url-http-oauth = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "url-http-oauth";
        ename = "url-http-oauth";
        version = "0.8.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/url-http-oauth-0.8.3.tar";
          sha256 = "06lpzh8kpxn8cr92blxrjw44h2cfc6fw0pr024sign4acczx10ws";
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
        version = "0.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/url-scgi-0.9.tar";
          sha256 = "19lvr4d2y9rd5gibaavp7ghkxmdh5zad9ynarbi2w4rjgmz5y981";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/url-scgi.html";
          license = lib.licenses.free;
        };
      }) {};
    use-package = callPackage ({ bind-key, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "use-package";
        ename = "use-package";
        version = "2.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/use-package-2.4.5.tar";
          sha256 = "060bbrbmx3psv4jkn95zjyhbyfidip86sfi8975fhqcc0aagnwhp";
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
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/validate-1.0.4.tar";
          sha256 = "1bn25l62zcabg2ppxwr4049m1qd0yj095cflqrak0n50acgjs6w5";
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
          sha256 = "16v2mmrih0ykk4z6qmy29gajjb3v83q978gzn3y6pg8y48b2wxpb";
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
          sha256 = "0a45bbrvk4s9cj3ih3hb6vqjv4hkwnz7m9a4mr45m6cb0sl9b8a3";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vc-got-1.2.tar";
          sha256 = "04m1frrnla4zc8db728280r9fbk50bgjkk4k7dizb0hawghk4r3p";
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
          sha256 = "0a8a4d9difrp2r6ac8micxn8ij96inba390324w087yxwqzkgk1g";
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
        version = "0.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vcard-0.2.2.tar";
          sha256 = "0r56y3q2gigm8rxifly50m5h1k948y987541cqd8w207wf1b56bh";
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
          url = "https://elpa.gnu.org/packages/vcl-mode-1.1.tar";
          sha256 = "0zz664c263x24xzs7hk2mqchzplmx2dlba98d5fpy8ybdnziqfkj";
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
          sha256 = "0crgb32dk0yzcgvjai0b67wcbcfppc3h0ppfqgdrim1nincbwc1m";
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
        version = "2024.3.1.121933719";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/verilog-mode-2024.3.1.121933719.tar";
          sha256 = "1z0mbd5sbbq2prhc0vfpqd4h4a6jwl5fqyrnl39yp05zm66va34w";
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
        version = "1.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-1.8.tar";
          sha256 = "0k6sfla0183vyjf2yd9sycck9nxz0x659kygxgiaip3zq7f9zkg8";
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
        version = "0.7.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-posframe-0.7.7.tar";
          sha256 = "0ahn0b5v9xw6f1zvgv27c82kxdh4rx7n9dbp17rkkkg3dvvkdzxy";
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
          url = "https://elpa.gnu.org/packages/vigenere-1.0.tar";
          sha256 = "1zlni6amznzi9w96kj7lnhfrr049crva2l8kwl5jsvyaj5fc6nq5";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/visual-filename-abbrev-1.2.tar";
          sha256 = "0vy4ar10wbdykzl47xnrfcwszjxyq2f1vhdbynfcmkcyrr40v4wm";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/visual-fill-0.2.tar";
          sha256 = "00r3cclhrdx5y0h1p1rrx5psvc8d95dayzpjdsy9xj44i8pcnvja";
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
          sha256 = "1napxdavsrwb5dq2i4ka06rhmmfk6qixc8mm2a6ab68iavprrqkv";
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
        version = "2.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vundo-2.3.0.tar";
          sha256 = "165y277fi0vp9301hy3pqgfnf160k29n8vri0zyq8a3vz3f8lqrl";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vundo.html";
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
          sha256 = "0igsdsfw80nnrbw1ba3rgwp16ncy195kwv78ll9zbbf3y23n7kr0";
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
          url = "https://elpa.gnu.org/packages/wconf-0.2.1.tar";
          sha256 = "1ci5ysn2w9hjzcsv698b6mh14qbrmvlzn4spaq4wzwl9p8672n08";
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
          sha256 = "0wikajm4pbffcy8clwwb5bnz67isqmcsbf9kca8rzx4svzi5j2gc";
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
          sha256 = "0418fpw2ra12n77560gh9j9ymv28d895bdhpr7x9xakvijjh705m";
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
        version = "1.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/websocket-1.15.tar";
          sha256 = "0cm3x6qzr4zqj46w0qfpn7n9g5z80figcv824869snvc74465h1g";
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
          sha256 = "1lf8q6sq0hnrspj6qy49i48az3js24ab4y0gksw4giiifiqlc5ba";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/which-key.html";
          license = lib.licenses.free;
        };
      }) {};
    window-commander = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "window-commander";
        ename = "window-commander";
        version = "3.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/window-commander-3.0.2.tar";
          sha256 = "15345sgdmgz0vv9bk2cmffjp66i0msqj0xn2cxl7wny3bkfx8amv";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/window-commander.html";
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
          url = "https://elpa.gnu.org/packages/windresize-0.1.tar";
          sha256 = "1wjqrwrfql5c67yv59hc95ga0mkvrqz74gy46aawhn8r3xr65qai";
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
        version = "4.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisi-4.3.2.tar";
          sha256 = "0qa6nig33igv4sqk3fxzrmx889pswq10smj9c9l3phz2acqx8q92";
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
        version = "1.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisitoken-grammar-mode-1.3.0.tar";
          sha256 = "0i0vy751ycbfp8l8ynzj6iqgvc3scllwysdchpjv4lyj0m7m3s20";
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
          url = "https://elpa.gnu.org/packages/wpuzzle-1.1.tar";
          sha256 = "05dgvr1miqp870nl7c8dw7j1kv4mgwm8scynjfwbs9wjz4xmzc6c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wpuzzle.html";
          license = lib.licenses.free;
        };
      }) {};
    wrap-search = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "wrap-search";
        ename = "wrap-search";
        version = "4.14.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wrap-search-4.14.11.tar";
          sha256 = "07x6fcig69d3hmcmvpj75h605j8sfjwmd4z1yd4rb6np60dh42ff";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wrap-search.html";
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
          sha256 = "081k9azz9jnmjmqlcc1yw9s4nziac772lw75xcm78fgsfrx42hmr";
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
        version = "3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xeft-3.3.tar";
          sha256 = "00zkhqajkkf979ccbnz076dpav2v52q44li2m4m4c6p3z0c3y255";
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
        version = "0.18";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xelb-0.18.tar";
          sha256 = "1qixb236z01azjbc1xycji99rjkq747hip4gcf0gli1is8ink0bs";
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
          sha256 = "12a12rmbc1c0j60nv1s8fgg3r2lcjw8hs7qpyscm7ggwanylxn6q";
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
        version = "1.25";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xr-1.25.tar";
          sha256 = "0jmhcrz6mj3fwm9acwv1jj6nlnqikprjgvglr3cgxysinqh6y3xi";
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
        version = "1.6.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xref-1.6.3.tar";
          sha256 = "0mir1nhic0rnz12d8i1n6m2ihfynhkkg8yccy4v9j4kd31w6f1gs";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref.html";
          license = lib.licenses.free;
        };
      }) {};
    xref-union = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xref-union";
        ename = "xref-union";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xref-union-0.2.0.tar";
          sha256 = "0ghhasqs0xq2i576fp97qx6x3h940kgyp76a49gj5cdmig8kyfi8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref-union.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "yasnippet";
        ename = "yasnippet";
        version = "0.14.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/yasnippet-0.14.1.tar";
          sha256 = "0xsq0i9xv9hib5a52rv5vywq1v6gr44gjsyfmqxwffmw1a25x25g";
        };
        packageRequires = [ cl-lib emacs ];
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
          sha256 = "1qiw5592mj8gmq1lhdcpxfza7iqn4cmhn36vdskfa7zpd1lq26y1";
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
        version = "2023.6.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/zones-2023.6.11.tar";
          sha256 = "1z3kq0lfc4fbr9dnk9kj2hqcv60bnjp0x4kbxaxy77vv02a62rzc";
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
          sha256 = "1yyh09jff31j5w6mqsnibig3wizv7acsw39pjjfv1rmngni2b8zi";
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
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/zuul-0.4.0.tar";
          sha256 = "1mj54hm4cqidrmbxyqdjfsc3qcmjhbl0wii79bydx637dvpfvqgf";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zuul.html";
          license = lib.licenses.free;
        };
      }) {};
  }
