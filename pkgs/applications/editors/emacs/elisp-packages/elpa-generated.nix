{ callPackage }:
{
  a68-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "a68-mode";
      ename = "a68-mode";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/a68-mode-1.2.tar";
        sha256 = "1x40j0w6kzjxxrj7qdvll1psackq526cfrihfmacmq97c9g8xwm6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/a68-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ace-window = callPackage (
    {
      avy,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  ack = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ack";
      ename = "ack";
      version = "1.11";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ack-1.11.tar";
        sha256 = "1ji02v3qis5sx7hpaaxksgh2jqxzzilagz6z33kjb1lds1sq4z2c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ack.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  activities = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      persist,
    }:
    elpaBuild {
      pname = "activities";
      ename = "activities";
      version = "0.7.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/activities-0.7.2.tar";
        sha256 = "1b6d77b5h2vikfxqjlb1jx5pnij5bif788nysvvn3wlzpwdi88s0";
      };
      packageRequires = [ persist ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/activities.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ada-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      gnat-compiler,
      lib,
      uniquify-files,
      wisi,
    }:
    elpaBuild {
      pname = "ada-mode";
      ename = "ada-mode";
      version = "8.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ada-mode-8.1.0.tar";
        sha256 = "10k514al716qjx3qg1m4k1rnf70fa73vrmmx3pp75zrw1d0db9y6";
      };
      packageRequires = [
        gnat-compiler
        uniquify-files
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ada-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ada-ref-man = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ada-ref-man";
      ename = "ada-ref-man";
      version = "2020.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ada-ref-man-2020.1.tar";
        sha256 = "0ijgl9lnmn8n3pllgh3apl2shbl38f3fxn8z5yy4q6pqqx0vr3fn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ada-ref-man.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  adaptive-wrap = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "adaptive-wrap";
      ename = "adaptive-wrap";
      version = "0.8";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/adaptive-wrap-0.8.tar";
        sha256 = "1dz5mi21v2wqh969m3xggxbzq3qf78hps418rzl73bb57l837qp8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/adaptive-wrap.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  adjust-parens = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "adjust-parens";
      ename = "adjust-parens";
      version = "3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/adjust-parens-3.2.tar";
        sha256 = "1gdlykg7ix3833s40152p1ji4r1ycp18niqjr1f994y4ydqxq8yl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/adjust-parens.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  advice-patch = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "advice-patch";
      ename = "advice-patch";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/advice-patch-0.1.tar";
        sha256 = "0km891648k257k4d6hbrv6jyz9663kww8gfarvzf9lv8i4qa5scp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/advice-patch.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  aggressive-completion = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "aggressive-completion";
      ename = "aggressive-completion";
      version = "1.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/aggressive-completion-1.7.tar";
        sha256 = "0d388w0yjpjzhqlar9fjrxsjxma09j8as6758sswv01r084gpdbk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/aggressive-completion.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  aggressive-indent = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "aggressive-indent";
      ename = "aggressive-indent";
      version = "1.10.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/aggressive-indent-1.10.0.tar";
        sha256 = "1c27g9qhqc4bh96bkxdcjbrhiwi7kzki1l4yhxvyvwwarisl6c7b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/aggressive-indent.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ahungry-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ahungry-theme";
      ename = "ahungry-theme";
      version = "1.10.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ahungry-theme-1.10.0.tar";
        sha256 = "16k6wm1qss5bk45askhq5vswrqsjic5dijpkgnmwgvm8xsdlvni6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ahungry-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  aircon-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "aircon-theme";
      ename = "aircon-theme";
      version = "0.0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/aircon-theme-0.0.6.tar";
        sha256 = "0dcnlk3q95bcghlwj8ii40xxhspnfbqcr9mvj1v3adl1s623fyp0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/aircon-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  all = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "all";
      ename = "all";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/all-1.1.tar";
        sha256 = "067c5ynklw1inbjwd1l6dkbpx3vw487qv39y7mdl55a6nqx7hgk4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/all.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  altcaps = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "altcaps";
      ename = "altcaps";
      version = "1.3.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/altcaps-1.3.0.tar";
        sha256 = "1q75hnx9pc65r069dg1m0r88b40q58p509m13v0mykbpfsinncag";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/altcaps.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ampc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ampc";
      ename = "ampc";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ampc-0.2.tar";
        sha256 = "17l2c5hr7cq0vf4qc8s2adwlhqp74glc4v909h0jcavrnbn8yn80";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ampc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  arbitools = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  ascii-art-to-unicode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ascii-art-to-unicode";
      ename = "ascii-art-to-unicode";
      version = "1.13";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ascii-art-to-unicode-1.13.tar";
        sha256 = "0qlh8zi691gz7s1ayp1x5ga3sj3rfy79y21r6hqf696mrkgpz1d8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ascii-art-to-unicode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  assess = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      m-buffer,
    }:
    elpaBuild {
      pname = "assess";
      ename = "assess";
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/assess-0.7.tar";
        sha256 = "1wka2idr63bn8fgh0cz4lf21jvlhkr895y0xnh3syp9vrss5hzsp";
      };
      packageRequires = [ m-buffer ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/assess.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  async = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "async";
      ename = "async";
      version = "1.9.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/async-1.9.9.tar";
        sha256 = "00slbyzjjn2v90lkaa9kc3wvlibs0rldh9crzjgp43y31xrzgpsg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/async.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auctex = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "auctex";
      ename = "auctex";
      version = "14.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/auctex-14.1.0.tar";
        sha256 = "0cb5f86p7yxqx27wck2a3wgsxrzhv5rrgn88wpias1w7v2lbsw2j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/auctex.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auctex-cont-latexmk = callPackage (
    {
      auctex,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "auctex-cont-latexmk";
      ename = "auctex-cont-latexmk";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/auctex-cont-latexmk-0.3.tar";
        sha256 = "1s1fp8cajwcsvrnvbhnlzfsphpflsv6fzmc624578sz2m0p1wg6n";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/auctex-cont-latexmk.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auctex-label-numbers = callPackage (
    {
      auctex,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "auctex-label-numbers";
      ename = "auctex-label-numbers";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/auctex-label-numbers-0.2.tar";
        sha256 = "1cd68yvpm061r9k4x6rvy3g2wdynv5gbjg2dyp06nkrgvakdb00x";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/auctex-label-numbers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  aumix-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "aumix-mode";
      ename = "aumix-mode";
      version = "7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/aumix-mode-7.tar";
        sha256 = "08baz31hm0nhikqg5h294kg5m4qkiayjhirhb57v57g5722jfk3m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/aumix-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auth-source-xoauth2-plugin = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      oauth2,
    }:
    elpaBuild {
      pname = "auth-source-xoauth2-plugin";
      ename = "auth-source-xoauth2-plugin";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/auth-source-xoauth2-plugin-0.3.1.tar";
        sha256 = "1qqyl5qz3ldp28qm1vwbq4q7csb4wy6b3w3z72fhasvkcpb266iw";
      };
      packageRequires = [ oauth2 ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/auth-source-xoauth2-plugin.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auto-correct = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "auto-correct";
      ename = "auto-correct";
      version = "1.1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/auto-correct-1.1.4.tar";
        sha256 = "05ky3qxbvxrkywpqj6syl7ll6za74fhjzrcia6wdmxsnjya5qbf1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/auto-correct.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auto-overlays = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  autocrypt = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "autocrypt";
      ename = "autocrypt";
      version = "0.4.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/autocrypt-0.4.2.tar";
        sha256 = "0mc4vb6x7qzn29dg9m05zgli6mwh9cj4vc5n6hvarzkn9lxl6mr3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/autocrypt.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  autorevert-tail-truncate = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "autorevert-tail-truncate";
      ename = "autorevert-tail-truncate";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/autorevert-tail-truncate-1.0.1.tar";
        sha256 = "1g7bqd617vmanjf3s1c4adsj5zhvsxrzib2pkj508fs5hbyyi1wi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/autorevert-tail-truncate.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  avy = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "avy";
      ename = "avy";
      version = "0.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/avy-0.5.0.tar";
        sha256 = "1xfcml38qmrwdd0rkhwrvv2s7dbznwhk3vy9pjd6ljpg22wkb80d";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/avy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bbdb = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bbdb";
      ename = "bbdb";
      version = "3.2.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bbdb-3.2.2.4.tar";
        sha256 = "1ymjydf54z3rbkxk4irvan5s8lc8wdhk01691741vfznx0nsc4a2";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bbdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  beacon = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "beacon";
      ename = "beacon";
      version = "1.3.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/beacon-1.3.4.tar";
        sha256 = "1hxb6vyvpppj7yzphknmh8m4a1h89lg6jr98g4d62k0laxazvdza";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/beacon.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  beframe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "beframe";
      ename = "beframe";
      version = "1.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/beframe-1.4.0.tar";
        sha256 = "1766y7jwhsccmndd30v7hyh3i8gacvzwb73ix7g0zynp12m6x6kb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/beframe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bicep-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bicep-ts-mode";
      ename = "bicep-ts-mode";
      version = "0.1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bicep-ts-mode-0.1.4.tar";
        sha256 = "0jf6zbmmwyjrl6wrcc99ahbv0xqbfr9zdzayi7racbflsyflxnb7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bicep-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bind-key = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bind-key";
      ename = "bind-key";
      version = "2.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bind-key-2.4.1.tar";
        sha256 = "0jrbm2l6h4r7qjcdcsfczbijmbf3njzzzrymv08zanchmy7lvsv2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bind-key.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  blist = callPackage (
    {
      elpaBuild,
      fetchurl,
      ilist,
      lib,
    }:
    elpaBuild {
      pname = "blist";
      ename = "blist";
      version = "0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/blist-0.6.tar";
        sha256 = "1r7pnbz4vdwbnga271d03i5dy1hvnxbf17q5bcrn05vwxlf8g83m";
      };
      packageRequires = [ ilist ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/blist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bluetooth = callPackage (
    {
      compat,
      dash,
      elpaBuild,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "bluetooth";
      ename = "bluetooth";
      version = "0.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bluetooth-0.4.1.tar";
        sha256 = "1chi9xjg5zcg6qycn2n442adhhmip1vpvg12szf1raq3zhg7lr01";
      };
      packageRequires = [
        compat
        dash
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bluetooth.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bnf-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bnf-mode";
      ename = "bnf-mode";
      version = "0.4.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bnf-mode-0.4.5.tar";
        sha256 = "1x6km8rhhb5bkas3yfmjfpyxlhyxkqnzviw1pqlq88c95j88h3d4";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bnf-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  boxy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "boxy";
      ename = "boxy";
      version = "2.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/boxy-2.0.0.tar";
        sha256 = "1vfgwgk3vzzp2cy7n0qwhn7hzjxbp9vzxp1al1pkynv9hfs503gb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/boxy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  boxy-headings = callPackage (
    {
      boxy,
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "boxy-headings";
      ename = "boxy-headings";
      version = "2.1.10";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/boxy-headings-2.1.10.tar";
        sha256 = "0a3933yckjw7b8jk5nnlb6hwjf1vzi1ydwk70csmz73402k0jxk1";
      };
      packageRequires = [
        boxy
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/boxy-headings.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  breadcrumb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "breadcrumb";
      ename = "breadcrumb";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/breadcrumb-1.0.1.tar";
        sha256 = "1s69a2z183mla4d4b5pcsswbwa3hjvsg1xj7r3hdw6j841b0l9dw";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/breadcrumb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  brief = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "brief";
      ename = "brief";
      version = "5.92";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/brief-5.92.tar";
        sha256 = "0nfnk5aag5w7170njdl9gq2kf48gzmbmdpz209y1vzdxw91jrwql";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/brief.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  buffer-env = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "buffer-env";
      ename = "buffer-env";
      version = "0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/buffer-env-0.6.tar";
        sha256 = "08qaw4y1sszhh97ih13vfrm0r1nn1k410f2wwvffvncxhqgxz5lv";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/buffer-env.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  buffer-expose = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "buffer-expose";
      ename = "buffer-expose";
      version = "0.4.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/buffer-expose-0.4.3.tar";
        sha256 = "1ymjjjrbknp3hdfwd8zyzfrsn5n267245ffmplm7yk2s34kgxr0n";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/buffer-expose.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bufferlo = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bufferlo";
      ename = "bufferlo";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bufferlo-1.2.tar";
        sha256 = "0144bvgi63cvh7fcqdiz3zy0nncj8jslxd3x9jaw7m4pwadvaqvq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bufferlo.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  buframe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      timeout,
    }:
    elpaBuild {
      pname = "buframe";
      ename = "buframe";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/buframe-0.2.tar";
        sha256 = "0bnj4xvwmda62j9i7a9pnd0x20wa6g3il8cl55df26qpgqmjjpkq";
      };
      packageRequires = [ timeout ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/buframe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bug-hunter = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "bug-hunter";
      ename = "bug-hunter";
      version = "1.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/bug-hunter-1.3.1.tar";
        sha256 = "0cgwq8b6jglbg9ydvf80ijgbbccrks3yb9af46sdd6aqdmvdlx21";
      };
      packageRequires = [
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/bug-hunter.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  buildbot = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "buildbot";
      ename = "buildbot";
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/buildbot-0.0.1.tar";
        sha256 = "056jakpyslizsp8sik5f7m90dpcga8y38hb5rh1yfa7k1xwcrrk2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/buildbot.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  calibre = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "calibre";
      ename = "calibre";
      version = "1.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/calibre-1.4.1.tar";
        sha256 = "1ak05y3cmmwpg8bijkwl97kvfxhxh9xxc74askyafc50n0jvaq87";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/calibre.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cape = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cape";
      ename = "cape";
      version = "2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cape-2.1.tar";
        sha256 = "10g0nxdg6cb2v08qip8dskh1zkdqv23vy8x2f0lyscbmwi72zkrd";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cape.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  capf-autosuggest = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "capf-autosuggest";
      ename = "capf-autosuggest";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/capf-autosuggest-0.3.tar";
        sha256 = "18cwiv227m8y1xqvsnjrzgd6f6kvvih742h8y38pphljssl109fk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/capf-autosuggest.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  caps-lock = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "caps-lock";
      ename = "caps-lock";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/caps-lock-1.0.tar";
        sha256 = "1yy4kjc1zlpzkam0jj8h3v5h23wyv1yfvwj2drknn59d8amc1h4y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/caps-lock.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  captain = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "captain";
      ename = "captain";
      version = "1.0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/captain-1.0.3.tar";
        sha256 = "0l8z8bqk705jdl7gvd2x7nhs0z6gn3swk5yzp3mnhjcfda6whz8l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/captain.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  chess = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  cl-generic = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cl-generic";
      ename = "cl-generic";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cl-generic-0.3.tar";
        sha256 = "0dqn484xb25ifiqd9hqdrs954c74akrf95llx23b2kzf051pqh1k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cl-generic.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cl-lib = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cl-lib";
      ename = "cl-lib";
      version = "0.7.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cl-lib-0.7.1.tar";
        sha256 = "1wpdg2zwhzxv4bkx9ldiwd16l6244wakv8yphrws4mnymkxvf2q1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cl-lib.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  clipboard-collector = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "clipboard-collector";
      ename = "clipboard-collector";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/clipboard-collector-0.3.tar";
        sha256 = "0v70f9pljq3jar3d1vpaj48nhrg90jzsvqcbzgv54989w8rvvcd6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/clipboard-collector.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cobol-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  code-cells = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "code-cells";
      ename = "code-cells";
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/code-cells-0.5.tar";
        sha256 = "04fvn0lwvnvf907k13822jpxyyi6cf55v543i9iqy57dav6sn2jx";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/code-cells.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  colorful-mode = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "colorful-mode";
      ename = "colorful-mode";
      version = "1.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/colorful-mode-1.2.4.tar";
        sha256 = "18gymjgsa5hxzy502b7mi99d8sypnn07i9934k4bj1py1xwl8q2b";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/colorful-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  comint-mime = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      mathjax,
    }:
    elpaBuild {
      pname = "comint-mime";
      ename = "comint-mime";
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/comint-mime-0.7.tar";
        sha256 = "1scf7b72kzqcf51svww3rbamdnm607pvzg04rdcglc2cna1n2apa";
      };
      packageRequires = [
        compat
        mathjax
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/comint-mime.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  compact-docstrings = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "compact-docstrings";
      ename = "compact-docstrings";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/compact-docstrings-0.2.tar";
        sha256 = "00fjhfysjyqigkg0icxlqw6imzhjk5xhlxmxxs1jiafhn55dbcpj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/compact-docstrings.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  company = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "company";
      ename = "company";
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/company-1.0.2.tar";
        sha256 = "00vmqra0fav0w4q13ngwpyqpxqah0ahfg7kp5l2nd0h2l8sp79qr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/company.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  company-ebdb = callPackage (
    {
      company,
      ebdb,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "company-ebdb";
      ename = "company-ebdb";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/company-ebdb-1.1.tar";
        sha256 = "1ym0r7y90n4d6grd4l02rxk096gsjmw9j81slig0pq1ky33rb6ks";
      };
      packageRequires = [
        company
        ebdb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/company-ebdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  company-math = callPackage (
    {
      company,
      elpaBuild,
      fetchurl,
      lib,
      math-symbol-lists,
    }:
    elpaBuild {
      pname = "company-math";
      ename = "company-math";
      version = "1.5.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/company-math-1.5.1.tar";
        sha256 = "16ya3yscxxmz9agi0nc5pi43wkfv45lh1zd89yqfc7zcw02nsnld";
      };
      packageRequires = [
        company
        math-symbol-lists
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/company-math.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  company-statistics = callPackage (
    {
      company,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "company-statistics";
      ename = "company-statistics";
      version = "0.2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/company-statistics-0.2.3.tar";
        sha256 = "1gfwhgv7q9d3xjgaim25diyd6jfl9w3j07qrssphcrdxv0q24d14";
      };
      packageRequires = [ company ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/company-statistics.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  compat = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "compat";
      ename = "compat";
      version = "30.1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/compat-30.1.0.1.tar";
        sha256 = "1rj5i709i0l7drr7f571gsk8d6b5slwrd2l9flayv63kwk1gizhn";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/compat.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cond-star = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cond-star";
      ename = "cond-star";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cond-star-1.0.tar";
        sha256 = "1r8wfb7g6dknpnqvsszrcdpc695srk0f8s85zi0d93k1iyl3yi2q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cond-star.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  constants = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "constants";
      ename = "constants";
      version = "2.11.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/constants-2.11.1.tar";
        sha256 = "0n1wa9hr0841733s6w30x1n5mmis8fpjfzl5mn7s9q12djpp20fy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/constants.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  consult = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "consult";
      ename = "consult";
      version = "2.8";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/consult-2.8.tar";
        sha256 = "01vvv5q1rlbi7db0hya8dilr6ywq0skf43mc49jka3c3gj3a924v";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/consult.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  consult-denote = callPackage (
    {
      consult,
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "consult-denote";
      ename = "consult-denote";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/consult-denote-0.3.1.tar";
        sha256 = "1rvn90wv6r48129w4s8wcc2gp9wa92zxwc0a4yc70xc5xxm85xi4";
      };
      packageRequires = [
        consult
        denote
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/consult-denote.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  consult-hoogle = callPackage (
    {
      consult,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "consult-hoogle";
      ename = "consult-hoogle";
      version = "0.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/consult-hoogle-0.5.0.tar";
        sha256 = "183mms98c5ajr2z60qwpl2b8b466dqz6nd84vvpqdzvxr9qkw14n";
      };
      packageRequires = [ consult ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/consult-hoogle.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  consult-recoll = callPackage (
    {
      consult,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "consult-recoll";
      ename = "consult-recoll";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/consult-recoll-1.0.0.tar";
        sha256 = "1fjc5s1xn15vglmaqywnrpqnjb46w15xysk7n18ifqapcya5g0x0";
      };
      packageRequires = [ consult ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/consult-recoll.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  context-coloring = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "context-coloring";
      ename = "context-coloring";
      version = "8.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/context-coloring-8.1.0.tar";
        sha256 = "0mqdl34g493pps85ckin5i3iz8kwlqkcwjvsf2sj4nldjvvfk1ng";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/context-coloring.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  corfu = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "corfu";
      ename = "corfu";
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/corfu-2.3.tar";
        sha256 = "1q86z90hbizvihnvpfn81vv2cd67jlwhp4w0cz1mr4fl1bnqq5g4";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/corfu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  coterm = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "coterm";
      ename = "coterm";
      version = "1.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/coterm-1.6.tar";
        sha256 = "0kgsg99dggirz6asyppwx1ydc0jh62xd1bfhnm2hyby5qkqz1yvk";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/coterm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  counsel = callPackage (
    {
      elpaBuild,
      fetchurl,
      ivy,
      lib,
      swiper,
    }:
    elpaBuild {
      pname = "counsel";
      ename = "counsel";
      version = "0.15.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/counsel-0.15.1.tar";
        sha256 = "1sgaph2wb4mkxlfq6448i1kymaxhs7h37nrn7vzbp9fhik634rhc";
      };
      packageRequires = [
        ivy
        swiper
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/counsel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cpio-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cpio-mode";
      ename = "cpio-mode";
      version = "0.17";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cpio-mode-0.17.tar";
        sha256 = "13jay5c36svq2r78gwp7d1slpkkzrx749q28554mxd855fr6pvaj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cpio-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cpupower = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cpupower";
      ename = "cpupower";
      version = "1.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cpupower-1.0.5.tar";
        sha256 = "155fhf38p95a5ws6jzpczw0z03zwbsqzdwj50v3grjivyp74pddz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cpupower.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  crdt = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "crdt";
      ename = "crdt";
      version = "0.3.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/crdt-0.3.5.tar";
        sha256 = "038qivbw02h1i98ym0fwx72x05gm0j4h93a54v1l7g25drm5zm83";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/crdt.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  crisp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "crisp";
      ename = "crisp";
      version = "1.3.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/crisp-1.3.6.tar";
        sha256 = "0am7gwadjp0nwlvf7y4sp9brbm0234k55bnxfv44lkwdf502mq8y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/crisp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  csharp-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "csharp-mode";
      ename = "csharp-mode";
      version = "2.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/csharp-mode-2.0.0.tar";
        sha256 = "1jjxq5vkqq2v8rkcm2ygggpg355aqmrl2hdhh1xma3jlnj5carnf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/csharp-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  csv-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "csv-mode";
      ename = "csv-mode";
      version = "1.27";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/csv-mode-1.27.tar";
        sha256 = "0jxf4id5c9696nh666x0xbzqx3vskyv810km61y9nkg7sp4ln2qf";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/csv-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cursor-undo = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cursor-undo";
      ename = "cursor-undo";
      version = "1.1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cursor-undo-1.1.5.tar";
        sha256 = "1zbn4wfirnwjhy4q0lz8s0zffp84v6zs1x6wjxlcr0la7xn2sx4v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cursor-undo.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cursory = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cursory";
      ename = "cursory";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cursory-1.2.0.tar";
        sha256 = "0019syaj02lxm4c4bdfqfq6g5izkgwwfgz82fj1grxk904kdi4fs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cursory.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cycle-quotes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cycle-quotes";
      ename = "cycle-quotes";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/cycle-quotes-0.1.tar";
        sha256 = "1glf8sd3gqp9qbd238vxd3aprdz93f887893xji3ybqli36i2xs1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/cycle-quotes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dape = callPackage (
    {
      elpaBuild,
      fetchurl,
      jsonrpc,
      lib,
    }:
    elpaBuild {
      pname = "dape";
      ename = "dape";
      version = "0.24.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dape-0.24.1.tar";
        sha256 = "01w2sr9cbs1d9zh15gajyac7xcqbz40f5xfwv0c7jmsqkn7rv7aq";
      };
      packageRequires = [ jsonrpc ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dape.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  darkroom = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  dash = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dash";
      ename = "dash";
      version = "2.20.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dash-2.20.0.tar";
        sha256 = "1ckcsfksvwcknbp39v5p4yyl5h6a8xz0iljx7wb20igq0l4lpy18";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dash.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dbus-codegen = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  debbugs = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      soap-client,
    }:
    elpaBuild {
      pname = "debbugs";
      ename = "debbugs";
      version = "0.45";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/debbugs-0.45.tar";
        sha256 = "1rbj3ms2hkg0ra30y0bwzmdlcq58p15vzhin28a1rw2rmbwx5irc";
      };
      packageRequires = [ soap-client ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/debbugs.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  delight = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "delight";
      ename = "delight";
      version = "1.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/delight-1.7.tar";
        sha256 = "1j7srr0i7s9hcny45m8zmj33nl9g6zi55cbkdzzlbx6si2rqwwlj";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/delight.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote";
      ename = "denote";
      version = "4.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-4.0.0.tar";
        sha256 = "13a1aynmrj1vzq9xljs2h96pywqhr7iblyag51asxjynkzj2z27g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-journal = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-journal";
      ename = "denote-journal";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-journal-0.1.1.tar";
        sha256 = "0922hjzah7nz49z3q3qyq06n77yqxd7mxiw7fmawavjh920dv3fq";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-journal.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-markdown = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-markdown";
      ename = "denote-markdown";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-markdown-0.1.1.tar";
        sha256 = "0ic8kqfw56xsm9s0rlq7cgnh0dzjsbbcx7kdk55dggpvxv67jj62";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-markdown.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-menu = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-menu";
      ename = "denote-menu";
      version = "1.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-menu-1.4.0.tar";
        sha256 = "1lw8fyf749wmkrcn8ixvrias1a84wcgy9snlmlk0w2h02dqapazi";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-menu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-org = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-org";
      ename = "denote-org";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-org-0.1.1.tar";
        sha256 = "0nwyyzx96d5k6dw4jb8bvni9fjr1plip57mdsyabrha19p6n282d";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-org.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-search = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-search";
      ename = "denote-search";
      version = "1.0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-search-1.0.3.tar";
        sha256 = "1537c5xr7gvsvwn7khjs03z4g6js03mwwz9i5rwnmksajhkyfiv7";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-search.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-sequence = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-sequence";
      ename = "denote-sequence";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-sequence-0.1.1.tar";
        sha256 = "06s2k555in897rpr2iabzv29dr79lm6fkpjp3yssidr9irxymf0h";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-sequence.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-silo = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-silo";
      ename = "denote-silo";
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/denote-silo-0.1.2.tar";
        sha256 = "1z5afwd9gwn9fy132s87smffi5lgdk8f8c941y9ak6q7fbbpkya7";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/denote-silo.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  detached = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "detached";
      ename = "detached";
      version = "0.10.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/detached-0.10.1.tar";
        sha256 = "0w6xgidi0g1pc13xfm8hcgmc7i2h5brj443cykwgvr5wkqnpmp9m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/detached.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  devdocs = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "devdocs";
      ename = "devdocs";
      version = "0.6.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/devdocs-0.6.1.tar";
        sha256 = "04m3jd3wymrsdlb1i7z6dz9pf1q8q38ihkbn3jisdca6xkk9jd6p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/devdocs.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  devicetree-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "devicetree-ts-mode";
      ename = "devicetree-ts-mode";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/devicetree-ts-mode-0.3.tar";
        sha256 = "06j385pvlhd7hp9isqp5gcf378m8p6578q6nz81r8dx93ymaak79";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/devicetree-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dicom = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dicom";
      ename = "dicom";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dicom-1.0.tar";
        sha256 = "05v20pac5xgcmcqn6hw0f3n8dlz3nr178044y2xry6zz0psc3vx0";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dicom.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dict-tree = callPackage (
    {
      elpaBuild,
      fetchurl,
      heap,
      lib,
      tNFA,
      trie,
    }:
    elpaBuild {
      pname = "dict-tree";
      ename = "dict-tree";
      version = "0.17";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dict-tree-0.17.tar";
        sha256 = "0p4j0m3b9i38l4rcgzdps95wqk27zz156d4q73vq054kpcphrfpp";
      };
      packageRequires = [
        heap
        tNFA
        trie
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dict-tree.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  diff-hl = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "diff-hl";
      ename = "diff-hl";
      version = "1.10.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/diff-hl-1.10.0.tar";
        sha256 = "0v8nm2sx3v405fj6i5v7nnar47j6na0q5cm5za9y33n6xaw3v2yh";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/diff-hl.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  diffview = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "diffview";
      ename = "diffview";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/diffview-1.0.el";
        sha256 = "1gkdmzmgjixz9nak7dxvqy28kz0g7i672gavamwgnc1jl37wkcwi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/diffview.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  diminish = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "diminish";
      ename = "diminish";
      version = "0.46";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/diminish-0.46.tar";
        sha256 = "1xqd6ldxl93l281ncddik1lfxjngi2drq61mv7v18r756c7bqr5r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/diminish.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dired-du = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dired-du";
      ename = "dired-du";
      version = "0.5.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dired-du-0.5.2.tar";
        sha256 = "066yjy9vdbf20adcqdcknk5b0ml18fy2bm9gkgcp0qfg37yy1yjg";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dired-du.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dired-duplicates = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dired-duplicates";
      ename = "dired-duplicates";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dired-duplicates-0.4.tar";
        sha256 = "1srih47bq7szg6n3qlz4yzzcijg79p8xpwmi5c4v9xscl94nnc4z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dired-duplicates.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dired-git-info = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dired-git-info";
      ename = "dired-git-info";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dired-git-info-0.3.1.tar";
        sha256 = "0rryvlbqx1j48wafja15yc39jd0fzgz9i6bzmq9jpql3w9445772";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dired-git-info.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dired-preview = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dired-preview";
      ename = "dired-preview";
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dired-preview-0.6.0.tar";
        sha256 = "1nlibx8jwyvb5n58sx8bg6vcazhnlj5dydmf36v7hzy0h4i460i0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dired-preview.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  disk-usage = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "disk-usage";
      ename = "disk-usage";
      version = "1.3.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/disk-usage-1.3.3.tar";
        sha256 = "02i7i7mrn6ky3lzhcadvq7wlznd0b2ay107h2b3yh4wwwxjxymyg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/disk-usage.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dismal = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  djvu = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "djvu";
      ename = "djvu";
      version = "1.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/djvu-1.1.2.tar";
        sha256 = "0z74aicvy680m1d6v5zk5pcpkd310jqqdxadpjcbnjcybzp1zisq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/djvu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  do-at-point = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "do-at-point";
      ename = "do-at-point";
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/do-at-point-0.1.2.tar";
        sha256 = "0kirhg78ra6311hx1f1kpqhpxjxxg61gnzsh9j6id10f92h6m5gz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/do-at-point.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  doc-toc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "doc-toc";
      ename = "doc-toc";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/doc-toc-1.2.tar";
        sha256 = "09xwa0xgnzlaff0j5zy3kam6spcnw0npppc3gf6ka5bizbk4dq99";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/doc-toc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  doc-view-follow = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "doc-view-follow";
      ename = "doc-view-follow";
      version = "0.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/doc-view-follow-0.3.2.tar";
        sha256 = "1lwzcmxsqcbwf42s8yisw3wraka3yphhwf51pznlvdwhwax4h4ph";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/doc-view-follow.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  docbook = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "docbook";
      ename = "docbook";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/docbook-0.1.tar";
        sha256 = "1kn71kpyb1maww414zgpc1ccgb02mmaiaix06jyqhf75hfxms2lv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/docbook.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  doric-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "doric-themes";
      ename = "doric-themes";
      version = "0.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/doric-themes-0.4.0.tar";
        sha256 = "0dh5gib95fqfqdlk493y8dpdln2bqs2v5gg4gghy4rhgg79six5j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/doric-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  drepl = callPackage (
    {
      comint-mime,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "drepl";
      ename = "drepl";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/drepl-0.3.tar";
        sha256 = "0dy8xvx5nwibiyhddm6nhcw384vhkhsbbxcs4hah0yxwajfm8yds";
      };
      packageRequires = [ comint-mime ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/drepl.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dts-mode";
      ename = "dts-mode";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/dts-mode-1.0.tar";
        sha256 = "16ads9xjbqgmgwzj63anhc6yb1j79qpcnxjafqrzdih1p5j7hrr9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/dts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  easy-escape = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "easy-escape";
      ename = "easy-escape";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/easy-escape-0.2.1.tar";
        sha256 = "0mwam1a7sl90aqgz6mj3zm0w1dq15b5jpxmwxv21xs1imyv696ci";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/easy-escape.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  easy-kill = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "easy-kill";
      ename = "easy-kill";
      version = "0.9.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/easy-kill-0.9.5.tar";
        sha256 = "1nwhqidy5zq6j867b21zng5ppb7n56drnhn3wjs7hjmkf23r63qy";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/easy-kill.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ebdb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "ebdb";
      ename = "ebdb";
      version = "0.8.22";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ebdb-0.8.22.tar";
        sha256 = "0nmrhjk2ddml115ibsy8j4crw5hzq9fa94v8y41iyj9h3gf8irzc";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ebdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ebdb-gnorb = callPackage (
    {
      ebdb,
      elpaBuild,
      fetchurl,
      gnorb,
      lib,
    }:
    elpaBuild {
      pname = "ebdb-gnorb";
      ename = "ebdb-gnorb";
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ebdb-gnorb-1.0.2.tar";
        sha256 = "1kwcrg268vmskls9p4ccs6ybdip30cb4fw3xzq11gqjch1nssh18";
      };
      packageRequires = [
        ebdb
        gnorb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ebdb-gnorb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ebdb-i18n-chn = callPackage (
    {
      ebdb,
      elpaBuild,
      fetchurl,
      lib,
      pyim,
    }:
    elpaBuild {
      pname = "ebdb-i18n-chn";
      ename = "ebdb-i18n-chn";
      version = "1.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ebdb-i18n-chn-1.3.2.tar";
        sha256 = "1qyia40z6ssvnlpra116avakyf81vqn42860ny21g0zsl99a58j2";
      };
      packageRequires = [
        ebdb
        pyim
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ebdb-i18n-chn.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ediprolog = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ediprolog";
      ename = "ediprolog";
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ediprolog-2.3.tar";
        sha256 = "02ynwqhkpv4wcz87zkr9188kjmhd8s9zkfiawn7gywb5jkki6nd0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ediprolog.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eev = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "eev";
      ename = "eev";
      version = "20250914";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/eev-20250914.tar";
        sha256 = "1bn7nv42pkd910s47if2jzrzfd10s2nbhid3adh96p9bpy46k639";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/eev.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ef-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ef-themes";
      ename = "ef-themes";
      version = "1.11.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ef-themes-1.11.0.tar";
        sha256 = "086d2fmgzgnjil97zjn2i0ii81dq9l8rr859j0kyaxiy83r27rqb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ef-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eglot = callPackage (
    {
      compat,
      eldoc,
      elpaBuild,
      external-completion,
      fetchurl,
      flymake ? null,
      jsonrpc,
      lib,
      project,
      seq,
      track-changes,
      xref,
    }:
    elpaBuild {
      pname = "eglot";
      ename = "eglot";
      version = "1.18";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/eglot-1.18.tar";
        sha256 = "1zqs498yn3i8wn045jgq9nw4pddiyrwwgyq39mndzvgvi1j6a431";
      };
      packageRequires = [
        compat
        eldoc
        external-completion
        flymake
        jsonrpc
        project
        seq
        track-changes
        xref
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/eglot.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  el-job = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "el-job";
      ename = "el-job";
      version = "2.5.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/el-job-2.5.3.tar";
        sha256 = "0wigrrn5qw0dknlr9jwgq89jvhbmpyxvxsyh4lb9lm0vpd1vdfyg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/el-job.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  el-search = callPackage (
    {
      cl-print ? null,
      elpaBuild,
      fetchurl,
      lib,
      stream,
    }:
    elpaBuild {
      pname = "el-search";
      ename = "el-search";
      version = "1.12.6.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/el-search-1.12.6.1.tar";
        sha256 = "1vq8cp2icpl8vkc9r8brzbn0mpaj03mnvdz1bdqn8nqrzc3w0h24";
      };
      packageRequires = [
        cl-print
        stream
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/el-search.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eldoc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "eldoc";
      ename = "eldoc";
      version = "1.16.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/eldoc-1.16.0.tar";
        sha256 = "08dnvfyz6qkjx3fcggp628qacbxvac1agl7kgbkg6kiq4axwmifb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/eldoc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  electric-spacing = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "electric-spacing";
      ename = "electric-spacing";
      version = "5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/electric-spacing-5.0.tar";
        sha256 = "1gr35nri25ycxr0wwkypky8zv43nnfrilx4jaj66mb9jsyix6smi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/electric-spacing.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  elisa = callPackage (
    {
      async,
      ellama,
      elpaBuild,
      fetchurl,
      lib,
      llm,
      plz,
    }:
    elpaBuild {
      pname = "elisa";
      ename = "elisa";
      version = "1.1.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/elisa-1.1.7.tar";
        sha256 = "042bdbaxz521xs4ra89mn408vaqax0f0dn6xl6823f4vv1spq6k7";
      };
      packageRequires = [
        async
        ellama
        llm
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/elisa.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  elisp-benchmarks = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "elisp-benchmarks";
      ename = "elisp-benchmarks";
      version = "1.16";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/elisp-benchmarks-1.16.tar";
        sha256 = "0v5db89z6hirvixgjwyz3a9dkx6xf486hy51sprvslki706m08p2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/elisp-benchmarks.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ellama = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      llm,
      plz,
      transient,
    }:
    elpaBuild {
      pname = "ellama";
      ename = "ellama";
      version = "1.8.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ellama-1.8.6.tar";
        sha256 = "03ckmz16r1xinb7h7gcf5h030b4axv44l9wanw9d6qwydgy6hl6r";
      };
      packageRequires = [
        compat
        llm
        plz
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ellama.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  emacs-gc-stats = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "emacs-gc-stats";
      ename = "emacs-gc-stats";
      version = "1.4.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/emacs-gc-stats-1.4.2.tar";
        sha256 = "055ma32r92ksjnqy8xbzv0a79r7aap12h61dj860781fapfnifa3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/emacs-gc-stats.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  embark = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "embark";
      ename = "embark";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/embark-1.1.tar";
        sha256 = "074ggh7dkr5jdkwcndl6znhkq48jmc62rp7mc6vjidr6yxf8d1rn";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/embark.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  embark-consult = callPackage (
    {
      compat,
      consult,
      elpaBuild,
      embark,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "embark-consult";
      ename = "embark-consult";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/embark-consult-1.1.tar";
        sha256 = "06yh6w4zgvvkfllmcr0szsgjrfhh9rpjwgmcrf6h2gai2ps9xdqr";
      };
      packageRequires = [
        compat
        consult
        embark
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/embark-consult.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ement = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      map,
      persist,
      plz,
      svg-lib,
      taxy,
      taxy-magit-section,
      transient,
    }:
    elpaBuild {
      pname = "ement";
      ename = "ement";
      version = "0.16";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ement-0.16.tar";
        sha256 = "1c496sm9lad5m18pjfwnqf6l1kjrnyayip8flj1ijm13996c3mp3";
      };
      packageRequires = [
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
    }
  ) { };
  emms = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
      seq,
    }:
    elpaBuild {
      pname = "emms";
      ename = "emms";
      version = "23";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/emms-23.tar";
        sha256 = "08s04cqk9p0srcxffvpdf67fajv130sfyah6yd13mj7am9r1ak9d";
      };
      packageRequires = [
        cl-lib
        nadvice
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/emms.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  engrave-faces = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "engrave-faces";
      ename = "engrave-faces";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/engrave-faces-0.3.1.tar";
        sha256 = "0nl5wx61192dqd0191dvaszgjc7b2adrxsyc75f529fcyrfwgqfa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/engrave-faces.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  enwc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "enwc";
      ename = "enwc";
      version = "2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/enwc-2.0.tar";
        sha256 = "0y8154ykrashgg0bina5ambdrxw2qpimycvjldrk9d67hrccfh3m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/enwc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  epoch-view = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "epoch-view";
      ename = "epoch-view";
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/epoch-view-0.0.1.el";
        sha256 = "1wy25ryyg9f4v83qjym2pwip6g9mszhqkf5a080z0yl47p71avfx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/epoch-view.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  erc = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "erc";
      ename = "erc";
      version = "5.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/erc-5.6.tar";
        sha256 = "16qyfsa2q297xcfjiacjms9v14kjwwrsp3m8kcs5s50aavzfvc1s";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/erc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ergoemacs-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      undo-tree,
    }:
    elpaBuild {
      pname = "ergoemacs-mode";
      ename = "ergoemacs-mode";
      version = "5.16.10.12";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ergoemacs-mode-5.16.10.12.tar";
        sha256 = "0s4lwb76c67npbcnvbxdawnj02zkc85sbm392lym1qccjmj9d02f";
      };
      packageRequires = [
        cl-lib
        undo-tree
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ergoemacs-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ess = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ess";
      ename = "ess";
      version = "25.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ess-25.1.0.tar";
        sha256 = "0j2153mfmw53n16xl12kn71hyd3fxi6f6521rzh3114yclkpa38k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ess.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  excorporate = callPackage (
    {
      elpaBuild,
      fetchurl,
      fsm,
      lib,
      soap-client,
      url-http-ntlm,
      url-http-oauth,
    }:
    elpaBuild {
      pname = "excorporate";
      ename = "excorporate";
      version = "1.1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/excorporate-1.1.3.tar";
        sha256 = "09szsql8qyca6hn7fib832fzi9fmcsf9wiacgqdw32lfjqv5fjwk";
      };
      packageRequires = [
        fsm
        soap-client
        url-http-ntlm
        url-http-oauth
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/excorporate.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  expand-region = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "expand-region";
      ename = "expand-region";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/expand-region-1.0.0.tar";
        sha256 = "1rjx7w4gss8sbsjaljraa6cjpb57kdpx9zxmr30kbifb5lp511rd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/expand-region.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  expreg = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "expreg";
      ename = "expreg";
      version = "1.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/expreg-1.4.1.tar";
        sha256 = "1m30d8yp46al7g1hakq95icmgjz0crcvj1h1yd6bj887v1nrnvkk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/expreg.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  external-completion = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "external-completion";
      ename = "external-completion";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/external-completion-0.1.tar";
        sha256 = "1bw2kvz7zf1s60d37j31krakryc1kpyial2idjy6ac6w7n1h0jzc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/external-completion.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  exwm = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      xelb,
    }:
    elpaBuild {
      pname = "exwm";
      ename = "exwm";
      version = "0.34";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/exwm-0.34.tar";
        sha256 = "1hp2ni9c6bn627275x37n6zhcismvni6vqp7cpdn3cx292n7sx6z";
      };
      packageRequires = [
        compat
        xelb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/exwm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  f90-interface-browser = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "f90-interface-browser";
      ename = "f90-interface-browser";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/f90-interface-browser-1.1.el";
        sha256 = "0mf32w2bgc6b43k0r4a11bywprj7y3rvl21i0ry74v425r6hc3is";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/f90-interface-browser.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  filechooser = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "filechooser";
      ename = "filechooser";
      version = "0.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/filechooser-0.2.4.tar";
        sha256 = "0bw1yvypm2vk6bh81h88505fd1538rrga9y40gmy7w144spfi6sb";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/filechooser.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  filladapt = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "filladapt";
      ename = "filladapt";
      version = "2.12.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/filladapt-2.12.2.tar";
        sha256 = "0nmgw6v2krxn5palddqj1jzqxrajhpyq9v2x9lw12cdcldm9ab4k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/filladapt.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  firefox-javascript-repl = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "firefox-javascript-repl";
      ename = "firefox-javascript-repl";
      version = "0.9.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/firefox-javascript-repl-0.9.5.tar";
        sha256 = "07qmp6hfzgljrl9gkwy673xk67b3bgxq4kkw2kzr8ma4a7lx7a8l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/firefox-javascript-repl.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flylisp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flylisp";
      ename = "flylisp";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/flylisp-0.2.tar";
        sha256 = "1agny4hc75xc8a9f339bynsazmxw8ccvyb03qx1d6nvwh9d7v1b9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/flylisp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake = callPackage (
    {
      eldoc,
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "flymake";
      ename = "flymake";
      version = "1.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/flymake-1.4.1.tar";
        sha256 = "0l20gxzlvpl0d3wvvsam3mda5hdlag4anplx3fd4xksbvfhndzlk";
      };
      packageRequires = [
        eldoc
        project
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/flymake.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-clippy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-clippy";
      ename = "flymake-clippy";
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/flymake-clippy-1.1.0.tar";
        sha256 = "1sij8qn7q9jvjnnnqqm152hnvkw079m66pwjyhvsqdqivqjvlnrd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/flymake-clippy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-codespell = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-codespell";
      ename = "flymake-codespell";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/flymake-codespell-0.1.tar";
        sha256 = "1x1bmdjmdaciknd702z54002bi1a5n51vvn9g7j6rnzjc1dxw97f";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/flymake-codespell.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-proselint = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-proselint";
      ename = "flymake-proselint";
      version = "0.3.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/flymake-proselint-0.3.0.tar";
        sha256 = "0bq7nc1qiqwxi848xy7wg1ig8k38nmq1w13xws10scjvndlbcjpl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/flymake-proselint.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  fontaine = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "fontaine";
      ename = "fontaine";
      version = "3.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/fontaine-3.0.1.tar";
        sha256 = "0bgfg6pkw724id1d3igiw4g0204wnjwsbnabfy2rq6nrf99z1qwr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/fontaine.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  frame-tabs = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "frame-tabs";
      ename = "frame-tabs";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/frame-tabs-1.1.tar";
        sha256 = "1a7hklir19inai68azgyfiw1bzq5z57kkp33lj6qbxxvfcqvw62w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/frame-tabs.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  frog-menu = callPackage (
    {
      avy,
      elpaBuild,
      fetchurl,
      lib,
      posframe,
    }:
    elpaBuild {
      pname = "frog-menu";
      ename = "frog-menu";
      version = "0.2.11";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/frog-menu-0.2.11.tar";
        sha256 = "1iwyg9z8i03p9kkz6vhv00bzsqrsgl4xqqh08icial29c80q939l";
      };
      packageRequires = [
        avy
        posframe
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/frog-menu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  fsm = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "fsm";
      ename = "fsm";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/fsm-0.2.1.tar";
        sha256 = "0kvm16077bn6bpbyw3k5935fhiq86ry2j1zcx9sj7dvb9w737qz4";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/fsm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ftable = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ftable";
      ename = "ftable";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ftable-1.1.tar";
        sha256 = "052vqw8892wv8lh5slm90gcvfk7ws5sgl1mzbdi4d3sy4kc4q48h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ftable.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gcmh = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gcmh";
      ename = "gcmh";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gcmh-0.2.1.tar";
        sha256 = "030w493ilmc7w13jizwqsc33a424qjgicy1yxvlmy08yipnw3587";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gcmh.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ggtags = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ggtags";
      ename = "ggtags";
      version = "0.9.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ggtags-0.9.0.tar";
        sha256 = "02gj8ghkk35clyscbvp1p1nlhmgm5h9g2cy4mavnfmx7jikmr4m3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ggtags.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gited = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gited";
      ename = "gited";
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gited-0.6.0.tar";
        sha256 = "1s2h6y1adh28pvm3h5bivfja2nqnzm8w9sfza894pxf96kwk3pg2";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gited.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gle-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  gnat-compiler = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      wisi,
    }:
    elpaBuild {
      pname = "gnat-compiler";
      ename = "gnat-compiler";
      version = "1.0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnat-compiler-1.0.3.tar";
        sha256 = "1chydgswab2m81m3kbd31b1akyw4v1c9468wlfxpg2yydy8fc7vs";
      };
      packageRequires = [ wisi ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnat-compiler.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnome-c-style = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnome-c-style";
      ename = "gnome-c-style";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnome-c-style-0.1.tar";
        sha256 = "09w68jbpzyyhcaqw335qpr840j7xx0j81zxxkxq4ahqv6ck27v4x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnome-c-style.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnome-dark-style = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnome-dark-style";
      ename = "gnome-dark-style";
      version = "0.2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnome-dark-style-0.2.3.tar";
        sha256 = "04cp31252svf5pkkkmx9b6nlcv3v4xffn739bna77jjyrw98mhv5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnome-dark-style.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnorb = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  gnu-elpa = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnu-elpa";
      ename = "gnu-elpa";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnu-elpa-1.1.tar";
        sha256 = "01cw1r5y86q1aardpvcwvwq161invrzxd0kv4qqi5agaff2nbp26";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnu-elpa.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnu-elpa-keyring-update = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnu-elpa-keyring-update";
      ename = "gnu-elpa-keyring-update";
      version = "2025.10.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update-2025.10.1.tar";
        sha256 = "0p3125llm6hiasxx1rxl5anwfa317w2m8ybj9zl8133m5sjzzvsf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnu-elpa-keyring-update.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnugo = callPackage (
    {
      ascii-art-to-unicode,
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      xpm,
    }:
    elpaBuild {
      pname = "gnugo";
      ename = "gnugo";
      version = "3.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnugo-3.1.2.tar";
        sha256 = "0wingn5v4wa1xgsgmqqls28cifnff8mvm098kn8clw42mxr40257";
      };
      packageRequires = [
        ascii-art-to-unicode
        cl-lib
        xpm
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnugo.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnus-mock = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnus-mock";
      ename = "gnus-mock";
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gnus-mock-0.5.tar";
        sha256 = "1yl624wzs4kw45zpnxh04dxn1kkpb6c2jl3i0sm1bijyhm303l4h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gnus-mock.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gpastel = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gpastel";
      ename = "gpastel";
      version = "0.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gpastel-0.5.0.tar";
        sha256 = "12y1ysgnqjvsdp5gal90mp2wplif7rq1cj61393l6gf3pgv6jkzc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gpastel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gpr-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      gnat-compiler,
      lib,
      wisi,
    }:
    elpaBuild {
      pname = "gpr-mode";
      ename = "gpr-mode";
      version = "1.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gpr-mode-1.0.5.tar";
        sha256 = "1qdk2pkdxggfhj8gm39jb2b29g0gbw50vgil6rv3z0q7nlhpm2fp";
      };
      packageRequires = [
        gnat-compiler
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gpr-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gpr-query = callPackage (
    {
      elpaBuild,
      fetchurl,
      gnat-compiler,
      lib,
      wisi,
    }:
    elpaBuild {
      pname = "gpr-query";
      ename = "gpr-query";
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gpr-query-1.0.4.tar";
        sha256 = "1y283x549w544x37lmh25n19agyah2iz0b052hx8br4rnjdd9ii3";
      };
      packageRequires = [
        gnat-compiler
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gpr-query.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  graphql = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "graphql";
      ename = "graphql";
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/graphql-0.1.2.tar";
        sha256 = "1blpsj6sav3z9gj733cccdhpdnyvnvxp48z1hnjh0f0fl5avvkix";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/graphql.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  greader = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "greader";
      ename = "greader";
      version = "0.12.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/greader-0.12.7.tar";
        sha256 = "05i6fmfs9lvffhm54lkw97x7vxlw7x30ka6xrpxh827qml3m7z3q";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/greader.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  greenbar = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "greenbar";
      ename = "greenbar";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/greenbar-1.2.tar";
        sha256 = "0w85b3gnckdiv32ki4kkwhgxc1m9ks7hayk87iapbzayqzvlqj3v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/greenbar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gtags-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gtags-mode";
      ename = "gtags-mode";
      version = "1.9.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/gtags-mode-1.9.3.tar";
        sha256 = "1cvmb6pnn4wpqna2h0a19m5yilh1jrzah61xzspwrdv2djf8zrlb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/gtags-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  guess-language = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "guess-language";
      ename = "guess-language";
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/guess-language-0.0.1.el";
        sha256 = "11a6m2337j4ncppaf59yr2vavvvsph2qh51d12zmq58g9wh3d7wz";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/guess-language.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hcel = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hcel";
      ename = "hcel";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hcel-1.0.0.tar";
        sha256 = "1pm3d0nz2mpf667jkjlmlidh203i4d4gk0n8xd3r66bzwc4l042b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hcel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  heap = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "heap";
      ename = "heap";
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/heap-0.5.tar";
        sha256 = "1q42v9mzmlhl4pr3wr94nsis7a9977f35w0qsyx2r982kwgmbndw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/heap.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hiddenquote = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hiddenquote";
      ename = "hiddenquote";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hiddenquote-1.2.tar";
        sha256 = "051aqiq77n487lnsxxwa8q0vyzk6m2fwi3l7xwvrl49p5xpia6zr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hiddenquote.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  highlight-escape-sequences = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "highlight-escape-sequences";
      ename = "highlight-escape-sequences";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/highlight-escape-sequences-0.4.tar";
        sha256 = "1gs662vvvzrqdlb1z73jf6wykjzs1jskcdksk8akqmply4sjvbpr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/highlight-escape-sequences.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hook-helpers = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hook-helpers";
      ename = "hook-helpers";
      version = "1.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hook-helpers-1.1.1.tar";
        sha256 = "05nqlshdqh32smav58hzqg8wp04h7w9sxr239qrz4wqxwlxlv9im";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hook-helpers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  html5-schema = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "html5-schema";
      ename = "html5-schema";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/html5-schema-0.1.tar";
        sha256 = "018zvdjhdrkcy8yrsqqqikhl6drmqm1fs0y50m8q8vx42p0cyi1p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/html5-schema.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hugoista = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "hugoista";
      ename = "hugoista";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hugoista-0.2.1.tar";
        sha256 = "02rv1r2xr6dhkfqwgbrrsdajxv6inbny5biimkb0qcf3i8b43dih";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hugoista.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hydra = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      lv,
    }:
    elpaBuild {
      pname = "hydra";
      ename = "hydra";
      version = "0.15.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hydra-0.15.0.tar";
        sha256 = "082wdr2nsfz8jhh7ic4nq4labz0pq8lcdwnxdmw79ppm20p2jipk";
      };
      packageRequires = [
        cl-lib
        lv
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hydra.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hyperbole = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hyperbole";
      ename = "hyperbole";
      version = "9.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/hyperbole-9.0.1.tar";
        sha256 = "0gjscqa0zagbymm6wfilvc8g68f8myv90ryd8kqfcpy81fh4dhiz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/hyperbole.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  idlwave = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "idlwave";
      ename = "idlwave";
      version = "6.5.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/idlwave-6.5.1.tar";
        sha256 = "0dd0dm92qyin8k4kgavrg82zwjhv6wsjq6gk55rzcspx0s8y2c24";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/idlwave.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ilist = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ilist";
      ename = "ilist";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ilist-0.4.tar";
        sha256 = "1hsja208yaszviv8p3mzi04j0jz8ij02nbl1y6shk3b965sflhyp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ilist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  indent-bars = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "indent-bars";
      ename = "indent-bars";
      version = "0.9.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/indent-bars-0.9.2.tar";
        sha256 = "030haxxla7m6p2zks9g50dj8rr8grm67n2ig7zd3k20h1yrfm6q0";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/indent-bars.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  inspector = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "inspector";
      ename = "inspector";
      version = "0.38";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/inspector-0.38.tar";
        sha256 = "1b0hb8cd85p41kzalkkg698qx515gzrr85d6j7wn2b8h3rrpp3g4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/inspector.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ioccur = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ioccur";
      ename = "ioccur";
      version = "2.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ioccur-2.6.tar";
        sha256 = "0xyx5xd46n5x078k7pv022h84xmxv7fkh31ddib872bmnirhk6ln";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ioccur.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  isearch-mb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "isearch-mb";
      ename = "isearch-mb";
      version = "0.8";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/isearch-mb-0.8.tar";
        sha256 = "1b4929vr5gib406p51zcvq1ysmzvnz6bs1lqwjp517kzp6r4gc5y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/isearch-mb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  iso-date = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "iso-date";
      ename = "iso-date";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/iso-date-1.2.0.tar";
        sha256 = "132v583glz0faxyizysbsg7bm3hhhwav2769xqq3x86y0k5399c5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/iso-date.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  iterators = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "iterators";
      ename = "iterators";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/iterators-0.1.1.tar";
        sha256 = "1xcqvj9dail1irvj2nbfx9x106mcav104pp89jz2diamrky6ja49";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/iterators.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ivy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ivy";
      ename = "ivy";
      version = "0.15.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ivy-0.15.1.tar";
        sha256 = "12ni3n8h7316hv4nrx4kbjah58n8zdxkf1v8fi0w39da1aqn3r0p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ivy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ivy-avy = callPackage (
    {
      avy,
      elpaBuild,
      fetchurl,
      ivy,
      lib,
    }:
    elpaBuild {
      pname = "ivy-avy";
      ename = "ivy-avy";
      version = "0.15.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ivy-avy-0.15.1.tar";
        sha256 = "0csysx22sf3bbfh000c2m48rzfn274km0zxbfbcx2871haskwva1";
      };
      packageRequires = [
        avy
        ivy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ivy-avy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ivy-explorer = callPackage (
    {
      elpaBuild,
      fetchurl,
      ivy,
      lib,
    }:
    elpaBuild {
      pname = "ivy-explorer";
      ename = "ivy-explorer";
      version = "0.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ivy-explorer-0.3.2.tar";
        sha256 = "0wv7gp2kznc6f6g9ky1gvq72i78ihp582kyks82h13w25rvh6f0a";
      };
      packageRequires = [ ivy ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ivy-explorer.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ivy-hydra = callPackage (
    {
      elpaBuild,
      fetchurl,
      hydra,
      ivy,
      lib,
    }:
    elpaBuild {
      pname = "ivy-hydra";
      ename = "ivy-hydra";
      version = "0.15.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ivy-hydra-0.15.1.tar";
        sha256 = "16z3ic50zbx9iaw0w6fv04cxpl6qz81424jdian1br1942pz3kdy";
      };
      packageRequires = [
        hydra
        ivy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ivy-hydra.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ivy-posframe = callPackage (
    {
      elpaBuild,
      fetchurl,
      ivy,
      lib,
      posframe,
    }:
    elpaBuild {
      pname = "ivy-posframe";
      ename = "ivy-posframe";
      version = "0.6.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ivy-posframe-0.6.3.tar";
        sha256 = "027lbddg4rc44jpvxsqyw9n9pi1bnsssfislg2il3hbr86v88va9";
      };
      packageRequires = [
        ivy
        posframe
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ivy-posframe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jami-bot = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jami-bot";
      ename = "jami-bot";
      version = "0.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jami-bot-0.0.4.tar";
        sha256 = "1dp4k5y7qy793m3fyxvkk57bfy42kac2w5wvy7zqzd4lckm0a93z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jami-bot.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jarchive = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jarchive";
      ename = "jarchive";
      version = "0.11.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jarchive-0.11.0.tar";
        sha256 = "17klpdrv74hgpwnhknbihg90j6sbikf4j62lq0vbfv3s7r0a0gb8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jarchive.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  javaimp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "javaimp";
      ename = "javaimp";
      version = "0.9.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/javaimp-0.9.1.tar";
        sha256 = "1gy7qys9mzpgbqm5798fncmblmi32b350q51ccsyydq67yh69s3z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/javaimp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jgraph-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  jinx = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jinx";
      ename = "jinx";
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jinx-2.3.tar";
        sha256 = "0sm6yrh70qy6w7v1ljr02rfj10kyixnghk1aigizc4rgpr4b8azp";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jinx.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jit-spell = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jit-spell";
      ename = "jit-spell";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jit-spell-0.4.tar";
        sha256 = "0p9nf2n0x6c6xl32aczghzipx8n5aq7a1x6r2s78xvpwr299k998";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jit-spell.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  js2-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "js2-mode";
      ename = "js2-mode";
      version = "20231224";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/js2-mode-20231224.tar";
        sha256 = "023z76zxh5q6g26x7qlgf9476lj95sj84d5s3aqhy6xyskkyyg6c";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/js2-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  json-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "json-mode";
      ename = "json-mode";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/json-mode-0.2.tar";
        sha256 = "1ix8nq9rjfgbq8vzzjp179j2wa11il0ys8fjjy9gnlqwk6lnk86h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/json-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jsonrpc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jsonrpc";
      ename = "jsonrpc";
      version = "1.0.25";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jsonrpc-1.0.25.tar";
        sha256 = "18f0g8j1rd2fpa707w6fll6ryj7mg6hbcy2pc3xff2a4ps8zv12b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jsonrpc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jumpc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jumpc";
      ename = "jumpc";
      version = "3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/jumpc-3.1.tar";
        sha256 = "1c6wzwrr1ydpn5ah5xnk159xcn4v1gv5rjm4iyfj83dss2ygirzp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/jumpc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  kind-icon = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      svg-lib,
    }:
    elpaBuild {
      pname = "kind-icon";
      ename = "kind-icon";
      version = "0.2.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/kind-icon-0.2.2.tar";
        sha256 = "1zafx7rvfyahb7zzl2n9gpb2lc8x3k0bkcap2fl0n54aw4j98i69";
      };
      packageRequires = [ svg-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/kind-icon.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  kiwix = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      request,
    }:
    elpaBuild {
      pname = "kiwix";
      ename = "kiwix";
      version = "1.1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/kiwix-1.1.5.tar";
        sha256 = "1krmlyfjs8b7ibixbmv41vhg1gm7prck6lpp61v17fgig92a9k2s";
      };
      packageRequires = [ request ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/kiwix.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  kmb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "kmb";
      ename = "kmb";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/kmb-0.1.tar";
        sha256 = "12klfmdjjlyjvrzz3rx8dmamnag1fwljhs05jqwd0dv4a2q11gg5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/kmb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  kubed = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "kubed";
      ename = "kubed";
      version = "0.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/kubed-0.5.0.tar";
        sha256 = "00j0yx7bknjdl6mcfimlwp7plxgn7al3fl4rfxw7s4pgqgyyslsw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/kubed.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  landmark = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "landmark";
      ename = "landmark";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/landmark-1.0.tar";
        sha256 = "1nnmnvyfjmkk5ddw4q24py1bqzykr29klip61n16bqpr39v56gpg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/landmark.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  latex-table-wizard = callPackage (
    {
      auctex,
      elpaBuild,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "latex-table-wizard";
      ename = "latex-table-wizard";
      version = "1.5.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/latex-table-wizard-1.5.4.tar";
        sha256 = "1999kh5yi0cg1k0al3np3zi2qhrmcpzxqsfvwg0mgrg3mww4gqlw";
      };
      packageRequires = [
        auctex
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/latex-table-wizard.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  leaf = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "leaf";
      ename = "leaf";
      version = "4.5.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/leaf-4.5.5.tar";
        sha256 = "1nvpl9ffma0ybbr7vlpcj7q33ja17zrswvl91bqljlmb4lb5121m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/leaf.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lentic = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
      m-buffer,
    }:
    elpaBuild {
      pname = "lentic";
      ename = "lentic";
      version = "0.12";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lentic-0.12.tar";
        sha256 = "0pszjhgy9dlk3h5gc8wnlklgl30ha3ig9bpmw2j1ps713vklfms7";
      };
      packageRequires = [
        dash
        m-buffer
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lentic.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lentic-server = callPackage (
    {
      elpaBuild,
      fetchurl,
      lentic,
      lib,
      web-server,
    }:
    elpaBuild {
      pname = "lentic-server";
      ename = "lentic-server";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lentic-server-0.2.tar";
        sha256 = "1r0jcfylvhlihwm6pm4f8pzvsmnlspfkph1hgi5qjkv311045244";
      };
      packageRequires = [
        lentic
        web-server
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lentic-server.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  let-alist = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "let-alist";
      ename = "let-alist";
      version = "1.0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/let-alist-1.0.6.tar";
        sha256 = "1fk1yl2cg4gxcn02n2gki289dgi3lv56n0akkm2h7dhhbgfr6gqm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/let-alist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lex = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lex";
      ename = "lex";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lex-1.2.tar";
        sha256 = "1pqjrlw558l4z4k40jmli8lmcqlzddhkr0mfm38rbycp7ghdr4zx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lex.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lin = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lin";
      ename = "lin";
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lin-1.1.0.tar";
        sha256 = "1rf81r8ylq2cccx4svdkiy2rvz1rq6cw0dakrcd4jrrscww52d7c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lin.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  listen = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      persist,
      taxy,
      taxy-magit-section,
      transient,
    }:
    elpaBuild {
      pname = "listen";
      ename = "listen";
      version = "0.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/listen-0.9.tar";
        sha256 = "1g1sv8fs8vl93fah7liaqzgwvc4b1chasx5151ayizz4q2qgwwbp";
      };
      packageRequires = [
        persist
        taxy
        taxy-magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/listen.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  literate-scratch = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "literate-scratch";
      ename = "literate-scratch";
      version = "2.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/literate-scratch-2.2.tar";
        sha256 = "01n27aps7dkydqda89xblmhc82g8y6dkmbhxgfav13vw2ns2r7sc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/literate-scratch.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  llm = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      plz,
      plz-event-source,
      plz-media-type,
    }:
    elpaBuild {
      pname = "llm";
      ename = "llm";
      version = "0.27.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/llm-0.27.2.tar";
        sha256 = "0wkz4l2ica2wrmb30yylqdbdp1q2xflarcdl0z399lh315jdbypg";
      };
      packageRequires = [
        compat
        plz
        plz-event-source
        plz-media-type
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/llm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lmc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lmc";
      ename = "lmc";
      version = "1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lmc-1.4.tar";
        sha256 = "0c8sd741a7imn1im4j17m99bs6zmppndsxpn23k33lmcqj1rfhsk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lmc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  load-dir = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "load-dir";
      ename = "load-dir";
      version = "0.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/load-dir-0.0.5.tar";
        sha256 = "1yxnckd7s4alkaddfs672g0jnsxir7c70crnm6rsc5vhmw6310nx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/load-dir.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  load-relative = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "load-relative";
      ename = "load-relative";
      version = "1.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/load-relative-1.3.2.tar";
        sha256 = "04ppqfzlqz7156aqm56yccizv0n71qir7yyp7xfiqq6vgj322rqv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/load-relative.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  loc-changes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "loc-changes";
      ename = "loc-changes";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/loc-changes-1.2.el";
        sha256 = "1x8fn8vqasayf1rb8a6nma9n6nbvkx60krmiahyb05vl5rrsw6r3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/loc-changes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  loccur = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "loccur";
      ename = "loccur";
      version = "1.2.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/loccur-1.2.5.tar";
        sha256 = "0dp7nhafx5x0aw4svd826bqsrn6qk46w12p04w7khpk7d9768a8x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/loccur.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  logos = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "logos";
      ename = "logos";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/logos-1.2.0.tar";
        sha256 = "0a609jfgfwq71ksxw4h2q25qbix75yrf7vm0dfpyzjvgcmqiviab";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/logos.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  luwak = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "luwak";
      ename = "luwak";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/luwak-1.0.0.tar";
        sha256 = "0z6h1cg7nshv87zl4fia6l5gwf9ax6f4wgxijf2smi8cpwmv6j79";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/luwak.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lv = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lv";
      ename = "lv";
      version = "0.15.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/lv-0.15.0.tar";
        sha256 = "1wb8whyj8zpsd7nm7r0yjvkfkr2ml80di7alcafpadzli808j2l4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/lv.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  m-buffer = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "m-buffer";
      ename = "m-buffer";
      version = "0.16.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/m-buffer-0.16.1.tar";
        sha256 = "1iq7nld1i8v0da1ajhvfdarx4bx3wnwgz5lhb78fcnsq8zb6cp5y";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/m-buffer.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  map = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "map";
      ename = "map";
      version = "3.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/map-3.3.1.tar";
        sha256 = "1za8wjdvyxsxvmzla823f7z0s4wbl22l8k08v8b4h4m6i7w356lp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/map.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  marginalia = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "marginalia";
      ename = "marginalia";
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/marginalia-2.3.tar";
        sha256 = "0k2ndssravhd94b63fyiv2h7rvny2fik988w1dnpdy6q9vj2vdgw";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/marginalia.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  markchars = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "markchars";
      ename = "markchars";
      version = "0.2.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/markchars-0.2.2.tar";
        sha256 = "0jagp5s2kk8ijwxbg5ccq31bjlcxkqpqhsg7a1hbyp3p5z3j73m0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/markchars.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  math-symbol-lists = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "math-symbol-lists";
      ename = "math-symbol-lists";
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/math-symbol-lists-1.3.tar";
        sha256 = "1r2acaf79kwwvndqn9xbvq9dc12vr3lryc25yp0w0gksp86p8cfa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/math-symbol-lists.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mathjax = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mathjax";
      ename = "mathjax";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mathjax-0.1.tar";
        sha256 = "16023kbzkc2v455bx7l4pfy3j7z1iba7rpv0ykzk2rz21i4jan7w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mathjax.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mathsheet = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      peg,
    }:
    elpaBuild {
      pname = "mathsheet";
      ename = "mathsheet";
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mathsheet-1.3.tar";
        sha256 = "1gyn47fzpa866i5xmdj6yq934xr9dsaq8za2r5z7hda660rh4wqi";
      };
      packageRequires = [ peg ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mathsheet.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  matlab-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "matlab-mode";
      ename = "matlab-mode";
      version = "7.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/matlab-mode-7.1.1.tar";
        sha256 = "0axqvarxnvn02pcqmqf9sf6kg0xfz5a8wfzjw8if6xsbk45krlcz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/matlab-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mct = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mct";
      ename = "mct";
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mct-1.1.0.tar";
        sha256 = "0kv0j37bdsmc2jv7adpx5m48cp4h0kvjq2jfwv7d8nzpk5kk2d2p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mct.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  memory-usage = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "memory-usage";
      ename = "memory-usage";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/memory-usage-0.2.tar";
        sha256 = "04bylvy86x8w96g7zil3jzyac0fijvb5lz4830ja5yabpvsnk3vq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/memory-usage.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  metar = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  midi-kbd = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "midi-kbd";
      ename = "midi-kbd";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/midi-kbd-0.2.tar";
        sha256 = "0jd92rainjd1nx72z7mrvsxs3az6axxiw1v9sbpsj03x8qq0129q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/midi-kbd.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mines = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mines";
      ename = "mines";
      version = "1.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mines-1.6.tar";
        sha256 = "0j52n43mv963hpgdh5kk1k9wi821r6w3diwdp47rfwsijdd0wnhs";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mines.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  minibuffer-header = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "minibuffer-header";
      ename = "minibuffer-header";
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/minibuffer-header-0.5.tar";
        sha256 = "1qic33wsdba5xw3qxigq18nibwhj45ggk0ragy4zj9cfy1l2ni44";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/minibuffer-header.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  minibuffer-line = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "minibuffer-line";
      ename = "minibuffer-line";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/minibuffer-line-0.1.tar";
        sha256 = "0sg9vhv7bi82a90ziiwsabnfvw8zp544v0l93hbl42cj432bpwfx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/minibuffer-line.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  minimap = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "minimap";
      ename = "minimap";
      version = "1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/minimap-1.4.tar";
        sha256 = "0n27wp65x5n21qy6x5dhzms8inf0248kzninp56kfx1bbf9w4x66";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/minimap.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  minuet = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
      plz,
    }:
    elpaBuild {
      pname = "minuet";
      ename = "minuet";
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/minuet-0.6.0.tar";
        sha256 = "1vpq6jsmw93hssla13dkf2ff13sv11fbjaq7wmrybnc4vnyfkycz";
      };
      packageRequires = [
        dash
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/minuet.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mmm-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mmm-mode";
      ename = "mmm-mode";
      version = "0.5.11";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mmm-mode-0.5.11.tar";
        sha256 = "0dh76lk0am07j2zi7hhbmr6cnnss7l0b9rhi9is0w0n5i7j4i0p2";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mmm-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  modus-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "modus-themes";
      ename = "modus-themes";
      version = "4.8.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/modus-themes-4.8.1.tar";
        sha256 = "1xax6pfq8xlybwid3sgzm82az4p1blm217qp1bvy0fjf5qcand5i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/modus-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mpdired = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mpdired";
      ename = "mpdired";
      version = "3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/mpdired-3.tar";
        sha256 = "19qkg7cjh037l4cw3q0b52hpp3fwmly6alc7z683baiz5fklcjc8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/mpdired.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  multi-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "multi-mode";
      ename = "multi-mode";
      version = "1.14";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/multi-mode-1.14.tar";
        sha256 = "0i2l50lcsj3mm9k38kfmh2hnb437pjbk2yxv26p6na1g1n44lkil";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/multi-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  multishell = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  muse = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "muse";
      ename = "muse";
      version = "3.20.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/muse-3.20.2.tar";
        sha256 = "0g2ff6x45x2k5dnkp31sk3bjj92jyhhnar7l5hzn8vp22l0rv8wn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/muse.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  myers = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "myers";
      ename = "myers";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/myers-0.1.tar";
        sha256 = "0a053w7nj0qfryvsh1ss854wxwbk5mhkl8a5nprcfgsh4qh2m487";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/myers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nadvice = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nadvice";
      ename = "nadvice";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nadvice-0.4.tar";
        sha256 = "19dx07v4z2lyyp18v45c5hgp65akw58bdqg5lcrzyb9mrlji8js6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nadvice.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nameless = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nameless";
      ename = "nameless";
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nameless-1.0.2.tar";
        sha256 = "0m3z701j2i13zmr4g0wjd3ms6ajr6w371n5kx95n9ssxyjwjppcm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nameless.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  names = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "names";
      ename = "names";
      version = "20151201.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/names-20151201.0.tar";
        sha256 = "0nf6n8hk58a7r56d899s5dsva3jjvh3qx9g2d1hra403fwlds74k";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/names.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nano-agenda = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nano-agenda";
      ename = "nano-agenda";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nano-agenda-0.3.tar";
        sha256 = "12sh6wqqd13sv966wj4k4djidn238fdb6l4wg3z9ib0dx36nygcr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nano-agenda.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nano-modeline = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nano-modeline";
      ename = "nano-modeline";
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nano-modeline-1.1.0.tar";
        sha256 = "1x4b4j82vzbi1mhbs9bwgw41hcagnfk56kswjk928i179pnkr0cx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nano-modeline.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nano-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nano-theme";
      ename = "nano-theme";
      version = "0.3.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nano-theme-0.3.4.tar";
        sha256 = "0x49lk0kx8mz72a81li6gwg3kivn7bn4ld0mml28smzqqfr3873a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nano-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nftables-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nftables-mode";
      ename = "nftables-mode";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nftables-mode-1.1.tar";
        sha256 = "1wjw6n60kj84j8gj62mr6s97xd0aqvr4v7npyxwmhckw9z13xcqv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nftables-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nhexl-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nhexl-mode";
      ename = "nhexl-mode";
      version = "1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nhexl-mode-1.5.tar";
        sha256 = "1i1by5bp5dby2r2jhzr0jvnchrybgnzmc5ln84w66180shk2s3yk";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nhexl-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nlinum = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nlinum";
      ename = "nlinum";
      version = "1.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/nlinum-1.9.tar";
        sha256 = "1cpyg6cxaaaaq6hc066l759dlas5mhn1fi398myfglnwrglia3lm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/nlinum.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  notes-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "notes-mode";
      ename = "notes-mode";
      version = "1.31";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/notes-mode-1.31.tar";
        sha256 = "0lwja53cknd1w432mcbfrcshmxmk23dqrbr9k2101pqfzbw8nri2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/notes-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  notmuch-indicator = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "notmuch-indicator";
      ename = "notmuch-indicator";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/notmuch-indicator-1.2.0.tar";
        sha256 = "1n525slxs0l5nbila1sy62fz384yz7f54nrq1ixdlq0j3czgh9kz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/notmuch-indicator.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ntlm = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ntlm";
      ename = "ntlm";
      version = "2.1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ntlm-2.1.0.tar";
        sha256 = "0kivmb6b57qjrwd41zwlfdq7l9nisbh4mgd96rplrkxpzw6dq0j7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ntlm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  num3-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "num3-mode";
      ename = "num3-mode";
      version = "1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/num3-mode-1.5.tar";
        sha256 = "1a7w2qd210zp199c1js639xbv2kmqmgvcqi5dn1vsazasp2dwlj2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/num3-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  oauth2 = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "oauth2";
      ename = "oauth2";
      version = "0.18.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/oauth2-0.18.3.tar";
        sha256 = "1xn9jkf55b9sc6fidzn6p1falvvgvpc08iz53fvmmp7fandgwbxi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/oauth2.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ob-asymptote = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ob-asymptote";
      ename = "ob-asymptote";
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ob-asymptote-1.0.2.tar";
        sha256 = "0b9glzj3aq39rksb0bg4qvsnqknwjk7lbixapw9695hfr2l4hv02";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ob-asymptote.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ob-haxe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ob-haxe";
      ename = "ob-haxe";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ob-haxe-1.0.tar";
        sha256 = "095qcvxpanw6fh96dfkdydn10xikbrjwih7i05iiyvazpk4x6nbz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ob-haxe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  objed = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "objed";
      ename = "objed";
      version = "0.8.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/objed-0.8.3.tar";
        sha256 = "1shgpha6f1pql95v86whsw6w6j7v35cas98fyygwrpkcrxx9a56r";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/objed.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  omn-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "omn-mode";
      ename = "omn-mode";
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/omn-mode-1.3.tar";
        sha256 = "01yg4ifbz7jfhvq6r6naf50vx00wpjsr44mmlj580bylfrmdc839";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/omn-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  on-screen = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  orderless = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "orderless";
      ename = "orderless";
      version = "1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/orderless-1.5.tar";
        sha256 = "188mksjaazf1rxvyqrcybya4a53j6c1xwvcbfh8s1sgv0jqxlv8z";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/orderless.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org";
      ename = "org";
      version = "9.7.39";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-9.7.39.tar";
        sha256 = "1yg50h84sqd2wfpcyxkwyvrvr30cqdqdvcl6kcsja22si19yjbxw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-contacts = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-contacts";
      ename = "org-contacts";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-contacts-1.1.tar";
        sha256 = "0gqanhnrxajx5cf7g9waks23sclbmvmwjqrs0q4frcih3gs2nhix";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-contacts.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-edna = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
      seq,
    }:
    elpaBuild {
      pname = "org-edna";
      ename = "org-edna";
      version = "1.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-edna-1.1.2.tar";
        sha256 = "1pifs5mbcjab21ylclck4kjdcds1xkvym27ncn9wwr8fl3fff2yl";
      };
      packageRequires = [
        org
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-edna.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-gnosis = callPackage (
    {
      compat,
      elpaBuild,
      emacsql,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org-gnosis";
      ename = "org-gnosis";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-gnosis-0.1.1.tar";
        sha256 = "0165bv6ky7zg9km7h63qzqg7rxnjdcpks4xyv0l2sidgmzimdyg5";
      };
      packageRequires = [
        compat
        emacsql
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-gnosis.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-jami-bot = callPackage (
    {
      elpaBuild,
      fetchurl,
      jami-bot,
      lib,
    }:
    elpaBuild {
      pname = "org-jami-bot";
      ename = "org-jami-bot";
      version = "0.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-jami-bot-0.0.5.tar";
        sha256 = "1fiv0a7k6alvfvb7c6av0kbkwbw58plw05hhcf1vnkr9gda3s13y";
      };
      packageRequires = [ jami-bot ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-jami-bot.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-modern = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-modern";
      ename = "org-modern";
      version = "1.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-modern-1.9.tar";
        sha256 = "09lgmng1g6l29alnwmxqk2qq0gx2vv5nrrmrxdzlrknkd8f07nl1";
      };
      packageRequires = [
        compat
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-modern.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-notify = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org-notify";
      ename = "org-notify";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-notify-0.1.1.tar";
        sha256 = "1vg0h32x5lc3p5n71m23q8mfdd1fq9ffmy9rsm5rcdphfk8s9x5l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-notify.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-real = callPackage (
    {
      boxy,
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-real";
      ename = "org-real";
      version = "1.0.11";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-real-1.0.11.tar";
        sha256 = "1mm2p6487m4sr8zvj7xqryvicvj0qbv7as39hxh1ad7yhfdhgpvw";
      };
      packageRequires = [
        boxy
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-real.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-remark = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-remark";
      ename = "org-remark";
      version = "1.3.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-remark-1.3.0.tar";
        sha256 = "0i4srqhxl2rslzf3fy3rk231hsvwkn46yghy7x40kmc2jgnvs1gf";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-remark.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-transclusion = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-transclusion";
      ename = "org-transclusion";
      version = "1.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-transclusion-1.4.0.tar";
        sha256 = "0ci6xja3jkj1a9f76sf3780gcjrdpbds2y2bwba3b55fjmr1fscl";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-transclusion.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-translate = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-translate";
      ename = "org-translate";
      version = "0.1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/org-translate-0.1.4.tar";
        sha256 = "0s0vqpncb6rvhpxdir5ghanjyhpw7bplqfh3bpgri5ay2b46kj4f";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/org-translate.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  orgalist = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "orgalist";
      ename = "orgalist";
      version = "1.16";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/orgalist-1.16.tar";
        sha256 = "0j78g12q66piclraa2nvd1h4ri8d6cnw5jahw6k5zi4xfjag6yx3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/orgalist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  osc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "osc";
      ename = "osc";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/osc-0.4.tar";
        sha256 = "1ls6v0mkh7z90amrlczrvv6mgpv6hzzjw0zlxjlzsj2vr1gz3vca";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/osc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  osm = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "osm";
      ename = "osm";
      version = "1.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/osm-1.7.tar";
        sha256 = "1iqg0cjqq2fzrimzgxqa7jsvhzajycl4nq1c7fsr3pd5yjp8d4z8";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/osm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  other-frame-window = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "other-frame-window";
      ename = "other-frame-window";
      version = "1.0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/other-frame-window-1.0.6.tar";
        sha256 = "1x8i6hbl48vmp5h43drr35lwaiwhcyr3vnk7rcyim5jl2ijw8yc0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/other-frame-window.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pabbrev = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pabbrev";
      ename = "pabbrev";
      version = "4.3.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pabbrev-4.3.0.tar";
        sha256 = "1fplbmzqz066gsmvmf2indg4n348vdgs2m34dm32gnrjghfrxxhs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pabbrev.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  paced = callPackage (
    {
      async,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "paced";
      ename = "paced";
      version = "1.1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/paced-1.1.3.tar";
        sha256 = "0j2362zq22j6qma6bb6jh6qpd12zrc161pgl9cfhnq5m3s9i1sz4";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/paced.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  package-x = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "package-x";
      ename = "package-x";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/package-x-1.0.tar";
        sha256 = "1wzwpqy992qv4jizx6fv6r1aw46gjzk49f4vv178bmshz03vndrx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/package-x.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  parsec = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "parsec";
      ename = "parsec";
      version = "0.1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/parsec-0.1.3.tar";
        sha256 = "032m9iks5a05vbc4159dfs9b7shmqm6mk05jgbs9ndvy400drwd6";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/parsec.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  parser-generator = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "parser-generator";
      ename = "parser-generator";
      version = "0.2.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/parser-generator-0.2.5.tar";
        sha256 = "1bfvhqwv3qapqvl35v6ac1nsl1p9fwzja02vdqif3sdyr30ps340";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/parser-generator.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  path-iterator = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "path-iterator";
      ename = "path-iterator";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/path-iterator-1.0.tar";
        sha256 = "0v9gasc0wlqd7pks6k3695md7mdfnaknh6xinmp4pkvvalfh7shv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/path-iterator.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  peg = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "peg";
      ename = "peg";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/peg-1.0.1.tar";
        sha256 = "14ll56fn9n11nydydslp7xyn79122dprm89i181ks170v0qcsps3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/peg.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  perl-doc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "perl-doc";
      ename = "perl-doc";
      version = "0.82";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/perl-doc-0.82.tar";
        sha256 = "1fj13361a9pgmlda8yix0p805r2gwzv1gxf43pq6y79a8hxbm8yn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/perl-doc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  persist = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "persist";
      ename = "persist";
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/persist-0.7.tar";
        sha256 = "0g38vf4a4f4b8cp35qc7pwzj1qwrnw6dd6mc83mrjs35fx43lpjn";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/persist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  phpinspect = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "phpinspect";
      ename = "phpinspect";
      version = "3.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/phpinspect-3.0.1.tar";
        sha256 = "138ipsmhhycm50a37kcx780j995xm0l2icrn2cjiw955fjf96rv7";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/phpinspect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  phps-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "phps-mode";
      ename = "phps-mode";
      version = "0.4.51";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/phps-mode-0.4.51.tar";
        sha256 = "1qiy16gh24sh274sasshxb230r2r2bx1b7awr9php854840p7pvx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/phps-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pinentry = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pinentry";
      ename = "pinentry";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pinentry-0.1.tar";
        sha256 = "0i5g4yj2qva3rp8ay2fl9gcmp7q42caqryjyni8r5h4f3misviwq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pinentry.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  plz = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "plz";
      ename = "plz";
      version = "0.9.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/plz-0.9.1.tar";
        sha256 = "0kx8zjqczsqhxd95bdy9b0kkpgkva4zq549d2hcfrkqhrqivm6qd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/plz.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  plz-event-source = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      plz-media-type,
    }:
    elpaBuild {
      pname = "plz-event-source";
      ename = "plz-event-source";
      version = "0.1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/plz-event-source-0.1.3.tar";
        sha256 = "1ayi272pvbblynrxhh51adq34jdjp6j2wfzwry7ysq0fz8vxs7nj";
      };
      packageRequires = [ plz-media-type ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/plz-event-source.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  plz-media-type = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      plz,
    }:
    elpaBuild {
      pname = "plz-media-type";
      ename = "plz-media-type";
      version = "0.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/plz-media-type-0.2.4.tar";
        sha256 = "1gsq86zb3bsasryafhgxbln2sy1w722iz61pd6fi4j6xszb5pb32";
      };
      packageRequires = [ plz ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/plz-media-type.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  plz-see = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      plz,
    }:
    elpaBuild {
      pname = "plz-see";
      ename = "plz-see";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/plz-see-0.1.tar";
        sha256 = "1mi35d9b26d425v1kkmmbh477klcxf76fnyg154ddjm0nkgqq90d";
      };
      packageRequires = [ plz ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/plz-see.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  poke = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "poke";
      ename = "poke";
      version = "3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/poke-3.2.tar";
        sha256 = "15j4g5y427d9mja2irv3ak6x60ik4kpnscnwl9pqym7qly7sa3v9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/poke.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  poke-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "poke-mode";
      ename = "poke-mode";
      version = "3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/poke-mode-3.1.tar";
        sha256 = "0g4vd26ahkmjxlcvqwd0mbk60qaf6c9zba9x7bb9pqabka9438y1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/poke-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  poker = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "poker";
      ename = "poker";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/poker-0.2.tar";
        sha256 = "10lfc6i4f08ydxanidwiq9404h4nxfa0vh4av5rrj6snqzqvd1bw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/poker.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  popper = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "popper";
      ename = "popper";
      version = "0.4.8";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/popper-0.4.8.tar";
        sha256 = "1i667qablblr8s614j1p6zfyqkwci56fpycb8hbxap6fpirgmv9x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/popper.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  posframe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "posframe";
      ename = "posframe";
      version = "1.4.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/posframe-1.4.4.tar";
        sha256 = "18cvfr2jxwsnsdg9f8wr0g64rkk6q1cc4gchrw76lnnknanidpk7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/posframe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pq = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pq";
      ename = "pq";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pq-0.2.tar";
        sha256 = "0d8ylsbmypaj29w674a4k445zr6hnggic8rsv7wx7jml6p2zph2n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pq.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  preview-auto = callPackage (
    {
      auctex,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "preview-auto";
      ename = "preview-auto";
      version = "0.4.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/preview-auto-0.4.1.tar";
        sha256 = "0wdjka1wixhlzi1sksswa2jnialpna0gj770z0gl6faxdi310p9l";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/preview-auto.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  preview-tailor = callPackage (
    {
      auctex,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "preview-tailor";
      ename = "preview-tailor";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/preview-tailor-0.2.tar";
        sha256 = "1mqh2myz5w84f4n01ibd695h4mnqwjxmg7rvs7pz3sylz1xqyks7";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/preview-tailor.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  project = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      xref,
    }:
    elpaBuild {
      pname = "project";
      ename = "project";
      version = "0.11.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/project-0.11.1.tar";
        sha256 = "1973d6z7nx9pp5gadqk8p71v6s5wqja40a0f8zjrn6rrnfarrcd0";
      };
      packageRequires = [ xref ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/project.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  psgml = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "psgml";
      ename = "psgml";
      version = "1.3.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/psgml-1.3.5.tar";
        sha256 = "1lfk95kr43az6ykfyhj7ygccw3ms2ifyyp43w9lwm5fcawgc8952";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/psgml.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pspp-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pspp-mode";
      ename = "pspp-mode";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pspp-mode-1.1.el";
        sha256 = "1qnwj7r367qs0ykw71c6s96ximgg2wb3hxg5fwsl9q2vfhbh35ca";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pspp-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pulsar = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pulsar";
      ename = "pulsar";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pulsar-1.2.0.tar";
        sha256 = "03bx06fa7md78xrn10kigrf3p8pm07lxpw70wbhfqgq1b3zr46rl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pulsar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pyim = callPackage (
    {
      async,
      elpaBuild,
      fetchurl,
      lib,
      xr,
    }:
    elpaBuild {
      pname = "pyim";
      ename = "pyim";
      version = "5.3.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pyim-5.3.4.tar";
        sha256 = "0axi8vizr2pdswdnnkr409k926h9k7w3c18nbmb9j3pfc32inkjs";
      };
      packageRequires = [
        async
        xr
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pyim.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pyim-basedict = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      pyim,
    }:
    elpaBuild {
      pname = "pyim-basedict";
      ename = "pyim-basedict";
      version = "0.5.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/pyim-basedict-0.5.5.tar";
        sha256 = "04sfiywyrvilymg013gk81ya0ax6p24d4zyrjg8limjw0fn1b347";
      };
      packageRequires = [ pyim ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/pyim-basedict.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  python = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      flymake ? null,
      lib,
      project,
      seq,
    }:
    elpaBuild {
      pname = "python";
      ename = "python";
      version = "0.30";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/python-0.30.tar";
        sha256 = "1m8jmjkf5cgw0jr5j4ca525kllaf1ailx5mg2z4xzvqwxkzwhwxd";
      };
      packageRequires = [
        compat
        flymake
        project
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/python.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  quarter-plane = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "quarter-plane";
      ename = "quarter-plane";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/quarter-plane-0.1.tar";
        sha256 = "06syayqdmh4nb7ys52g1mw01wnz5hjv710dari106fk8fm9cy18c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/quarter-plane.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  queue = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "queue";
      ename = "queue";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/queue-0.2.tar";
        sha256 = "117g6sl5dh7ssp6m18npvrqik5rs2mnr16129cfpnbi3crsw23c8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/queue.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rainbow-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rainbow-mode";
      ename = "rainbow-mode";
      version = "1.0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rainbow-mode-1.0.6.tar";
        sha256 = "0xv39jix1gbwq6f8laj93sqkf2j5hwda3l7mjqc7vsqjw1lkhmjv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rainbow-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rbit = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rbit";
      ename = "rbit";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rbit-0.1.tar";
        sha256 = "1xfl3m53bdi25h8mp7s0zp1yy7436cfydxrgkfc31fsxkh009l9h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rbit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rcirc-color = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rcirc-color";
      ename = "rcirc-color";
      version = "0.4.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rcirc-color-0.4.5.tar";
        sha256 = "0sfwmi0sspj7sx1psij4fzq1knwva8706w0204mbjxsq2nh5s9f3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rcirc-color.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rcirc-mentions = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rcirc-mentions";
      ename = "rcirc-mentions";
      version = "1.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rcirc-mentions-1.0.5.tar";
        sha256 = "1qf3zsqjryqsx31y1dmmqdvny5w4f4z96mxb2ibj39ah9j2vgixb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rcirc-mentions.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rcirc-menu = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rcirc-menu";
      ename = "rcirc-menu";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rcirc-menu-1.1.el";
        sha256 = "0w77qlwlmx59v5894i96fldn6x4lliv4ddv8967vq1kfchn4w5mc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rcirc-menu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rcirc-sqlite = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rcirc-sqlite";
      ename = "rcirc-sqlite";
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rcirc-sqlite-1.0.4.tar";
        sha256 = "0bxih4m3rn76lq5q2hbq04fb0yqfy848cqfzl7gii1qsrfplqcal";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rcirc-sqlite.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      loc-changes,
      test-simple,
    }:
    elpaBuild {
      pname = "realgud";
      ename = "realgud";
      version = "1.5.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-1.5.1.tar";
        sha256 = "1iisvzxvdsifxkz7b2wacw85dkjagrmbcdhcfsnswnfbp3r3kg35";
      };
      packageRequires = [
        load-relative
        loc-changes
        test-simple
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-ipdb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-ipdb";
      ename = "realgud-ipdb";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-ipdb-1.0.0.tar";
        sha256 = "0zmgsrb15rmgszidx4arjazb6fz523q5w516z5k5cn92wfzfyncr";
      };
      packageRequires = [ realgud ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-ipdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-jdb = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-jdb";
      ename = "realgud-jdb";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-jdb-1.0.0.tar";
        sha256 = "081lqsxbg6cxv8hz8s0z2gbdif9drp5b0crbixmwf164i4h8l4gc";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-jdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-lldb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-lldb";
      ename = "realgud-lldb";
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-lldb-1.0.2.tar";
        sha256 = "1g4spjrldyi9rrh5dwrcqpz5qm37fq2qpvmirxvdqgfbwl6gapzj";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-lldb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-node-debug = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-node-debug";
      ename = "realgud-node-debug";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-node-debug-1.0.0.tar";
        sha256 = "1wyh6apy289a3qa1bnwv68x8pjkpqy4m18ygqnr4x759hjkq3nir";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-node-debug.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-node-inspect = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-node-inspect";
      ename = "realgud-node-inspect";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-node-inspect-1.0.0.tar";
        sha256 = "16cx0rq4zx5k0y75j044dbqzrzs1df3r95rissmhfgsi5m2qf1h2";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-node-inspect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-trepan-ni = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-trepan-ni";
      ename = "realgud-trepan-ni";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-trepan-ni-1.0.1.tar";
        sha256 = "09vllklpfc0q28ankp2s1v10kwnxab4g6hb9zn63d1rfa92qy44k";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-trepan-ni.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-trepan-xpy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-trepan-xpy";
      ename = "realgud-trepan-xpy";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/realgud-trepan-xpy-1.0.1.tar";
        sha256 = "13fll0c6p2idg56q0czgv6s00vvb585b40dn3b14hdpy0givrc0x";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/realgud-trepan-xpy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rec-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rec-mode";
      ename = "rec-mode";
      version = "1.9.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rec-mode-1.9.4.tar";
        sha256 = "0pi483g5qgz6gvyi13a4ldfbkaad3xkad08aqfcnmsdylvc9zzma";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rec-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  register-list = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "register-list";
      ename = "register-list";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/register-list-0.1.tar";
        sha256 = "01w2yyvbmnkjrmx5f0dk0327c0k7fvmgi928j6hbvlrp5wk6s394";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/register-list.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  relint = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      xr,
    }:
    elpaBuild {
      pname = "relint";
      ename = "relint";
      version = "2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/relint-2.1.tar";
        sha256 = "0ikml87y0k85qd92m3l1gkzjd9ng3mhjfk19w15ln0w801351cq0";
      };
      packageRequires = [ xr ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/relint.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  repology = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "repology";
      ename = "repology";
      version = "1.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/repology-1.2.4.tar";
        sha256 = "0nj4dih9mv8crqq8rd4k8dzgq7l0195syfxsf2gyikmqz9sjbr85";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/repology.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rich-minority = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  rnc-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rnc-mode";
      ename = "rnc-mode";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rnc-mode-0.3.tar";
        sha256 = "1p03g451888v86k9z6g8gj375p1pcdvikgk1phxkhipwi5hbf5g8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rnc-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rt-liberation = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rt-liberation";
      ename = "rt-liberation";
      version = "7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rt-liberation-7.tar";
        sha256 = "0bi1qyc4n4ar0rblnddmlrlrkdvdrvv54wg4ii39hhxij4p6niif";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rt-liberation.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ruby-end = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ruby-end";
      ename = "ruby-end";
      version = "0.4.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ruby-end-0.4.3.tar";
        sha256 = "07175v9fy96lmkfa0007lhx7v3fkk77iwca3rjl94dgdp4b8lbk5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ruby-end.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rudel = callPackage (
    {
      cl-generic,
      cl-lib ? null,
      cl-print ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rudel";
      ename = "rudel";
      version = "0.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/rudel-0.3.2.tar";
        sha256 = "00rs2fy64ybam26szpc93miwajq42acyh0dkg0ixr95mg49sc46j";
      };
      packageRequires = [
        cl-generic
        cl-lib
        cl-print
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/rudel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  satchel = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "satchel";
      ename = "satchel";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/satchel-0.2.tar";
        sha256 = "115rkq2ygawsg8ph44zfqwsd9ykm4370v0whgjwhc1wx2iyn5ir9";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/satchel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scanner = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scanner";
      ename = "scanner";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/scanner-0.3.tar";
        sha256 = "07cqbphpgcqz2bb204c26mh3pc4h4z792dz9pxh1fjwh4d0iasqy";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/scanner.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scroll-restore = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scroll-restore";
      ename = "scroll-restore";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/scroll-restore-1.0.tar";
        sha256 = "1i9ld1l5h2cpzf8bzk7nlk2bcln48gya8zrq79v6rawbrwdlz2z4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/scroll-restore.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sed-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sed-mode";
      ename = "sed-mode";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sed-mode-1.1.tar";
        sha256 = "0zhga0xsffdcinh10di046n6wbx35gi1zknnqzgm9wvnm2iqxlyn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sed-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  seq = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "seq";
      ename = "seq";
      version = "2.24";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/seq-2.24.tar";
        sha256 = "13x8l1m5if6jpc8sbrbx9r64fyhh450ml6vfm92p6i5wv6gl74w6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/seq.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  setup = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "setup";
      ename = "setup";
      version = "1.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/setup-1.5.0.tar";
        sha256 = "184g3kd9caxyhwq41w94spkjs1j45vblg4sqfb5h5pqb5h9p95n5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/setup.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  shelisp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "shelisp";
      ename = "shelisp";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/shelisp-1.0.0.tar";
        sha256 = "0zhkk04nj25lmpdlqblfhx3rb415w2f58f7wb19k1s2ry4k7m15g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/shelisp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  shell-command-plus = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "shell-command-plus";
      ename = "shell-command+";
      version = "2.5.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/shell-command+-2.5.0.tar";
        sha256 = "0svmrar0blgq3ffg9sll6b5vnqi1nw7snkbl04x2s9qln2i88dzx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/shell-command+.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  shen-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "shen-mode";
      ename = "shen-mode";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/shen-mode-0.1.tar";
        sha256 = "0xskyd0d3krwgrpca10m7l7c0l60qq7jjn2q207n61yw5yx71pqn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/shen-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  show-font = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "show-font";
      ename = "show-font";
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/show-font-1.0.0.tar";
        sha256 = "1caga09ypj6vb4vziw6slvhkjbzj6a3vss9lbgbigzb4m6q8caqf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/show-font.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sisu-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sisu-mode";
      ename = "sisu-mode";
      version = "7.1.8";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sisu-mode-7.1.8.tar";
        sha256 = "02cfyrjynwvf2rlnkfy8285ga9kzbg1b614sch0xnxqw81mp7drp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sisu-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  site-lisp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "site-lisp";
      ename = "site-lisp";
      version = "0.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/site-lisp-0.2.0.tar";
        sha256 = "17wwn1wjkq4vjzhgzq5pyn5x6bzai6nwmxcsp9d375b88qwp973n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/site-lisp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sketch-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sketch-mode";
      ename = "sketch-mode";
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sketch-mode-1.0.4.tar";
        sha256 = "1vrbmyhf9bffy2fkz91apzxla6v8nbv2wb25vxcr9x3smbag9kal";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sketch-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  slime-volleyball = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  sm-c-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sm-c-mode";
      ename = "sm-c-mode";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sm-c-mode-1.2.tar";
        sha256 = "0xykl8wkbw5y7ah79zlfzz1k0di9ghfsv2xjxwx7rrb37wny5184";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sm-c-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  smalltalk-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "smalltalk-mode";
      ename = "smalltalk-mode";
      version = "4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/smalltalk-mode-4.0.tar";
        sha256 = "0ly2qmsbmzd5nd7iaighws10y0yj7p2356fw32pkp0cmzzvc3d54";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/smalltalk-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  smart-yank = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "smart-yank";
      ename = "smart-yank";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/smart-yank-0.1.1.tar";
        sha256 = "08dc4c60jcjyiixyzckxk5qk6s2pl1jmrp4h1bj53ssd1kn4208m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/smart-yank.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sml-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sml-mode";
      ename = "sml-mode";
      version = "6.12";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sml-mode-6.12.tar";
        sha256 = "10zp0gi5rbjjxjzn9k6klvdms9k3yxx0qry0wa75a68sj5x2rdzh";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sml-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  so-long = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "so-long";
      ename = "so-long";
      version = "1.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/so-long-1.1.2.tar";
        sha256 = "01qdxlsllpj5ajixkqf7v9p95zn9qnvjdnp30v54ymj2pd0d9a32";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/so-long.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  soap-client = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "soap-client";
      ename = "soap-client";
      version = "3.2.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/soap-client-3.2.3.tar";
        sha256 = "1yhs661g0vqxpxqcxgsxvljmrpcqzl0y52lz6jvfilmshw7r6k2s";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/soap-client.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sokoban = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sokoban";
      ename = "sokoban";
      version = "1.4.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sokoban-1.4.9.tar";
        sha256 = "1l3d4al96252kdhyn4dr88ir67kay57n985w0qy8p930ncrs846v";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sokoban.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sotlisp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sotlisp";
      ename = "sotlisp";
      version = "1.6.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sotlisp-1.6.2.tar";
        sha256 = "0q65iwr89cwwqnc1kndf2agq5wp48a7k02qsksgaj0n6zv7i4dfn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sotlisp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  spacious-padding = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "spacious-padding";
      ename = "spacious-padding";
      version = "0.7.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/spacious-padding-0.7.0.tar";
        sha256 = "0kzqg5nddwc061q44zzlhv1kniivda17khz94wdbpb1x2z9ym147";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/spacious-padding.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  speedrect = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "speedrect";
      ename = "speedrect";
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/speedrect-0.7.tar";
        sha256 = "0nxwwd12qqyxq1fg8n6miyx63fp29cvpfp8w33zmf9dhkcjwyfd1";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/speedrect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  spinner = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "spinner";
      ename = "spinner";
      version = "1.7.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/spinner-1.7.4.tar";
        sha256 = "0lq8q62q5an8199p8pyafg5l6hdnnqi6i6sybnk60sdcqy62pa6r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/spinner.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sql-beeline = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sql-beeline";
      ename = "sql-beeline";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sql-beeline-0.2.tar";
        sha256 = "0ngvvfhs1fj3ca5g563bssaz9ac5fiqkqzv09s4ramalp2q6axq9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sql-beeline.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sql-cassandra = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sql-cassandra";
      ename = "sql-cassandra";
      version = "0.2.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sql-cassandra-0.2.2.tar";
        sha256 = "154rymq0k6869cw7sc7nhx3di5qv1ffgf8shkxc22gvkrj2s7p9b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sql-cassandra.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sql-indent = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  srht = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      plz,
      transient,
    }:
    elpaBuild {
      pname = "srht";
      ename = "srht";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/srht-0.4.tar";
        sha256 = "0ps49syzlaf4lxvji61y6y7r383r65v96d57hj75xkn6hvyrz74n";
      };
      packageRequires = [
        plz
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/srht.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ssh-deploy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ssh-deploy";
      ename = "ssh-deploy";
      version = "3.1.16";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ssh-deploy-3.1.16.tar";
        sha256 = "0fb88l3270d7l808q8x16zcvjgsjbyhgifgv17syfsj0ja63x28p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ssh-deploy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  standard-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "standard-themes";
      ename = "standard-themes";
      version = "2.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/standard-themes-2.2.0.tar";
        sha256 = "0qdld75vcfhsn2l0xips52vrlp5q7ss3973hd722h2gp1wddn5f7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/standard-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  stream = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "stream";
      ename = "stream";
      version = "2.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/stream-2.4.0.tar";
        sha256 = "16wl1q7wikk0wyzfwjz16azq025dx4wdh1j9q0nadi68ygxi172b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/stream.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  substitute = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "substitute";
      ename = "substitute";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/substitute-0.3.1.tar";
        sha256 = "0038kkn6v2w3asg9abwary2cacr9wbw90wdvq7q9wyk1818cygff";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/substitute.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  svg = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "svg";
      ename = "svg";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/svg-1.1.tar";
        sha256 = "10x2rry349ibzd9awy4rg18cd376yvkzqsyq0fm4i05kq4dzqp4a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/svg.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  svg-clock = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      svg,
    }:
    elpaBuild {
      pname = "svg-clock";
      ename = "svg-clock";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/svg-clock-1.2.tar";
        sha256 = "0r0wayb1q0dd2yi1nqa0m4jfy36lydxxa6xvvd6amgh9sy499qs8";
      };
      packageRequires = [ svg ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/svg-clock.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  svg-lib = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "svg-lib";
      ename = "svg-lib";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/svg-lib-0.3.tar";
        sha256 = "1s7n3j1yzprs9frb554c66pcrv3zss1y26y6qgndii4bbzpa7jh8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/svg-lib.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  svg-tag-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      svg-lib,
    }:
    elpaBuild {
      pname = "svg-tag-mode";
      ename = "svg-tag-mode";
      version = "0.3.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/svg-tag-mode-0.3.3.tar";
        sha256 = "14vkjy3dvvvkhxi3m8d56m0dpvg9gpbwmmb0dchz8ap8wjbvc85j";
      };
      packageRequires = [ svg-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/svg-tag-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  swiper = callPackage (
    {
      elpaBuild,
      fetchurl,
      ivy,
      lib,
    }:
    elpaBuild {
      pname = "swiper";
      ename = "swiper";
      version = "0.15.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/swiper-0.15.1.tar";
        sha256 = "0m70jgcdsbrj6i5b1srrdgzkwavzi098532fv6vi2051nl42snvz";
      };
      packageRequires = [ ivy ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/swiper.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  switchy-window = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "switchy-window";
      ename = "switchy-window";
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/switchy-window-1.3.tar";
        sha256 = "0ym5cy6czsrd15f8rgh3dad8fwn8pb2xrvhlmdikc59cc29zamrv";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/switchy-window.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sxhkdrc-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sxhkdrc-mode";
      ename = "sxhkdrc-mode";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/sxhkdrc-mode-1.2.0.tar";
        sha256 = "0a4r06cxgqkvx2vv94icy096kg5v1qf637gmgwrgg0i4w49hk5jk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/sxhkdrc-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  system-packages = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "system-packages";
      ename = "system-packages";
      version = "1.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/system-packages-1.1.1.tar";
        sha256 = "0ndnx94ilxha7mby47n29qvr0lrypmsa7d1mxdwd66jd150sar5r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/system-packages.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tNFA = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      queue,
    }:
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
    }
  ) { };
  tam = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      queue,
    }:
    elpaBuild {
      pname = "tam";
      ename = "tam";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tam-0.1.tar";
        sha256 = "16ms55cwm2cwixl03a3bbsqs159c3r3dv5kaazvsghby6c511bx8";
      };
      packageRequires = [ queue ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tam.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  taxy = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "taxy";
      ename = "taxy";
      version = "0.10.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/taxy-0.10.2.tar";
        sha256 = "1nmlx2rvlgzvmz1h3s5yn3qnad12pn2a83gjzxf3ln79p8rv1mj6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/taxy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  taxy-magit-section = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      magit-section,
      taxy,
    }:
    elpaBuild {
      pname = "taxy-magit-section";
      ename = "taxy-magit-section";
      version = "0.14.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/taxy-magit-section-0.14.3.tar";
        sha256 = "16j1a2vx9awr5vk1x3i1m526ym6836zxlypx1f50fcwjy0w8q8a3";
      };
      packageRequires = [
        magit-section
        taxy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/taxy-magit-section.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  temp-buffer-browse = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "temp-buffer-browse";
      ename = "temp-buffer-browse";
      version = "1.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/temp-buffer-browse-1.5.tar";
        sha256 = "00hbh25fj5fm9dsp8fpdk8lap3gi5jlva6f0m6kvjqnmvc06q36r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/temp-buffer-browse.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tempel = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tempel";
      ename = "tempel";
      version = "1.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tempel-1.6.tar";
        sha256 = "1h5k3cc5kl4g11chrfjgnhr1vg29fj3qz706rimilki367n2sra5";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tempel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  termint = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "termint";
      ename = "termint";
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/termint-0.1.1.tar";
        sha256 = "1d6hg6bs105a8dzr0v2by0mb9c7v87jwqi4dxxzm6287448x7qqa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/termint.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  test-simple = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  tex-item = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tex-item";
      ename = "tex-item";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tex-item-0.1.tar";
        sha256 = "0ggbn3lk64cv6pnw97ww7vn250jchj80zx3hvkcqlccyw34x6ziy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tex-item.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tex-parens = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tex-parens";
      ename = "tex-parens";
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tex-parens-0.7.tar";
        sha256 = "1h3l4kn154mmzxgz6s7y2qrkpqk4ava3j1iwx07gsgnr5pcpgvfr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tex-parens.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  theme-buffet = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "theme-buffet";
      ename = "theme-buffet";
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/theme-buffet-0.1.2.tar";
        sha256 = "1cfrrl41rlxdbybvxs8glkgmgkznwgpq70h58rkvwm6b5jfs8wv0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/theme-buffet.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  timeout = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "timeout";
      ename = "timeout";
      version = "2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/timeout-2.1.tar";
        sha256 = "1mm4yp1spw512dnav1p3wnxqrsyls918i14azg03by4v32r9945p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/timeout.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  timerfunctions = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "timerfunctions";
      ename = "timerfunctions";
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
    }
  ) { };
  tiny = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tiny";
      ename = "tiny";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tiny-0.2.1.tar";
        sha256 = "1cr73a8gba549ja55x0c2s554f3zywf69zbnd7v82jz5q1k9wd2v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tiny.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tmr = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tmr";
      ename = "tmr";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tmr-1.2.0.tar";
        sha256 = "0ywy3wz6km4smp7igzn44fwincc79nwzm0a55jv7hyz6bv78n8xr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tmr.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tomelr = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      map,
      seq,
    }:
    elpaBuild {
      pname = "tomelr";
      ename = "tomelr";
      version = "0.4.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tomelr-0.4.3.tar";
        sha256 = "0r2f4dl10fl75ygvbmb4vkqixy24k0z2wpr431ljzp5m29bn74kh";
      };
      packageRequires = [
        map
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tomelr.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  topspace = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "topspace";
      ename = "topspace";
      version = "0.3.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/topspace-0.3.1.tar";
        sha256 = "0m8z2q1gdi0zfh1df5xb2v0sg1v5fysrl00fv2qqgnd61c2n0hhz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/topspace.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  track-changes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "track-changes";
      ename = "track-changes";
      version = "1.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/track-changes-1.4.tar";
        sha256 = "0ygc53dm144ld4f7ig1fh1z345gnkrin7q108kj9d4dhgp8f2381";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/track-changes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tramp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tramp";
      ename = "tramp";
      version = "2.8.0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tramp-2.8.0.3.tar";
        sha256 = "1qszpb4qywpnx5x7ynx8srq6m6aiygdimffghihxcviv1r1mxs53";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tramp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tramp-nspawn = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tramp-nspawn";
      ename = "tramp-nspawn";
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tramp-nspawn-1.0.1.tar";
        sha256 = "0cy8l389s6pi135gxcygv1vna6k3gizqd33avf3wsdbnqdf2pjnc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tramp-nspawn.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tramp-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tramp-theme";
      ename = "tramp-theme";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tramp-theme-0.3.tar";
        sha256 = "1v9265cnk858jl522zcnqf2cv3f3g93f0mk52plz3n4a8k5nlfa7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tramp-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  transcribe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "transcribe";
      ename = "transcribe";
      version = "1.5.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/transcribe-1.5.2.tar";
        sha256 = "1v1bvcv3zqrj073l3vw7gz20rpa9p86rf1yv219n47kmh27c80hq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/transcribe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  transient = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "transient";
      ename = "transient";
      version = "0.10.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/transient-0.10.1.tar";
        sha256 = "1qxml619jpjp2an4iiq7c2n0vy0xam73rjl6076lialfwsa05hqd";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/transient.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  transient-cycles = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "transient-cycles";
      ename = "transient-cycles";
      version = "2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/transient-cycles-2.0.tar";
        sha256 = "0cq2k77rgbw3fx84a2d33nbb75wqxynrc1mx4gb32a9ysm0sa4s3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/transient-cycles.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tree-inspector = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      treeview,
    }:
    elpaBuild {
      pname = "tree-inspector";
      ename = "tree-inspector";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/tree-inspector-0.4.tar";
        sha256 = "0v59kp1didml9k245m1v0s0ahh2r79cc0hp5ika93iamrdxkxaiz";
      };
      packageRequires = [ treeview ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/tree-inspector.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  trie = callPackage (
    {
      elpaBuild,
      fetchurl,
      heap,
      lib,
      tNFA,
    }:
    elpaBuild {
      pname = "trie";
      ename = "trie";
      version = "0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/trie-0.6.tar";
        sha256 = "1jvhvvxkxbbpy93x9kpznvp2hqkkbdbbjaj27fd0wkbijg0k03ln";
      };
      packageRequires = [
        heap
        tNFA
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/trie.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  triples = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "triples";
      ename = "triples";
      version = "0.6.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/triples-0.6.1.tar";
        sha256 = "0rziyr9gwab140afs0hhwqbi6kvp2ypv7clp0y9yckmpj1b0bzrv";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/triples.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ulisp-repl = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ulisp-repl";
      ename = "ulisp-repl";
      version = "1.0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/ulisp-repl-1.0.3.tar";
        sha256 = "1c23d66vydfp29px2dlvgl5xg91a0rh4w4b79q8ach533nfag3ia";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/ulisp-repl.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  undo-tree = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      queue,
    }:
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
    }
  ) { };
  uni-confusables = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "uni-confusables";
      ename = "uni-confusables";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/uni-confusables-0.3.tar";
        sha256 = "08150kgqsbcpykvf8m2b25y386h2b4pj08vffm6wh4f000wr72k3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/uni-confusables.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  uniquify-files = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "uniquify-files";
      ename = "uniquify-files";
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/uniquify-files-1.0.4.tar";
        sha256 = "0xw2l49xhdy5qgwja8bkiq2ibdppl45xzqlr17z92l1vfq4akpzp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/uniquify-files.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  urgrep = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "urgrep";
      ename = "urgrep";
      version = "0.5.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/urgrep-0.5.2.tar";
        sha256 = "1lwr601xyw0gcix6v53dn5h0jsxwpa5pkqgz56a6311z9d9qlj3c";
      };
      packageRequires = [
        compat
        project
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/urgrep.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  url-http-ntlm = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      ntlm ? null,
    }:
    elpaBuild {
      pname = "url-http-ntlm";
      ename = "url-http-ntlm";
      version = "2.0.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/url-http-ntlm-2.0.6.tar";
        sha256 = "06bfw1w128gg9b60pb3wcpcib33jf13y1niyhs6grhm7yq11waz2";
      };
      packageRequires = [ ntlm ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/url-http-ntlm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  url-http-oauth = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "url-http-oauth";
      ename = "url-http-oauth";
      version = "0.8.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/url-http-oauth-0.8.4.tar";
        sha256 = "10iznck31ilfjwjbbwfalqchg260yqypai487436cc0s1fm47vvf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/url-http-oauth.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  url-scgi = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "url-scgi";
      ename = "url-scgi";
      version = "0.9";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/url-scgi-0.9.tar";
        sha256 = "19lvr4d2y9rd5gibaavp7ghkxmdh5zad9ynarbi2w4rjgmz5y981";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/url-scgi.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  use-package = callPackage (
    {
      bind-key,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "use-package";
      ename = "use-package";
      version = "2.4.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/use-package-2.4.6.tar";
        sha256 = "0idy78mpg9zikjqfg431q7fd34mwz18blvp6yq1bf29q582a9jyf";
      };
      packageRequires = [ bind-key ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/use-package.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  validate = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "validate";
      ename = "validate";
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/validate-1.0.4.tar";
        sha256 = "1bn25l62zcabg2ppxwr4049m1qd0yj095cflqrak0n50acgjs6w5";
      };
      packageRequires = [
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/validate.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  valign = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "valign";
      ename = "valign";
      version = "3.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/valign-3.1.1.tar";
        sha256 = "16v2mmrih0ykk4z6qmy29gajjb3v83q978gzn3y6pg8y48b2wxpb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/valign.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vc-backup = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vc-backup";
      ename = "vc-backup";
      version = "1.1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vc-backup-1.1.1.tar";
        sha256 = "0lalz700s7cppayjyv7bvmgzcfl9hk1w84i2q00k1ns84h4qzji1";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vc-backup.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vc-got = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vc-got";
      ename = "vc-got";
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vc-got-1.2.tar";
        sha256 = "04m1frrnla4zc8db728280r9fbk50bgjkk4k7dizb0hawghk4r3p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vc-got.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vc-hgcmd = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vc-hgcmd";
      ename = "vc-hgcmd";
      version = "1.14.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vc-hgcmd-1.14.1.tar";
        sha256 = "0a8a4d9difrp2r6ac8micxn8ij96inba390324w087yxwqzkgk1g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vc-hgcmd.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vc-jj = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vc-jj";
      ename = "vc-jj";
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vc-jj-0.4.tar";
        sha256 = "1wws05yybiwxnx1qyapnw87k74glv8izkk2zlzn21hvqscbknz1y";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vc-jj.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vcard = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vcard";
      ename = "vcard";
      version = "0.2.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vcard-0.2.2.tar";
        sha256 = "0r56y3q2gigm8rxifly50m5h1k948y987541cqd8w207wf1b56bh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vcard.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vcl-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vcl-mode";
      ename = "vcl-mode";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vcl-mode-1.1.tar";
        sha256 = "0zz664c263x24xzs7hk2mqchzplmx2dlba98d5fpy8ybdnziqfkj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vcl-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vdiff = callPackage (
    {
      elpaBuild,
      fetchurl,
      hydra,
      lib,
    }:
    elpaBuild {
      pname = "vdiff";
      ename = "vdiff";
      version = "0.2.4";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vdiff-0.2.4.tar";
        sha256 = "0crgb32dk0yzcgvjai0b67wcbcfppc3h0ppfqgdrim1nincbwc1m";
      };
      packageRequires = [ hydra ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vdiff.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vecdb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      pg,
      plz,
    }:
    elpaBuild {
      pname = "vecdb";
      ename = "vecdb";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vecdb-0.2.tar";
        sha256 = "10p5nhk4v4j05k9cz9br5ninycpp7spgby9mrr9z8bsy2g0j0il2";
      };
      packageRequires = [
        pg
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vecdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  verilog-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "verilog-mode";
      ename = "verilog-mode";
      version = "2025.1.1.100165202";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/verilog-mode-2025.1.1.100165202.tar";
        sha256 = "1cgv081dlarc0b4s6rjkqbvs4fa9npyq9pjxj7173vmgkfdwmkp5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/verilog-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vertico = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vertico";
      ename = "vertico";
      version = "2.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vertico-2.5.tar";
        sha256 = "06yj03x61406zfs75q4blh9fav284psnigsy3g5wpqrv3p79b89s";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vertico.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vertico-posframe = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      posframe,
      vertico,
    }:
    elpaBuild {
      pname = "vertico-posframe";
      ename = "vertico-posframe";
      version = "0.9.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vertico-posframe-0.9.0.tar";
        sha256 = "16vnacmz52d1rwdmddsr1rm1zki1p3bw10ngpw39a3dszbwqkl3m";
      };
      packageRequires = [
        posframe
        vertico
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vertico-posframe.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vigenere = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vigenere";
      ename = "vigenere";
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vigenere-1.0.tar";
        sha256 = "1zlni6amznzi9w96kj7lnhfrr049crva2l8kwl5jsvyaj5fc6nq5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vigenere.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  visual-filename-abbrev = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "visual-filename-abbrev";
      ename = "visual-filename-abbrev";
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/visual-filename-abbrev-1.3.tar";
        sha256 = "0aly8lkiykcxq3yyyd3lwyc7fmjpcxjdgny0iw0mzl8nhshrqrs0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/visual-filename-abbrev.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  visual-fill = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "visual-fill";
      ename = "visual-fill";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/visual-fill-0.2.tar";
        sha256 = "00r3cclhrdx5y0h1p1rrx5psvc8d95dayzpjdsy9xj44i8pcnvja";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/visual-fill.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vlf = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vlf";
      ename = "vlf";
      version = "1.7.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vlf-1.7.2.tar";
        sha256 = "1napxdavsrwb5dq2i4ka06rhmmfk6qixc8mm2a6ab68iavprrqkv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vlf.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vundo = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vundo";
      ename = "vundo";
      version = "2.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/vundo-2.4.0.tar";
        sha256 = "1aj2l6iivgv6mh3rvrj8w8jhznx7cywn5f2b2ivl4hmrxlfbgsjr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/vundo.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wcheck-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wcheck-mode";
      ename = "wcheck-mode";
      version = "2021";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wcheck-mode-2021.tar";
        sha256 = "0igsdsfw80nnrbw1ba3rgwp16ncy195kwv78ll9zbbf3y23n7kr0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wcheck-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wconf = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wconf";
      ename = "wconf";
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wconf-0.2.1.tar";
        sha256 = "1ci5ysn2w9hjzcsv698b6mh14qbrmvlzn4spaq4wzwl9p8672n08";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wconf.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  web-server = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "web-server";
      ename = "web-server";
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/web-server-0.1.2.tar";
        sha256 = "0wikajm4pbffcy8clwwb5bnz67isqmcsbf9kca8rzx4svzi5j2gc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/web-server.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  webfeeder = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "webfeeder";
      ename = "webfeeder";
      version = "1.1.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/webfeeder-1.1.2.tar";
        sha256 = "0418fpw2ra12n77560gh9j9ymv28d895bdhpr7x9xakvijjh705m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/webfeeder.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  websocket = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  which-key = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "which-key";
      ename = "which-key";
      version = "3.6.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/which-key-3.6.1.tar";
        sha256 = "0p1vl7dnd7nsvzgsff19px9yzcw4w07qb5sb8g9r8a8slgvf3vqh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/which-key.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  window-commander = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "window-commander";
      ename = "window-commander";
      version = "3.0.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/window-commander-3.0.2.tar";
        sha256 = "15345sgdmgz0vv9bk2cmffjp66i0msqj0xn2cxl7wny3bkfx8amv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/window-commander.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  window-tool-bar = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "window-tool-bar";
      ename = "window-tool-bar";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/window-tool-bar-0.3.tar";
        sha256 = "00kggfpfi1nj05mzy5zig0fs4as7qh99wqgvya3xj2kw8141cvd6";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/window-tool-bar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  windower = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "windower";
      ename = "windower";
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/windower-0.0.1.el";
        sha256 = "19xizbfbnzhhmhlqy20ir1a1y87bjwrq67bcawxy6nxpkwbizsv7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/windower.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  windresize = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "windresize";
      ename = "windresize";
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/windresize-0.1.tar";
        sha256 = "1wjqrwrfql5c67yv59hc95ga0mkvrqz74gy46aawhn8r3xr65qai";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/windresize.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wisi = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "wisi";
      ename = "wisi";
      version = "4.3.2";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wisi-4.3.2.tar";
        sha256 = "0qa6nig33igv4sqk3fxzrmx889pswq10smj9c9l3phz2acqx8q92";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wisi.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wisitoken-grammar-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      mmm-mode,
      wisi,
    }:
    elpaBuild {
      pname = "wisitoken-grammar-mode";
      ename = "wisitoken-grammar-mode";
      version = "1.3.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wisitoken-grammar-mode-1.3.0.tar";
        sha256 = "0i0vy751ycbfp8l8ynzj6iqgvc3scllwysdchpjv4lyj0m7m3s20";
      };
      packageRequires = [
        mmm-mode
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wisitoken-grammar-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wpuzzle = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wpuzzle";
      ename = "wpuzzle";
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wpuzzle-1.1.tar";
        sha256 = "05dgvr1miqp870nl7c8dw7j1kv4mgwm8scynjfwbs9wjz4xmzc6c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wpuzzle.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wrap-search = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wrap-search";
      ename = "wrap-search";
      version = "4.17.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/wrap-search-4.17.6.tar";
        sha256 = "0wq0fw5ry5fnp96q9bffawc1vdl4p6kknwhlyf4xypmja011afys";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/wrap-search.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xclip = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xclip";
      ename = "xclip";
      version = "1.11.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xclip-1.11.1.tar";
        sha256 = "0raqlpskjrkxv7a0q5ikq8dqf2h21g0vcxdw03vqcah2v43zxflx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xclip.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xeft = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xeft";
      ename = "xeft";
      version = "3.6";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xeft-3.6.tar";
        sha256 = "0vdnl0rp9bkl5gyyacqczbl41vl8hrvah51jbfx4szf4qldmfhsm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xeft.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xelb = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xelb";
      ename = "xelb";
      version = "0.21";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xelb-0.21.tar";
        sha256 = "0fmms4dy5b9l6qlf246p61v3k8szm7qhl60lf84wc0xpa6ah2698";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xelb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xpm = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      queue,
    }:
    elpaBuild {
      pname = "xpm";
      ename = "xpm";
      version = "1.0.5";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xpm-1.0.5.tar";
        sha256 = "12a12rmbc1c0j60nv1s8fgg3r2lcjw8hs7qpyscm7ggwanylxn6q";
      };
      packageRequires = [
        cl-lib
        queue
      ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xpm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xr = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xr";
      ename = "xr";
      version = "2.1";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xr-2.1.tar";
        sha256 = "1yssl7av2rpanzmm93iw74acnb3pbrnh0b51kr64wcj6hwb26cy2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xr.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xref = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xref";
      ename = "xref";
      version = "1.7.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xref-1.7.0.tar";
        sha256 = "0jy49zrkqiqg9131k24y6nyjnq2am4dwwdrqmginrrwzvi3y9d24";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xref.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xref-union = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xref-union";
      ename = "xref-union";
      version = "0.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/xref-union-0.2.0.tar";
        sha256 = "0ghhasqs0xq2i576fp97qx6x3h940kgyp76a49gj5cdmig8kyfi8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/xref-union.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  yaml = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "yaml";
      ename = "yaml";
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/yaml-1.2.0.tar";
        sha256 = "1j1shz85vdj7w7bslpmpfws92fi3afp44533irq8caf7zj9masph";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/yaml.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  yasnippet = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "yasnippet";
      ename = "yasnippet";
      version = "0.14.3";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/yasnippet-0.14.3.tar";
        sha256 = "1c0zhdcqz0jrx2swbqwschnwb07wy4s2gld3x6b4b892psxc2cg8";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/yasnippet.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  yasnippet-classic-snippets = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      yasnippet,
    }:
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
    }
  ) { };
  zones = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "zones";
      ename = "zones";
      version = "2023.6.11";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/zones-2023.6.11.tar";
        sha256 = "1z3kq0lfc4fbr9dnk9kj2hqcv60bnjp0x4kbxaxy77vv02a62rzc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/zones.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ztree = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
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
    }
  ) { };
  zuul = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "zuul";
      ename = "zuul";
      version = "0.4.0";
      src = fetchurl {
        url = "https://elpa.gnu.org/packages/zuul-0.4.0.tar";
        sha256 = "1mj54hm4cqidrmbxyqdjfsc3qcmjhbl0wii79bydx637dvpfvqgf";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/zuul.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
