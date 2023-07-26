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
        version = "1.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ack-1.11.tar";
          sha256 = "0fsi3lgfkyv9gxwcs0q5c9fawksz6x0pqarjagcndnd7jlbxjw7z";
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
        version = "8.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ada-mode-8.0.5.tar";
          sha256 = "00baypl9bv2z42d6z2k531ai25yw2aj1dcv4pi1jhcp19c9kjg4l";
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
        version = "1.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aggressive-completion-1.7.tar";
          sha256 = "1rpy53kh19ljjr2xgna716jynajjpgkkjgcl3gzryxsmky8mwbfl";
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
    aircon-theme = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "aircon-theme";
        ename = "aircon-theme";
        version = "0.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/aircon-theme-0.0.6.tar";
          sha256 = "09yjjx9gy1x2i8xk7jlblzk6gkx7cgglb0pwxbl8n6aj19ba40nd";
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
    altcaps = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "altcaps";
        ename = "altcaps";
        version = "1.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/altcaps-1.1.0.tar";
          sha256 = "15jfhn9v74zi779a0m0v5dx8h135pbsxx0rh472sl13q2ark97bk";
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
        version = "1.9.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/async-1.9.7.tar";
          sha256 = "0wwjgvj42irznwz6rjh8yiz4p9hswgi6ak57anjn256c4zx8xaz2";
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
        version = "13.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auctex-13.2.1.tar";
          sha256 = "0q914q1qm5w0yx9cqfmyxzbzxmrdkz321cazy7g7l4mc5qndb9nm";
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
    auto-header = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "auto-header";
        ename = "auto-header";
        version = "0.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/auto-header-0.1.2.tar";
          sha256 = "0rk7xq7bzgaxdyw7j3vjnishf2pyzs84xamq4blgbb93n0f4nlfj";
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
          sha256 = "0wln6b4j3pd3mhx6sx0bnz74c4n6fidmkg77cqfpxs4j5l1zjp2z";
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
        version = "0.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/autocrypt-0.4.1.tar";
          sha256 = "1r2b1nyw2ai58br3kh4r5rpy450njz7rcccbmcwxsyfgiz4wbqy8";
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
        version = "3.2.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bbdb-3.2.2.2.tar";
          sha256 = "0bf20r5xhxln6z4qp8zrlln0303dkci2ydsr74pxcj08aqgk5xxf";
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
          sha256 = "1fy76c2x0xpnx7wfpsxfawdlrspan4dbj2157k9sa62i6a1c8f21";
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
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/beframe-0.3.0.tar";
          sha256 = "0naa3agr4h0z1fc3fwnsq4k57zpzvg7ganbr6dyp7c70ja8x32h0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/beframe.html";
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
    blist = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "blist";
        ename = "blist";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/blist-0.2.tar";
          sha256 = "1gsrj6clsfw36i7pdayfip615r80543j3iph6zm93p88wgwqigrq";
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
        version = "0.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/bluetooth-0.3.1.tar";
          sha256 = "1p10kcim5wqnbj2kiqv6hgjkzznaa48qysnnf8ym90mylsczr70z";
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
        version = "1.1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-1.1.3.tar";
          sha256 = "1z153lccj6rgix9kj5xk8xzdc44ixq8flia7ppjxpj7c0slr3sm2";
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
        version = "2.1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/boxy-headings-2.1.4.tar";
          sha256 = "101kiw10p0sd8j8px16zsw57my7h2f1anhnwj678z22hxhs8vla7";
        };
        packageRequires = [ boxy emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/boxy-headings.html";
          license = lib.licenses.free;
        };
      }) {};
    brief = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, nadvice }:
      elpaBuild {
        pname = "brief";
        ename = "brief";
        version = "5.88.22.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/brief-5.88.22.2.tar";
          sha256 = "1i4sdm8kcrazzp22gb4hi1gd4lfq6hdh6pnldmi1zjjyhl1gbzn3";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buffer-env-0.4.tar";
          sha256 = "0y8ik87dqldhn6q631zp2ln9z5byqgm9icrvr4xrdx6g8mr9c56z";
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
    buildbot = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "buildbot";
        ename = "buildbot";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/buildbot-0.0.1.tar";
          sha256 = "0glvybvjgwbx3dnr09w9y65v2ic080a4zhs88893amvfw29ig4lx";
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
        version = "1.3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/calibre-1.3.3.tar";
          sha256 = "03vg3vym5v04jcvrbyh1m1vfh04a4maiyac89c052lj9zp7yzrx7";
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
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cape-0.17.tar";
          sha256 = "1kby5qbw2z5c6629vfx6dx4f1a8gx58ciif9b9589drc6fnnsnlr";
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
        version = "0.7.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cl-lib-0.7.1.tar";
          sha256 = "1pnsm335wi1lkg7vi0lnqxajm12rvyakzd5iccxhipbk3gz3r6my";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cobol-mode-1.1.tar";
          sha256 = "1ivp0pghrkflhr2md34a6a86gwns867bnl30nqzwq8m4qc5xqjra";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/code-cells-0.3.tar";
          sha256 = "0i5n9xqpf0www553in3xibc93vw9x6659zaqnvr5rkad95gz456x";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/comint-mime-0.3.tar";
          sha256 = "0dlzwzmiwq9z8riq6h1gpq1g713x09kxgaz2m4anxkbmgb95r7hf";
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
        version = "1.5.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/company-math-1.5.1.tar";
          sha256 = "1inib2ywb4ycr9hxgrzyffqi0jnrpjsn52bkwlsqyzgfxr5n4qsw";
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
    compat = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "compat";
        ename = "compat";
        version = "29.1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/compat-29.1.4.2.tar";
          sha256 = "1njvbvvx2gl10psswb8md2s9diiy476gy4yj6vwips40r0n96l3g";
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
        version = "0.35";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-0.35.tar";
          sha256 = "00rw4d9k16wx55pk7fyj4z718vmqjq18jy0xiv7izzkdkkkk3l7p";
        };
        packageRequires = [ compat emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/consult.html";
          license = lib.licenses.free;
        };
      }) {};
    consult-recoll = callPackage ({ consult, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "consult-recoll";
        ename = "consult-recoll";
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/consult-recoll-0.8.tar";
          sha256 = "02vg1rr2fkcqrrivqgggdjdq0ywvlyzazwq1xd02yah3j4sbv4ag";
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
          sha256 = "01wm36qgxsg7lgdxkn7avzfmxcpilsmvfwz3s7y04i0sdrsjvzp4";
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
        version = "0.38";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/corfu-0.38.tar";
          sha256 = "1pj7zdcqfk77fvfqgvp1gri4m11akn5hd87av28k745i7s0nq0i6";
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
          sha256 = "0ikfm1acdsckflv1hcy9lmssyac2099x2yybhvb6vkghcgy99p00";
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
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/counsel-0.14.0.tar";
          sha256 = "03n1qk66dcbh9xlnlzpwkb441c2xdpfc7bzx4i2szw0xh4a6g5sj";
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
    cpupower = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "cpupower";
        ename = "cpupower";
        version = "1.0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/cpupower-1.0.5.tar";
          sha256 = "1hg5jwdkxl6mx145wwdmnhc8k3z3srvpm757kppj1ybmvjbpxx0y";
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
          sha256 = "0pir9ap8lryrw12slgg4v30bzjphc37r6p0fw36larlh9wp8jj5z";
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
        version = "2.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csharp-mode-2.0.0.tar";
          sha256 = "16b9zp6psf32ds9kk7vwf57xppz2jvbk4wpr7mqbn75bx3qvl44m";
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
        version = "1.22";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/csv-mode-1.22.tar";
          sha256 = "1f9pny1hkhdfmkmfpsk6ayjmb9p5hdpxpnmcprf51nfbvmi7ssig";
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
          sha256 = "0m6q7x5144l2q582gdaqgirvgy30ljd1qyjf82l3v1jkc5qf9wfr";
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
        version = "0.36";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/debbugs-0.36.tar";
          sha256 = "1rzv13shadbvy583vjj4zg13v920zpiqrsnn10r3cqqyli89ivn2";
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
    denote = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "denote";
        ename = "denote";
        version = "2.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/denote-2.0.0.tar";
          sha256 = "1wrfbirkzf9szss1rgpmgdr0gy2dvhnbzlnyhw3sp2jvw5sb1xz9";
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
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/denote-menu-1.1.1.tar";
          sha256 = "12ry0rv45hv1vrwx9wih72s9h0f3r18xssnkzfa9ilp77kgbas5q";
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
          sha256 = "1qfcxhzd3gc66kq58k77cvxy18cr371c40z3n4w4m4ngxmpk96hi";
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
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/devdocs-0.5.tar";
          sha256 = "0qyp8lhf76yv2ym7cryvygvf2m9jah5nsl1g79gqjrsin6vlhqka";
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
        version = "1.9.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/diff-hl-1.9.2.tar";
          sha256 = "1avpqwrxhbx8zxwghc8714rcdfhc15b5chq2ixb366ml8xdmvhck";
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
    dired-preview = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "dired-preview";
        ename = "dired-preview";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dired-preview-0.1.1.tar";
          sha256 = "1qmrh0sd9s908xkxz5vfhq956ynrx6k2bx8lddmdp8ci8xkw6wmh";
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
        version = "1.1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/djvu-1.1.2.tar";
          sha256 = "0i7xwgg2fxndy81lnng6fh9iknals8xvx4f1nmxq7c099bzwb57c";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/doc-toc-1.2.tar";
          sha256 = "0vz2jyqgx0sf3mhxnnm0fl395a9mcd9fg661pp3mz0pywpl3ymax";
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
          url = "https://elpa.gnu.org/packages/docbook-0.1.el";
          sha256 = "01x0g8dhw65mzp9mk6qhx9p2bsvkw96hz1awrrf2ji17sp8hd1v6";
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
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/dts-mode-1.0.tar";
          sha256 = "0ihwqkv1ddysjgxh01vpayv3ia0vx55ny8ym0mi5b4iz95idj60s";
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
        version = "0.9.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/easy-kill-0.9.5.tar";
          sha256 = "0h8rzd23sgkj3vxnyhis9iyq8n3xqp9x1mvxlm61s6wwj9j398j6";
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
        version = "0.8.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ebdb-0.8.17.tar";
          sha256 = "0d2csc7b4mhaqcj8g3v46j11f5xcvbvgx06wxxfq2w0p2nzz1sik";
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
        version = "2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ediprolog-2.2.tar";
          sha256 = "021jm5zdxrjg7xcja18vgc2v52rk17xi1k7xxw8q802nmixhy0js";
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
        version = "20230127";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eev-20230127.tar";
          sha256 = "12f8r1mymd73gjbha6w9fk1ar38yxgbnrr6asvr8aa9rhcwwgxqm";
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
        version = "1.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ef-themes-1.3.0.tar";
          sha256 = "1cchc1cfp2y32d736r4523gjzvg4rd1nqddxsjsk5kialz06alms";
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
        version = "1.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eglot-1.15.tar";
          sha256 = "05brq76xbdkbhbn572n0hyz80lwc3ly5waaqsaan5l1apxgl6ww7";
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
        version = "1.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/eldoc-1.14.0.tar";
          sha256 = "15bg61nbfb6l51frlsn430ga3vscns2651wvi6377vlyra7kgn39";
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
    emacs-gc-stats = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "emacs-gc-stats";
        ename = "emacs-gc-stats";
        version = "1.4.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/emacs-gc-stats-1.4.1.tar";
          sha256 = "0k7vng4ikcgb3s9qwjxfyjaq4s45n9r2m9hhnvi953gh3q4xdyck";
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
        version = "0.22.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-0.22.1.tar";
          sha256 = "0dxbvrp057a0kyydnf8vfwnf4m3q3jy4180agcmizlr64lm2pmh1";
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
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/embark-consult-0.7.tar";
          sha256 = "12b8p2f1bpy43jzjz3ask9h38z23hq4nxkid5dljnpmvf31d8x9c";
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
        version = "0.11";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ement-0.11.tar";
          sha256 = "0hsing0iwb69qmnzqii66rqb0cwy3k35ybl68a9jh7iw97jcxm73";
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
        version = "16";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/emms-16.tar";
          sha256 = "1c18lrrfg1n5vn1av9p7q3jys27pdmxq8pq5gqb6397jnv9xywby";
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
          sha256 = "1q4sjl2rvcfwcirm32nmi53258ln71yhh1dgszlxwknm38a14v3i";
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
                               , url-http-ntlm
                               , url-http-oauth }:
      elpaBuild {
        pname = "excorporate";
        ename = "excorporate";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/excorporate-1.1.1.tar";
          sha256 = "06ilfkrlx6ca0qfqq3w1w07kdwak556i1wgf1875py2d5xkg4r90";
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
    expreg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "expreg";
        ename = "expreg";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/expreg-1.0.0.tar";
          sha256 = "0fyyp1cqhgbqmyjb4dyr49zg3jpj3hkhgzl1lh2gcp08d83jl6av";
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
          sha256 = "12pddwp5jby2icshj77w4kwxv75zi00jdxw18f721d7zx3l7q668";
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
        version = "0.27";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/exwm-0.27.tar";
          sha256 = "094k33clmxhnab0wniyrs48sdz28kna2g6fmkhsd7n20nmhhc4sn";
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
          sha256 = "115959sgy7jivb5534rkm5mbqpjayfci9wpzx75p7cjsn02hfi0p";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/face-shift.html";
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
          sha256 = "0ml59kiigqnss84az1c8hp87bmcs9dngz01ly63x47wfym2af8mi";
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
        version = "1.3.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-1.3.4.tar";
          sha256 = "0gm08rj83if9cs0jz7zig363zfqp809j6lgaqdb0apzh48fbznkd";
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
        version = "0.3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/flymake-proselint-0.3.0.tar";
          sha256 = "1x1hp06hggywmpbimyw4cg0cyg7g9v39r552ypivq9pvz94kmkp0";
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
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/fontaine-1.0.0.tar";
          sha256 = "1p34d84z87s2zsfxdc18bjpif21fdixfzv2k4b9g4i0pcr94nc4v";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ftable-1.1.tar";
          sha256 = "0ww2kl5gb2dkkz0dxinjjnd3qafr31qjcqp1x10r3vcfbp9cfy4b";
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
    gnat-compiler = callPackage ({ elpaBuild, emacs, fetchurl, lib, wisi }:
      elpaBuild {
        pname = "gnat-compiler";
        ename = "gnat-compiler";
        version = "1.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnat-compiler-1.0.2.tar";
          sha256 = "1cwjv1ziw5hjnk493vwwg25bnvy98wcryy0c4gknl1xp5qr2qxdg";
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
          sha256 = "0724i8p1hywgbfk0czxvrcwlwigj8r7x6ww0ap3k2sg90531ymws";
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
        version = "2022.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update-2022.12.tar";
          sha256 = "1kij50xw5km14x44zjsfc1cdkz4xq79nv7hgfjsz3pgypq672z5z";
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
    gpr-mode = callPackage ({ elpaBuild
                            , emacs
                            , fetchurl
                            , gnat-compiler
                            , lib
                            , wisi }:
      elpaBuild {
        pname = "gpr-mode";
        ename = "gpr-mode";
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gpr-mode-1.0.3.tar";
          sha256 = "0m93szqyh9dd73z2pygvacg42n3siiy8pji3yzg1ynji859bc3b8";
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
        version = "1.0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gpr-query-1.0.3.tar";
          sha256 = "13h8hl2g55mbaz95k9jfcvz718rv4vli9wccr3rr7cb7yfvn4c5j";
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
          sha256 = "1mzgz4piszm0v18gdn63xb46zqd1r17fkh24rw863i0p1achl21m";
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
    gtags-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "gtags-mode";
        ename = "gtags-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/gtags-mode-1.0.tar";
          sha256 = "0nyzsr3fnds931ihw2dp5xlgv151kzph7qv1n751r1cajimzlp7n";
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
          sha256 = "1j6snbyi710qnxr68mbmj1v2i6gqf6znd872fkjkyj85pg3iibia";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hiddenquote-1.2.tar";
          sha256 = "1ssfy1ha5a1pakihmkifry200k7z1mxcgl4w9pwvp7wmzbkv2zql";
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
    hydra = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, lv }:
      elpaBuild {
        pname = "hydra";
        ename = "hydra";
        version = "0.15.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hydra-0.15.0.tar";
          sha256 = "1mppx20920kfq97wd7mkrn4bcmm46k5m8wqm49asd54w701iq3n1";
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
        version = "8.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/hyperbole-8.0.0.tar";
          sha256 = "171x7jad62xd0n3xgs32dksyhn5abxj1kna0qgm65mm0v73hrv8d";
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
    inspector = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "inspector";
        ename = "inspector";
        version = "0.33";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/inspector-0.33.tar";
          sha256 = "1kap3z68sjjaszmmznl4kk6mr31yd99cqv4yj34zb94vsb2xb6xj";
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
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/isearch-mb-0.7.tar";
          sha256 = "1dfjh4ya9515vx0q2dv1brddw350gxd40h1g1vsa783ivvm0hm75";
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
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-0.14.0.tar";
          sha256 = "1fzl7xcmxjg005g4676ac3jcshgmcmdr81ywmxvjcs8wj71v56jv";
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
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-avy-0.14.0.tar";
          sha256 = "0gjpvjahhkxsakqrcni78v71fsrh3f0jrs55a4kqc5hv6qyn8hk9";
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
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/ivy-hydra-0.14.0.tar";
          sha256 = "1gsjr2yny9qcj56cb4xy47la11z0lszq0f2qws0yzyh02ng30k1n";
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
    jarchive = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jarchive";
        ename = "jarchive";
        version = "0.10.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jarchive-0.10.0.tar";
          sha256 = "0hgxfz6kqammgbr6cx7l8bg9hmakamrkbzbsjycb4k0gbi4r567b";
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
          sha256 = "106wn53z39fcna3sv4p0idmjg9lg5lijm5hyb4lbibp4s5yh2y3b";
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
    jinx = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "jinx";
        ename = "jinx";
        version = "0.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jinx-0.9.tar";
          sha256 = "0q9g3agql5gm95r64lpcwcs9scwhmwcjjnkiykzxdzpnkjn0mjgb";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jit-spell-0.3.tar";
          sha256 = "0q8wd9phd0zcjhc92j633vz82fr0ji8zc9vir7kcn1msrf6jspwz";
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
        version = "20230408";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/js2-mode-20230408.tar";
          sha256 = "1rzlbqddvaa51dz13did5ylj0ggwqnl0wii8735sylfcv6b82241";
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
        version = "1.0.17";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/jsonrpc-1.0.17.tar";
          sha256 = "0vfd1z78pyif3l6gapcq9vs6cjfxiyc420xzwn0krrb25jjzx1ab";
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
        version = "0.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/kind-icon-0.2.0.tar";
          sha256 = "1vgwbd99vx793iy04albkxl24c7vq598s7bg0raqwmgx84abww6r";
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
    latex-table-wizard = callPackage ({ auctex
                                      , elpaBuild
                                      , emacs
                                      , fetchurl
                                      , lib
                                      , transient }:
      elpaBuild {
        pname = "latex-table-wizard";
        ename = "latex-table-wizard";
        version = "1.5.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/latex-table-wizard-1.5.3.tar";
          sha256 = "1lwnz3c4228cnbxnqrm6g476khb0gqgh1qdjm39q8w89nw47vvfy";
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
    lin = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lin";
        ename = "lin";
        version = "1.0.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/lin-1.0.0.tar";
          sha256 = "0b090g2l8mvm3b6k7s31v9lw48qjcvcif2p201wlqgipddm6s180";
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
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/load-relative-1.3.2.tar";
          sha256 = "1fwa51jp0sq5l69y98l2zyj0iq9s6rj1rnqrmvncif61smma8fd7";
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
    logos = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "logos";
        ename = "logos";
        version = "1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/logos-1.1.1.tar";
          sha256 = "1lg4disxfzw9nf438j32q1cna447mlxy3sg523cqzhimh1mk5s9f";
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
          sha256 = "10jcblm0q5948l3ar911dfj6y9p5bggwz9nmq9d3prlgz5zczv34";
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
          sha256 = "1xnyk8bvr0bdz68qc1sga3w9lwdga5qpp3m7290z1vyv0mznh4gm";
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
        version = "3.3.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/map-3.3.1.tar";
          sha256 = "1gvywhdfg27nx6pyq7yfwq9x6j96jama59i5s9rp41pvg2dlmvm0";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/marginalia-1.3.tar";
          sha256 = "14wk3ld9zaj05dmsyhq70kdl0h4bk4gl6sn7x5cckq3av78idh39";
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
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/math-symbol-lists-1.3.tar";
          sha256 = "0h330j7vxmb56z66xgynqlxkr5bnp5id25j0w4ikyms407sdyrbs";
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
    minibuffer-header = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "minibuffer-header";
        ename = "minibuffer-header";
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/minibuffer-header-0.5.tar";
          sha256 = "1nw53h34izm0z8njsf6jacc40fhg4x5l8r403ysmw2ps89i80p36";
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
    mmm-mode = callPackage ({ cl-lib ? null, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "mmm-mode";
        ename = "mmm-mode";
        version = "0.5.9";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/mmm-mode-0.5.9.tar";
          sha256 = "12fss1ccb66xc87m5wpr3vg7bfrzz5m0q6s7pa0avvhsm2f8r2yh";
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
        version = "4.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/modus-themes-4.2.0.tar";
          sha256 = "0bki4h3rs1ch47sygb4nib8960lyvvgs7yxgsy009il3hfxzdgsq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/modus-themes.html";
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
        version = "1.1.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/multishell-1.1.10.tar";
          sha256 = "1ipn9rlh9jg55i04adjy32n8dkjhhw1bcd72w97mlsdk66g8j6l3";
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
        version = "0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nadvice-0.4.tar";
          sha256 = "0ac7zxi04gzcd5hz81lib1db3c6a7xmwkb381ljxvaha1mlzp1k0";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/nano-agenda-0.3.tar";
          sha256 = "1ip21vjapcrla6j0qbjkcrdhs6xq773cswmwbhnsxb3xpzsa1z7x";
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
          sha256 = "1bjxsqbi540cx2zxzrps2bdwj3hkaxw1s9wha1lrldhvckq7dm91";
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
          sha256 = "1hfw6zxnzm4x55iqk1pg6nlp79c86np856bbdac4nv65ff4dkiqq";
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
          sha256 = "0wcd31frnvxzkns4jdfxraai0bfi1184wcn64r8lg73h933p47iz";
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
    notmuch-indicator = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "notmuch-indicator";
        ename = "notmuch-indicator";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/notmuch-indicator-1.0.1.tar";
          sha256 = "1n5k2ikk93mdwqqysf6l7gd8i6iazk8yvbqpf8xnz5zny248cc2x";
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
        version = "1.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/num3-mode-1.5.tar";
          sha256 = "0i01v0sl0wi98xvc3wkk2lwc3nxmnhhpyrhr9gn88x5ygc0p4rdw";
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
    openpgp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "openpgp";
        ename = "openpgp";
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/openpgp-1.0.1.tar";
          sha256 = "1cm6c8394869dw2a5ykb92crz7c4pdav82a8nslbi533knxn7wn6";
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
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/orderless-1.0.tar";
          sha256 = "0kslgrs857h3mm837hcb8v52ankbv0hm2pz0q136imckzj32m43s";
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
        version = "9.6.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-9.6.8.tar";
          sha256 = "1drkpwpjkbi5q6hnifi1x6ib0fp51isga2gl0hj7q0shy161ajv0";
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
          sha256 = "1kzdw9kbnpryxdb9ywh2va4nnjcxw6asszf5n7a95rw2gl6m3l10";
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
          sha256 = "1a022ssqpxbkp03n2bij78srwjx7kacpsgj9a6wbm0yn946hgjpz";
        };
        packageRequires = [ emacs org seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-edna.html";
          license = lib.licenses.free;
        };
      }) {};
    org-modern = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "org-modern";
        ename = "org-modern";
        version = "0.10";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-modern-0.10.tar";
          sha256 = "0y17n6ac1b8rsa91qbisagp5mpmpnlni3j78x55z5dnpbi31yn1l";
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
        version = "0.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-notify-0.1.0.tar";
          sha256 = "1ijwlv8493g19cascv7fl23sjljvdcak6pg4y1wbs595mmsmh409";
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
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-real-1.0.6.tar";
          sha256 = "1qfzmmv3c1yc14v502x0438pxh2bcwli1r3xmcxibhb7h6p9mr3k";
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
        version = "1.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/org-remark-1.2.1.tar";
          sha256 = "0xf10kgb0g4y9i4s1d3a1i5a119a1pijzhp5xxj2b2wyvjs2g3yk";
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
          sha256 = "02r48jzr5zivk11c3c3a9vj1cixfgf1wlmv1kjr5bxldayhg7aqb";
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
          sha256 = "0dvg3h8mmzlqfg60rwxjgy17sqv84p6nj2ngjdafkp9a4halv0g7";
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
    osm = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "osm";
        ename = "osm";
        version = "0.13";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/osm-0.13.tar";
          sha256 = "13bdp8cz1w396vdfxvv8ygla7cbln178rjliknhfl3kqggg32kqx";
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
        version = "4.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pabbrev-4.2.2.tar";
          sha256 = "0iydz8yz866krxv1qv32k88w4464xpymh0wxgrxv6nvniwvhvd0s";
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
        version = "0.1.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/parser-generator-0.1.6.tar";
          sha256 = "0qql5klnh8fbnbkb4mhv6axxvw4qv09cy1h556m0qzg30sckxas1";
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
        version = "1.0.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/peg-1.0.1.tar";
          sha256 = "0yxfwwwc6fck1p9smcm1dwnva42868xvavhy7j749vlxrgb3v94x";
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
          sha256 = "1hbf36zrpjx0xx257370axxfs1yb3iz6g9kc4wg83gcag09j3lci";
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
        version = "0.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/persist-0.5.tar";
          sha256 = "090n4479zs82by7a3vb551gyjvv8lpfcylk43ywr2lfyssc9xiq0";
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
        version = "0.4.46";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/phps-mode-0.4.46.tar";
          sha256 = "128pbn2ndqwvaxxagwz23xa9adr3m5dac1cid7dichddsis849z8";
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
    plz = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "plz";
        ename = "plz";
        version = "0.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/plz-0.7.tar";
          sha256 = "00xm6hp51m4cmlw15qgqrspwgs3d9z1hw9pbpva9sa4v7vsbipd2";
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
        version = "3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poke-3.2.tar";
          sha256 = "0rhcz7kg20j72hf9rhq5zacdak8ayhn4cnwhgq9qwr18z00bxxm7";
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
        version = "3.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/poke-mode-3.0.tar";
          sha256 = "0xw50x3fx3ai3rsykh371hwlgkmyx4h37ps2583l69f7id7h2103";
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
        version = "1.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/posframe-1.4.2.tar";
          sha256 = "0ca43wgbr0n5ri7cyxjmn7blq59xq43rx9z9q02a2j4yn05w8nss";
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
        version = "0.9.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/project-0.9.8.tar";
          sha256 = "0i1q9blvpj3bygjh98gv0kqn2rm01b8lqp9vra82sy3hzzj39pyx";
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
          sha256 = "12ndv9xj4zg0k2vas4bmpf2iwy71hy203zxfd7sfwskdd96kzjjv";
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
          sha256 = "0qknyd6ihqg4n940yll5v2hz3w07fsp4mbdfh7drbws13c1ivnly";
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
        version = "5.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/pyim-5.3.2.tar";
          sha256 = "13irkmhlfq99glyy0vhj559si5672cqcysjxlxn7lvckxr298vzc";
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
          sha256 = "1zppp12217aakawgndy6daxpw1098lh7lsjar2wwd4qv4xs0d4p6";
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
        version = "1.0.6";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rainbow-mode-1.0.6.tar";
          sha256 = "04v73cm1cap19vwc8lqsw0rmfr9v7r3swc4wgxnk9dnzxi9j2527";
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
        version = "0.4.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rcirc-color-0.4.5.tar";
          sha256 = "0j2bcx2dplcy5zgh9zdhla8i12rq916ilbnw4ns83xdg7k0dwncf";
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
          sha256 = "0qd9hcq7a9vn453rs4pf3p8wwh7fynxhim9j6sf97lm8pilif9yd";
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
        version = "1.9.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rec-mode-1.9.1.tar";
          sha256 = "0f60bw07l6kk1kkjjxsk30p6rxj9mpngaxqy8piyabnijfgjzd3s";
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
        version = "1.23";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/relint-1.23.tar";
          sha256 = "0cyv9hjlyxy1c2394544ljq5d4prhi296y9j2zy6p1lq6irncmv9";
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
        version = "1.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/repology-1.2.3.tar";
          sha256 = "1ngx23b7dilyps20nznrrn867kbxyn6nryf4p1sy5m576hkw18kn";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rnc-mode-0.3.tar";
          sha256 = "1bd4pxaijcs0w8v9r7x9aiqyqf1rl46153dxl0ilhm3fc90iyf2r";
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
        version = "5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/rt-liberation-5.tar";
          sha256 = "1gjj38rag3hh42xkf7qlvwn0qj45i8v30h5wgs3w2a2ccs46bpy4";
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
          sha256 = "0b6hh31vpyv6j86v97migw4if2i9m95075p0bf5ai61cqb42crg4";
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
        version = "1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sed-mode-1.1.tar";
          sha256 = "1vpfzr95xfvjiq7x1pkhjm96936yzsy9bzm1v8p3hyr486bar0mp";
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
        version = "1.3.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/setup-1.3.2.tar";
          sha256 = "1sr514w4mn0fbdawjb5p0fd6i6q2zi9737rbwcgakb1l9cqvb5qy";
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
        version = "2.4.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/shell-command+-2.4.2.tar";
          sha256 = "1ldvil6hjs8c7wpdwx0jwaar867dil5qh6vy2k27i1alffr9nnqm";
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
    site-lisp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "site-lisp";
        ename = "site-lisp";
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/site-lisp-0.1.1.tar";
          sha256 = "05fdh7hv3dwm8li4qsyrm9j6zdj43k82al1p5z9ir6xmy1r5b571";
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
        version = "6.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sml-mode-6.12.tar";
          sha256 = "19wyxsnw60lmjbb7ijislpv9vzk9996rh1b0iw7wyrqszfxy2p20";
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
        version = "3.2.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/soap-client-3.2.3.tar";
          sha256 = "0z6af253iwimam03jnpai2h989i6vyv05wdz7dadna6amdryfznc";
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
          sha256 = "1zri4czw2d5impkgn8d4hliyw31vndadg7wj31gairk8kyakjpgm";
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
    spacious-padding = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "spacious-padding";
        ename = "spacious-padding";
        version = "0.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/spacious-padding-0.1.0.tar";
          sha256 = "0kc5f1p9y2gp2sb6l2vljjhi330f8zxfm7gjjvyymhf2grr61mxw";
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
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/sql-beeline-0.2.tar";
          sha256 = "1bqzs53x506bzgchvjfr1ljqxbb9y041n7aj9n7ajb2634i7lllr";
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
          sha256 = "06h301fpqax24x295x06bz08ipjjnxs9smisyz82z08kgszq92c6";
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
    srht = callPackage ({ elpaBuild, emacs, fetchurl, lib, plz }:
      elpaBuild {
        pname = "srht";
        ename = "srht";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/srht-0.2.tar";
          sha256 = "1qps9vdsiy5zkz88kh9kl1hnn1wlfz6n5brzcxi28fwx0hb3ksz2";
        };
        packageRequires = [ emacs plz ];
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
          sha256 = "0ajmsg4r9yba2m9wn08dsdzl8pr3pjixyqqp263mpwsh02h8im2g";
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
        version = "1.2.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/standard-themes-1.2.0.tar";
          sha256 = "1prf89jk41cmd3bj51343jyz53k5bjbc871s54cqlhz3vvbgc4ww";
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
    substitute = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "substitute";
        ename = "substitute";
        version = "0.2.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/substitute-0.2.1.tar";
          sha256 = "1p9lhgi4y224aghwnnjxm14da461pj0ym4a7asla02hf33y61i5j";
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
        version = "0.2.7";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/svg-lib-0.2.7.tar";
          sha256 = "0vq7a1hh6am5a1hqc1fay4cra7944zch5m5vadwhsnqgnrylm2gw";
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
        version = "0.14.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/swiper-0.14.0.tar";
          sha256 = "1p2qil6gj4y8y3ydqs8pbxn8j16q9r42nnc2f61c30hws504pkms";
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
          sha256 = "1ax63fksjmjsgai7xxzm1mj5bhbc7dzk7c389abd280g637z2cy7";
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
          sha256 = "1vzb7ijx61rq31xj0d13yidlirp038841fwdvlqlv88hi6hb2faq";
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
        version = "1.0.12";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/system-packages-1.0.12.tar";
          sha256 = "1q962z0lbdz7qw60lbhzqs8cqc66rhvsyjghy6rs7iqmq6h2sf8c";
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
        version = "0.10.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/taxy-0.10.1.tar";
          sha256 = "05czw8fkifb25rwl99dmncr1g0rjfx1bqijl7igqs9j6h9ia2xvg";
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
        version = "0.12.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/taxy-magit-section-0.12.2.tar";
          sha256 = "1pf83zz5ibhqqlqgcxig0dsl1rnkk5r6v16s5ngvbc37q40vkwn1";
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
          url = "https://elpa.gnu.org/packages/temp-buffer-browse-1.5.el";
          sha256 = "1drfvqxc6g4vfijmx787b1ygq7x2s5wq26l45qnz4wdrqqmcqx3c";
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
        version = "0.8";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tempel-0.8.tar";
          sha256 = "1ppvkwy7c31p4ibshfralwz02xnxmssf6lgikahpimrg928zcd80";
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
    tmr = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tmr";
        ename = "tmr";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tmr-0.4.0.tar";
          sha256 = "1s4q7gbqjhqsvwzcfqr9ykm2pdrjybsi2fanxm01vvmzwg2bi6d8";
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
          sha256 = "03dj7mhqyfdpxr32nyvfgkqr6wr55cd7yk9a0izjs4468zx8vl0d";
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
          sha256 = "1c2raqmbyv5bd48gimh6dazfb6dmipjmf1j0w53vyrs48dx6kskq";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/topspace.html";
          license = lib.licenses.free;
        };
      }) {};
    tramp = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tramp";
        ename = "tramp";
        version = "2.6.1.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tramp-2.6.1.1.1.tar";
          sha256 = "1aclan50xl0cgsxy9l7c1dd73w4kklmap9c74gndcssdi6p1mw69";
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
          sha256 = "1w8h563pcdksqqy5v5vi7vrx76r6pi4bzhqywk1v67rhnr33qsvq";
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
    transient = callPackage ({ compat, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "transient";
        ename = "transient";
        version = "0.4.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/transient-0.4.3.tar";
          sha256 = "1aqw7fr5p2f1xs5pvfpmhhvh16491qvcbg40993siqkdi05w4i1j";
        };
        packageRequires = [ compat emacs ];
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
          sha256 = "1gad71kqdw6rm9dy5rxm85l4a5qibs20ijl8bpaxbbq37j44lvjb";
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
        version = "0.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/tree-inspector-0.3.tar";
          sha256 = "1hns99rfga8p85ylbr4ri14wyfcxf0bcni0fyr09awipxrpn6ikq";
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
    triples = callPackage ({ elpaBuild, emacs, fetchurl, lib, seq }:
      elpaBuild {
        pname = "triples";
        ename = "triples";
        version = "0.3.5";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/triples-0.3.5.tar";
          sha256 = "086w3izri2fvg2w9lq4srjcq9gc6amz5vj2iihhysd10ypj3zxwy";
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
          sha256 = "11k1dca7kw1yviiw310slfj02a7x1w6m3qg7v71d2gcmdbp112ib";
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
          sha256 = "09n0wp0dfg9xyxw0hwwb5p6namninvsw1fs710hmnh224q6wffgy";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/ulisp-repl.html";
          license = lib.licenses.free;
        };
      }) {};
    undo-tree = callPackage ({ elpaBuild, emacs, fetchurl, lib, queue }:
      elpaBuild {
        pname = "undo-tree";
        ename = "undo-tree";
        version = "0.8.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/undo-tree-0.8.2.tar";
          sha256 = "0fgir9pls9439zwyl3j2yvrwx9wigisj1jil4ijma27dfrpgm288";
        };
        packageRequires = [ emacs queue ];
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
        version = "1.0.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/uniquify-files-1.0.4.tar";
          sha256 = "0ry52l9p2sz8nsfh15ffa25s46vqhna466ahmjmnmlihgjhdm85q";
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
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/urgrep-0.1.1.tar";
          sha256 = "0bdi0phx7in23g4pb6yrzp4b1n08zjk4cnvhj3ya76y7sah0hdsz";
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
    url-http-oauth = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "url-http-oauth";
        ename = "url-http-oauth";
        version = "0.8.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/url-http-oauth-0.8.3.tar";
          sha256 = "1vcbx8rpzvx4v4g7iyja6kpsqidaiy2xzj7glrwwzhppkbp0xkvy";
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
          sha256 = "0mfbqr03302gk38aamlg1lgdznd6y3blcc3zizfb72ppb87j78mc";
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
          sha256 = "09aimbmkcpyffrq1qnavzx6c4ccfawz7ndz2ac8md7qxilxx58yc";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vc-got-1.2.tar";
          sha256 = "074di4bchhnpfixkjdis8dwxx6r32j1qypxk647q1z7lvd92j39s";
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
        version = "0.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vcard-0.2.2.tar";
          sha256 = "0f06qzmj91kdpdlhlykh7v7jx0xvwxg8072ys145g1mvh5l23yig";
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
        version = "2023.6.6.141322628";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/verilog-mode-2023.6.6.141322628.tar";
          sha256 = "14qls4v5yxrgyiimvvggimw5ddlx0ll387a1r6awm274rj4p3d19";
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
        version = "1.4";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-1.4.tar";
          sha256 = "0jv4adwi18j14yjasqndsgyxgrd1jnjhwrw90hyplfii08f6gmdq";
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
        version = "0.7.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vertico-posframe-0.7.3.tar";
          sha256 = "1gfapchkj9jkzlyz3hzkb9kpifcak0fn4y5jw6f2cs6379sjwvzm";
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
        version = "1.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/visual-filename-abbrev-1.2.tar";
          sha256 = "0sipyqrgf723ii2zd6r8hvihn5kax5qd0dwwrrxqy6f58wnhyq1r";
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
    vundo = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "vundo";
        ename = "vundo";
        version = "2.1.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/vundo-2.1.0.tar";
          sha256 = "1inm6kvh5j47nsrmq6wpf30dqmx0arzdpa6vdcn834g50i4fh8kc";
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
        version = "1.15";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/websocket-1.15.tar";
          sha256 = "0mvvq9gsx856ip2gkrvjw4k8a85vrrkp27dcpkvamxq93lfd7hin";
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
    window-commander = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "window-commander";
        ename = "window-commander";
        version = "3.0.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/window-commander-3.0.2.tar";
          sha256 = "1v85g89rz8r2ypw6651lrb9mvrimdwhxan7kxzhpgam2i2g7kcr7";
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
        version = "4.2.2";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/wisi-4.2.2.tar";
          sha256 = "041np2xssm4iv75wmwds25fwx0p2y3j6ph0j0pxmgcj9p028mbka";
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
          sha256 = "05g2zn3p9r7rha20wv8jy1dwvllfyjjpzr6agkcm523rj639jh2b";
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
    xeft = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "xeft";
        ename = "xeft";
        version = "3.3";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xeft-3.3.tar";
          sha256 = "1jzas6qy0s686s0ghdrgcz2bfyp32s70qvkqw00sm3mm3jypiplm";
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
        version = "1.24";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xr-1.24.tar";
          sha256 = "04g7qx6qmhp98pw5iwdhspln9sg9jzjq2zp3nmq3q1yl82pzd214";
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
          sha256 = "0ccfp47y769zrb5sza8skzy4nj4793lzd0jn5c83s3g916gp304l";
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
        version = "0.1.1";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/xref-union-0.1.1.tar";
          sha256 = "1v95l4j3w3zrjmii3pz319s4jmqnfdx6np120zhc6ccgj1fawy2c";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/xref-union.html";
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
    zuul = callPackage ({ elpaBuild, emacs, fetchurl, lib, project }:
      elpaBuild {
        pname = "zuul";
        ename = "zuul";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.gnu.org/packages/zuul-0.4.0.tar";
          sha256 = "1bm91g001q3n5m9ihxc719siiiy23pkpfkhplwi9p1i4i9zrpx5g";
        };
        packageRequires = [ emacs project ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/zuul.html";
          license = lib.licenses.free;
        };
      }) {};
  }
