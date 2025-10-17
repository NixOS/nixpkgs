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
      version = "1.2.0.20250524.125533";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/a68-mode-1.2.0.20250524.125533.tar";
        sha256 = "0z8cmasvzbziwgi52p8bn4xdcz5izkhj12laf1gzwwzik1lmh5kj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/a68-mode.html";
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
      version = "0.10.0.0.20220911.35841";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ace-window-0.10.0.0.20220911.35841.tar";
        sha256 = "0xfc1pw7m4vg0xvj40djm7rxqr0405pby3rgl5vyd8ci5kpmmvhs";
      };
      packageRequires = [ avy ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ace-window.html";
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
      version = "1.11.0.20220924.84123";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ack-1.11.0.20220924.84123.tar";
        sha256 = "0vic2izviakj6qh2l15jd8qm8yr0h0qhy4r8sx7zdngpi9i14r5v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ack.html";
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
      version = "0.8pre0.20250223.175841";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/activities-0.8pre0.20250223.175841.tar";
        sha256 = "0hmv2wvbs006lwc7r9bz9pf7i40dbklqllkrwdigbxbi2cn8xya8";
      };
      packageRequires = [ persist ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/activities.html";
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
      version = "8.1.0.0.20231018.91522";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ada-mode-8.1.0.0.20231018.91522.tar";
        sha256 = "07kd6dj1dbds68qmi4dh4w3fc8l18jyxrfbz4lxb5v9c59hk8c46";
      };
      packageRequires = [
        gnat-compiler
        uniquify-files
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ada-mode.html";
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
      version = "2020.1.0.20201129.190419";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ada-ref-man-2020.1.0.20201129.190419.tar";
        sha256 = "0a201fn9xs3vg52vri8aw2p56rsw428hk745m6hja6q5gn6rl0zw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ada-ref-man.html";
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
      version = "0.8.0.20240113.95028";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/adaptive-wrap-0.8.0.20240113.95028.tar";
        sha256 = "0dj20mmipnik62480cm11rnvsvbc3js2ql5r321kj20g87rz9l2a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/adaptive-wrap.html";
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
      version = "3.2.0.20240113.95404";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/adjust-parens-3.2.0.20240113.95404.tar";
        sha256 = "0l7s63dfpar2ddiydl43m6ipzc7qghv9k5hfcnj56aj6hs7ibcd2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/adjust-parens.html";
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
      version = "0.1.0.20201220.233221";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/advice-patch-0.1.0.20201220.233221.tar";
        sha256 = "1bca9s6cxpsyvyl0fxqa59x68rpdj44kxcaxmaa0lsy10vgib542";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/advice-patch.html";
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
      version = "1.7.0.20220417.71805";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/aggressive-completion-1.7.0.20220417.71805.tar";
        sha256 = "1nmh9as4m0xjvda1f0hda8s1wk1z973wlfxcfci768y45ffnjn0g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/aggressive-completion.html";
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
      version = "1.10.0.0.20230112.100030";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/aggressive-indent-1.10.0.0.20230112.100030.tar";
        sha256 = "0vp49nz5n82pcds2hxqz0fy5zcmvcrpfd1zgsm1cwyph7vvx7djj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/aggressive-indent.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  agitate = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "agitate";
      ename = "agitate";
      version = "0.0.20241021.65229";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/agitate-0.0.20241021.65229.tar";
        sha256 = "11f1yj937wfnn6d12845pwa8045wp5pk9mbcvzhigni3jkm8820p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/agitate.html";
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
      version = "1.10.0.0.20211231.115425";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ahungry-theme-1.10.0.0.20211231.115425.tar";
        sha256 = "0iddqqkv9i3d9yajhysl54av91i0gdngxqyn7vvapf1nz3pxzrvz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ahungry-theme.html";
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
      version = "0.0.6.0.20240613.140459";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/aircon-theme-0.0.6.0.20240613.140459.tar";
        sha256 = "1npppgbs1dfixqpmdc0nfxx4vvnsvpy101q8lcf7h9i8br63mlqy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/aircon-theme.html";
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
      version = "1.1.0.20240405.133638";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/all-1.1.0.20240405.133638.tar";
        sha256 = "0cybsyr7ksgslwdfnrz8cpymk34f9gz75ahz368rhg926qlxy95j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/all.html";
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
      version = "1.3.0.0.20250128.71323";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/altcaps-1.3.0.0.20250128.71323.tar";
        sha256 = "0ilfba0cz5rh1dwgbj9cvbj46kc98ipa2yw8cjcvr7267y30d2a3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/altcaps.html";
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
      version = "0.2.0.20240220.181558";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ampc-0.2.0.20240220.181558.tar";
        sha256 = "139gqhijy92qnprk25av550zd7165ilsnnmdx4v0v0fnwgxnya7h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ampc.html";
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
      version = "0.977.0.20221212.221354";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/arbitools-0.977.0.20221212.221354.tar";
        sha256 = "0s9w9hfki33bnfgm7yyhhcl0kbpn1ahd5li7nfy409zcb5spz17h";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/arbitools.html";
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
      version = "1.13.0.20230911.4520";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ascii-art-to-unicode-1.13.0.20230911.4520.tar";
        sha256 = "10x2svbc9qkrcckwjfsd1rlcqbvapvrb80x8m0p2awffwisr165j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ascii-art-to-unicode.html";
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
      version = "0.7.0.20240303.95456";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/assess-0.7.0.20240303.95456.tar";
        sha256 = "0yqiqlgnhqvqc4w9s05csk2h2iwyv1m32wb121v6famfqaicgl12";
      };
      packageRequires = [ m-buffer ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/assess.html";
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
      version = "1.9.9.0.20251005.63407";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/async-1.9.9.0.20251005.63407.tar";
        sha256 = "1mb8wvmkyi5baykccps4dl17jpk90yar043594aa7fsy8rqzdw7c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/async.html";
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
      version = "14.1.0.0.20251007.83053";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auctex-14.1.0.0.20251007.83053.tar";
        sha256 = "18v9vfscvkzsj106rr8wp690v71x9lfh952wvar4cvb1jw6715zy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auctex.html";
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
      version = "0.3.0.20250115.185937";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auctex-cont-latexmk-0.3.0.20250115.185937.tar";
        sha256 = "1rdnnc7ihg12dprivywjmhfl5s2cb58bl2n3fy7gf6h2wsjw0md5";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auctex-cont-latexmk.html";
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
      version = "0.2.0.20241019.12742";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auctex-label-numbers-0.2.0.20241019.12742.tar";
        sha256 = "0y4y8267r3bmwshcb5qkfrpnaxs1zwy1rwdhngjci005n68bslk9";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auctex-label-numbers.html";
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
      version = "7.0.20221221.74552";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/aumix-mode-7.0.20221221.74552.tar";
        sha256 = "0c3yhk8ir4adv3wy80iywbvl1sm86xssg0j0q4rym50pr4vqx60n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/aumix-mode.html";
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
      version = "0.3.1.0.20250905.185219";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auth-source-xoauth2-plugin-0.3.1.0.20250905.185219.tar";
        sha256 = "0jplpq1mrcqp924j12bc9kf949ndb64pzmrc4l1njn2wliykapq8";
      };
      packageRequires = [ oauth2 ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auth-source-xoauth2-plugin.html";
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
      version = "1.1.4.0.20221221.74656";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auto-correct-1.1.4.0.20221221.74656.tar";
        sha256 = "10h6b5px4krcwjwhc475al9kcizijsz773zkcijrfi83283l35nc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auto-correct.html";
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
      version = "0.10.10.0.20201215.220815";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/auto-overlays-0.10.10.0.20201215.220815.tar";
        sha256 = "1gmsli1bil210867x642x4zvhqradl3d4pk4n5ky5g6xp1h36c7w";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/auto-overlays.html";
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
      version = "0.4.2.0.20250415.115030";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/autocrypt-0.4.2.0.20250415.115030.tar";
        sha256 = "1lf52r37ik8y8chc047k6mya560q4ybbbq82brdm088rabl81khx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/autocrypt.html";
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
      version = "1.0.1.0.20250209.105211";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/autorevert-tail-truncate-1.0.1.0.20250209.105211.tar";
        sha256 = "07nlbvlassaj0rcph1kwf2h9bxdkfk3s77q300aj6kp0k73a17rd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/autorevert-tail-truncate.html";
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
      version = "0.5.0.0.20241101.125753";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/avy-0.5.0.0.20241101.125753.tar";
        sha256 = "0rg6jgq1iyhw7vwf8kv3mzjpwzbq44n5csv3lgd3hj8f72y4jpvb";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/avy.html";
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
      version = "3.2.2.4.0.20231023.5901";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bbdb-3.2.2.4.0.20231023.5901.tar";
        sha256 = "16m5irp1y9crv13l2qncafys4fscwq2d28ig8hnx4g5bag9bi7j4";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bbdb.html";
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
      version = "1.3.4.0.20220729.220057";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/beacon-1.3.4.0.20220729.220057.tar";
        sha256 = "1dpd3j2aip3zi3ivbszsgrifw43bryx01df868hmrxm1s0vvjhh6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/beacon.html";
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
      version = "1.4.0.0.20250808.63627";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/beframe-1.4.0.0.20250808.63627.tar";
        sha256 = "1pk37b1n7ng58ymajcq29ass1wgrpg0q48vrr22l7lwrpl6jcfx8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/beframe.html";
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
      version = "0.1.4.0.20251006.205101";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bicep-ts-mode-0.1.4.0.20251006.205101.tar";
        sha256 = "1ciq4v2h29ic3amh6qdl27miz23c71533rhks1i5w4xp6wxvs4iz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bicep-ts-mode.html";
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
      version = "2.4.1.0.20250611.62842";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bind-key-2.4.1.0.20250611.62842.tar";
        sha256 = "1wrkvjcbbki9lnlcq1miw3gnyayzmjg2wqrxwpyaq8429xh275qq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bind-key.html";
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
      version = "0.6.0.20250210.24138";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/blist-0.6.0.20250210.24138.tar";
        sha256 = "1rf4y81i7jmgqdma1i5gvr767mi2z7qpil4w9sak7graqj79vzn6";
      };
      packageRequires = [ ilist ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/blist.html";
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
      version = "0.4.1.0.20241028.70437";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bluetooth-0.4.1.0.20241028.70437.tar";
        sha256 = "0j4znabnbzdj2kskvma63svhiq2l3nahd7saqk2v2jc1xrzllfvm";
      };
      packageRequires = [
        compat
        dash
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bluetooth.html";
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
      version = "0.4.5.0.20240915.211838";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bnf-mode-0.4.5.0.20240915.211838.tar";
        sha256 = "109lfqv767ka7k8klxlr66sfzih2ypy4y0gkkrw5q14pzdx0149x";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bnf-mode.html";
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
      version = "2.0.0.0.20250325.150735";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/boxy-2.0.0.0.20250325.150735.tar";
        sha256 = "1qk6z7z9ya9d173c3ic5wmxvjq4gdk3z6817inpq43l2npq15hi6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/boxy.html";
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
      version = "2.1.10.0.20250128.144211";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/boxy-headings-2.1.10.0.20250128.144211.tar";
        sha256 = "0i48ld39vdq9skdi5pnbaf7izkmyrc2m9jb3ykppw3s1393xmcyg";
      };
      packageRequires = [
        boxy
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/boxy-headings.html";
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
      version = "1.0.1.0.20250208.145328";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/breadcrumb-1.0.1.0.20250208.145328.tar";
        sha256 = "1bj75faninnkm2cdy1x4c6f9kamf8wkwc1rf4il5khi6gyr0ki2z";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/breadcrumb.html";
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
      version = "5.92.0.20240823.62608";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/brief-5.92.0.20240823.62608.tar";
        sha256 = "0v2cdk4bs9xq7sn2a3qj3iaxmpmji5m9063cjhkhfd1crngv8a5a";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/brief.html";
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
      version = "0.6.0.20250516.122320";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/buffer-env-0.6.0.20250516.122320.tar";
        sha256 = "0m1kb8h2mjjd5hznp86yxjdic0zngq89x67vd7srvikxxbj312d9";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/buffer-env.html";
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
      version = "0.4.3.0.20190429.135558";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/buffer-expose-0.4.3.0.20190429.135558.tar";
        sha256 = "0f3a064i4a1ylb1ibqmz302h24kymir3zj1d225b7v6r89nam216";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/buffer-expose.html";
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
      version = "1.2.0.20250914.184401";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bufferlo-1.2.0.20250914.184401.tar";
        sha256 = "1xfgizjfwclgvy7sbjqfsrgp59xk8n7cixgkiwsnviysyyxh1rwv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bufferlo.html";
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
      version = "0.2.0.20250917.90933";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/buframe-0.2.0.20250917.90933.tar";
        sha256 = "1wlivzwzfmq3j8b1zgaw4bzln3c27d1xr9fvqq2p31cjh5ra36nl";
      };
      packageRequires = [ timeout ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/buframe.html";
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
      version = "1.3.1.0.20201128.92354";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/bug-hunter-1.3.1.0.20201128.92354.tar";
        sha256 = "1bskf9csg49n4cisl57wv0sa74s6v3wffdxw80m3r2yr0kx01cfs";
      };
      packageRequires = [
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/bug-hunter.html";
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
      version = "0.0.1.0.20230726.134747";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/buildbot-0.0.1.0.20230726.134747.tar";
        sha256 = "1z27pfx3h1fad9wiazrkqgfdc1h06g2rlb3cq1zk83hilg64nnjd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/buildbot.html";
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
      version = "1.4.1.0.20240208.85735";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/calibre-1.4.1.0.20240208.85735.tar";
        sha256 = "1rbmck8bc28c2rf321606w748nqc5klly6yrm3r8zyviggwd1v2c";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/calibre.html";
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
      version = "2.1.0.20250920.155804";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cape-2.1.0.20250920.155804.tar";
        sha256 = "1hh5adcv1d7p29bbd49351rn2kx57kld4g4qlp1ifzn02w1gfdpz";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cape.html";
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
      version = "0.3.0.20211123.104430";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/capf-autosuggest-0.3.0.20211123.104430.tar";
        sha256 = "0f16csl2ky8kys3wcv41zqh1l9976gc009pjy21kp6ck0pm0m3kg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/capf-autosuggest.html";
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
      version = "1.0.0.20221221.74713";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/caps-lock-1.0.0.20221221.74713.tar";
        sha256 = "0f8n79yw9zs1cpa8nhqmvw95kj762lv8rzrkj30ybvj1612vl1z9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/caps-lock.html";
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
      version = "1.0.3.0.20221221.74732";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/captain-1.0.3.0.20221221.74732.tar";
        sha256 = "0ay26xzbhrxgvslrwcc504k5s0kxk0c8rnps656xz1wl38fbvm5b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/captain.html";
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
      version = "2.0.5.0.20220926.150547";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/chess-2.0.5.0.20220926.150547.tar";
        sha256 = "16md052m600mmy43fgpcpwl4jz5q67v9w2h3y234ild6sp1qanlj";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/chess.html";
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
      version = "0.3.0.20221221.74800";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cl-generic-0.3.0.20221221.74800.tar";
        sha256 = "1yhjgcc3rnhi0kf2mgm7yii1pa9hzz0dnfkg393p456rl07q7vqq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cl-generic.html";
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
      version = "0.7.1.0.20221221.74809";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cl-lib-0.7.1.0.20221221.74809.tar";
        sha256 = "1xig9cma7p5bplnqnxmwh1axxlf813ar69bzyvks09yhg04jikm1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cl-lib.html";
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
      version = "0.3.0.20190215.154741";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/clipboard-collector-0.3.0.20190215.154741.tar";
        sha256 = "03y1wivagbsl4f2qgmxcy43pbpvpxhd1d57ihpdvsl2illb6bwlq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/clipboard-collector.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cobol-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cobol-mode";
      ename = "cobol-mode";
      version = "1.1.0.20250810.203242";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cobol-mode-1.1.0.20250810.203242.tar";
        sha256 = "16hkkrg551jsapnraf4vl19r53yl4ll3wdr49yxyy9qkiqvv2l25";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cobol-mode.html";
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
      version = "0.5.0.20250608.143915";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/code-cells-0.5.0.20250608.143915.tar";
        sha256 = "1chbb4sab9a73aj7a283g1qpsqbv6rvzfah4qqg5piykc2hk0yg0";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/code-cells.html";
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
      version = "1.2.4.0.20251006.212555";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/colorful-mode-1.2.4.0.20251006.212555.tar";
        sha256 = "170v711l6qapsypzg7i56kkmwvnzc0h625wbb5hgv205zkcqvrzw";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/colorful-mode.html";
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
      version = "0.7.0.20241116.123039";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/comint-mime-0.7.0.20241116.123039.tar";
        sha256 = "0sypcmpx5fyl92kkcaas3k877lwqvy02694riqp0rpm5rnpr182v";
      };
      packageRequires = [
        compat
        mathjax
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/comint-mime.html";
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
      version = "0.2.0.20220305.183958";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/compact-docstrings-0.2.0.20220305.183958.tar";
        sha256 = "024l45bxxkh6x7rd8qcmykxdhdj0yckcf7vzacl7ynzwm9ah7sry";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/compact-docstrings.html";
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
      version = "1.0.2.0.20250911.12909";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/company-1.0.2.0.20250911.12909.tar";
        sha256 = "1186p5rzaxiz9hc4s254b9q7c9vpqcdv788h87mnmniabv18yf26";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/company.html";
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
      version = "1.1.0.20221221.74915";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/company-ebdb-1.1.0.20221221.74915.tar";
        sha256 = "1qidrgcm2hdkrbh75rjfzxbmbyvxvyfy4m2kd6lgcx0v494lzvqw";
      };
      packageRequires = [
        company
        ebdb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/company-ebdb.html";
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
      version = "1.5.1.0.20221227.132907";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/company-math-1.5.1.0.20221227.132907.tar";
        sha256 = "070kfw13aw1hfvkdxb83zic44301nawnl57saqwrg6lh0psxpyxv";
      };
      packageRequires = [
        company
        math-symbol-lists
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/company-math.html";
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
      version = "0.2.3.0.20250805.152437";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/company-statistics-0.2.3.0.20250805.152437.tar";
        sha256 = "0r23dakpkakwv294snzfq7s6g56m48d0j9ncnmkyhs37vg51x21x";
      };
      packageRequires = [ company ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/company-statistics.html";
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
      version = "30.1.0.1.0.20250619.142858";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/compat-30.1.0.1.0.20250619.142858.tar";
        sha256 = "0lxpm1kbshrq6f2j9ihdd5xd6lwabmypfmlk9fp2ibzv32wwajv7";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/compat.html";
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
      version = "1.0.0.20250310.74521";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cond-star-1.0.0.20250310.74521.tar";
        sha256 = "1j7s227aih10np8j74b880lgk8v3g35dgpph23bzkqzrybl3w0z6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cond-star.html";
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
      version = "2.11.1.0.20240827.95043";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/constants-2.11.1.0.20240827.95043.tar";
        sha256 = "0ar6j385kifqyd01996li7ni1c1kwn11m80bssbc4agsrmk5kn02";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/constants.html";
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
      version = "2.8.0.20251008.43406";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/consult-2.8.0.20251008.43406.tar";
        sha256 = "05673j1jjr8il31g854ijgy73haplvcjsk0v41bri1iv9cyfiqaf";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/consult.html";
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
      version = "0.3.1.0.20250805.41616";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/consult-denote-0.3.1.0.20250805.41616.tar";
        sha256 = "1ryyjcxlqbkqiivbiazkj7pxqac9sn3kyczz103z9pmvf3g3wc1r";
      };
      packageRequires = [
        consult
        denote
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/consult-denote.html";
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
      version = "0.5.0.0.20250219.74017";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/consult-hoogle-0.5.0.0.20250219.74017.tar";
        sha256 = "0k0xqnwg75cm284niyfmcnmdx3qbnslr1ssz5hz0yca99bz8sypx";
      };
      packageRequires = [ consult ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/consult-hoogle.html";
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
      version = "1.0.0.0.20250223.210510";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/consult-recoll-1.0.0.0.20250223.210510.tar";
        sha256 = "1aivy3imjpkm5rbvcygyj8a42hmpkkld852jf4lkb42s4ifpf3i7";
      };
      packageRequires = [ consult ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/consult-recoll.html";
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
      version = "8.1.0.0.20240331.133753";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/context-coloring-8.1.0.0.20240331.133753.tar";
        sha256 = "1m8c7vccdb868n777rqi8mhjwfbm25q7hbx7x6y145mxmnqr1vgn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/context-coloring.html";
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
      version = "2.3.0.20250923.125035";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/corfu-2.3.0.20250923.125035.tar";
        sha256 = "0sc7q6l53d4vpyvnsnqhawl0bcl5p61nbna9v6xfrn1lw86xdcqi";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/corfu.html";
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
      version = "1.6.0.20221015.160420";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/coterm-1.6.0.20221015.160420.tar";
        sha256 = "1633q3vrqhjfv4ipirirgkpmal5j1rfh6jxkq3sm3qwlg8lgak4s";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/coterm.html";
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
      version = "0.15.1.0.20250329.151454";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/counsel-0.15.1.0.20250329.151454.tar";
        sha256 = "0fnxgf08dkq16d65xcaa822vasdqzixmd7ihw48hncx80jzqk1s6";
      };
      packageRequires = [
        ivy
        swiper
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/counsel.html";
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
      version = "0.17.0.20241101.133717";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cpio-mode-0.17.0.20241101.133717.tar";
        sha256 = "0kf5h4x3yz69360vp3ikqxrg1nx4cxnlv01kgfpm5kcr94zdzyka";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cpio-mode.html";
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
      version = "1.0.5.0.20230704.131557";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cpupower-1.0.5.0.20230704.131557.tar";
        sha256 = "1xls5wjxrx2a193piav0yp0sv1m7jv5zqk46hbxxhfakl3jg5zlq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cpupower.html";
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
      version = "0.3.5.0.20241129.104719";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/crdt-0.3.5.0.20241129.104719.tar";
        sha256 = "0aad3acn44av7c3cfdiyivqryvf3f330mm38w5hirv5v3zyx5arx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/crdt.html";
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
      version = "1.3.6.0.20221221.74923";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/crisp-1.3.6.0.20221221.74923.tar";
        sha256 = "0kpw81h9n8qwrvmqan9bwj32d4vgsrmma4f0rig04bdx0mxmdzir";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/crisp.html";
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
      version = "2.0.0.0.20221205.181941";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/csharp-mode-2.0.0.0.20221205.181941.tar";
        sha256 = "1cmc6b7pwjalzipc2clis2si7d03r0glpgxj7qpvfdp26y1cjabv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/csharp-mode.html";
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
      version = "1.27.0.20250307.75451";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/csv-mode-1.27.0.20250307.75451.tar";
        sha256 = "089z16kqm12zs7wrs46hskmz3mc1jqx00mzilaap197xq9hqkc3m";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/csv-mode.html";
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
      version = "1.1.5.0.20240818.152228";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cursor-undo-1.1.5.0.20240818.152228.tar";
        sha256 = "0hz6na9izpzbf50sq0bsy0q265g66ic67kc9zzhw0hqsfpym6b7f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cursor-undo.html";
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
      version = "1.2.0.0.20250722.60609";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cursory-1.2.0.0.20250722.60609.tar";
        sha256 = "140g6vi060ns4dippvq8z2j6ydsb54ygdk0scvg7igk2j0zndg35";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cursory.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cus-abbrev = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cus-abbrev";
      ename = "cus-abbrev";
      version = "0.1.0.20250307.190425";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cus-abbrev-0.1.0.20250307.190425.tar";
        sha256 = "1xjfdxr2yy7s5xq0732bczczm6c9ypkr1jlyl2jg240p51gg4kp8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cus-abbrev.html";
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
      version = "0.1.0.20221221.75021";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/cycle-quotes-0.1.0.20221221.75021.tar";
        sha256 = "0igwwbhf1b6c67znik3zphdngddkgai146qcjlkgg1ihr4ajc3pc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/cycle-quotes.html";
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
      version = "0.24.1.0.20251006.200603";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dape-0.24.1.0.20251006.200603.tar";
        sha256 = "1c1rkhzc2b8r8dnmh670gs9v9k5bh1kafkz2inli7f221hkmvq16";
      };
      packageRequires = [ jsonrpc ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dape.html";
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
      version = "0.3.0.20200507.173652";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/darkroom-0.3.0.20200507.173652.tar";
        sha256 = "1j57wa2jhpjs6ynda73s0vv4dzyr9jg0lifv7nc8bv79lr4sjab2";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/darkroom.html";
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
      version = "2.20.0.0.20250814.95131";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dash-2.20.0.0.20250814.95131.tar";
        sha256 = "06xrjbqbsr5ywd7pqi2gn2w9aavg3yr0vf0i8h40s5nhls683r41";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dash.html";
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
      version = "0.1.0.20220306.62546";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dbus-codegen-0.1.0.20220306.62546.tar";
        sha256 = "1jg8ibxy79g93b3hl97bpgz90ny5q936k8bjcmxix7hn82wg7a9l";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dbus-codegen.html";
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
      version = "0.45.0.20250929.72502";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/debbugs-0.45.0.20250929.72502.tar";
        sha256 = "1mfvlfsjx10ndns6rfl2sap2vfb8d602ng4sn0iw0la9ywsaw6pg";
      };
      packageRequires = [ soap-client ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/debbugs.html";
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
      version = "1.7.0.20200711.42851";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/delight-1.7.0.20200711.42851.tar";
        sha256 = "1v8yhii0s1rs1c2i7gs2rd98224qhpkybvrks8w5ghq4p3nxrrvw";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/delight.html";
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
      version = "4.0.0.0.20251007.45843";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-4.0.0.0.20251007.45843.tar";
        sha256 = "0b6fzi9mhkqy0wky7rz9nnq6x8wigagc5ry918qm9zb30f5pg1xg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote.html";
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
      version = "0.1.1.0.20250908.94202";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-journal-0.1.1.0.20250908.94202.tar";
        sha256 = "1gpyxh9bb1pk9frg676zazk8jdmy466r23110c3m59hx35rqmdy3";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-journal.html";
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
      version = "0.1.1.0.20250719.40600";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-markdown-0.1.1.0.20250719.40600.tar";
        sha256 = "1ck90jkhl7bm018hgpyl1g8f33jyaj5dk12b7khjx6a949ypx4nk";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-markdown.html";
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
      version = "1.4.0.0.20250829.94810";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-menu-1.4.0.0.20250829.94810.tar";
        sha256 = "1q0n6zrpilz20fj9b4fiianr68zpkdrfzh4nxhwim5z12dbkn3bb";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-menu.html";
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
      version = "0.1.1.0.20250829.181530";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-org-0.1.1.0.20250829.181530.tar";
        sha256 = "1y6fadg2wv5lizn7p53j2hziz8mq7r5m0pxvm253b9j8r6390r8k";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-org.html";
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
      version = "1.0.3.0.20250501.205109";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-search-1.0.3.0.20250501.205109.tar";
        sha256 = "0xpb39936fxldbv9d8i0122yvcapjvxkghv6d3ybxgm4wc8svbrn";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-search.html";
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
      version = "0.1.1.0.20250905.174858";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-sequence-0.1.1.0.20250905.174858.tar";
        sha256 = "126rhzjfbp1f94s8ivqis6vd2pi85zrn5ass5k8a6sd9sh4ahnja";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-sequence.html";
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
      version = "0.1.2.0.20250605.84406";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/denote-silo-0.1.2.0.20250605.84406.tar";
        sha256 = "12wj4ydi5gzavgxv3g170p7d8wi9ydqb2apnjvzq27gnf0n2kjzi";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/denote-silo.html";
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
      version = "0.10.1.0.20221129.143049";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/detached-0.10.1.0.20221129.143049.tar";
        sha256 = "0fidhqf1m599v939hv3xsqbkckgk2fm550i7lkh0p961a3v542i8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/detached.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  devdocs = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      mathjax,
    }:
    elpaBuild {
      pname = "devdocs";
      ename = "devdocs";
      version = "0.6.1.0.20250608.141406";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/devdocs-0.6.1.0.20250608.141406.tar";
        sha256 = "155j0c3ldrp16399fv1mqppkky0zzjy1d4bls83j8w3xl2r8ai4v";
      };
      packageRequires = [
        compat
        mathjax
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/devdocs.html";
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
      version = "0.3.0.20240117.132538";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/devicetree-ts-mode-0.3.0.20240117.132538.tar";
        sha256 = "12jfiv7j0k5sqjbz28nd5x34hpxp76lyl41fl7bvsgiyb06i0gnf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/devicetree-ts-mode.html";
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
      version = "1.0.0.20251008.104111";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dicom-1.0.0.20251008.104111.tar";
        sha256 = "0fmrnw2phx45xfshi9hwjldk8hbcywdnf9dv0q2cs7yw3l60f02n";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dicom.html";
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
      version = "0.17.0.20231015.24654";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dict-tree-0.17.0.20231015.24654.tar";
        sha256 = "0nij9pkscr6mdjmrq9dlqnks91sd21pn01bsgn4zk918zygnkggj";
      };
      packageRequires = [
        heap
        tNFA
        trie
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dict-tree.html";
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
      version = "1.10.0.0.20251008.224129";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/diff-hl-1.10.0.0.20251008.224129.tar";
        sha256 = "1161jxws89flszfy9x7wrz1jzzlg3c9xbpcnik9x3x5wamhr7bh9";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/diff-hl.html";
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
      version = "1.0.0.20230224.111651";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/diffview-1.0.0.20230224.111651.tar";
        sha256 = "1shw58jk2dzr8sc9hhfjqjrmwqarvq989ic96zjmhajxvcqcz3ql";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/diffview.html";
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
      version = "0.46.0.20220909.84745";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/diminish-0.46.0.20220909.84745.tar";
        sha256 = "1d31bk42p1qjhpbr6lin87y18nya1qk9dm37vhhiq5sxajfr5ab9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/diminish.html";
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
      version = "0.5.2.0.20221221.75108";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dired-du-0.5.2.0.20221221.75108.tar";
        sha256 = "0h31k45sx47vmk20sn77fzz86gbwiqxrryr091p5s05smrlsfxc2";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dired-du.html";
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
      version = "0.4.0.20240328.201645";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dired-duplicates-0.4.0.20240328.201645.tar";
        sha256 = "0122wxl2sql31s4h7rf7mxz6kv15m77q9bqmixxsgzhfghbia7k7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dired-duplicates.html";
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
      version = "0.3.1.0.20191229.192948";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dired-git-info-0.3.1.0.20191229.192948.tar";
        sha256 = "0zq74nynra4cbyb81l3v9w0qrzz057z9abg6c6zjshlrq8kxv5kx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dired-git-info.html";
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
      version = "0.6.0.0.20250720.94036";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dired-preview-0.6.0.0.20250720.94036.tar";
        sha256 = "09cvi5kcdzghm1l657jnfsvdnfnkfnl76m9vnai49z53a66iivkc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dired-preview.html";
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
      version = "1.3.3.0.20230920.164444";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/disk-usage-1.3.3.0.20230920.164444.tar";
        sha256 = "06vd56yaaz9a6b46g4r6ccasc74pyqls9krj3bcrdayhj34w3mxy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/disk-usage.html";
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
      version = "1.5.2.0.20221221.75154";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dismal-1.5.2.0.20221221.75154.tar";
        sha256 = "0nyy9dkafkzxvx60d1bzrn2a1m3n53al3x17r3kf7d2b24gcljbd";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dismal.html";
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
      version = "1.1.2.0.20221221.75224";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/djvu-1.1.2.0.20221221.75224.tar";
        sha256 = "0iirmzaah0nix14jaj0hnszrdkdsh4wli8hb951l7iw7szkc5fsp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/djvu.html";
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
      version = "0.1.2.0.20250501.125137";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/do-at-point-0.1.2.0.20250501.125137.tar";
        sha256 = "1sszwgf740yklj2cm47rzc5ia8ygn8vzfagpadcsv38mpcxpdzz0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/do-at-point.html";
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
      version = "1.2.0.20230409.212954";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/doc-toc-1.2.0.20230409.212954.tar";
        sha256 = "1gcdkcb1ydgl24jmrnkg1a7kndl7kkvckwf12y5pj2l2idf9ifx8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/doc-toc.html";
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
      version = "0.3.2.0.20250427.143824";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/doc-view-follow-0.3.2.0.20250427.143824.tar";
        sha256 = "04jk93rkv682w6zcfr283gpwgi5fiq5w3xdpv49zkwddx783crfa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/doc-view-follow.html";
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
      version = "0.1.0.20221221.75233";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/docbook-0.1.0.20221221.75233.tar";
        sha256 = "0r7sjnbj4wgqa2vw57ac28gixw762km0cwas0qhclxizb95nsnz2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/docbook.html";
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
      version = "0.4.0.0.20251004.101735";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/doric-themes-0.4.0.0.20251004.101735.tar";
        sha256 = "1dlsfy3faww658v03886gc44mf696pjr33igp2cfzw9ya1xsszaf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/doric-themes.html";
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
      version = "0.3.0.20240929.81709";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/drepl-0.3.0.20240929.81709.tar";
        sha256 = "14b8argsv9i1aqzvkkx11810g9rf93kn6kz2qcd552pxllcpyf1l";
      };
      packageRequires = [ comint-mime ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/drepl.html";
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
      version = "1.0.0.20221221.75311";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/dts-mode-1.0.0.20221221.75311.tar";
        sha256 = "1bpd6npx70rzh3mb5235g1ydh839bnjag70qp17r0wd2wkj6w0gj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/dts-mode.html";
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
      version = "0.2.1.0.20210917.85414";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/easy-escape-0.2.1.0.20210917.85414.tar";
        sha256 = "0hk9244g7hgnan7xd4451qjklfqh5hbkxjl60l32nr19ynw0ygif";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/easy-escape.html";
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
      version = "0.9.5.0.20220511.55730";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/easy-kill-0.9.5.0.20220511.55730.tar";
        sha256 = "0il8lhi2j80sz63lnjkayryikcya03zn3z40bnfjbsydpyqj4kzd";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/easy-kill.html";
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
      version = "0.8.22.0.20240305.123820";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ebdb-0.8.22.0.20240305.123820.tar";
        sha256 = "0j6wflmslapq3wr5bg6ql7qamh9k9zzp1xzadkxq3i3124syanfs";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ebdb.html";
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
      version = "1.0.2.0.20221221.75324";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ebdb-gnorb-1.0.2.0.20221221.75324.tar";
        sha256 = "0lzsarv0pkdgkj19il0syk7yz6gcfkp0rl3i49rsqb3lpf5b6s5q";
      };
      packageRequires = [
        ebdb
        gnorb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ebdb-gnorb.html";
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
      version = "1.3.2.0.20221221.75334";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ebdb-i18n-chn-1.3.2.0.20221221.75334.tar";
        sha256 = "16hna0z08903pkq957cgxk26ihq6j3fab775ickb24zfssjm3l61";
      };
      packageRequires = [
        ebdb
        pyim
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ebdb-i18n-chn.html";
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
      version = "2.3.0.20241006.95158";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ediprolog-2.3.0.20241006.95158.tar";
        sha256 = "1xwha4xn7hpb57vvlrhcm5z0r59wz82vrcdx13kp46zvmll0zcrd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ediprolog.html";
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
      version = "20250914.0.20250914.191243";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/eev-20250914.0.20250914.191243.tar";
        sha256 = "1ns804y302xdnvf2vczk4banvcysgw5dv54yv3ffjsjchgn2z5qs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/eev.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ef-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      modus-themes,
    }:
    elpaBuild {
      pname = "ef-themes";
      ename = "ef-themes";
      version = "1.11.0.0.20251007.75143";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ef-themes-1.11.0.0.20251007.75143.tar";
        sha256 = "1sg7dhgxrgs7c2sy4128rv1iikj9ymigiwz3kx0a1smwn6vrmh71";
      };
      packageRequires = [ modus-themes ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ef-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eglot = callPackage (
    {
      eldoc,
      elpaBuild,
      external-completion,
      fetchurl,
      flymake ? null,
      jsonrpc,
      lib,
      project,
      seq,
      xref,
    }:
    elpaBuild {
      pname = "eglot";
      ename = "eglot";
      version = "1.18.0.20251003.84456";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/eglot-1.18.0.20251003.84456.tar";
        sha256 = "0avj1q1m7qmdivvz3nqysbq9lxnzpy6cfw599wl44ij5xdfnpwrx";
      };
      packageRequires = [
        eldoc
        external-completion
        flymake
        jsonrpc
        project
        seq
        xref
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/eglot.html";
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
      version = "2.5.3.0.20251008.162616";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/el-job-2.5.3.0.20251008.162616.tar";
        sha256 = "0vqng5mcrpima2wnpgs5cqb1v0fk0d2fcpz15vq8pcdsd3zm7h10";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/el-job.html";
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
      version = "1.12.6.1.0.20250307.74553";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/el-search-1.12.6.1.0.20250307.74553.tar";
        sha256 = "053bzm8gz336krhivkp6sb6gbl7788mp8zx3xsfdwxdxrib72hf8";
      };
      packageRequires = [
        cl-print
        stream
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/el-search.html";
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
      version = "1.16.0.0.20250709.192845";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/eldoc-1.16.0.0.20250709.192845.tar";
        sha256 = "1n35mlpl1r2kxvp6z0ah3zykgjlam9pq2mxbap0iamhmvrp27537";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/eldoc.html";
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
      version = "5.0.0.20201201.154407";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/electric-spacing-5.0.0.20201201.154407.tar";
        sha256 = "0ywa68zwci0v6g9nc8czlhvf9872vl262nrxffahc5r7lp1hay8k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/electric-spacing.html";
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
      version = "1.1.7.0.20250202.204048";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/elisa-1.1.7.0.20250202.204048.tar";
        sha256 = "0bs2cb2i18afd1vnrfszdj9kxqmr678l01a8l4rz19yv7iril299";
      };
      packageRequires = [
        async
        ellama
        llm
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/elisa.html";
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
      version = "1.16.0.20250424.171436";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/elisp-benchmarks-1.16.0.20250424.171436.tar";
        sha256 = "06ryqghnn904c7qjxdi5qy6fi4b6c73i6mlqh4sal6f7p2624k4i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/elisp-benchmarks.html";
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
      version = "1.8.6.0.20250918.160602";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ellama-1.8.6.0.20250918.160602.tar";
        sha256 = "0x1nndmivxvhpqjbns038qpksr9g02gh7rpg9r1jmkdmhvkiihgp";
      };
      packageRequires = [
        compat
        llm
        plz
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ellama.html";
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
      version = "1.4.2.0.20231206.152254";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/emacs-gc-stats-1.4.2.0.20231206.152254.tar";
        sha256 = "08ivfm6m9y4i1w0xmjkbs6b2h7i5q1v2991rjs2w5s9d864yqg2l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/emacs-gc-stats.html";
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
      version = "1.1.0.20250825.75213";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/embark-1.1.0.20250825.75213.tar";
        sha256 = "0x5zg5rlhx4vlhijsjb1mjxmbc3g6mk4qf5s98ma71wprvfx3c8y";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/embark.html";
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
      version = "1.1.0.20250825.75213";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/embark-consult-1.1.0.20250825.75213.tar";
        sha256 = "0ypm3z99kd8kiszih55ysh7jhcf711s7qqyg3m8byli6wff4h40x";
      };
      packageRequires = [
        compat
        consult
        embark
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/embark-consult.html";
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
      version = "0.17pre0.20250511.153249";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ement-0.17pre0.20250511.153249.tar";
        sha256 = "0vkkk79z2q73niffjkjbywiqr3ykdvb9ssq3095kxjnrc7k6vzvz";
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
        homepage = "https://elpa.gnu.org/devel/ement.html";
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
      version = "23.0.20251002.104209";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/emms-23.0.20251002.104209.tar";
        sha256 = "072l1pkqwpkk00px2251jvl4x0769kjlldd6l4a5d1cdi0kam074";
      };
      packageRequires = [
        cl-lib
        nadvice
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/emms.html";
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
      version = "0.3.1.0.20240421.82802";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/engrave-faces-0.3.1.0.20240421.82802.tar";
        sha256 = "0dxj9m9jyvrqhv67m2kkh0akjc7l6h40fvsy20k721zq9xvc6zkl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/engrave-faces.html";
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
      version = "2.0.0.20171007.121321";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/enwc-2.0.0.20171007.121321.tar";
        sha256 = "0c308kd1pinhb1lh2vi40bcnmvzydf1j7sqka9kajhxr0l4kjazb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/enwc.html";
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
      version = "0.0.1.0.20221221.75416";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/epoch-view-0.0.1.0.20221221.75416.tar";
        sha256 = "0hd51d441c2w05rx10wpa0rbc94pjwwaqy5mxlgfwnx52jabz15h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/epoch-view.html";
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
      version = "5.6.1snapshot0.20250904.171225";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/erc-5.6.1snapshot0.20250904.171225.tar";
        sha256 = "07mm33az8c055p2i22ihp4vrs460wvk75fdcy960b45qlsd19kwp";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/erc.html";
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
      nadvice,
    }:
    elpaBuild {
      pname = "ergoemacs-mode";
      ename = "ergoemacs-mode";
      version = "5.16.10.12.0.20240828.210215";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ergoemacs-mode-5.16.10.12.0.20240828.210215.tar";
        sha256 = "1n87f2si44hyyiy3nj3hr0pjxkjdb419pkybs7vawi27k59dd8rw";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ergoemacs-mode.html";
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
      version = "25.1.0.0.20251003.204431";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ess-25.1.0.0.20251003.204431.tar";
        sha256 = "1njv0vdxi7v9wn00mn0k3qxhxliz80hh74jx9nzm4j2n003lf8y9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ess.html";
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
      version = "1.1.3.0.20250627.211849";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/excorporate-1.1.3.0.20250627.211849.tar";
        sha256 = "16vj05282g69f3p6b3f9nfgnd6c8d6jan0srbfrxjiqmvlx51cxv";
      };
      packageRequires = [
        fsm
        soap-client
        url-http-ntlm
        url-http-oauth
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/excorporate.html";
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
      version = "1.0.0.0.20241217.184034";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/expand-region-1.0.0.0.20241217.184034.tar";
        sha256 = "1bh8109irsh2hpk70fg38d0rf8as32a39677gz1m7k7v4fvs3nv5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/expand-region.html";
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
      version = "1.4.1.0.20250918.220913";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/expreg-1.4.1.0.20250918.220913.tar";
        sha256 = "1fdwxr3albv7ww87w8ib8r0rid8zkibcgbl3qhp29vm8g28s89ws";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/expreg.html";
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
      version = "0.1.0.20250806.111358";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/external-completion-0.1.0.20250806.111358.tar";
        sha256 = "15r86524q9645xcdhb0ciygfrcnjy9sfihk50i39wqzv9nnp4dhq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/external-completion.html";
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
      version = "0.34.0.20250919.75516";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/exwm-0.34.0.20250919.75516.tar";
        sha256 = "1fm2mmni78xif4lva5rwsrv40ywbz8m0cc1gl3krqsilb3a150y8";
      };
      packageRequires = [
        compat
        xelb
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/exwm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  f90-interface-browser = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "f90-interface-browser";
      ename = "f90-interface-browser";
      version = "1.1.0.20221221.75553";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/f90-interface-browser-1.1.0.20221221.75553.tar";
        sha256 = "0qv3v3ya8qdgwq0plcc3qbba4n66fqww3sawmqhzssksry39l1yj";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/f90-interface-browser.html";
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
      version = "0.2.4.0.20250910.151030";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/filechooser-0.2.4.0.20250910.151030.tar";
        sha256 = "1b82fyqvbaq0mq6pz6m6i0h3i6kjcz59a3i9qfzlhvvjfa07zfyp";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/filechooser.html";
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
      version = "2.12.2.0.20221221.75607";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/filladapt-2.12.2.0.20221221.75607.tar";
        sha256 = "11s9n8d4psjs4dbsx2w8hyir5hapz952da5nz3xihli8a0q93mhv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/filladapt.html";
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
      version = "0.9.5.0.20230605.161924";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/firefox-javascript-repl-0.9.5.0.20230605.161924.tar";
        sha256 = "1nfkzx07j3hddai213lia9pixfrrdajrvg7fvlx5js8zxfpvcjx6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/firefox-javascript-repl.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flylisp = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flylisp";
      ename = "flylisp";
      version = "0.2.0.20221221.75619";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/flylisp-0.2.0.20221221.75619.tar";
        sha256 = "110hfk979c664y27qf5af54phm8i4iq5qqk5vygjwd7252nd7i4a";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/flylisp.html";
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
      version = "1.4.1.0.20250906.55308";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/flymake-1.4.1.0.20250906.55308.tar";
        sha256 = "1wy77d63mlcax9sksf3js0acqmx33hkn03iz37aqlyikjy51vbs9";
      };
      packageRequires = [
        eldoc
        project
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/flymake.html";
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
      version = "1.1.0.0.20250323.141048";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/flymake-clippy-1.1.0.0.20250323.141048.tar";
        sha256 = "04w4z16iny2z22wffzgrkijsxyjcd24p2ip5yx35wvk7np6r3hxk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/flymake-clippy.html";
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
      version = "0.1.0.20231030.222337";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/flymake-codespell-0.1.0.20231030.222337.tar";
        sha256 = "1v3a2gg4myav4cs1vj4d5isxhbw9qvryk5r2dx3x19qqmmmm6djz";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/flymake-codespell.html";
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
      version = "0.3.0.0.20230325.160756";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/flymake-proselint-0.3.0.0.20230325.160756.tar";
        sha256 = "1p3jpsv6w4hask7bk07dmafwgymbw3xl6i0vx0sjd0i5aa0xs9vz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/flymake-proselint.html";
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
      version = "3.0.1.0.20250710.40159";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/fontaine-3.0.1.0.20250710.40159.tar";
        sha256 = "0sb35y50ja6k2fagxaibbi85xq8q3g25k5ci9pwgi355s24yzq77";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/fontaine.html";
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
      version = "1.1.0.20221221.75627";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/frame-tabs-1.1.0.20221221.75627.tar";
        sha256 = "08ql56h8h425ngs40m9zpy4ysxlxi74vanlkga42bskzax0ns2cm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/frame-tabs.html";
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
      version = "0.2.11.0.20201115.95734";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/frog-menu-0.2.11.0.20201115.95734.tar";
        sha256 = "00ihlqq4bxgrp6hdf1b6xhnvp87ilys1ykp0l38cs5lv6a10wvqs";
      };
      packageRequires = [
        avy
        posframe
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/frog-menu.html";
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
      version = "0.2.1.0.20221212.223608";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/fsm-0.2.1.0.20221212.223608.tar";
        sha256 = "1zwl1b9sn4imxynada0vf8nxwm49lh8fahxfc35czlbn0w0jqm1k";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/fsm.html";
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
      version = "1.1.0.20230102.145125";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ftable-1.1.0.20230102.145125.tar";
        sha256 = "0231qjah5s76g8dmnc5zpn6i6lysypf6jvvzmnyyv92lr8arzmfz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ftable.html";
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
      version = "0.2.1.0.20201116.225142";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gcmh-0.2.1.0.20201116.225142.tar";
        sha256 = "0yb47avdy5f3a2g9cg2028h5agsqpddsbfsc6ncavnxnnyiccj8h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gcmh.html";
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
      version = "0.9.0.0.20230602.13355";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ggtags-0.9.0.0.20230602.13355.tar";
        sha256 = "1krykf1hknczhdhh8rfj4vzcba87q5sjbv0p2y41mcvmmfnhharw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ggtags.html";
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
      version = "0.6.0.0.20221221.75709";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gited-0.6.0.0.20221221.75709.tar";
        sha256 = "095679pq1lam42zran5qjk3zd4gf908vd5fkq9jppqlilcsqf7zb";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gited.html";
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
      version = "1.1.0.20221221.75729";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gle-mode-1.1.0.20221221.75729.tar";
        sha256 = "1bakvlx4bzz62hibwwm0hmhyzqqzy31xvsg6pw3lh2i028qd1ykx";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gle-mode.html";
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
      version = "1.0.3.0.20230915.165808";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnat-compiler-1.0.3.0.20230915.165808.tar";
        sha256 = "0rm0s33nl9dzghlfsprycr2na412z4vnfc69q2pc6nlazsliz6w0";
      };
      packageRequires = [ wisi ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnat-compiler.html";
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
      version = "0.1.0.20230924.235858";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnome-c-style-0.1.0.20230924.235858.tar";
        sha256 = "0gij2d1k40yhifr7ad3p465f5lg77cb441pl41mdc0g6v5gipnqf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnome-c-style.html";
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
      version = "0.2.3.0.20250325.182321";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnome-dark-style-0.2.3.0.20250325.182321.tar";
        sha256 = "1kk6pgl79zgd2jvnh011177080w7vz2561mqi88s1rpv43lf4qxa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnome-dark-style.html";
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
      version = "1.6.11.0.20230108.110132";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnorb-1.6.11.0.20230108.110132.tar";
        sha256 = "0jha80xr8pbribp0ki40cydvi35as7v2c2xsy0anh65j9ciym5ag";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnorb.html";
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
      version = "1.1.0.20221212.224322";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnu-elpa-1.1.0.20221212.224322.tar";
        sha256 = "0hk9ha7f0721wnsnjazpr970lfa4q03dhpxxffw9qcn1mlvh8qb8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnu-elpa.html";
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
      version = "2025.10.1.0.20251008.190710";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnu-elpa-keyring-update-2025.10.1.0.20251008.190710.tar";
        sha256 = "0fvx7yh0n3glb8h2m9bb3an0q2pc34qpxcwz3ggsgp3fwsxf3k6f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnu-elpa-keyring-update.html";
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
      version = "3.1.2.0.20250131.151403";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnugo-3.1.2.0.20250131.151403.tar";
        sha256 = "1afx15bab0zx5iykx9fjn0k32m8rj58n2998kgvpmnyxwl449v77";
      };
      packageRequires = [
        ascii-art-to-unicode
        cl-lib
        xpm
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnugo.html";
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
      version = "0.5.0.20210503.105756";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gnus-mock-0.5.0.20210503.105756.tar";
        sha256 = "1gpjbx9iabrx2b4qinw0chv44g2v1z2ivaiywjzr3vy3h3pp6fga";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gnus-mock.html";
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
      version = "0.5.0.0.20231030.71342";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gpastel-0.5.0.0.20231030.71342.tar";
        sha256 = "1d5pj1rk0xv2fww827yplpcll5hy8w9fkcm9c8wf4yi3l6igkmgz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gpastel.html";
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
      version = "1.0.5.0.20231115.90848";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gpr-mode-1.0.5.0.20231115.90848.tar";
        sha256 = "1m768s196027zl402vmfvdzvdl3whbjg5lyfiwjx25d9gfx32351";
      };
      packageRequires = [
        gnat-compiler
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gpr-mode.html";
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
      version = "1.0.4.0.20251001.94944";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gpr-query-1.0.4.0.20251001.94944.tar";
        sha256 = "17cj6rks98nc40991nwzx8znbws1pkjhfsnznfhack76i8612hxi";
      };
      packageRequires = [
        gnat-compiler
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gpr-query.html";
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
      version = "0.1.2.0.20221202.2453";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/graphql-0.1.2.0.20221202.2453.tar";
        sha256 = "0wh1lnn85nj026iln02b7p5hgrwd3dmqjkv48gc33ypyd4afh31z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/graphql.html";
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
      version = "0.12.7.0.20250722.52020";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/greader-0.12.7.0.20250722.52020.tar";
        sha256 = "0zgwih2mz53igjqw4ifk7qa82dbvxiz5hfyydz4nlh6x18ysg825";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/greader.html";
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
      version = "1.2.0.20250603.210745";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/greenbar-1.2.0.20250603.210745.tar";
        sha256 = "1rx0jivxr95pjfksf1k8dl2ic9sqmss7rm2cvq5ghazv2r1lpl1k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/greenbar.html";
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
      version = "1.9.3.0.20250618.235351";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/gtags-mode-1.9.3.0.20250618.235351.tar";
        sha256 = "0009dg34n71lgf28dsqaghzyykfvid9la5mz6aw1d3130x6hd46j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/gtags-mode.html";
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
      version = "0.0.1.0.20240528.185800";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/guess-language-0.0.1.0.20240528.185800.tar";
        sha256 = "0hlcnd69mqs90ndp59pqcjdwl27cswnpqy6yjzaspmbya6plv3g6";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/guess-language.html";
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
      version = "1.0.0.0.20221012.11633";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hcel-1.0.0.0.20221012.11633.tar";
        sha256 = "03k08w10bvl6fz7nkmv2d7kksphxigw6cwfhfq0kkgxn4l8h37an";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hcel.html";
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
      version = "0.5.0.20201214.121301";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/heap-0.5.0.20201214.121301.tar";
        sha256 = "0917bfrdiwwmdqmnpy2cg1dn7v5gyl7damwp6ld7sky6v3d113ya";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/heap.html";
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
      version = "1.2.0.20250305.95113";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hiddenquote-1.2.0.20250305.95113.tar";
        sha256 = "114gvcz1p3s9ksnl2ljjv0h1ncn3ad0pfi1wnga9ab07h7l46jn5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hiddenquote.html";
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
      version = "0.4.0.20201214.173014";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/highlight-escape-sequences-0.4.0.20201214.173014.tar";
        sha256 = "13x8750r3zn9sqbsxliiipk6kfnpg7clmd49niyrh80x9nj4pf72";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/highlight-escape-sequences.html";
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
      version = "1.1.1.0.20201201.93957";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hook-helpers-1.1.1.0.20201201.93957.tar";
        sha256 = "0x3358k5lglnb4yf27c2ybzlsw9jp4n4jh5sizczl9n8g1vxbgkb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hook-helpers.html";
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
      version = "0.1.0.20221221.80245";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/html5-schema-0.1.0.20221221.80245.tar";
        sha256 = "15f1nhsgpp0mv8mdrvv0jnscq0j23ggriw2d2dw26sr6lv93w2r4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/html5-schema.html";
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
      version = "0.2.1.0.20250324.144142";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hugoista-0.2.1.0.20250324.144142.tar";
        sha256 = "0kmm5zdy8jw1hzr11f9aahqsbnclr1qlphh6picpyh7x0sc2nl2z";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hugoista.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hydra = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      lv,
    }:
    elpaBuild {
      pname = "hydra";
      ename = "hydra";
      version = "0.15.0.0.20250316.223951";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hydra-0.15.0.0.20250316.223951.tar";
        sha256 = "1zm3d5pcyblsq0r7aapwcankk80xls3821bvjf12cnzmapy9772a";
      };
      packageRequires = [ lv ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hydra.html";
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
      version = "9.0.2pre0.20250914.231303";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/hyperbole-9.0.2pre0.20250914.231303.tar";
        sha256 = "07nk16nkvl9myr7mxhrql5wpxsr1qa2nj4r76x4fh6lvsh9nfnim";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/hyperbole.html";
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
      version = "6.5.1.0.20240523.142720";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/idlwave-6.5.1.0.20240523.142720.tar";
        sha256 = "00i7kl0j7aacm7vyjgmm2kqhjjb3s70g69ka3sqhigm7s1hn3zk9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/idlwave.html";
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
      version = "0.4.0.20240807.41050";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ilist-0.4.0.20240807.41050.tar";
        sha256 = "1j9ihvkbribvach3z23qw1fcf03gm9ijhmh6mrcvagcy7gllz02n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ilist.html";
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
      version = "0.9.2.0.20250719.204514";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/indent-bars-0.9.2.0.20250719.204514.tar";
        sha256 = "0dvbgzkqdnbk65gsk1mh7cn06w6n5qmdpm4mmswkx57g479j68ni";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/indent-bars.html";
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
      version = "0.38.0.20241108.155318";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/inspector-0.38.0.20241108.155318.tar";
        sha256 = "1x0cgn7w1gdm60hg7a2ym82hvf60l594v7k4mrln87m1yk4wqgak";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/inspector.html";
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
      version = "2.6.0.20211231.163129";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ioccur-2.6.0.20211231.163129.tar";
        sha256 = "0v048d1p95km3jwgs6x805fjg6qfv5pjwdwia1wzl9liqai21v1c";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ioccur.html";
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
      version = "0.8.0.20240310.84654";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/isearch-mb-0.8.0.20240310.84654.tar";
        sha256 = "1rb97ir8nbv7ici8isjcm4bfaxakd6a05yxv9as2wv9xl8fzfhwq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/isearch-mb.html";
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
      version = "1.2.0.0.20250822.220102";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/iso-date-1.2.0.0.20250822.220102.tar";
        sha256 = "00x25a6rfck3dmsxir62j6zp433jl1mamk7w5vgnd69s883x95vp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/iso-date.html";
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
      version = "0.1.1.0.20221221.80300";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/iterators-0.1.1.0.20221221.80300.tar";
        sha256 = "10cx933rk7f92jk8q87b69ls3w823fwxnr7i6j0bxpzjx66q15yk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/iterators.html";
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
      version = "0.15.1.0.20250519.175035";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ivy-0.15.1.0.20250519.175035.tar";
        sha256 = "094xx1zpxs1qf799s3cv2ymr5q7bgs87yr8haf6wqwf44rxdwycw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ivy.html";
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
      version = "0.15.1.0.20250329.150930";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ivy-avy-0.15.1.0.20250329.150930.tar";
        sha256 = "0zqjfv86p52nr5vfmnliw5awsrzxalhlqwkninnp9sxgdib59z0k";
      };
      packageRequires = [
        avy
        ivy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ivy-avy.html";
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
      version = "0.3.2.0.20190909.192125";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ivy-explorer-0.3.2.0.20190909.192125.tar";
        sha256 = "1jvahaswknvaia62cq8bz5lx55fb1c07zr63n7awcp0sajk3ph3z";
      };
      packageRequires = [ ivy ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ivy-explorer.html";
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
      version = "0.15.1.0.20250329.151244";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ivy-hydra-0.15.1.0.20250329.151244.tar";
        sha256 = "19a9bs0hynz203zw6f1y3khgyd3nv7mf3pp2da5gd6h0012j3k5s";
      };
      packageRequires = [
        hydra
        ivy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ivy-hydra.html";
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
      version = "0.6.3.0.20241023.25839";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ivy-posframe-0.6.3.0.20241023.25839.tar";
        sha256 = "01wiviygb0c5kjdds1fk10jf9rcf6f59iychqp42yk2lghhw9k1z";
      };
      packageRequires = [
        ivy
        posframe
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ivy-posframe.html";
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
      version = "0.0.4.0.20240204.184721";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jami-bot-0.0.4.0.20240204.184721.tar";
        sha256 = "04zdnrah3jypkyx8dl0ns7cjcws5yv4d56ixaa94vjjjvyw9d8mv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jami-bot.html";
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
      version = "0.11.0.0.20231010.221311";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jarchive-0.11.0.0.20231010.221311.tar";
        sha256 = "122qffkbl5in1y1zpphn38kmg49xpvddxzf8im9hcvigf7dik6f5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jarchive.html";
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
      version = "0.9.1.0.20241129.211411";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/javaimp-0.9.1.0.20241129.211411.tar";
        sha256 = "1i7jga44n7rdfb51y72x6c3j0k2pwb90x1xz3m0j0iq4avy89dj9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/javaimp.html";
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
      version = "1.1.0.20221221.80333";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jgraph-mode-1.1.0.20221221.80333.tar";
        sha256 = "1ddmyxanfnqfmwx3ld25awm4qhwbzavla8xan261nyh4wwnm8hfq";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jgraph-mode.html";
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
      version = "2.3.0.20251007.170933";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jinx-2.3.0.20251007.170933.tar";
        sha256 = "0ihjqsvckn08fq9z1c8yy8ic1lfjzid2835s8xa2sq07qk7389fi";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jinx.html";
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
      version = "0.4.0.20240810.110215";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jit-spell-0.4.0.20240810.110215.tar";
        sha256 = "0k4icsk8wdshdza9mgdlfyg5ybnhkzdwjjkjq4s2g6d5h0ai1xzl";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jit-spell.html";
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
      version = "20231224.0.20241205.14012";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/js2-mode-20231224.0.20241205.14012.tar";
        sha256 = "0kcxgkib56fjgv9c2ancr046ag3nwr6zw5x2dzw9gbnlma5w3x66";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/js2-mode.html";
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
      version = "0.2.0.20250307.75711";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/json-mode-0.2.0.20250307.75711.tar";
        sha256 = "06554pl40d8cgnabcxvixsdn904z28zsl579w6y64cqjf3da4qx3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/json-mode.html";
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
      version = "1.0.25.0.20250907.123924";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jsonrpc-1.0.25.0.20250907.123924.tar";
        sha256 = "115x2m52fga5mxj9dbvc2vk380m5qx130zczaisgc2r23qw8gwjb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jsonrpc.html";
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
      version = "3.1.0.20231015.14814";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/jumpc-3.1.0.20231015.14814.tar";
        sha256 = "1v8jxyvs0540w6rdsy96a49lb8nhrq4r66mmvc42j8lh7k4nggdw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/jumpc.html";
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
      version = "0.2.2.0.20250311.112658";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/kind-icon-0.2.2.0.20250311.112658.tar";
        sha256 = "07lnpxq6g8rlc0mbnbwya8jjp2d42xixwm1knz57ab0lm7vcbmap";
      };
      packageRequires = [ svg-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/kind-icon.html";
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
      version = "1.1.5.0.20220316.84759";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/kiwix-1.1.5.0.20220316.84759.tar";
        sha256 = "0pi543y1gzkhi9chzwfmp9is8jnp31wx69m9355afrvxdncq6gna";
      };
      packageRequires = [ request ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/kiwix.html";
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
      version = "0.1.0.20221221.80420";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/kmb-0.1.0.20221221.80420.tar";
        sha256 = "00zqrfh1nqn01azmkd2gy3il48h1sddp6addj9yfq4kwd7ylhym5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/kmb.html";
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
      version = "0.5.0.0.20250822.121413";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/kubed-0.5.0.0.20250822.121413.tar";
        sha256 = "1mnf64pghsdkx63i2bax7rdwdq6ribrd1krl5ri4p3gfkpsy1r56";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/kubed.html";
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
      version = "1.0.0.20221221.80428";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/landmark-1.0.0.20221221.80428.tar";
        sha256 = "1rwiysmynp2z4bfynhf9k1zd3y5s6dyp2312vq1rhyifgdd8mivq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/landmark.html";
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
      version = "1.5.4.0.20230903.170436";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/latex-table-wizard-1.5.4.0.20230903.170436.tar";
        sha256 = "1y1crsd29fvqabzwzki7jqziarycix6bib0cmxlrfsqs95y7dr5w";
      };
      packageRequires = [
        auctex
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/latex-table-wizard.html";
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
      version = "4.5.5.0.20241018.51628";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/leaf-4.5.5.0.20241018.51628.tar";
        sha256 = "1d2y0qhy9qz0wahclwnskf5kdqhr51iljnrki7jmkzxfya3r1dwa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/leaf.html";
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
      version = "0.12.0.20240303.95600";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lentic-0.12.0.20240303.95600.tar";
        sha256 = "0w6fl0yzmh0gd3d5d5049zrx341x0jrj48g265jy4jywdvk621kv";
      };
      packageRequires = [
        dash
        m-buffer
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lentic.html";
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
      version = "0.2.0.20240314.214448";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lentic-server-0.2.0.20240314.214448.tar";
        sha256 = "1mg12bkwsqm4nwwwmpfx3dav583i96dsk5ap5hjiz2ggwwrmrq8h";
      };
      packageRequires = [
        lentic
        web-server
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lentic-server.html";
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
      version = "1.0.6.0.20250201.73956";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/let-alist-1.0.6.0.20250201.73956.tar";
        sha256 = "0qnp9dnnjmygirg8qncnc3mdi6kj08x63njsj6qwbb3276rr18w8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/let-alist.html";
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
      version = "1.2.0.20240216.82808";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lex-1.2.0.20240216.82808.tar";
        sha256 = "0mh2jk838216mwv6bab28mq9nb5617c5y7s0yqynkz3vkarnnxx1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lex.html";
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
      version = "1.1.0.0.20250728.43733";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lin-1.1.0.0.20250728.43733.tar";
        sha256 = "0ki0wlkmzmv1byi3gvdrbjhiy3qjb3qka908m5svgwjdxcf6zi7m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lin.html";
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
      version = "0.10pre0.20240923.201649";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/listen-0.10pre0.20240923.201649.tar";
        sha256 = "0klkjl8g7r6i0cx5yp1f2z6vafxpx0llbsk024bp6jjx9l6n7vp9";
      };
      packageRequires = [
        persist
        taxy
        taxy-magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/listen.html";
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
      version = "2.2.0.20250425.54453";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/literate-scratch-2.2.0.20250425.54453.tar";
        sha256 = "0wv9fmkv37j4gss36rd81wyp37cssmxvxpf98xf4yscj84vv742m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/literate-scratch.html";
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
      version = "0.27.2.0.20251004.1607";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/llm-0.27.2.0.20251004.1607.tar";
        sha256 = "00vf791pjf4sxja3wp9nl7s514gk3c3rcdmdw37nfcvw8vx3qa9h";
      };
      packageRequires = [
        compat
        plz
        plz-event-source
        plz-media-type
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/llm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lmc = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lmc";
      ename = "lmc";
      version = "1.4.0.20230105.113402";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lmc-1.4.0.20230105.113402.tar";
        sha256 = "0ldwr9gw0bkcj43w5x84qwq2gvv2nr53711wlh42zawh0dyhm8h7";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lmc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  load-dir = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "load-dir";
      ename = "load-dir";
      version = "0.0.5.0.20221221.80456";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/load-dir-0.0.5.0.20221221.80456.tar";
        sha256 = "00ynwml6xf7341z1w0wz1afh9jc4v8ggc8izy8qcvdiawxc418iq";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/load-dir.html";
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
      version = "1.3.2.0.20230214.53224";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/load-relative-1.3.2.0.20230214.53224.tar";
        sha256 = "19pkb7xqyllll2pgyqs7bv0qfbv6n9i5qlx9rjzm4ws0c9j464zd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/load-relative.html";
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
      version = "1.2.0.20201201.94106";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/loc-changes-1.2.0.20201201.94106.tar";
        sha256 = "1jrjqn5600l245vhr5h6zwg6g72k0n721ck94mji755bqd231yxs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/loc-changes.html";
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
      version = "1.2.5.0.20240610.183057";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/loccur-1.2.5.0.20240610.183057.tar";
        sha256 = "1apir3ijix4pkrv8q30xxqbiwvj78vp3y68ffq18fcwiww0gkavf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/loccur.html";
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
      version = "1.2.0.0.20250601.73518";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/logos-1.2.0.0.20250601.73518.tar";
        sha256 = "0c67ky0zvi26q7hzzhpj2gb9xlw1y7zzg3m94frc8glaibaj5cpl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/logos.html";
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
      version = "1.0.0.0.20221125.50733";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/luwak-1.0.0.0.20221125.50733.tar";
        sha256 = "0b4kxq5im8gvg1zg12b8ii62w0vsf3gacimwd603srfc5l1rbvcw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/luwak.html";
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
      version = "0.15.0.0.20250316.223951";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/lv-0.15.0.0.20250316.223951.tar";
        sha256 = "1risk08xjfnam98fjqwfzki80m8rhdmm71h6xhc0glagzd8i15fk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/lv.html";
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
      version = "0.16.1.0.20241215.171432";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/m-buffer-0.16.1.0.20241215.171432.tar";
        sha256 = "1cvygjcnhlicbjxchgc45yzmw1v07qyzhf4qbf6xgrkwv06clrd6";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/m-buffer.html";
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
      version = "3.3.1.0.20250819.91151";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/map-3.3.1.0.20250819.91151.tar";
        sha256 = "0axrs58ji1q74q2b9yfq5kb8sjhz9lbjqgmqb9cv78hy28pjvq7y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/map.html";
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
      version = "2.3.0.20251006.112635";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/marginalia-2.3.0.20251006.112635.tar";
        sha256 = "1kca6q6c0bncal0bim1hzldkjbgm4ia0l5v40h5zl9ybakzqlvp3";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/marginalia.html";
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
      version = "0.2.2.0.20221221.80510";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/markchars-0.2.2.0.20221221.80510.tar";
        sha256 = "0f1n1jzhksl5cl5c4n2arqhj2zkwzs8i4yzdz39y2b51x2gi2yav";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/markchars.html";
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
      version = "1.3.0.20220828.204754";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/math-symbol-lists-1.3.0.20220828.204754.tar";
        sha256 = "0q038qwcq7lg3a7n451gw80xlwv4hczz3432xcx00hxgvlh744yc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/math-symbol-lists.html";
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
      version = "0.1.0.20241113.83941";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mathjax-0.1.0.20241113.83941.tar";
        sha256 = "1n49nj70bpxpm72caffx0lmcnlfqdljy8sn8mzwhfiingrif2spb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mathjax.html";
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
      version = "1.3.0.20250928.180349";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mathsheet-1.3.0.20250928.180349.tar";
        sha256 = "0mkmfm3ck71pm75r5rii1l89a9m50hgw68n92ww1m016z2zrw6va";
      };
      packageRequires = [ peg ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mathsheet.html";
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
      version = "7.1.1.0.20251001.101359";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/matlab-mode-7.1.1.0.20251001.101359.tar";
        sha256 = "1s4kvfan9xlv2m1l92y59ib7lfzycnidkh456pq2pva74if810a5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/matlab-mode.html";
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
      version = "1.1.0.0.20250827.55853";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mct-1.1.0.0.20250827.55853.tar";
        sha256 = "0hspc3q453k7wmaiwh9q4b83n41l5fp2nc6di3slzghpjfnskpp6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mct.html";
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
      version = "0.2.0.20201201.223908";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/memory-usage-0.2.0.20201201.223908.tar";
        sha256 = "1jybms0756sswwdq8gqc6kpp5m7y971v4yzcmhraykhf32rwf4rq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/memory-usage.html";
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
      version = "0.3.0.20221221.80722";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/metar-0.3.0.20221221.80722.tar";
        sha256 = "08xcxx9wbjkqf6s1rbsp54f648r8n122k66nfd8ibv9qbd8qvmxq";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/metar.html";
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
      version = "0.2.0.20221221.80736";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/midi-kbd-0.2.0.20221221.80736.tar";
        sha256 = "0fz9r0y3qdnaq9wi00151xzqh3ygwcfw6yl32cs1vaaxv2czkjai";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/midi-kbd.html";
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
      version = "1.6.0.20201130.184335";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mines-1.6.0.20201130.184335.tar";
        sha256 = "0vl93im89fg72wpcqdhg1x2l4iybznh6gjvpkr1i29y05fsx2aad";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mines.html";
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
      version = "0.5.0.20220921.71345";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/minibuffer-header-0.5.0.20220921.71345.tar";
        sha256 = "1s77h5s2abpm75k57zcp1s525qs74sdm6vpzlkvqjz8lpn8zkkp0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/minibuffer-header.html";
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
      version = "0.1.0.20221221.80745";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/minibuffer-line-0.1.0.20221221.80745.tar";
        sha256 = "10gl1lnihawv9dw2rzaydyh8cdgpqgj7y8jsr6hjgqv82hxqyccn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/minibuffer-line.html";
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
      version = "1.4.0.20201201.162630";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/minimap-1.4.0.20201201.162630.tar";
        sha256 = "0h0ydmfinr82j0ifkgwjhc8blg6z2f5k0711fwrcbx8wrgrvfh5v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/minimap.html";
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
      version = "0.6.0.0.20250915.11734";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/minuet-0.6.0.0.20250915.11734.tar";
        sha256 = "1ghnibrqwvmq6dw3rn3z1knh50x5294jvskv4grawzirs7ki252p";
      };
      packageRequires = [
        dash
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/minuet.html";
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
      version = "0.5.11.0.20240222.42825";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mmm-mode-0.5.11.0.20240222.42825.tar";
        sha256 = "037g19hdya14q7wivdcw8h7wyx8lb8pw5waya3ak435cyfmpg1a7";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mmm-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mode-line-maker = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mode-line-maker";
      ename = "mode-line-maker";
      version = "0.1.0.20250912.174809";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mode-line-maker-0.1.0.20250912.174809.tar";
        sha256 = "08pwkdf94v4gzvfpjvs2dqkkzfr2w9c8k2qm5fwpjr7mb0y67fq5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mode-line-maker.html";
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
      version = "4.8.1.0.20251007.41506";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/modus-themes-4.8.1.0.20251007.41506.tar";
        sha256 = "0xidd1aw3byzvbz79nw1mjk9f9qnnqfgw6v4aycqbw0zlz2s8wvv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/modus-themes.html";
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
      version = "4pre0.20250502.114712";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/mpdired-4pre0.20250502.114712.tar";
        sha256 = "1s831xln9vlxcchmxmis8ky751r3xwi5nlnnchdn7sjngkqjkl30";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/mpdired.html";
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
      version = "1.14.0.20240919.113013";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/multi-mode-1.14.0.20240919.113013.tar";
        sha256 = "0h99nppak4xr3difyh86ng1sv6k9d1ad41kvafaqbf69v4xs711m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/multi-mode.html";
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
      version = "1.1.10.0.20220605.120254";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/multishell-1.1.10.0.20220605.120254.tar";
        sha256 = "0pl45mwwgdf505sviyzacalq6kisq0pnh99i1cnclrmjkjy6yxz9";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/multishell.html";
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
      version = "3.20.2.0.20240209.184001";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/muse-3.20.2.0.20240209.184001.tar";
        sha256 = "1sn5siingpzg4y5wjc3ff2ln98gb7hhvwmhnvhmmqbnb8r459vs0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/muse.html";
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
      version = "0.1.0.20221221.80834";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/myers-0.1.0.20221221.80834.tar";
        sha256 = "11nwn1nysr09r1701cd3wvkzn01s19l6lla0f33vqm66ahj9yldh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/myers.html";
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
      version = "0.4.0.20241227.124457";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nadvice-0.4.0.20241227.124457.tar";
        sha256 = "1bhv1111iyypw01jpsy9p3lci2gi1bkpgfz7447f6w7rr2s9rbdr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nadvice.html";
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
      version = "1.0.2.0.20230112.95905";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nameless-1.0.2.0.20230112.95905.tar";
        sha256 = "1b44w8jkqqsi995a2daw05ks64njlgpkab6m3iy3lx3v8fggjahp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nameless.html";
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
      nadvice,
    }:
    elpaBuild {
      pname = "names";
      ename = "names";
      version = "20151201.0.0.20220425.173515";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/names-20151201.0.0.20220425.173515.tar";
        sha256 = "1s91v83jkwxjl1iqrmjy60rnnqcgzly0z8chp87f7i22fj5gjz4h";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/names.html";
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
      version = "0.3.0.20230417.100538";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nano-agenda-0.3.0.20230417.100538.tar";
        sha256 = "1fhpic6zimk81a7w6m9hl6iw0vniz3pl775sxyg167ysn5sqsl2y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nano-agenda.html";
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
      version = "1.1.0.0.20240429.102433";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nano-modeline-1.1.0.0.20240429.102433.tar";
        sha256 = "0jlaqkrqn2x4fhlz57c94586xjqi1sb89p6py4j5r00669djwhrf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nano-modeline.html";
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
      version = "0.3.4.0.20250902.55900";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nano-theme-0.3.4.0.20250902.55900.tar";
        sha256 = "0yz9k9v980vzxyylywvkphk6bbgkfgw8a40q5za83kb7g3gf7sx6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nano-theme.html";
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
      version = "1.1.0.20221221.80909";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nftables-mode-1.1.0.20221221.80909.tar";
        sha256 = "149qz88wlapln0b8d9mcmj630vyh2ha65hqb46yrf08fch992cpx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nftables-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nhexl-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nhexl-mode";
      ename = "nhexl-mode";
      version = "1.5.0.20221215.152407";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nhexl-mode-1.5.0.20221215.152407.tar";
        sha256 = "0bdw6lycm1hclz3qzckcpnssrd4i52051dzbs87f9sv6f6v31373";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nhexl-mode.html";
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
      version = "1.9.0.20221221.80940";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/nlinum-1.9.0.20221221.80940.tar";
        sha256 = "15kw7r8lz9nb5s0rzgdlj1s1kl1l6nxzr7kmwv5i7b1xhpnyn7xn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/nlinum.html";
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
      version = "1.31.0.20240402.80928";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/notes-mode-1.31.0.20240402.80928.tar";
        sha256 = "1kiki1b6bx3nn1xgbnh0xnwnhx5wkn0zzlk6jfsks5npj2a4h88g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/notes-mode.html";
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
      version = "1.2.0.0.20250729.50820";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/notmuch-indicator-1.2.0.0.20250729.50820.tar";
        sha256 = "0wfkrpw1v0h5zjhd47q9m36nbr9ykhqmvzv0bx4rps1k7mbxvv8x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/notmuch-indicator.html";
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
      version = "2.1.0.0.20250101.73917";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ntlm-2.1.0.0.20250101.73917.tar";
        sha256 = "0ld0xc1a237yah9ng723kd3ywmy4d5jly8rs2hjzc9f3bjd2sl6q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ntlm.html";
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
      version = "1.5.0.20221221.81242";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/num3-mode-1.5.0.20221221.81242.tar";
        sha256 = "076m1lh9ma1wzavirmy7dq7nsl410n03yf7vq4ljxvbkw801sig7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/num3-mode.html";
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
      version = "0.18.3.0.20250909.170257";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/oauth2-0.18.3.0.20250909.170257.tar";
        sha256 = "08bgi2ql4ifqkisxrjhxqyjd6zfnx2na7sgkvd9z70mq1wxs5wfp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/oauth2.html";
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
      version = "1.0.2.0.20250511.114502";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ob-asymptote-1.0.2.0.20250511.114502.tar";
        sha256 = "0hkfqgym36lmlbqq4a5aj031hz14isfsnjn6qhkgxg06pc1wlzcl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ob-asymptote.html";
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
      version = "1.0.0.20210211.73431";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ob-haxe-1.0.0.20210211.73431.tar";
        sha256 = "148bly2nf0r64q2cfm0hd6i26bxaans7aj52nv4gb5qxsiqng0ly";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ob-haxe.html";
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
      version = "0.8.3.0.20201002.84752";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/objed-0.8.3.0.20201002.84752.tar";
        sha256 = "1fjcl2gm4675l430rdr2lihsj13n24pi9zwjfqvsm4bnqbx9ywiz";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/objed.html";
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
      version = "1.3.0.20240326.173146";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/omn-mode-1.3.0.20240326.173146.tar";
        sha256 = "1iyh0xqm9aag92vj44l4ymrjc0gnn41gckk1l96605cfkwr5m6qa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/omn-mode.html";
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
      version = "1.3.3.0.20201127.191411";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/on-screen-1.3.3.0.20201127.191411.tar";
        sha256 = "1dak8rb89mkdpv3xc2h0kpn09i4l42iavslvkhy2vxj0qq6c1r9p";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/on-screen.html";
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
      version = "1.5.0.20250922.134410";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/orderless-1.5.0.20250922.134410.tar";
        sha256 = "10i2hyyj5ki8cga21rdprjq5qnbqlhqxw1kn92d0zm1f2w1h9ykg";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/orderless.html";
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
      version = "9.8pre0.20251006.171414";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-9.8pre0.20251006.171414.tar";
        sha256 = "1sfjf93fgmlmjm3ys86npcp7djmzgdl2w8y50mjzd8bc4zgf73ab";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org.html";
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
      version = "1.1.0.20250905.33527";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-contacts-1.1.0.20250905.33527.tar";
        sha256 = "1d5d41lrliv30ngqx974lsm3am8k6zll8mh940a777isc4mglvhn";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-contacts.html";
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
      version = "1.1.2.0.20200902.94459";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-edna-1.1.2.0.20200902.94459.tar";
        sha256 = "043pb34ai8rj515zgbw5nq5x3mkiyqcnk25787qc3mbddi9n9hwq";
      };
      packageRequires = [
        org
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-edna.html";
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
      version = "0.1.1.0.20250804.81757";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-gnosis-0.1.1.0.20250804.81757.tar";
        sha256 = "16lw8pv8n9aamn5f8q2gk8ljzpcgwzlhsgiclw45bn98cy0cqb1d";
      };
      packageRequires = [
        compat
        emacsql
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-gnosis.html";
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
      version = "0.0.5.0.20240204.184749";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-jami-bot-0.0.5.0.20240204.184749.tar";
        sha256 = "1zl9xblhppqwddizf7s7l9d4qzcr8d6vgvjwmiw4wvb4lpyba9r4";
      };
      packageRequires = [ jami-bot ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-jami-bot.html";
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
      version = "1.9.0.20250924.170536";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-modern-1.9.0.20250924.170536.tar";
        sha256 = "05x6c3hq0xwml82047lmxvgck83pmxcmq4aff3vy57m6b2dd9p7w";
      };
      packageRequires = [
        compat
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-modern.html";
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
      version = "0.1.1.0.20231016.93952";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-notify-0.1.1.0.20231016.93952.tar";
        sha256 = "0pxm5pbmsf965daf3y7v5x6ca8ddi2a9d4lm04ky3113zz5ay95d";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-notify.html";
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
      version = "1.0.11.0.20250104.92914";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-real-1.0.11.0.20250104.92914.tar";
        sha256 = "11my7ygxgin8gjhmaqj3q8c3llyjgac6x5rd7mcx9qb3llpfxhmm";
      };
      packageRequires = [
        boxy
        org
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-real.html";
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
      version = "1.3.0.0.20250129.201717";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-remark-1.3.0.0.20250129.201717.tar";
        sha256 = "14j1lzxkjx70n703vv6lwfy914qiac20k4w0x9nv9312v9py6h3h";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-remark.html";
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
      version = "1.4.0.0.20250119.195656";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-transclusion-1.4.0.0.20250119.195656.tar";
        sha256 = "0zyqkxl1kpy1y2wxvc84lxhdz55w8qc6jinvkjmj4vjyfdlcz35a";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-transclusion.html";
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
      version = "0.1.4.0.20220312.90634";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/org-translate-0.1.4.0.20220312.90634.tar";
        sha256 = "1fq0h0q5nh92dc9vgp7nmqyz2nl0byd2v6vl5k2lk3rlmbx7jnkz";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/org-translate.html";
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
      version = "1.16.0.20240618.91747";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/orgalist-1.16.0.20240618.91747.tar";
        sha256 = "0kw1iasyg5j1kghwb952rah040qhybhycsmgk8y0rfk382ra3a1i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/orgalist.html";
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
      version = "0.4.0.20221221.81343";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/osc-0.4.0.20221221.81343.tar";
        sha256 = "0mlyszhc2nbf5p4jnc6wlq8iipzmy9ymvbszq13myza410nd9xqh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/osc.html";
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
      version = "1.7.0.20251008.104137";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/osm-1.7.0.20251008.104137.tar";
        sha256 = "15c74hby5j5dzki8m4avlsf3jrnz5qz1p8cyi2khyzlaf7jihpy7";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/osm.html";
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
      version = "1.0.6.0.20221221.81352";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/other-frame-window-1.0.6.0.20221221.81352.tar";
        sha256 = "11fdg3nl1w4vm46477kwk6d6vz769q726iz5cwknbvjzj8an994s";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/other-frame-window.html";
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
      version = "4.3.0.0.20240617.162224";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pabbrev-4.3.0.0.20240617.162224.tar";
        sha256 = "0wkizis0wb6syy2lzp1mi2cn5znzangi1w18jcn5ra8k8xj66yp4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pabbrev.html";
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
      version = "1.1.3.0.20190227.204125";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/paced-1.1.3.0.20190227.204125.tar";
        sha256 = "1ykjmv45kkfa569m8hpvya8a7wvkqrg9nbz28sbxmx79abm1bmmi";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/paced.html";
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
      version = "1.0.0.20250516.155254";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/package-x-1.0.0.20250516.155254.tar";
        sha256 = "1lr9g496sm8h6ph8x7w8c2ayhnlh7w30hhl6xwwfdsh0sqp2hy50";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/package-x.html";
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
      version = "0.1.3.0.20180729.171626";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/parsec-0.1.3.0.20180729.171626.tar";
        sha256 = "0lhcj6cjgkq9ha85n0hqcm0ik7avfzw9f8zcklyivwn2bx80r7r7";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/parsec.html";
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
      version = "0.2.5.0.20250505.82351";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/parser-generator-0.2.5.0.20250505.82351.tar";
        sha256 = "1gdaaas4p6xgmp67fwz0l43fyk0akj6q1vbv8gfgmzyaz9glwkaw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/parser-generator.html";
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
      version = "1.0.0.20221221.81414";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/path-iterator-1.0.0.20221221.81414.tar";
        sha256 = "1ln9l9x6bj1sp7shc2iafn11yji6lsgm4fm1ji1kfp3my1zhqc40";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/path-iterator.html";
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
      version = "1.0.1.0.20221221.81502";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/peg-1.0.1.0.20221221.81502.tar";
        sha256 = "0gc41pf2gy01bmjgx09c1kifi6pkhcm8jrbdx1ncblhix76ia4q4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/peg.html";
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
      version = "0.82.0.20250606.121940";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/perl-doc-0.82.0.20250606.121940.tar";
        sha256 = "0ymxvkwphqykq7qznxdlmsid4l7946vrll95b92n8f896wn8zlqa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/perl-doc.html";
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
      version = "0.7.0.20250930.85116";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/persist-0.7.0.20250930.85116.tar";
        sha256 = "0iapa9d0njc1qyqjbkl71fwws7hfz5303i17b69d6xdaynb7dajr";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/persist.html";
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
      version = "3.0.1.0.20250605.141218";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/phpinspect-3.0.1.0.20250605.141218.tar";
        sha256 = "0j9c7nzddc7krfan42jh3zlqv469ddq864wiym79n5xvjafalbz1";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/phpinspect.html";
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
      version = "0.4.51.0.20250428.55352";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/phps-mode-0.4.51.0.20250428.55352.tar";
        sha256 = "1r0faz9ijidagzcbphz7w2qwbxbdyznxk9ffx2rmrhjbizknrcm9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/phps-mode.html";
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
      version = "0.1.0.20250408.22039";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pinentry-0.1.0.20250408.22039.tar";
        sha256 = "10372ijcmwz48k03lbfw5s4lh2kmizhzfpd7in61zl12f2qv9rw7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pinentry.html";
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
      version = "0.10pre0.20250318.183534";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/plz-0.10pre0.20250318.183534.tar";
        sha256 = "08iyw80d2431k60fkw26i3z8zw0jk9czmxr1vi7z7hdfrqmw7gc0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/plz.html";
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
      version = "0.1.4pre0.20250413.93107";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/plz-event-source-0.1.4pre0.20250413.93107.tar";
        sha256 = "1g4bvdbdg5c0ch62l8314rv44b2wyymkbydyi0fkdjjb3a9ns4b0";
      };
      packageRequires = [ plz-media-type ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/plz-event-source.html";
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
      version = "0.2.5pre0.20250412.100044";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/plz-media-type-0.2.5pre0.20250412.100044.tar";
        sha256 = "1w35bdxgsv1wvqwn64miyzplbb6gqry25wnl6l7dyd2n71h2hmxl";
      };
      packageRequires = [ plz ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/plz-media-type.html";
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
      version = "0.1.0.20231101.73512";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/plz-see-0.1.0.20231101.73512.tar";
        sha256 = "09ibjvd9wvndrygnfq0jic7m9bk6v490rk1k3b4qjvv5xfvsvvhq";
      };
      packageRequires = [ plz ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/plz-see.html";
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
      version = "3.2.0.20230517.100500";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/poke-3.2.0.20230517.100500.tar";
        sha256 = "0p12szh563vynl7h9j55v7373g43fhmsy03iibvnywaira4arw5l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/poke.html";
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
      version = "3.1.0.20231014.222558";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/poke-mode-3.1.0.20231014.222558.tar";
        sha256 = "1aqw9rn17n7ywnys6dlwykrf63l4kgapqsk1fay5qjj0y1nkq167";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/poke-mode.html";
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
      version = "0.2.0.20221221.81510";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/poker-0.2.0.20221221.81510.tar";
        sha256 = "14xc4jpkpy88drijp19znfhlyv61p2fx2l3zqsqbl3br2xwxy219";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/poker.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  polymode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "polymode";
      ename = "polymode";
      version = "0.2.2.0.20250617.103312";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/polymode-0.2.2.0.20250617.103312.tar";
        sha256 = "0qc8gkkb6n059wbpbr3hk57lxsl5h22l1gsf7rvqk55l6dsb1hl0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/polymode.html";
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
      version = "0.4.8.0.20250323.144723";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/popper-0.4.8.0.20250323.144723.tar";
        sha256 = "0hfl4krm53blsm9bvki4gf1as43f8i7rszcjivbsiz1r4h99j9v8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/popper.html";
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
      version = "1.4.4.0.20250211.11057";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/posframe-1.4.4.0.20250211.11057.tar";
        sha256 = "18vmjb0qx39danlvq0r4k2crqvb8xkfrpfj5xk7yxwj7al92q390";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/posframe.html";
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
      version = "0.2.0.20240317.135839";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pq-0.2.0.20240317.135839.tar";
        sha256 = "0hva6d8iqqdvnllm7cssxrmn21alcb2aa4d6874bqdfqjij2hw1z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pq.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  prefixed-core = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "prefixed-core";
      ename = "prefixed-core";
      version = "0.0.20221212.225529";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/prefixed-core-0.0.20221212.225529.tar";
        sha256 = "1b9bikccig8l96fal97lv6gajjip6qmbkx21y0pndfbw2kaamic4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/prefixed-core.html";
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
      version = "0.4.1.0.20250829.60323";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/preview-auto-0.4.1.0.20250829.60323.tar";
        sha256 = "0qbpzbwfg1d3jh7nh7xvxhy4pdmxd75yzl652vcyb7cy8h4kc6ac";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/preview-auto.html";
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
      version = "0.2.0.20241018.170554";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/preview-tailor-0.2.0.20241018.170554.tar";
        sha256 = "0wcqrannqgyd1fzydia3q8c5dgk8c89irfrikkz568g2jgwnih16";
      };
      packageRequires = [ auctex ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/preview-tailor.html";
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
      version = "0.11.1.0.20251001.102725";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/project-0.11.1.0.20251001.102725.tar";
        sha256 = "0cyqqz8q0qis1lvgpdkwkzddj8zgraj9vn20xlc2bq52mmdql3a2";
      };
      packageRequires = [ xref ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/project.html";
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
      version = "1.3.5.0.20221229.184738";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/psgml-1.3.5.0.20221229.184738.tar";
        sha256 = "1zdfdzbadrbj6g4k2q7w5yvxvblpwn4mkihmnmag7jym66r4wmnb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/psgml.html";
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
      version = "1.1.0.20221221.81719";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pspp-mode-1.1.0.20221221.81719.tar";
        sha256 = "010qckmc85wc4i7k1rmhffcdbpxpvs6p5qxdvr6g3ws00c1a3j4l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pspp-mode.html";
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
      version = "1.2.0.0.20250729.33601";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pulsar-1.2.0.0.20250729.33601.tar";
        sha256 = "12k9nijvsfr29c6mhw026a13z2q3gs2idaymivlkywakipzrsdzz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pulsar.html";
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
      version = "5.3.4.0.20250225.70943";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pyim-5.3.4.0.20250225.70943.tar";
        sha256 = "07549ppwkx8xr71a4xdkxwhg9ilmnmxmqac83klcpzscm9gasyh3";
      };
      packageRequires = [
        async
        xr
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pyim.html";
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
      version = "0.5.5.0.20240923.73912";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/pyim-basedict-0.5.5.0.20240923.73912.tar";
        sha256 = "01czkf0i4hg2fdd7m3qas5wvb6ziczsrlnyr7phr1vrgh7qfl6n2";
      };
      packageRequires = [ pyim ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/pyim-basedict.html";
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
      version = "0.30.0.20250925.170612";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/python-0.30.0.20250925.170612.tar";
        sha256 = "1pkanqqv9c5046nzl1b83bh2cs1wchqh28y6vzwxn23l0yn7b23i";
      };
      packageRequires = [
        compat
        flymake
        project
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/python.html";
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
      version = "0.1.0.20221221.81727";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/quarter-plane-0.1.0.20221221.81727.tar";
        sha256 = "1s0fl9sxjhv0sl5ikvkhdnddjg1n2hzw0a64xcvm8859dk77fmy8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/quarter-plane.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  queue = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "queue";
      ename = "queue";
      version = "0.2.0.20210306.173709";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/queue-0.2.0.20210306.173709.tar";
        sha256 = "09iicl5fdpli6jnvdj0h8cwj7wqqmxnfzdd57vfjdq09v3sjkljs";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/queue.html";
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
      version = "1.0.6.0.20231215.171141";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rainbow-mode-1.0.6.0.20231215.171141.tar";
        sha256 = "0qr0yl8fszrrdnl8x3d8lnndr5s9g3bf708qilb3f6i5ahkqhq7l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rainbow-mode.html";
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
      version = "0.1.0.20201128.182847";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rbit-0.1.0.20201128.182847.tar";
        sha256 = "1ajjfkih0dji2mdsvcpdzmb32nv20niryl8x17ki1016302qfvdj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rbit.html";
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
      version = "0.4.5.0.20230414.195045";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rcirc-color-0.4.5.0.20230414.195045.tar";
        sha256 = "1amlzg7njbmk1kbb569ygx2az7vd7py89z9aq9cmf5rm15hjsm59";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rcirc-color.html";
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
      version = "1.0.5.0.20250908.131006";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rcirc-mentions-1.0.5.0.20250908.131006.tar";
        sha256 = "04l93gigrw6jkrarwf2ckakpq0p2n3nr6iigzc7mhflj1kbx1wm0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rcirc-mentions.html";
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
      version = "1.1.0.20221221.81818";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rcirc-menu-1.1.0.20221221.81818.tar";
        sha256 = "0gd19rzqgqb9w5cfpr1rz719k5z1rfkn8480b0h1zkvgpgmdrzbx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rcirc-menu.html";
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
      version = "1.0.4.0.20241108.161537";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rcirc-sqlite-1.0.4.0.20241108.161537.tar";
        sha256 = "0x5pngsnmny2ppg3cgdp5g3nmds6ys3zvamaj8wr6n1qw6k5b4z1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rcirc-sqlite.html";
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
      version = "1.5.1.0.20250605.74308";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-1.5.1.0.20250605.74308.tar";
        sha256 = "187r7zflc4f51jwbms8864j5vwp524g61rqzggjylcrc0zypgbry";
      };
      packageRequires = [
        load-relative
        loc-changes
        test-simple
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-ipdb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-ipdb";
      ename = "realgud-ipdb";
      version = "1.0.0.0.20231216.160636";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-ipdb-1.0.0.0.20231216.160636.tar";
        sha256 = "1s08gngzq18bgxdc6qpsg7j9wjqq842wj5bki2l8jgyqpin6g3h5";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-ipdb.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-jdb = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-jdb";
      ename = "realgud-jdb";
      version = "1.0.0.0.20200722.72030";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-jdb-1.0.0.0.20200722.72030.tar";
        sha256 = "1vh4x50gcy5i9v9pisn0swmv0ighksn8ni68pdwxkns5ka99qqi6";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-jdb.html";
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
      version = "1.0.2.0.20241118.210939";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-lldb-1.0.2.0.20241118.210939.tar";
        sha256 = "1wpl9608rg6a6nbrnqmhhd8wwwdaf6cpw4lxv59bz2n903bbyr1d";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-lldb.html";
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
      version = "1.0.0.0.20190525.123417";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-node-debug-1.0.0.0.20190525.123417.tar";
        sha256 = "1s5zav3d0xdj0jggw3znfzb43d9jrnzaafk51wiachh7j673gjjv";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-node-debug.html";
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
      version = "1.0.0.0.20190526.154549";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-node-inspect-1.0.0.0.20190526.154549.tar";
        sha256 = "0hss16d3avyisdxp1xhzjqn2kd9xc3vkqg4ynsgvxampzli78fw9";
      };
      packageRequires = [
        cl-lib
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-node-inspect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  realgud-trepan-ni = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      load-relative,
      realgud,
    }:
    elpaBuild {
      pname = "realgud-trepan-ni";
      ename = "realgud-trepan-ni";
      version = "1.0.1.0.20210513.183733";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-trepan-ni-1.0.1.0.20210513.183733.tar";
        sha256 = "0p7sc7g1nwg1hyvgx5mzs2qpjnrayp7brw720kzxfxnxdfj7p0gj";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-trepan-ni.html";
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
      version = "1.0.1.0.20230322.184556";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/realgud-trepan-xpy-1.0.1.0.20230322.184556.tar";
        sha256 = "0m9pwqbkhwkm9fys7rs2lapydkinh4v7q3q3j8b0qb0nl8qcni7i";
      };
      packageRequires = [
        load-relative
        realgud
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/realgud-trepan-xpy.html";
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
      version = "1.9.4.0.20240830.70150";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rec-mode-1.9.4.0.20240830.70150.tar";
        sha256 = "0jdz5hf8ials41vi90jrklv1sh7f83l6h2g7z3csqah0lgb19xxk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rec-mode.html";
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
      version = "0.1.0.20250213.102055";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/register-list-0.1.0.20250213.102055.tar";
        sha256 = "1q0lcj1ranylqawvi9y0c6rc87bl7g6bdwd08hpnsjh3jzyzmvqk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/register-list.html";
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
      version = "2.1.0.20250904.163151";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/relint-2.1.0.20250904.163151.tar";
        sha256 = "11abw06nwq50xpin61qnmka3zdlkdmpljl34gs3ahf0b7p4w1g9b";
      };
      packageRequires = [ xr ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/relint.html";
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
      version = "1.2.4.0.20240108.130348";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/repology-1.2.4.0.20240108.130348.tar";
        sha256 = "1ybr0zn647sb6gfqrm6ahdkx3q30j2b0gaab335nkc7jqx1ba565";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/repology.html";
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
      version = "1.0.3.0.20240924.201748";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rich-minority-1.0.3.0.20240924.201748.tar";
        sha256 = "1jywghc41c5i0y0f2vi32yykfbkh7kccs9h46idlfq7a2fq42z55";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rich-minority.html";
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
      version = "0.3.0.20221221.81910";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rnc-mode-0.3.0.20221221.81910.tar";
        sha256 = "1rdz1g440sjzxcqc4p2s0vv525ala4k470ddn4h9ghljnncqbady";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rnc-mode.html";
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
      version = "7.0.20240306.83828";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rt-liberation-7.0.20240306.83828.tar";
        sha256 = "1gz0hiwl8qqf1adxwgr8ly98pymqjrl3jjfly5r182l3rwp82gsh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rt-liberation.html";
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
      version = "0.4.3.0.20230205.12506";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ruby-end-0.4.3.0.20230205.12506.tar";
        sha256 = "0cr18s311c986gwx12f6fmnqwyqb4fh7j6h8m2cgp767vn4aqwxl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ruby-end.html";
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
      version = "0.3.2.0.20221212.230154";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/rudel-0.3.2.0.20221212.230154.tar";
        sha256 = "0lcdc0gdqkl4disr9rwn1dmziwaiwnsyhfwvf02vrgpabd7dq95w";
      };
      packageRequires = [
        cl-generic
        cl-lib
        cl-print
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/rudel.html";
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
      version = "0.2.0.20220223.202624";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/satchel-0.2.0.20220223.202624.tar";
        sha256 = "1x558csdfahlp459m4bb827yayrzgisaijzbpxbl1pjhq595585d";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/satchel.html";
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
      version = "0.3.0.20250208.195044";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/scanner-0.3.0.20250208.195044.tar";
        sha256 = "0fxq0lylgdzsk398q2658gsd3xlr8wd63wlpvnx0vakzj824x2cb";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/scanner.html";
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
      version = "1.0.0.20221221.81959";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/scroll-restore-1.0.0.20221221.81959.tar";
        sha256 = "04xhshjm5fr5q85srmjhvm20l0zljgbdsy1f3g3lczgzqrwvyg9f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/scroll-restore.html";
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
      version = "1.1.0.20230721.154631";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sed-mode-1.1.0.20230721.154631.tar";
        sha256 = "1gb7m8w5v0ay8mcm7alyixsnmndivd24467v58rkj0bpf7bmfa5v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sed-mode.html";
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
      version = "2.24.0.20240201.135317";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/seq-2.24.0.20240201.135317.tar";
        sha256 = "0plr9pbvzd5cfivj90n0jm920hp2x1giy9889pr8x5bqqnba6j66";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/seq.html";
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
      version = "1.5.0.0.20250829.105526";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/setup-1.5.0.0.20250829.105526.tar";
        sha256 = "167qy96rkvz1i1np6vjh7h0f3zm32pihyr4rcpwpxamkggb8x6vj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/setup.html";
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
      version = "1.0.0.0.20221212.230255";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/shelisp-1.0.0.0.20221212.230255.tar";
        sha256 = "0kk24mkmm4imf7gsr7xihj3xf2y9mgy61gpyql0wms1vlmkl0mwk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/shelisp.html";
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
      version = "2.5.0.0.20250930.194048";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/shell-command+-2.5.0.0.20250930.194048.tar";
        sha256 = "1p6s6rp10mg23vvnls5pxgx014jf86x6427xbqms3bbdz0fpzn5j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/shell-command+.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  shell-quasiquote = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "shell-quasiquote";
      ename = "shell-quasiquote";
      version = "0.0.20250316.162215";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/shell-quasiquote-0.0.20250316.162215.tar";
        sha256 = "1f19k60y30vnp3dw62fn2wi94bkgdfx6nl8i50yx5nnw0cjp9f7l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/shell-quasiquote.html";
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
      version = "0.1.0.20221221.82050";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/shen-mode-0.1.0.20221221.82050.tar";
        sha256 = "17ygb1c0x52n3cnmvaacrcf7m6qdjxdqaw1pn7lg3899kl45dh3r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/shen-mode.html";
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
      version = "1.0.0.0.20250907.131347";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/show-font-1.0.0.0.20250907.131347.tar";
        sha256 = "13z63f0sxpl078hzqd1v3naynb4j9h6c26xpxkjifjsl3rw333ch";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/show-font.html";
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
      version = "7.1.8.0.20221221.82114";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sisu-mode-7.1.8.0.20221221.82114.tar";
        sha256 = "1cyynn3sk8wxfhiz5q0lqwq07kqy67s2rvjql62880in5m5r2jpa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sisu-mode.html";
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
      version = "0.2.0.0.20250918.230122";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/site-lisp-0.2.0.0.20250918.230122.tar";
        sha256 = "0m72y6vlnwmj25wdy687hl14v77s81m00p9mjs6rv5sgcplnff8l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/site-lisp.html";
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
      version = "1.0.4.0.20230420.122954";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sketch-mode-1.0.4.0.20230420.122954.tar";
        sha256 = "0ssh1v49h94gvchpynvjcsw80swpcdw541zxxhxm5zi6gsnyhnjd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sketch-mode.html";
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
      version = "1.2.0.0.20221221.82156";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/slime-volleyball-1.2.0.0.20221221.82156.tar";
        sha256 = "015qpac86km7czpqr2f7xpjlkwbq9s4z9jl0dnr8b2bzh0iwqiik";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/slime-volleyball.html";
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
      version = "1.2.0.20240404.93144";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sm-c-mode-1.2.0.20240404.93144.tar";
        sha256 = "1xbkdvhxaffk6csav2ivbrqv85rkb4arnsslp2ji13alkm5hx1zx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sm-c-mode.html";
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
      version = "4.0.0.20221221.82225";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/smalltalk-mode-4.0.0.20221221.82225.tar";
        sha256 = "1qk0z1gddw7fidvj429ivjwnxb4f5g074r531nmpvmy2l7srchd9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/smalltalk-mode.html";
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
      version = "0.1.1.0.20221221.82231";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/smart-yank-0.1.1.0.20221221.82231.tar";
        sha256 = "17w9ybfvdsnsy1vf1mg7a4428rna49i2yfifrp20srj8c0dapwzd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/smart-yank.html";
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
      version = "6.12.0.20250404.173928";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sml-mode-6.12.0.20250404.173928.tar";
        sha256 = "05cdfdsnphxxww1mb05fzf18gray50s7k96m4nfpqcwlyzmbi947";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sml-mode.html";
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
      version = "1.1.2.0.20250315.100518";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/so-long-1.1.2.0.20250315.100518.tar";
        sha256 = "0jjf9y2swl23njng62l43avy37s4ca18z8g647mkp50rx02j9q8b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/so-long.html";
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
      version = "3.2.3.0.20250226.15703";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/soap-client-3.2.3.0.20250226.15703.tar";
        sha256 = "0nnksnwhx9fhj3lrc8s1l2c075xgpcfz5hmdk253835n0wzfz3n5";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/soap-client.html";
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
      version = "1.4.9.0.20220928.185052";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sokoban-1.4.9.0.20220928.185052.tar";
        sha256 = "1d3s1v81mvfjcq5bbf0338ldxgl2rymqb3vqqw7drbics4jq5fc0";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sokoban.html";
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
      version = "1.6.2.0.20220909.50328";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sotlisp-1.6.2.0.20220909.50328.tar";
        sha256 = "1g48ahiwdipk4ckynqipsfradd1qafg59s10jkbpkp3wvfmxi5sf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sotlisp.html";
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
      version = "0.7.0.0.20250719.40007";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/spacious-padding-0.7.0.0.20250719.40007.tar";
        sha256 = "0zdfzk1v3niq2rxm0v52086jyijjj0vvcr7071r8780a41jr3yqm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/spacious-padding.html";
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
      version = "0.7.0.20241220.133155";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/speedrect-0.7.0.20241220.133155.tar";
        sha256 = "10bcmxy5pcni1789fa67awv03q17d5b3ls47vxkn1p6diiha95jw";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/speedrect.html";
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
      version = "1.7.4.0.20220915.94959";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/spinner-1.7.4.0.20220915.94959.tar";
        sha256 = "1110bxj7vgai0wgsqbd9917k72xmalyfy0rlwqp46azg02ljam6j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/spinner.html";
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
      version = "0.2.0.20221221.82329";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sql-beeline-0.2.0.20221221.82329.tar";
        sha256 = "0qfw9q5isyjywlm2fyaazci24jza6h4s50i0zmjk35j6spyxwffs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sql-beeline.html";
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
      version = "0.2.2.0.20221221.82336";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sql-cassandra-0.2.2.0.20221221.82336.tar";
        sha256 = "1rl2bdjyglzssm00zdfqidd9j7jzizxaq60bclqa5dsz80zsd6aq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sql-cassandra.html";
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
      version = "1.7.0.20241109.2223";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sql-indent-1.7.0.20241109.2223.tar";
        sha256 = "0hrpal1di201x62hq2xhck0xhv2vnn972j6nb2mca9lxyvz6h625";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sql-indent.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sql-smie = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sql-smie";
      ename = "sql-smie";
      version = "0.0.20221221.82351";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sql-smie-0.0.20221221.82351.tar";
        sha256 = "05jv2k9gswwwyi19da8d5f176lb81qmnf94dvghyzh272v9iwvkr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sql-smie.html";
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
      version = "0.4.0.20240506.104337";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/srht-0.4.0.20240506.104337.tar";
        sha256 = "1fs6av8l3v4vvzxxhd20rzwrwh8dkk1d1x21jkjx8nczj2jydwb0";
      };
      packageRequires = [
        plz
        transient
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/srht.html";
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
      version = "3.1.16.0.20241117.185025";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ssh-deploy-3.1.16.0.20241117.185025.tar";
        sha256 = "03slq2jz6npx33n8ygs761mgqzbain6gqyyl38581gsl8kawx9zs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ssh-deploy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  standard-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      modus-themes,
    }:
    elpaBuild {
      pname = "standard-themes";
      ename = "standard-themes";
      version = "2.2.0.0.20251008.94216";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/standard-themes-2.2.0.0.20251008.94216.tar";
        sha256 = "0f5fb0d5wzzz1amqf4a6gsliwzff9d7f0q6zdgl6hjdjdcmk9dij";
      };
      packageRequires = [ modus-themes ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/standard-themes.html";
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
      version = "2.4.0.0.20250102.122330";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/stream-2.4.0.0.20250102.122330.tar";
        sha256 = "0p1cl4xl0yh3qw0r5zy37rapbzi0xav8wzhcrvm0scgsr7il5jm8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/stream.html";
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
      version = "0.3.1.0.20250710.41803";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/substitute-0.3.1.0.20250710.41803.tar";
        sha256 = "1b4cs2kmg6vp946m6vrwhp0rqps737xzndkx7cnhxqmg315whn39";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/substitute.html";
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
      version = "1.1.0.20250101.73917";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/svg-1.1.0.20250101.73917.tar";
        sha256 = "1sacdwkqh5vb9bnd1vmxjk35nl9rzakh5v9mpzslh2mjysx61bmm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/svg.html";
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
      version = "1.2.0.20221221.82408";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/svg-clock-1.2.0.20221221.82408.tar";
        sha256 = "15fshgjqv3995f2339rwvjw9vyiqz2lfs9h80gkmssha7fdfw3qx";
      };
      packageRequires = [ svg ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/svg-clock.html";
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
      version = "0.3.0.20250822.125859";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/svg-lib-0.3.0.20250822.125859.tar";
        sha256 = "14ilvsml7j9xi9fkqhdxab6nmy979741fwxq72xpfl3j9ivymsrn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/svg-lib.html";
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
      version = "0.3.3.0.20241021.134153";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/svg-tag-mode-0.3.3.0.20241021.134153.tar";
        sha256 = "1zhmjpskaqsv2rl8lqbnb93b08d0xjk0d84ksjzwgr3bzmscpz5n";
      };
      packageRequires = [ svg-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/svg-tag-mode.html";
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
      version = "0.15.1.0.20250329.151337";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/swiper-0.15.1.0.20250329.151337.tar";
        sha256 = "08glyqqvj3m9bph1i53m32wg58xvxzglc44gidmg2b1gf2w3gl82";
      };
      packageRequires = [ ivy ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/swiper.html";
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
      version = "1.3.0.20230411.180529";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/switchy-window-1.3.0.20230411.180529.tar";
        sha256 = "1h3jib0qr8wj3xk3qha5yrw2vqhidnqhj4jhw2smrfk61vyfs83b";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/switchy-window.html";
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
      version = "1.2.0.0.20250814.70257";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/sxhkdrc-mode-1.2.0.0.20250814.70257.tar";
        sha256 = "1zjkhhpsiq5wdp2lyq98zrxj52c5h6kr4vn9dfimgkx3z3z8dcgl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/sxhkdrc-mode.html";
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
      version = "1.1.1.0.20250919.135435";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/system-packages-1.1.1.0.20250919.135435.tar";
        sha256 = "0j7cyrgiyn0vyyc77wz7rjmn4rp7zsv3pqrn5zws2p254r2dyn6g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/system-packages.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  systemd = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "systemd";
      ename = "systemd";
      version = "0.0.20221221.82418";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/systemd-0.0.20221221.82418.tar";
        sha256 = "1ir3y4w2x1cl24zy66yym5rlpffgrcs10x4sxhb2sgg5k4d88scn";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/systemd.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tNFA = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      queue,
    }:
    elpaBuild {
      pname = "tNFA";
      ename = "tNFA";
      version = "0.1.1.0.20240405.140856";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tNFA-0.1.1.0.20240405.140856.tar";
        sha256 = "0m2lh50bz56j5gdpjvan0sksgnlb3cszb28q69xni88hajacn4aw";
      };
      packageRequires = [
        cl-lib
        queue
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tNFA.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tam = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tam";
      ename = "tam";
      version = "0.1.0.20230920.103516";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tam-0.1.0.20230920.103516.tar";
        sha256 = "01w1vwb1ajmbk90c79wc0dc367sy5b5qdf471zr0xinajfv47709";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tam.html";
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
      version = "0.10.2.0.20240816.184044";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/taxy-0.10.2.0.20240816.184044.tar";
        sha256 = "1qsy9j5si9kkhv7vssc7cg8iypizgzfckb5bpvas0cxiv7ibfqv6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/taxy.html";
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
      version = "0.14.3.0.20240923.174028";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/taxy-magit-section-0.14.3.0.20240923.174028.tar";
        sha256 = "104vhlbr03sz1lrvqh3qs96a61d0kcjqqc71q84q400890an3gh9";
      };
      packageRequires = [
        magit-section
        taxy
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/taxy-magit-section.html";
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
      version = "1.5.0.20160804.124501";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/temp-buffer-browse-1.5.0.20160804.124501.tar";
        sha256 = "0jw3fjbnbbrsz54hmg4rhcwrl0ag7h6873n2kdph3gjds29d8jxp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/temp-buffer-browse.html";
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
      version = "1.6.0.20250920.84834";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tempel-1.6.0.20250920.84834.tar";
        sha256 = "0l9b21ijpi6wx5z1da2xg95qnh1g168lhmsqkx2dqljlsrjmg5cv";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tempel.html";
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
      version = "0.1.1.0.20251004.2413";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/termint-0.1.1.0.20251004.2413.tar";
        sha256 = "0dvfm0kbhbv84l1hjc0gwafp8vphq466mjq4x7p4awdab594x114";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/termint.html";
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
      version = "1.3.0.0.20230916.123447";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/test-simple-1.3.0.0.20230916.123447.tar";
        sha256 = "1xbf63qg17va0qwq2mkg12jg1fk6wwrs43jjzxxccx28h6d205il";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/test-simple.html";
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
      version = "0.1.0.20240617.174820";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tex-item-0.1.0.20240617.174820.tar";
        sha256 = "17b95npakxjzc03qrsxla5jhdzhq0clwdrx57f9ck94a0fnpji3x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tex-item.html";
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
      version = "0.7.0.20250709.53958";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tex-parens-0.7.0.20250709.53958.tar";
        sha256 = "0mbcgc17cy8imk7dzh9krwd62dy2h7fj5pzvfr1wggdczrs2zva8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tex-parens.html";
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
      version = "0.1.2.0.20240105.165329";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/theme-buffet-0.1.2.0.20240105.165329.tar";
        sha256 = "1p1vmyl2cdm6vk45884jhrxjgd53mdch4wfkd1hx269v76zl58pa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/theme-buffet.html";
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
      version = "2.1.0.20250911.163956";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/timeout-2.1.0.20250911.163956.tar";
        sha256 = "1arsi968crr146qgqifx4s71ah50w3d3kl5m4k42mkgc50awy1r2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/timeout.html";
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
      version = "1.4.2.0.20221221.82440";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/timerfunctions-1.4.2.0.20221221.82440.tar";
        sha256 = "08spli0dfi882wrjcxjgk3zl4g4b5rlrvpyjmkgkzq6ix5z7w80j";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/timerfunctions.html";
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
      version = "0.2.1.0.20220910.192941";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tiny-0.2.1.0.20220910.192941.tar";
        sha256 = "04ybgq2ppzjpindwgypsp4sb0hmzq5k7sg9niyp18dxkj0nv1l7n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tiny.html";
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
      version = "1.2.0.0.20251006.73242";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tmr-1.2.0.0.20251006.73242.tar";
        sha256 = "1ll3776pbkjvxiqy2d0n11armxakckacjfmjwz6cpm19iz3h0gx4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tmr.html";
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
      version = "0.4.3.0.20220511.213722";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tomelr-0.4.3.0.20220511.213722.tar";
        sha256 = "0vjhbz8lfhk84kgm8vd9lfn9qx60g40j7n3kx7iadk0p4842fpaa";
      };
      packageRequires = [
        map
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tomelr.html";
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
      version = "0.3.1.0.20230106.94110";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/topspace-0.3.1.0.20230106.94110.tar";
        sha256 = "179k6d4v4lw66gpb2lmf1zcz6ww1fr3ys0x992wd1r7mvlc070s8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/topspace.html";
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
      version = "1.4.0.20250312.1734";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/track-changes-1.4.0.20250312.1734.tar";
        sha256 = "003cp1sz74nj92dbvcm4gzsr546v5l38ifi76371lv3j5wxjfgsi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/track-changes.html";
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
      version = "2.8.0.3.0.20250929.70756";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tramp-2.8.0.3.0.20250929.70756.tar";
        sha256 = "18zlii5z5qpp18ab6cylndvbcp0586b4g6xjih536g27awqki4i9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tramp.html";
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
      version = "1.0.1.0.20220923.120957";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tramp-nspawn-1.0.1.0.20220923.120957.tar";
        sha256 = "0mpr7d5vgfwsafbmj8lqc1k563b7qnjz1zq73rl8rb2km5jxczhn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tramp-nspawn.html";
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
      version = "0.3.0.20241214.144045";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tramp-theme-0.3.0.20241214.144045.tar";
        sha256 = "1fhd8pag716h7x71bz059wd6vqn4mz058yg0apfz68dlchma4zhk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tramp-theme.html";
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
      version = "1.5.2.0.20221221.82457";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/transcribe-1.5.2.0.20221221.82457.tar";
        sha256 = "12xw9vxzqfr3pis49apdzc5bg0n30wfx0xa9kycdbcpda88f3z6h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/transcribe.html";
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
      version = "0.10.1.0.20251006.181532";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/transient-0.10.1.0.20251006.181532.tar";
        sha256 = "04jzkvi4sd5mm73n86gcq3cfmqpl833864sy4q8rzqwshak211k7";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/transient.html";
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
      version = "2.0.0.20250625.85410";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/transient-cycles-2.0.0.20250625.85410.tar";
        sha256 = "1782gr8hwidfxilggb83s2v9wzkvyhcxbv3nj8f4aylhcdahfzf8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/transient-cycles.html";
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
      version = "0.4.0.20240322.113138";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/tree-inspector-0.4.0.20240322.113138.tar";
        sha256 = "15k30zdbr8cr88z00dn2jfnybrhkmp769pc361v9n4mdgapwmiap";
      };
      packageRequires = [ treeview ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/tree-inspector.html";
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
      version = "0.6.0.20231015.13107";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/trie-0.6.0.20231015.13107.tar";
        sha256 = "0kwz7b7y90yq676r09h4w0wbrm61030sw6mqhrcq9130s107lbkx";
      };
      packageRequires = [
        heap
        tNFA
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/trie.html";
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
      version = "0.6.1.0.20251004.160701";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/triples-0.6.1.0.20251004.160701.tar";
        sha256 = "05xplf1ipdykw5l25zsfgcghb5a5pq1la93059w82nqyqsa9401r";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/triples.html";
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
      version = "1.0.3.0.20230604.111559";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ulisp-repl-1.0.3.0.20230604.111559.tar";
        sha256 = "0b6yvlwikgkkfqklrhbcs0p6y349b6700x78n77xf0kkgv7mca1i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ulisp-repl.html";
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
      version = "0.8.2.0.20220312.180415";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/undo-tree-0.8.2.0.20220312.180415.tar";
        sha256 = "1gm5108p4qv7v4dqpxkd3zb2h5w8nsz0xjbxzxpkvykqp982g030";
      };
      packageRequires = [ queue ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/undo-tree.html";
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
      version = "0.3.0.20221212.230830";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/uni-confusables-0.3.0.20221212.230830.tar";
        sha256 = "15kc12zih2d6lazcqgiaq9jc5zgznnhaywh7ibflwc6siqvwxzvg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/uni-confusables.html";
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
      version = "1.0.4.0.20221221.82507";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/uniquify-files-1.0.4.0.20221221.82507.tar";
        sha256 = "0zn7z3y7f7hw4144ssa398455091qrg238wp9fr53l2rxpdkdkwf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/uniquify-files.html";
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
      version = "0.6.0snapshot0.20250709.114307";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/urgrep-0.6.0snapshot0.20250709.114307.tar";
        sha256 = "149q30izqnv462k4rvghb5g3mh6p3zznh2sqdzi4msk2mbpgggny";
      };
      packageRequires = [
        compat
        project
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/urgrep.html";
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
      version = "2.0.6.0.20250626.205101";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/url-http-ntlm-2.0.6.0.20250626.205101.tar";
        sha256 = "05zx6vyqh2jkipl4srnp01agxrjy0lzvgsjbisnjk56nx4lhnfs3";
      };
      packageRequires = [ ntlm ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/url-http-ntlm.html";
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
      version = "0.8.4.0.20250626.204641";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/url-http-oauth-0.8.4.0.20250626.204641.tar";
        sha256 = "1krqpp8zvc79xqb8jn9pq9scxrv8cj8bim53nspr67v0z21y3wzc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/url-http-oauth.html";
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
      version = "0.9.0.20231222.161107";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/url-scgi-0.9.0.20231222.161107.tar";
        sha256 = "1dgi0r0igwsk3mx6b7mvd6xz7dmb545g2394s0wh9kkjhlkyd5b3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/url-scgi.html";
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
      version = "2.4.6.0.20250524.65524";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/use-package-2.4.6.0.20250524.65524.tar";
        sha256 = "0zayaizp0d4sk1v4mrc4kfjgzlbxzsa2jrrdadis5al6x077jabx";
      };
      packageRequires = [ bind-key ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/use-package.html";
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
      version = "1.0.4.0.20180215.204244";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/validate-1.0.4.0.20180215.204244.tar";
        sha256 = "1hayzx6x2xqfzg84ik5n5x84ixmwc0kc8h7f0796d4rfiljl4y3c";
      };
      packageRequires = [
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/validate.html";
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
      version = "3.1.1.0.20210501.211155";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/valign-3.1.1.0.20210501.211155.tar";
        sha256 = "1w5by0y4552c2qlm708b3523fp9sgizd0zxrwk2k1v6qwh04pa67";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/valign.html";
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
      version = "1.1.1.0.20250918.224711";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vc-backup-1.1.1.0.20250918.224711.tar";
        sha256 = "10a6a12xqsxvhpq88wwc1ylv5zy3x347d9l2bv2wpfrq7n7nrpr7";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vc-backup.html";
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
      version = "1.2.0.20250223.143804";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vc-got-1.2.0.20250223.143804.tar";
        sha256 = "18rph07s97jhnfc13kpfma82i7y5nkj9z697xxqxzzz8ijnqncnw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vc-got.html";
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
      version = "1.14.1.0.20230605.161947";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vc-hgcmd-1.14.1.0.20230605.161947.tar";
        sha256 = "1qrrbr7qgbsc00mrbslaa0k6n3dnighw5dq3mx1hlgz0flm623gi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vc-hgcmd.html";
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
      version = "0.4.0.20251007.180307";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vc-jj-0.4.0.20251007.180307.tar";
        sha256 = "0n1kqx2wlr94qb6zsd3mgikf6imb0gn0bg1hajpqv794xv58mlh8";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vc-jj.html";
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
      version = "0.2.2.0.20230718.145809";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vcard-0.2.2.0.20230718.145809.tar";
        sha256 = "14rc6glk0wyfjymiv2h5db0cxpl7j8i7h3xlm5bhvgiab00vhk6x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vcard.html";
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
      version = "1.1.0.20201127.191542";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vcl-mode-1.1.0.20201127.191542.tar";
        sha256 = "1fjf37s5yfivjbagw7m83y7z5i3dfzqnhcaga7r092v9jvkabw51";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vcl-mode.html";
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
      version = "0.2.4.0.20230620.220116";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vdiff-0.2.4.0.20230620.220116.tar";
        sha256 = "1974s441i7hvz6jly2xzndrfpp94nidhkb6gjgfk9f5lml1z17n1";
      };
      packageRequires = [ hydra ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vdiff.html";
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
      version = "0.2.0.20250724.14151";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vecdb-0.2.0.20250724.14151.tar";
        sha256 = "09l02c9vldx4bk6cn69rnfg9kafxfif7nmsv538jhhxzf5q31z43";
      };
      packageRequires = [
        pg
        plz
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vecdb.html";
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
      version = "2025.1.1.100165202.0.20250121.85659";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/verilog-mode-2025.1.1.100165202.0.20250121.85659.tar";
        sha256 = "1m40qcgnas9sisxpg9822c59ay4pgmnvmgjl3pfi99h9wl9s87ns";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/verilog-mode.html";
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
      version = "2.5.0.20250909.214050";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vertico-2.5.0.20250909.214050.tar";
        sha256 = "0iikcz47zmdzij62q35q2f4pr6a729nk6i5hqg7bzy3fwjhryy2v";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vertico.html";
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
      version = "0.9.0.0.20250910.92713";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vertico-posframe-0.9.0.0.20250910.92713.tar";
        sha256 = "17lzg4w68rws0824dm1qn1fv9a63pwscvhabfqlfvicnkrpz7rzb";
      };
      packageRequires = [
        posframe
        vertico
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vertico-posframe.html";
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
      version = "1.0.0.20221221.82600";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vigenere-1.0.0.20221221.82600.tar";
        sha256 = "03zkmvx6cs5s0plbafb40pxs0rqx1vz12ql03zlx21h0zwgynqwf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vigenere.html";
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
      version = "1.3.0.20240721.74720";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/visual-filename-abbrev-1.3.0.20240721.74720.tar";
        sha256 = "06pl6cn2lrxjvhdjmcw0lf7hh1p4lhii86imxa2cqiciyysfxm9c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/visual-filename-abbrev.html";
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
      version = "0.2.0.20240424.95324";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/visual-fill-0.2.0.20240424.95324.tar";
        sha256 = "1vgfa29gl4rh6gx08r1imlabznrlmx21p41ns62w9lxi6y8hzf8y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/visual-fill.html";
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
      version = "1.7.2.0.20231016.224412";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vlf-1.7.2.0.20231016.224412.tar";
        sha256 = "1smcw9x38cl7pnxdzy8ycx6g80yb5k0qd7x1520wzbp1g31dsar1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vlf.html";
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
      version = "2.4.0.0.20250927.224241";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/vundo-2.4.0.0.20250927.224241.tar";
        sha256 = "0y6zx6mld7dy2cqlcr81zm4g0vdm7ib92c9d1zca2b8i5pg5qfrp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/vundo.html";
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
      version = "2021.0.20220101.81620";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wcheck-mode-2021.0.20220101.81620.tar";
        sha256 = "15785pi3fgfdi3adsa4lhsbdqw6bnfcm44apxpfixqfx56d3xh8m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wcheck-mode.html";
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
      version = "0.2.1.0.20201202.220257";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wconf-0.2.1.0.20201202.220257.tar";
        sha256 = "0nnf2jak4hjzj2m2v44ymnyvsgiyzz49nnz48j3cpiw7vpb79ibh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wconf.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  web-server = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "web-server";
      ename = "web-server";
      version = "0.1.2.0.20210811.22503";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/web-server-0.1.2.0.20210811.22503.tar";
        sha256 = "1d2ij23gswvg41xgdg51m2prqn1f9lcwb2rb9rh3s9p6skj14y9b";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/web-server.html";
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
      version = "1.1.2.0.20210605.74155";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/webfeeder-1.1.2.0.20210605.74155.tar";
        sha256 = "1xcaycimshijmyq071i5qch3idjfl3g4sws9ig97a9hx3m5wfi53";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/webfeeder.html";
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
      version = "1.15.0.20230808.230535";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/websocket-1.15.0.20230808.230535.tar";
        sha256 = "15xry8bv9vcc470j3an5ks9z2hg7ia4nl7x4xvqb77rpbkq53rb9";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/websocket.html";
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
      version = "3.6.1.0.20250330.141700";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/which-key-3.6.1.0.20250330.141700.tar";
        sha256 = "0gg43zbsvfkhzbaw3msvd6kvimkdih2j15g63dz3nfq11m9iw70l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/which-key.html";
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
      version = "3.0.2.0.20240314.125442";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/window-commander-3.0.2.0.20240314.125442.tar";
        sha256 = "082fwi8basfddwvi5yjgvdbf0f7xh58kmbvshnpim143pyxzgi9q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/window-commander.html";
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
      version = "0.3.0.20250313.50858";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/window-tool-bar-0.3.0.20250313.50858.tar";
        sha256 = "00cvxm8qgfck1ydc3089c4p707wmqb2x0z2nc8xjzb38p4khw0pr";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/window-tool-bar.html";
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
      version = "0.0.1.0.20200212.91532";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/windower-0.0.1.0.20200212.91532.tar";
        sha256 = "1s9kq9256x8chayqfcczxfcdb67pk6752xg7v6ixb9f3ad590ls2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/windower.html";
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
      version = "0.1.0.20221221.82616";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/windresize-0.1.0.20221221.82616.tar";
        sha256 = "0hgfyhz3jx4yhxspvh8zb4s852j8iwijrg7d4madr1p9rm2g3pjq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/windresize.html";
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
      version = "4.3.2.0.20240313.173240";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wisi-4.3.2.0.20240313.173240.tar";
        sha256 = "01i5r77ndxy76gby6v4j25w4pf6kmqaxagya29b9gnrnw07m8n5b";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wisi.html";
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
      version = "1.3.0.0.20231023.83923";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wisitoken-grammar-mode-1.3.0.0.20231023.83923.tar";
        sha256 = "0ai5s1sgy0wk8hc84w7da65p30ldk514n2h6hqa71f9ia5jbd0j8";
      };
      packageRequires = [
        mmm-mode
        wisi
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wisitoken-grammar-mode.html";
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
      version = "1.1.0.20221221.82918";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wpuzzle-1.1.0.20221221.82918.tar";
        sha256 = "0ky8n0xjxsw4a684g3l8imbrfsvbc9nq1i8gi1y384qjvvjqxaxv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wpuzzle.html";
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
      version = "4.17.6.0.20240929.62253";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/wrap-search-4.17.6.0.20240929.62253.tar";
        sha256 = "0y0pscf44blym8hkirbhrpcr9sjk2jdx7rfwvnfs9nnhq2a57ihm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/wrap-search.html";
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
      version = "1.11.1.0.20240912.92814";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xclip-1.11.1.0.20240912.92814.tar";
        sha256 = "1w4sprqnhlrmwq2jccwxz1mc9jsm2hlmzwfb42jvraanybcbal4n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xclip.html";
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
      version = "3.6.0.20250501.222827";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xeft-3.6.0.20250501.222827.tar";
        sha256 = "157384q5asxxibjz3g537cl0pa39z6scji53c3wnj8w3w1zm6jbm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xeft.html";
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
      version = "0.21.0.20250724.152124";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xelb-0.21.0.20250724.152124.tar";
        sha256 = "1j9s7kqngz1vy9v7j4bbj7mbqi4ljwqz12gkix56ql92yxycw941";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xelb.html";
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
      version = "1.0.5.0.20230911.4618";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xpm-1.0.5.0.20230911.4618.tar";
        sha256 = "0ymby7wqz6bmn4kcl0if0ybhafba139pgmzifvk00bh7r0s5gsz9";
      };
      packageRequires = [
        cl-lib
        queue
      ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xpm.html";
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
      version = "2.1.0.20250904.163110";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xr-2.1.0.20250904.163110.tar";
        sha256 = "1xa4y8dlkcskxhvd3gyfpfibkhgxfx25lf89km33wwz4d7vibzc9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xr.html";
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
      version = "1.7.0.0.20250515.124004";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xref-1.7.0.0.20250515.124004.tar";
        sha256 = "1h93z4dlk7vd2wif93zsypr55mdfnd2yyy6n69wz3d410jf51jf7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xref.html";
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
      version = "0.2.0.0.20231225.162837";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/xref-union-0.2.0.0.20231225.162837.tar";
        sha256 = "0is4r12r30drq1msa5143bgnwam1kgbf2iia30fbqv0l0rhvqd9x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/xref-union.html";
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
      version = "1.2.0.0.20250316.172129";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/yaml-1.2.0.0.20250316.172129.tar";
        sha256 = "0alwrb50napf86jimcnbjbkpd3nizvizskxa8rpglqn5yllj5qlw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/yaml.html";
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
      version = "0.14.3.0.20250604.12916";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/yasnippet-0.14.3.0.20250604.12916.tar";
        sha256 = "0dx89kw6pvbj8dhf0cza660zcpd2las9add9dm5ak6x6x56sw3s8";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/yasnippet.html";
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
      version = "1.0.2.0.20221221.83103";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/yasnippet-classic-snippets-1.0.2.0.20221221.83103.tar";
        sha256 = "01066fmg42031naaqpy1ls8xw8k2hq02sib43smx20wdbqak6gx7";
      };
      packageRequires = [ yasnippet ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/yasnippet-classic-snippets.html";
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
      version = "2023.6.11.0.20231018.110342";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/zones-2023.6.11.0.20231018.110342.tar";
        sha256 = "0gyla7n7znzhxfdwb9jmxkijvidpxvqs9p68dbaiyk86daq2pxzm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/zones.html";
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
      version = "1.0.6.0.20230617.194317";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/ztree-1.0.6.0.20230617.194317.tar";
        sha256 = "1zh6qdzalvikb48dc0pk3rnk7jvknx07dkrggc259q61jdp3pj1m";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/ztree.html";
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
      version = "0.4.0.0.20230524.131806";
      src = fetchurl {
        url = "https://elpa.gnu.org/devel/zuul-0.4.0.0.20230524.131806.tar";
        sha256 = "1pvfi8dp5i6h7z35h91408pz8bsval35sd7dk02v0hr6znln0pvb";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.gnu.org/devel/zuul.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
