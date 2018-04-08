{ callPackage }: {
    ace-window = callPackage ({ avy, elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ace-window";
        version = "0.9.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ace-window-0.9.0.el";
          sha256 = "1m7fc4arcxn7fp0hnzyp20czjp4zx3rjaspfzpxzgc8sbghi81a3";
        };
        packageRequires = [ avy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ace-window.html";
          license = lib.licenses.free;
        };
      }) {};
    ack = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ack";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ack-1.5.tar";
          sha256 = "0sljshiy44z27idy0rxjs2fx4smlm4v607wic7md1vihp6qp4l9r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ack.html";
          license = lib.licenses.free;
        };
      }) {};
    ada-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib, wisi }:
    elpaBuild {
        pname = "ada-mode";
        version = "5.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-mode-5.3.1.tar";
          sha256 = "0srna7w3y2nq0y80a01bcx8mg6gvind7nzvsbk9bd7rrr05njrd9";
        };
        packageRequires = [ cl-lib emacs wisi ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    ada-ref-man = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ada-ref-man";
        version = "2012.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-ref-man-2012.3.tar";
          sha256 = "0w88xw51jb85nmqbi3i9kj9kx2fa6zlazk3x7afll7njc6g4105z";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ada-ref-man.html";
          license = lib.licenses.free;
        };
      }) {};
    adaptive-wrap = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "adaptive-wrap";
        version = "0.5.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/adaptive-wrap-0.5.2.el";
          sha256 = "1qcf1cabn4wb34cdmlyk3rv5dl1dcrxrbaw38kly1prs6y4l22aw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adaptive-wrap.html";
          license = lib.licenses.free;
        };
      }) {};
    adjust-parens = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "adjust-parens";
        version = "3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/adjust-parens-3.0.tar";
          sha256 = "16gmrgdfyqs7i617669f7xy5mds1svbyfv12xhdjk96rbssfngzg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/adjust-parens.html";
          license = lib.licenses.free;
        };
      }) {};
    aggressive-indent = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "aggressive-indent";
        version = "1.8.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aggressive-indent-1.8.3.el";
          sha256 = "0jnzccl50x0wapprgwxinp99pwwa6j43q6msn4gv437j7swy8wnj";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/aggressive-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    ahungry-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "ahungry-theme";
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
    all = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "all";
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
    ampc = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ampc";
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
        version = "0.94";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/arbitools-0.94.el";
          sha256 = "00iq8rr1275p48ic5mibcx657li723q8r7ax4g21w6bzwsj3gksd";
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
        version = "1.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ascii-art-to-unicode-1.11.el";
          sha256 = "1z1vjpskvhynja41cv5z6xrz3rmpdzz51avv2gzrpxxa4k6iaz8s";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ascii-art-to-unicode.html";
          license = lib.licenses.free;
        };
      }) {};
    async = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "async";
        version = "1.9.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/async-1.9.2.tar";
          sha256 = "17fnvrj7jww29sav6a6jpizclg4w2962m6h37akpii71gf0vrffw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/async.html";
          license = lib.licenses.free;
        };
      }) {};
    auctex = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "auctex";
        version = "12.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auctex-12.1.1.tar";
          sha256 = "10l96569dy9pfp8bm64pndhk1skg65kqhsyllwfa0zvb7mjkm70l";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auctex.html";
          license = lib.licenses.free;
        };
      }) {};
    aumix-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "aumix-mode";
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
    auto-correct = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "auto-correct";
        version = "1.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-correct-1.1.3.el";
          sha256 = "09r58p8na1ai2v9zllb92lvsjlq2jfzwvj0ipck1py0i4xfsm7aq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-correct.html";
          license = lib.licenses.free;
        };
      }) {};
    auto-overlays = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "auto-overlays";
        version = "0.10.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-overlays-0.10.9.tar";
          sha256 = "0aqjp3bkd7mi191nm971z857s09py390ikcd93hyhmknblk0v14p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/auto-overlays.html";
          license = lib.licenses.free;
        };
      }) {};
    avy = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "avy";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/avy-0.4.0.tar";
          sha256 = "1vbp37ndv5930x120n0isxxxfs8d5wqlrbnxvp6h3ahbbv0zdcsn";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/avy.html";
          license = lib.licenses.free;
        };
      }) {};
    bbdb = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "bbdb";
        version = "3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bbdb-3.2.tar";
          sha256 = "1p56dg0mja2b2figy7yhdx714zd5j6njzn0k07zjka3jc06izvjx";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bbdb.html";
          license = lib.licenses.free;
        };
      }) {};
    beacon = callPackage ({ elpaBuild, fetchurl, lib, seq }: elpaBuild {
        pname = "beacon";
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
    bug-hunter = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, seq }:
    elpaBuild {
        pname = "bug-hunter";
        version = "1.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bug-hunter-1.3.1.el";
          sha256 = "0xplsnmj144r90vxxkmpdxlaq6gyx4ca6iklq60wd0w05fw9q02x";
        };
        packageRequires = [ cl-lib seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/bug-hunter.html";
          license = lib.licenses.free;
        };
      }) {};
    caps-lock = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "caps-lock";
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
    captain = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "captain";
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
        version = "2.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/chess-2.0.4.tar";
          sha256 = "1sq1bjmp513vldfh7hc2bbfc54665abqiz0kqgqq3gijckaxn5js";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/chess.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-generic = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "cl-generic";
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
    cl-lib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "cl-lib";
        version = "0.6.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-lib-0.6.1.el";
          sha256 = "00w7bw6wkig13pngijh7ns45s1jn5kkbbjaqznsdh6jk5x089j9y";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/cl-lib.html";
          license = lib.licenses.free;
        };
      }) {};
    cl-print = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "cl-print";
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
    cobol-mode = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "cobol-mode";
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
    coffee-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "coffee-mode";
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
    compact-docstrings = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "compact-docstrings";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/compact-docstrings-0.1.el";
          sha256 = "1qmxn1i07nnzfckl06lg3xpvccx2hjgpypgc9v4pdihjfdwnifm5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/compact-docstrings.html";
          license = lib.licenses.free;
        };
      }) {};
    company = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "company";
        version = "0.9.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-0.9.6.tar";
          sha256 = "0w1jqhs87g0sqhv2iw6a5i8f4yjkrc65fb3h6vyv11sb8kfnhda7";
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
        version = "1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-ebdb-1.el";
          sha256 = "1awriwvjpf9k2r6hzawai5kxz28j40zk9fvpb946kd5yj0hxr9nc";
        };
        packageRequires = [ company ebdb ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    company-math = callPackage ({ company, elpaBuild, fetchurl, lib, math-symbol-lists }:
    elpaBuild {
        pname = "company-math";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-math-1.1.tar";
          sha256 = "10yi5jmv7njcaansgy2aw7wm1j3acch1j9x6lfg9mxk0j21zvgwp";
        };
        packageRequires = [ company math-symbol-lists ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/company-math.html";
          license = lib.licenses.free;
        };
      }) {};
    company-statistics = callPackage ({ company, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "company-statistics";
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
    context-coloring = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "context-coloring";
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
    counsel-ebdb = callPackage ({ ebdb, elpaBuild, fetchurl, ivy, lib }:
    elpaBuild {
        pname = "counsel-ebdb";
        version = "1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/counsel-ebdb-1.el";
          sha256 = "0p919gq871rxlrn6lpjbwws7h6i2gc9vgcxzj8bzgz8xk5hq9mis";
        };
        packageRequires = [ ebdb ivy ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/counsel-ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    crisp = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "crisp";
        version = "1.3.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/crisp-1.3.4.el";
          sha256 = "1xbnf7xlw499zsnr5ky2bghb2fzg3g7cf2ldmbb7c3b84raryn0i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crisp.html";
          license = lib.licenses.free;
        };
      }) {};
    csv-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "csv-mode";
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csv-mode-1.7.el";
          sha256 = "0r4bip0w3h55i8h6sxh06czf294mrhavybz0zypzrjw91m1bi7z6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/csv-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    cycle-quotes = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "cycle-quotes";
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
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/darkroom-0.1.el";
          sha256 = "0fif8fm1h7x7g16949shfnaik5f5488clsvkf8bi5izpqp3vi6ak";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/darkroom.html";
          license = lib.licenses.free;
        };
      }) {};
    dash = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "dash";
        version = "2.12.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dash-2.12.0.tar";
          sha256 = "02r547vian59zr55z6ri4p2b7q5y5k256wi9j8a317vjzyh54m05";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dash.html";
          license = lib.licenses.free;
        };
      }) {};
    dbus-codegen = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "dbus-codegen";
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
    debbugs = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, soap-client }:
    elpaBuild {
        pname = "debbugs";
        version = "0.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/debbugs-0.15.tar";
          sha256 = "1x7jw2ldgkknyxg7x9fhnqkary691icnysmi3xw0g2fjrvllzhqw";
        };
        packageRequires = [ cl-lib soap-client ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/debbugs.html";
          license = lib.licenses.free;
        };
      }) {};
    delight = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "delight";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/delight-1.5.el";
          sha256 = "0kzlvzwmn6zj0874086q2xw0pclyi7wlkq48zh2lkd2796xm8vw7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/delight.html";
          license = lib.licenses.free;
        };
      }) {};
    dict-tree = callPackage ({ elpaBuild, fetchurl, heap, lib, tNFA, trie }:
    elpaBuild {
        pname = "dict-tree";
        version = "0.14";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dict-tree-0.14.el";
          sha256 = "1k00k3510bgq7rijvrxbx4b7qlq2abq1dyyn51zgm8q0qk68p5jq";
        };
        packageRequires = [ heap tNFA trie ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dict-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    diff-hl = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "diff-hl";
        version = "1.8.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diff-hl-1.8.4.tar";
          sha256 = "0axhidc3cym7a2x4rpxf4745qss9s9ajyg4s9h5b4zn7v7fyp71n";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/diff-hl.html";
          license = lib.licenses.free;
        };
      }) {};
    diffview = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "diffview";
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
    dired-du = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "dired-du";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-du-0.5.tar";
          sha256 = "09yj37p2fa5f81fqrzwghjkyy2ydsf4rbkfwpn2yyvzd5nd97bpl";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dired-du.html";
          license = lib.licenses.free;
        };
      }) {};
    dismal = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "dismal";
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dismal-1.5.tar";
          sha256 = "1vhs6w6c2klsrfjpw8vr5c4gwiw83ppdjhsn2la0fvkm60jmc476";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dismal.html";
          license = lib.licenses.free;
        };
      }) {};
    djvu = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "djvu";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/djvu-0.5.el";
          sha256 = "1wpyv4ismfsz5hfaj75j3h3nni1mnk33czhw3rd45cf32a2zkqsj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/djvu.html";
          license = lib.licenses.free;
        };
      }) {};
    docbook = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "docbook";
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
    dts-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "dts-mode";
        version = "0.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dts-mode-0.1.0.el";
          sha256 = "08xwqbdg0gwipc3gfacs3gpc6zz6lhkw7pyj7n9qhg020c4qv7hq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/dts-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    easy-kill = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "easy-kill";
        version = "0.9.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/easy-kill-0.9.3.tar";
          sha256 = "17nw0mglmg877axwg1d0gs03yc0p04lzmd3pl0nsnqbh3303fnqb";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/easy-kill.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib, seq }:
    elpaBuild {
        pname = "ebdb";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-0.5.tar";
          sha256 = "1apsb08ml50nacqa6i86zwa2xxdfqry380bksp16zv63cj86b67g";
        };
        packageRequires = [ cl-lib emacs seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    ebdb-gnorb = callPackage ({ ebdb, elpaBuild, fetchurl, gnorb, lib }:
    elpaBuild {
        pname = "ebdb-gnorb";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-i18n-chn-1.2.el";
          sha256 = "1qgrlk625mhfd6n1mc0kqfzbisnb61kx3vrrl3bzlz4viq3kcc10";
        };
        packageRequires = [ ebdb pyim ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ebdb-i18n-chn.html";
          license = lib.licenses.free;
        };
      }) {};
    ediprolog = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ediprolog";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ediprolog-1.2.el";
          sha256 = "039ffvp7c810mjyargmgw1i87g0z8qs8qicq826sd9aiz9hprfaz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ediprolog.html";
          license = lib.licenses.free;
        };
      }) {};
    el-search = callPackage ({ cl-print, elpaBuild, emacs, fetchurl, lib, stream }:
    elpaBuild {
        pname = "el-search";
        version = "1.6.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/el-search-1.6.3.tar";
          sha256 = "1yd8qlq95fb5qfmg3m16i9d5nsmkkgr12q0981r5ng06pc0j4al6";
        };
        packageRequires = [ cl-print emacs stream ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/el-search.html";
          license = lib.licenses.free;
        };
      }) {};
    eldoc-eval = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "eldoc-eval";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eldoc-eval-0.1.el";
          sha256 = "1mnhxdsn9h43iq941yqmg92v3hbzwyg7acqfnz14q5g52bnagg19";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/eldoc-eval.html";
          license = lib.licenses.free;
        };
      }) {};
    electric-spacing = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "electric-spacing";
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
    enwc = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "enwc";
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
    epoch-view = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "epoch-view";
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
    ergoemacs-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib, undo-tree }:
    elpaBuild {
        pname = "ergoemacs-mode";
        version = "5.14.7.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ergoemacs-mode-5.14.7.3.tar";
          sha256 = "0lqqrnw6z9w7js8r40khckjc1cyxdiwx8kapf5pvyfs09gs89i90";
        };
        packageRequires = [ emacs undo-tree ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ergoemacs-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    excorporate = callPackage ({ elpaBuild, emacs, fetchurl, fsm, lib, soap-client, url-http-ntlm }:
    elpaBuild {
        pname = "excorporate";
        version = "0.7.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/excorporate-0.7.6.tar";
          sha256 = "02bp0z6vpssc12vxxs1g4whmfxf88wsk0bcq4422vvz256l6vpf9";
        };
        packageRequires = [ emacs fsm soap-client url-http-ntlm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/excorporate.html";
          license = lib.licenses.free;
        };
      }) {};
    exwm = callPackage ({ elpaBuild, fetchurl, lib, xelb }: elpaBuild {
        pname = "exwm";
        version = "0.18";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/exwm-0.18.tar";
          sha256 = "1shz5bf4v4gg3arjaaldics5qkg3aiiaf3ngys8lb6qyxhcpvh6q";
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
    flylisp = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "flylisp";
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
    fsm = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "fsm";
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
    ggtags = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "ggtags";
        version = "0.8.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ggtags-0.8.12.el";
          sha256 = "0ny3llk021g6r0s75xdm4hzpbxv393ddm2r6f2xdk8kqnq4gnirp";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ggtags.html";
          license = lib.licenses.free;
        };
      }) {};
    gited = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "gited";
        version = "0.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gited-0.4.1.tar";
          sha256 = "0080jcr10xvvf2rl7ar01c6zmzd0pafrs6w2l8v4cwwapyhv0dcd";
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
    gnome-c-style = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "gnome-c-style";
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
        version = "1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnorb-1.4.2.tar";
          sha256 = "1892j8gdbcny6b9psxa1lwxsb1gkj9z9z00rfc62kdw8bffmx38y";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnorb.html";
          license = lib.licenses.free;
        };
      }) {};
    gnugo = callPackage ({ ascii-art-to-unicode, cl-lib ? null, elpaBuild, fetchurl, lib, xpm }:
    elpaBuild {
        pname = "gnugo";
        version = "3.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnugo-3.1.0.tar";
          sha256 = "0xpjvs250gg71qwapdsb1hlc61gs0gpkjds01srf784fvyxx2gf1";
        };
        packageRequires = [ ascii-art-to-unicode cl-lib xpm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/gnugo.html";
          license = lib.licenses.free;
        };
      }) {};
    heap = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "heap";
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
    helm-ebdb = callPackage ({ ebdb, elpaBuild, fetchurl, helm, lib }:
    elpaBuild {
        pname = "helm-ebdb";
        version = "1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/helm-ebdb-1.el";
          sha256 = "17gpna0hywxnhfwc9zsm2r35mskyfi416qqmmdba26r4zmpb9r63";
        };
        packageRequires = [ ebdb helm ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/helm-ebdb.html";
          license = lib.licenses.free;
        };
      }) {};
    highlight-escape-sequences = callPackage ({ elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "highlight-escape-sequences";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/highlight-escape-sequences-0.3.el";
          sha256 = "0q54h0zdaflr2sk4mwgm2ix8cdq4rm4pz03ln430qxc1zm8pz6gy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-escape-sequences.html";
          license = lib.licenses.free;
        };
      }) {};
    hook-helpers = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "hook-helpers";
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
    html5-schema = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "html5-schema";
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
    hyperbole = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "hyperbole";
        version = "7.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hyperbole-7.0.2.tar";
          sha256 = "1hgwa740941a9s5wf1cqf76h3af8qbiiw9sc76biz6m3vx0hy1zs";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/hyperbole.html";
          license = lib.licenses.free;
        };
      }) {};
    ioccur = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ioccur";
        version = "2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ioccur-2.4.el";
          sha256 = "1isid3kgsi5qkz27ipvmp9v5knx0qigmv7lz12mqdkwv8alns1p9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ioccur.html";
          license = lib.licenses.free;
        };
      }) {};
    iterators = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "iterators";
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
    ivy = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "ivy";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-0.10.0.tar";
          sha256 = "01m58inpd8jbfvzqsrwigzjfld9a66nf36cbya26dmdy7vwdm8xm";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ivy.html";
          license = lib.licenses.free;
        };
      }) {};
    javaimp = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "javaimp";
        version = "0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/javaimp-0.6.tar";
          sha256 = "015kchx6brsjk7q6lz9y44a18n5imapd95czx50hqdscjczmj2ff";
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
        version = "20180301";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/js2-mode-20180301.tar";
          sha256 = "0kcs70iygbpaxs094q6agsjs56sz03jy4fwk178f9hr93x95pynx";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/js2-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    json-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "json-mode";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/json-mode-0.1.el";
          sha256 = "025bwpx7nc1qhdyf2yaqjdr6x1qr6q45776yvy427xdh4nbk054l";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/json-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    jumpc = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "jumpc";
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
    kmb = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "kmb";
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
    landmark = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "landmark";
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
    let-alist = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "let-alist";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/let-alist-1.0.5.el";
          sha256 = "0r7b9jni50la1m79kklml11syg8d2fmdlr83pv005sv1wh02jszw";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/let-alist.html";
          license = lib.licenses.free;
        };
      }) {};
    lex = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "lex";
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
    load-relative = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "load-relative";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-relative-1.3.el";
          sha256 = "1hfxb2436jdsi9wfmsv47lkkpa5galjf5q81bqabbsv79rv59dps";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/load-relative.html";
          license = lib.licenses.free;
        };
      }) {};
    loc-changes = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "loc-changes";
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
    loccur = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "loccur";
        version = "1.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/loccur-1.2.3.el";
          sha256 = "09pxp03g4pg95cpqiadyv9dz6qrwd9igrkwrhm4s38cscmqm7dzq";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/loccur.html";
          license = lib.licenses.free;
        };
      }) {};
    markchars = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "markchars";
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/markchars-0.2.0.el";
          sha256 = "1wn9v9jzcyq5wxhw5839jsggfy97955ngspn2gn6jmvz6zdgy4hv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markchars.html";
          license = lib.licenses.free;
        };
      }) {};
    math-symbol-lists = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "math-symbol-lists";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/math-symbol-lists-1.1.tar";
          sha256 = "06klvnqipz0n9slw72fxmhrydrw6bi9fs9vnn8hrja8gsqf8inlz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/math-symbol-lists.html";
          license = lib.licenses.free;
        };
      }) {};
    memory-usage = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "memory-usage";
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
    midi-kbd = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "midi-kbd";
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
    minibuffer-line = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "minibuffer-line";
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
    minimap = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "minimap";
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minimap-1.2.el";
          sha256 = "1vcxdxy7mv8mi4lrri3kmyf9kly3rb02z4kpfx5d1xv493havvb8";
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
        version = "0.5.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mmm-mode-0.5.6.tar";
          sha256 = "1vwsi8sk1i16dvz940c6q7i75023hrw07sc4cpmcz06rj8r68gr0";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/mmm-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    multishell = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "multishell";
        version = "1.1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/multishell-1.1.5.tar";
          sha256 = "0g38p5biyxqkjdkmxlikvhkhkmafyy3ibd012q83skaf8fi4cv1y";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multishell.html";
          license = lib.licenses.free;
        };
      }) {};
    muse = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "muse";
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
    myers = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "myers";
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
    nameless = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "nameless";
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
    names = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "names";
        version = "20151201.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/names-20151201.0.tar";
          sha256 = "13smsf039x4yd7pzvllgn1vz8lhkwghnhip9y2bka38vk37w912d";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/names.html";
          license = lib.licenses.free;
        };
      }) {};
    nhexl-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "nhexl-mode";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nhexl-mode-0.2.el";
          sha256 = "0qrzpkxxdwi2b3136yj5agvaxwr9g2c58kpmjmjpfhpc6yyyx5x0";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nhexl-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    nlinum = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "nlinum";
        version = "1.8.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nlinum-1.8.1.el";
          sha256 = "0fx560yfjy6nqgs1d3fiv0h46i8q3r592clsia7nihkriah7rlwf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/nlinum.html";
          license = lib.licenses.free;
        };
      }) {};
    notes-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "notes-mode";
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
    ntlm = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "ntlm";
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
    num3-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "num3-mode";
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
    oauth2 = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "oauth2";
        version = "0.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/oauth2-0.11.el";
          sha256 = "0ydkc9jazsnbbvfhd47mql52y7k06n3z7r0naqxkwb99j9blqsmp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/oauth2.html";
          license = lib.licenses.free;
        };
      }) {};
    omn-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "omn-mode";
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
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/on-screen-1.3.2.el";
          sha256 = "15d18mjgv1pnwl6kf3pr5w64q1322p1l1qlfvnckglwmzy5sl2qv";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/on-screen.html";
          license = lib.licenses.free;
        };
      }) {};
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "9.1.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-9.1.9.tar";
          sha256 = "16yr0srfzsrzv2b1f2wjk8gb2pyhsgj2hxbscixirkxqz674c5cl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    osc = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "osc";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/osc-0.1.el";
          sha256 = "09nzbbzvxfrjm91wawbv6bg6fqlcx1qi0711qc73yfrbc8ndsnsb";
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
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/other-frame-window-1.0.4.el";
          sha256 = "0hg82j8zjh0ann6bf56r0p8s0y3a016zny8byp80mcvkw63wrn5i";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/other-frame-window.html";
          license = lib.licenses.free;
        };
      }) {};
    pabbrev = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "pabbrev";
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
    paced = callPackage ({ async, elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "paced";
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
    pinentry = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "pinentry";
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
    poker = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "poker";
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
    posframe = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "posframe";
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/posframe-0.3.0.el";
          sha256 = "0q74lwklr29c50qgaqly48nj7f49kgxiv70lsvhdy8cg2v082v8k";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/posframe.html";
          license = lib.licenses.free;
        };
      }) {};
    psgml = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "psgml";
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
    python = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "python";
        version = "0.26.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/python-0.26.1.el";
          sha256 = "1dpw2w2nk6ggr8pz293qysjkiya3i7k25i447fbycjil59anzpb3";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/python.html";
          license = lib.licenses.free;
        };
      }) {};
    quarter-plane = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "quarter-plane";
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
    queue = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "queue";
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
    rainbow-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "rainbow-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rainbow-mode-1.0.el";
          sha256 = "1mg9dbgvg79sphpic56d11mrjwx668xffx5z5jszc9fdl5b8ygml";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rainbow-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    rbit = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "rbit";
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
    rcirc-color = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "rcirc-color";
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-color-0.3.el";
          sha256 = "1ya4agh63x60lv8qzrjrng02dnrc70ci0s05b800iq71k71ss3dl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rcirc-color.html";
          license = lib.licenses.free;
        };
      }) {};
    rcirc-menu = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "rcirc-menu";
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
    realgud = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib, load-relative, loc-changes, test-simple }:
    elpaBuild {
        pname = "realgud";
        version = "1.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/realgud-1.4.5.tar";
          sha256 = "108wgxg7fb4byaiasgvbxv2hq7b00biq9f0mh9hy6vw4160y5w24";
        };
        packageRequires = [
          cl-lib
          emacs
          load-relative
          loc-changes
          test-simple
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/realgud.html";
          license = lib.licenses.free;
        };
      }) {};
    register-list = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "register-list";
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
    rich-minority = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "rich-minority";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rich-minority-1.0.1.el";
          sha256 = "1pr89k3jz044vf582klphl1zf0r7hj2g7ga8j1dwbrpr9ngiicgc";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rich-minority.html";
          license = lib.licenses.free;
        };
      }) {};
    rnc-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "rnc-mode";
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
    rudel = callPackage ({ cl-generic, cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "rudel";
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rudel-0.3.1.tar";
          sha256 = "0glqa68g509p0s2vcc0i8kzlddnc9brd9jqhnm5rzxz4i050cvnz";
        };
        packageRequires = [ cl-generic cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rudel.html";
          license = lib.licenses.free;
        };
      }) {};
    scroll-restore = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "scroll-restore";
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
    sed-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "sed-mode";
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
    seq = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "seq";
        version = "2.20";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/seq-2.20.tar";
          sha256 = "0vrpx6nnyjb0gsypknzagimlhvcvi5y1rcdkpxyqr42415zr8d0n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/seq.html";
          license = lib.licenses.free;
        };
      }) {};
    shen-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "shen-mode";
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
    sisu-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "sisu-mode";
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
    smart-yank = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "smart-yank";
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
        version = "6.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sml-mode-6.8.el";
          sha256 = "105fcrz5qp95f2n3fdm3awr6z58sbrjihjss6qnrg4lz2ggbc328";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sml-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    soap-client = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "soap-client";
        version = "3.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/soap-client-3.1.3.tar";
          sha256 = "1s5m6dc7z532wchdih2ax2a791khyajjxb2xaw5rklk47yc5v3nk";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/soap-client.html";
          license = lib.licenses.free;
        };
      }) {};
    sokoban = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "sokoban";
        version = "1.4.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sokoban-1.4.6.tar";
          sha256 = "112cl1l36zn5q9cw81rxi96zflf7ddp3by1h7fsz48yjfidpfbzn";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sokoban.html";
          license = lib.licenses.free;
        };
      }) {};
    sotlisp = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "sotlisp";
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
    spinner = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "spinner";
        version = "1.7.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/spinner-1.7.3.el";
          sha256 = "19kp1mmndbmw11sgvv2ggfjl4pyf5zrsbh3871f0965pw9z8vahd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/spinner.html";
          license = lib.licenses.free;
        };
      }) {};
    sql-indent = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "sql-indent";
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-indent-1.1.tar";
          sha256 = "06q41msfir178f50nk8fnyc1rwgyq5iyy17pv8mq0zqbacjbp88z";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sql-indent.html";
          license = lib.licenses.free;
        };
      }) {};
    stream = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "stream";
        version = "2.2.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/stream-2.2.4.tar";
          sha256 = "1fdjjxfnpzfv5jsy0wmmnrsk821bg8d3magsng609fb2pkwvk1ij";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/stream.html";
          license = lib.licenses.free;
        };
      }) {};
    svg = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "svg";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-0.1.el";
          sha256 = "0v27casnjvjjaalmrbw494sk0zciws037cn6cmcc6rnhj30lzbv5";
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
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-clock-1.0.el";
          sha256 = "0j6zk7fsv72af12phqdw8axbn2y8y4rfgxiab1p3pxq3y7k47jid";
        };
        packageRequires = [ emacs svg ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/svg-clock.html";
          license = lib.licenses.free;
        };
      }) {};
    tNFA = callPackage ({ elpaBuild, fetchurl, lib, queue }: elpaBuild {
        pname = "tNFA";
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
    temp-buffer-browse = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "temp-buffer-browse";
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
    test-simple = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "test-simple";
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
    timerfunctions = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "timerfunctions";
        version = "1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/timerfunctions-1.4.2.el";
          sha256 = "122q8nv08pz1mkgilvi9qfrs7rsnc5picr7jyz2jpnvpd9qw6jw5";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/timerfunctions.html";
          license = lib.licenses.free;
        };
      }) {};
    tiny = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "tiny";
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
    tramp-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "tramp-theme";
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
    transcribe = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "transcribe";
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
    trie = callPackage ({ elpaBuild, fetchurl, heap, lib, tNFA }: elpaBuild {
        pname = "trie";
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/trie-0.4.el";
          sha256 = "0869fh3bghxil94wd9vgbb5bk1hx2qkh75vbvp0psmcima8dgzgw";
        };
        packageRequires = [ heap tNFA ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/trie.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-tree = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "undo-tree";
        version = "0.6.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/undo-tree-0.6.5.el";
          sha256 = "0bs97xyxwfkjvzax9llg0zsng0vyndnrxj5d2n5mmynaqcn89d37";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/undo-tree.html";
          license = lib.licenses.free;
        };
      }) {};
    uni-confusables = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "uni-confusables";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/uni-confusables-0.1.tar";
          sha256 = "0s3scvzhd4bggk0qafcspf97cmcvdw3w8bbf5ark4p22knvg80zp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/uni-confusables.html";
          license = lib.licenses.free;
        };
      }) {};
    url-http-ntlm = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, ntlm ? null }:
    elpaBuild {
        pname = "url-http-ntlm";
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
    validate = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib, seq }:
    elpaBuild {
        pname = "validate";
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
    vdiff = callPackage ({ elpaBuild, emacs, fetchurl, hydra, lib }: elpaBuild {
        pname = "vdiff";
        version = "0.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vdiff-0.2.3.el";
          sha256 = "197wszzhm2kbfvvlg3f0dzfs3lf4536yq5fd67k2rycj421fr9qz";
        };
        packageRequires = [ emacs hydra ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vdiff.html";
          license = lib.licenses.free;
        };
      }) {};
    vigenere = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "vigenere";
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
    vlf = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "vlf";
        version = "1.7.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vlf-1.7.1.tar";
          sha256 = "0cnwxk20573iqkwk0c0h7pyjk0rkr8l2qd0xmyqj8mvdxjb8nnkz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/vlf.html";
          license = lib.licenses.free;
        };
      }) {};
    w3 = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "w3";
        version = "4.0.49";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/w3-4.0.49.tar";
          sha256 = "01n334b3gwx288xysa1vxsvb14avsz3syfigw85i7m5nizhikqbb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/w3.html";
          license = lib.licenses.free;
        };
      }) {};
    wcheck-mode = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "wcheck-mode";
        version = "2016.1.30";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wcheck-mode-2016.1.30.el";
          sha256 = "0hzrxnslfl04h083njy7wp4hhgrqpyz0cnm73v348kr1i4wx9xjq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wcheck-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    wconf = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "wconf";
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
    web-server = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "web-server";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/web-server-0.1.1.tar";
          sha256 = "1q51fhqw5al4iycdlighwv7jqgdpjb1a66glwd5jnc9b651yk42n";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-server.html";
          license = lib.licenses.free;
        };
      }) {};
    websocket = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "websocket";
        version = "1.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/websocket-1.8.tar";
          sha256 = "0dcxmnnm8z7cvsc7nkb822a1g6w03klp7cijjnfq0pz84p3w9cd9";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/websocket.html";
          license = lib.licenses.free;
        };
      }) {};
    which-key = callPackage ({ elpaBuild, emacs, fetchurl, lib }: elpaBuild {
        pname = "which-key";
        version = "3.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/which-key-3.1.0.tar";
          sha256 = "17n09i92m7qdicybxl60j81c8fn7jcx25wds0sb7j8i364psjabq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/which-key.html";
          license = lib.licenses.free;
        };
      }) {};
    windresize = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "windresize";
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
    wisi = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
    elpaBuild {
        pname = "wisi";
        version = "1.1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisi-1.1.6.tar";
          sha256 = "0p7hm9l4gbp50rmpqna6jnc1pss2axdd6m6hk9ik4afbz0knzwnk";
        };
        packageRequires = [ cl-lib emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wisi.html";
          license = lib.licenses.free;
        };
      }) {};
    wpuzzle = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "wpuzzle";
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
    xclip = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "xclip";
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xclip-1.4.el";
          sha256 = "12rw790wzj10jcsqf292hc7qx18ybyay8jqji4shmrv16igrzl6p";
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
        version = "0.14";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xelb-0.14.tar";
          sha256 = "09flnbjy9ck784kprz036rwg9qk45hpv0w5hz3pz3zhwyk57fv74";
        };
        packageRequires = [ cl-generic emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xelb.html";
          license = lib.licenses.free;
        };
      }) {};
    xpm = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "xpm";
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xpm-1.0.4.tar";
          sha256 = "075miyashh9cm3b0gk6ngld3rm8bfgnh4qxnhxmmvjgzf6a64grh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xpm.html";
          license = lib.licenses.free;
        };
      }) {};
    yasnippet = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "yasnippet";
        version = "0.12.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/yasnippet-0.12.2.tar";
          sha256 = "03cilldgq7fpzk9ix2a8q1ppilxp5gvyrym7krifvrg1g2rs1qv9";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet.html";
          license = lib.licenses.free;
        };
      }) {};
    ztree = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
    elpaBuild {
        pname = "ztree";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ztree-1.0.5.tar";
          sha256 = "14pbbsyav1dzz8m8waqdcmcx9bhw5g8m2kh1ahpxc3i2lfhdan1x";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ztree.html";
          license = lib.licenses.free;
        };
      }) {};
  }