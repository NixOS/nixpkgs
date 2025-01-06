{ callPackage }:
{
  adoc-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "adoc-mode";
      ename = "adoc-mode";
      version = "0.8.0snapshot0.20240218.103518";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/adoc-mode-0.8.0snapshot0.20240218.103518.tar";
        sha256 = "149cj68amidnb9pgg3xh6bpfaxbcqlv5wnacajp4pr4cn5byr0sy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/adoc-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  afternoon-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "afternoon-theme";
      ename = "afternoon-theme";
      version = "0.1.0.20140104.185934";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/afternoon-theme-0.1.0.20140104.185934.tar";
        sha256 = "07x6mfmwci8m7dsrvvd679a1pj56dcd82bzr9dnhi7hy5nvnb93d";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/afternoon-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  alect-themes = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "alect-themes";
      ename = "alect-themes";
      version = "0.10.0.20211022.165129";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/alect-themes-0.10.0.20211022.165129.tar";
        sha256 = "1p9p5p58cyz5m1bsrm4icazm049n4q72mwawp0zlibsdqywjliqj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/alect-themes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ample-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ample-theme";
      ename = "ample-theme";
      version = "0.3.0.0.20240426.84530";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/ample-theme-0.3.0.0.20240426.84530.tar";
        sha256 = "00h1za3qdqjgaxr2c3qlmz374gl9fhrgg7r453wvkz1fy6n9vp5i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/ample-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  annotate = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "annotate";
      ename = "annotate";
      version = "2.2.3.0.20241017.150805";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/annotate-2.2.3.0.20241017.150805.tar";
        sha256 = "19m3xg2yhf9gxyvp3n143dkyb6r592b2bv7sxcj4g8fhm7qlj6jc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/annotate.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  anti-zenburn-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "anti-zenburn-theme";
      ename = "anti-zenburn-theme";
      version = "2.5.1.0.20180712.183837";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/anti-zenburn-theme-2.5.1.0.20180712.183837.tar";
        sha256 = "1jn3kzzqjmcrfq381y71cc3ffyk0dr16nf86x193vm5jynbc3scq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/anti-zenburn-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  anzu = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "anzu";
      ename = "anzu";
      version = "0.66.0.20240928.212403";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/anzu-0.66.0.20240928.212403.tar";
        sha256 = "1a96jbbg2miprbdj79l4q2k12r4wxklmbrrw3smfyrp5hisj71gc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/anzu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  apache-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "apache-mode";
      ename = "apache-mode";
      version = "2.2.0.0.20240327.1751";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apache-mode-2.2.0.0.20240327.1751.tar";
        sha256 = "0yr3m1340327skxln7z2acns6kingaid4wryi9lyfv05fwhfgl5a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/apache-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  apropospriate-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "apropospriate-theme";
      ename = "apropospriate-theme";
      version = "0.2.0.0.20241118.190153";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apropospriate-theme-0.2.0.0.20241118.190153.tar";
        sha256 = "0nqnf57bf21wg2vlw85msg927618hhsn4qfwd60vrx70260432kf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/apropospriate-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  arduino-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      spinner,
    }:
    elpaBuild {
      pname = "arduino-mode";
      ename = "arduino-mode";
      version = "1.3.1.0.20240527.160335";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/arduino-mode-1.3.1.0.20240527.160335.tar";
        sha256 = "016cidd24b098jnqsxi79pigakhpdl9cglhypa50xf3nnqpa6p75";
      };
      packageRequires = [ spinner ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/arduino-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  auto-dim-other-buffers = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "auto-dim-other-buffers";
      ename = "auto-dim-other-buffers";
      version = "2.1.1.0.20240515.131159";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/auto-dim-other-buffers-2.1.1.0.20240515.131159.tar";
        sha256 = "1dp3q1hrdcvi82pcj5hxha9yyy9lkdqs8kxfq6v7lq716wxkwxfl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/auto-dim-other-buffers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  autothemer = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "autothemer";
      ename = "autothemer";
      version = "0.2.18.0.20230907.60046";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/autothemer-0.2.18.0.20230907.60046.tar";
        sha256 = "0qay7d5z0p91kzpbp140daqyiclsksql6cnp0bn1602n4f3dn4ii";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/autothemer.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  base32 = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "base32";
      ename = "base32";
      version = "1.0.0.20240227.184114";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/base32-1.0.0.20240227.184114.tar";
        sha256 = "0nxxymnxy9sd12w1kfj8n86zbhxf40mi12nmb3q0wigg2nynl31k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/base32.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bash-completion = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bash-completion";
      ename = "bash-completion";
      version = "3.1.1.0.20241118.194353";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bash-completion-3.1.1.0.20241118.194353.tar";
        sha256 = "10cirfnwz34yc7glf1xzshq3926jdwdf3s7bdarykrkxmsrha4f7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/bash-completion.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  beancount = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "beancount";
      ename = "beancount";
      version = "0.9.0.20240908.163924";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/beancount-0.9.0.20240908.163924.tar";
        sha256 = "0iqshz6xamnhx4m5phr5zrfmai61l41f44hmyiqvwqg6spyf6nzi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/beancount.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  better-jumper = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "better-jumper";
      ename = "better-jumper";
      version = "1.0.1.0.20241009.111701";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/better-jumper-1.0.1.0.20241009.111701.tar";
        sha256 = "1ghi9g9bdai7i7fh9s5nldl9zfk3si9vjjn66qldb6q7v4g86gxx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/better-jumper.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bind-map = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bind-map";
      ename = "bind-map";
      version = "1.1.2.0.20240308.155008";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bind-map-1.1.2.0.20240308.155008.tar";
        sha256 = "1vrn55667x38qqcaqy8f9p1l5f79j551qjw4m01k5ndan1ybbs8p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/bind-map.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  bison-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "bison-mode";
      ename = "bison-mode";
      version = "0.4.0.20210527.1753";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bison-mode-0.4.0.20210527.1753.tar";
        sha256 = "0mx6qvy68cnc2j9ji8qyryqwlmqfyf21v65iqcqpjqmi7h0w8rk1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/bison-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  blow = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "blow";
      ename = "blow";
      version = "1.0.0.20221128.51815";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/blow-1.0.0.20221128.51815.tar";
        sha256 = "1g7y9p3gr4v7bzrmwyssx5pf6zj9i0s7rggqyq3c4gssachicdiy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/blow.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  blueprint-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "blueprint-ts-mode";
      ename = "blueprint-ts-mode";
      version = "0.0.3.0.20231031.183012";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/blueprint-ts-mode-0.0.3.0.20231031.183012.tar";
        sha256 = "1pa2a2r54pn7lmkgmwrc2lxvnabjbjlqs8rgkmqrfgnq1gkrm6rh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/blueprint-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  boxquote = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "boxquote";
      ename = "boxquote";
      version = "2.3.0.20231216.85245";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/boxquote-2.3.0.20231216.85245.tar";
        sha256 = "1b5kqxpvxfzq8n0q1bqjbyb0vmrsdm02qfai28ihxqixk4q8czbi";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/boxquote.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  buttercup = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "buttercup";
      ename = "buttercup";
      version = "1.36.0.20240904.231112";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/buttercup-1.36.0.20240904.231112.tar";
        sha256 = "1kshwvzszv5jpjf3j5rpwas0zs60xprk0v30w58822vh13swcqrc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/buttercup.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  camera = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "camera";
      ename = "camera";
      version = "0.3.0.20230828.93723";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/camera-0.3.0.20230828.93723.tar";
        sha256 = "1mykzs3filgi3za7rq4imjy8hymy3i4nsr8k9bcqvd5h3z19ijhm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/camera.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  caml = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "caml";
      ename = "caml";
      version = "4.10snapshot0.20231010.232819";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/caml-4.10snapshot0.20231010.232819.tar";
        sha256 = "0dw5429dy1m4jj0khs58fc8cisky8yd9m58ckhjx5qf1k1bm0hji";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/caml.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cdlatex = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cdlatex";
      ename = "cdlatex";
      version = "4.18.5.0.20241007.162342";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cdlatex-4.18.5.0.20241007.162342.tar";
        sha256 = "0zk8whr3644kab13p11rvbdrqlr2np6s0h329ggvw7bnsphg35yw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/cdlatex.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cider = callPackage (
    {
      clojure-mode,
      elpaBuild,
      fetchurl,
      lib,
      parseedn,
      queue,
      seq,
      sesman,
      spinner,
      transient,
    }:
    elpaBuild {
      pname = "cider";
      ename = "cider";
      version = "1.16.1.0.20241203.160720";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cider-1.16.1.0.20241203.160720.tar";
        sha256 = "0b6nqhg5c0ny8ilm4653c7pd34aj02bh6ya9bzc9swdpyq7pwnqr";
      };
      packageRequires = [
        clojure-mode
        parseedn
        queue
        seq
        sesman
        spinner
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/cider.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  clojure-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "clojure-mode";
      ename = "clojure-mode";
      version = "5.20.0snapshot0.20241125.112305";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-mode-5.20.0snapshot0.20241125.112305.tar";
        sha256 = "0hh17w63j5x4687kbd2vmlj9qs468ivq54mwwcm6p43wr7rvk2cj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/clojure-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  clojure-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "clojure-ts-mode";
      ename = "clojure-ts-mode";
      version = "0.2.2.0.20241104.213550";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-ts-mode-0.2.2.0.20241104.213550.tar";
        sha256 = "0b37iccwh8l6z0q3ls3ysfy7pjp8q52kbiw4lipjgljg0lmj5lsv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/clojure-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  coffee-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "coffee-mode";
      ename = "coffee-mode";
      version = "0.6.3.0.20230908.103000";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/coffee-mode-0.6.3.0.20230908.103000.tar";
        sha256 = "171rj50xg708lmqmxh73ij92vdx07di2yw77bfywrbhrqb2bhvh6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/coffee-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  consult-flycheck = callPackage (
    {
      consult,
      elpaBuild,
      fetchurl,
      flycheck,
      lib,
    }:
    elpaBuild {
      pname = "consult-flycheck";
      ename = "consult-flycheck";
      version = "1.0.0.20241114.112007";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/consult-flycheck-1.0.0.20241114.112007.tar";
        sha256 = "1jzli50sjr8pv2j9qg7glxdgm54sx2yw6xr7ka738gisa1r0iscl";
      };
      packageRequires = [
        consult
        flycheck
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/consult-flycheck.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  corfu-terminal = callPackage (
    {
      corfu,
      elpaBuild,
      fetchurl,
      lib,
      popon,
    }:
    elpaBuild {
      pname = "corfu-terminal";
      ename = "corfu-terminal";
      version = "0.7.0.20230810.20636";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/corfu-terminal-0.7.0.20230810.20636.tar";
        sha256 = "0cz5qzdz4npd9lc4z06mwclrp6w1vw6vdqzgkhdjnfgi0ciylil0";
      };
      packageRequires = [
        corfu
        popon
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/corfu-terminal.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  crux = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "crux";
      ename = "crux";
      version = "0.5.0.0.20240401.113645";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/crux-0.5.0.0.20240401.113645.tar";
        sha256 = "12pk351yrj850rg1yd9spxwrhkjlllgxbpbpfs829vnbpnvxlp6f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/crux.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  csv2ledger = callPackage (
    {
      csv-mode,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "csv2ledger";
      ename = "csv2ledger";
      version = "1.5.4.0.20241109.230511";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/csv2ledger-1.5.4.0.20241109.230511.tar";
        sha256 = "1ank47lk4qgmbgr7qb9fgkramc7qngs93rq0rnlvkdh2fm198ywj";
      };
      packageRequires = [ csv-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/csv2ledger.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cyberpunk-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cyberpunk-theme";
      ename = "cyberpunk-theme";
      version = "1.22.0.20240112.144451";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cyberpunk-theme-1.22.0.20240112.144451.tar";
        sha256 = "05p6159ay4lil44mq7a1715jjv3rw6lh5f1ax4w98lf7v4kwl0hx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/cyberpunk-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  cycle-at-point = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      recomplete,
    }:
    elpaBuild {
      pname = "cycle-at-point";
      ename = "cycle-at-point";
      version = "0.2.0.20240422.30057";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cycle-at-point-0.2.0.20240422.30057.tar";
        sha256 = "18nlbg8jwdgvi56qgbvqs0z8yfj9nkw30da45d7anjaln6a8089j";
      };
      packageRequires = [ recomplete ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/cycle-at-point.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  d-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "d-mode";
      ename = "d-mode";
      version = "202408131340.0.20241126.105644";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/d-mode-202408131340.0.20241126.105644.tar";
        sha256 = "11hc3dyxyr1pcq25jvw9x3ys4v73rbqw9p19s4i59p9mdb0bnxpy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/d-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dart-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dart-mode";
      ename = "dart-mode";
      version = "1.0.7.0.20240925.1934";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dart-mode-1.0.7.0.20240925.1934.tar";
        sha256 = "0pzhvlbfdk0adj4by21knbpvkj99dzclhixad2cdyfvqgw3j1xkk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dart-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  denote-refs = callPackage (
    {
      denote,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "denote-refs";
      ename = "denote-refs";
      version = "0.1.2.0.20230115.155857";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/denote-refs-0.1.2.0.20230115.155857.tar";
        sha256 = "02d8vmlhxjj4vqlk8mnrym1xqdgznf83n7a8am5i3blrc3s48zs0";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/denote-refs.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  devhelp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "devhelp";
      ename = "devhelp";
      version = "1.0.0.20221128.51631";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/devhelp-1.0.0.20221128.51631.tar";
        sha256 = "0mkpagxz3vj8cwx9rxrdzygjf448iplmr89pani1q755ikz19njh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/devhelp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  devil = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "devil";
      ename = "devil";
      version = "0.7.0beta3.0.20240129.2809";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/devil-0.7.0beta3.0.20240129.2809.tar";
        sha256 = "1fhvp1kvvli5g9a3575bsa8zyfnf1q0p5wn15819zvncjp1912nl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/devil.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  diff-ansi = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "diff-ansi";
      ename = "diff-ansi";
      version = "0.2.0.20240818.235912";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/diff-ansi-0.2.0.20240818.235912.tar";
        sha256 = "085h7xb75dkdmsnc572rmqgzw1pp4jmxcfrr3nnpbvirgjij8pma";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/diff-ansi.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dirvish = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "dirvish";
      ename = "dirvish";
      version = "2.0.53.0.20230519.150010";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dirvish-2.0.53.0.20230519.150010.tar";
        sha256 = "0n73giyvg244s0cxfrkc3j0jrq20bs1zili6liab0s3ks02kvqdg";
      };
      packageRequires = [ transient ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dirvish.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  doc-show-inline = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "doc-show-inline";
      ename = "doc-show-inline";
      version = "0.1.0.20240616.234552";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/doc-show-inline-0.1.0.20240616.234552.tar";
        sha256 = "0p39glahjqm2fv8xcnwyhcnzsf53g15013jbnj1lh7610bdgfk6g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/doc-show-inline.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dockerfile-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dockerfile-mode";
      ename = "dockerfile-mode";
      version = "1.7.0.20240914.114946";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dockerfile-mode-1.7.0.20240914.114946.tar";
        sha256 = "1v7yv221p844249m75ip41p0khn2gas7hfv8b0np3g78pzdai4mw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dockerfile-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dracula-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dracula-theme";
      ename = "dracula-theme";
      version = "1.8.2.0.20241102.130126";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dracula-theme-1.8.2.0.20241102.130126.tar";
        sha256 = "01f3g7cy9snm4f2b2rx7zd82kwxzlf9g0wapwa83k3i60p23rf5s";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dracula-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  drupal-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      php-mode,
    }:
    elpaBuild {
      pname = "drupal-mode";
      ename = "drupal-mode";
      version = "0.8.1.0.20240816.123653";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/drupal-mode-0.8.1.0.20240816.123653.tar";
        sha256 = "135h1bm7zyk2nhcx6j3nc7n0fi180sld655212sin650hidiygnl";
      };
      packageRequires = [ php-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/drupal-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  dslide = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dslide";
      ename = "dslide";
      version = "0.5.5.0.20241128.111432";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dslide-0.5.5.0.20241128.111432.tar";
        sha256 = "1d2rsqzn8w6w3qvsfsgpmjwn53nsj30jivli02d7n24q30pxzpv6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dslide.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eat = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "eat";
      ename = "eat";
      version = "0.9.4.0.20240314.193241";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/eat-0.9.4.0.20240314.193241.tar";
        sha256 = "1ry5mlg9wmdr4n5zjq1n45z0xhnrpgjyr6611xd9j43i6dnldb38";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/eat.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  edit-indirect = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "edit-indirect";
      ename = "edit-indirect";
      version = "0.1.13.0.20240128.11949";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/edit-indirect-0.1.13.0.20240128.11949.tar";
        sha256 = "1hb37vcda0ksbkm4ibr3nz5d8l4s15awff5qhdvjxihsnnj7fnz1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/edit-indirect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  editorconfig = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "editorconfig";
      ename = "editorconfig";
      version = "0.11.0.0.20241027.181535";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/editorconfig-0.11.0.0.20241027.181535.tar";
        sha256 = "17vx1rf8dnyfkj1c7cv2zw9kvrc9cllm3wr4r0wik31xrkw7zpdj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/editorconfig.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  elixir-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "elixir-mode";
      ename = "elixir-mode";
      version = "2.5.0.0.20230626.143859";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/elixir-mode-2.5.0.0.20230626.143859.tar";
        sha256 = "109v0lh9jfrva2qxa0zxw2zgjl4q67rx3ijsgsyg3m1p8rx2kpba";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/elixir-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  elpher = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "elpher";
      ename = "elpher";
      version = "3.6.4.0.20241022.162545";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/elpher-3.6.4.0.20241022.162545.tar";
        sha256 = "070njpzhspzgpry9wy69l76kmfdwzy8c5nx32kr0isx7b6qzvb5v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/elpher.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  emacsql = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "emacsql";
      ename = "emacsql";
      version = "4.1.0.0.20241201.155153";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/emacsql-4.1.0.0.20241201.155153.tar";
        sha256 = "10sqyqba0jsf1w6i7x77vxgj13wjzr3k9bcpzmzxhqgprakndixy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/emacsql.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  engine-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "engine-mode";
      ename = "engine-mode";
      version = "2.2.4.0.20230911.95607";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/engine-mode-2.2.4.0.20230911.95607.tar";
        sha256 = "05avl4rdv2drlg9vzwld064dpf53cyqbf8pqnglsxwrimm7cd9yv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/engine-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      goto-chg,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "evil";
      ename = "evil";
      version = "1.15.0.0.20241006.175409";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-1.15.0.0.20241006.175409.tar";
        sha256 = "0w752hhnpkfa5wqm1rk6nzq6n9y8c8mjzjhzri91l06jngpl6ckd";
      };
      packageRequires = [
        cl-lib
        goto-chg
        nadvice
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-anzu = callPackage (
    {
      anzu,
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-anzu";
      ename = "evil-anzu";
      version = "0.2.0.20220911.193944";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-anzu-0.2.0.20220911.193944.tar";
        sha256 = "0ap13nrpcjm9q7pia8jy544sc08gc44bgyqi7yvkh2yk8cw96g8m";
      };
      packageRequires = [
        anzu
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-anzu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-args = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-args";
      ename = "evil-args";
      version = "1.1.0.20240209.210417";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-args-1.1.0.20240209.210417.tar";
        sha256 = "0k1awcw8rdc5fwj03kw1xmc4iw2ivmv39lrs4pdp9by7396i6829";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-args.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-escape = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-escape";
      ename = "evil-escape";
      version = "3.16.0.20231122.211452";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-escape-3.16.0.20231122.211452.tar";
        sha256 = "1yv77vxvyl41795h7ixl6fhm43n7q6xqkqp1yaqgv5g9iymdj1s0";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-escape.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-exchange = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-exchange";
      ename = "evil-exchange";
      version = "0.41.0.20220111.55801";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-exchange-0.41.0.20220111.55801.tar";
        sha256 = "0fgw327b2gpppynrxpp6gs2ixhzchgi5wg97nan7cf5cp3c367ax";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-exchange.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-goggles = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-goggles";
      ename = "evil-goggles";
      version = "0.0.2.0.20231021.73827";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-goggles-0.0.2.0.20231021.73827.tar";
        sha256 = "10h27w2id8iv53nndjpv9rb99v758j041l2h4kl1kfy2ar8a7vk6";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-goggles.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-iedit-state = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      iedit,
      lib,
    }:
    elpaBuild {
      pname = "evil-iedit-state";
      ename = "evil-iedit-state";
      version = "1.3.0.20220219.93900";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-iedit-state-1.3.0.20220219.93900.tar";
        sha256 = "1fvwjvhzrkiaixvfsh2nrlhsvyw5igaighfpk57mnbyxarfc1564";
      };
      packageRequires = [
        evil
        iedit
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-iedit-state.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-indent-plus = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-indent-plus";
      ename = "evil-indent-plus";
      version = "1.0.1.0.20230927.151313";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-indent-plus-1.0.1.0.20230927.151313.tar";
        sha256 = "0vm6bsy33hc79nz17861wrxs3l56fsgc08s1lr6v3k65nwkv6i3m";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-indent-plus.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-lisp-state = callPackage (
    {
      bind-map,
      elpaBuild,
      evil,
      fetchurl,
      lib,
      smartparens,
    }:
    elpaBuild {
      pname = "evil-lisp-state";
      ename = "evil-lisp-state";
      version = "8.2.0.20160403.224859";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-lisp-state-8.2.0.20160403.224859.tar";
        sha256 = "0ms80bxj64n7rqwjlqk4yqwwa1g90ldmb9vs597axzs25mv5jszk";
      };
      packageRequires = [
        bind-map
        evil
        smartparens
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-lisp-state.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-matchit = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-matchit";
      ename = "evil-matchit";
      version = "3.0.4.0.20241111.120111";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-matchit-3.0.4.0.20241111.120111.tar";
        sha256 = "1jv7rs102i00kwdkj1n3l0j9as0kbrylhkkn2rrgwv9b97lmlirs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-matchit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-nerd-commenter = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-nerd-commenter";
      ename = "evil-nerd-commenter";
      version = "3.6.1.0.20240216.114656";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-nerd-commenter-3.6.1.0.20240216.114656.tar";
        sha256 = "0wav3c5k2iz4xzrkwj7nj3xg5zp9nldynxag2gl7p3nkz4scg49r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-nerd-commenter.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-numbers = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-numbers";
      ename = "evil-numbers";
      version = "0.7.0.20241204.12906";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-numbers-0.7.0.20241204.12906.tar";
        sha256 = "1r4ic5db8vl3mslp48w8lqx904raxi8lzp512jcjv21vs36gjl97";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-numbers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-surround = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-surround";
      ename = "evil-surround";
      version = "1.0.4.0.20240325.85222";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-surround-1.0.4.0.20240325.85222.tar";
        sha256 = "0ji4pp9dp0284km585a3iay60m9v0xzsn42g3fw431vadbs0y5ym";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-surround.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-visual-mark-mode = callPackage (
    {
      dash,
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-visual-mark-mode";
      ename = "evil-visual-mark-mode";
      version = "0.0.5.0.20230202.31851";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-visual-mark-mode-0.0.5.0.20230202.31851.tar";
        sha256 = "1n394k0mm3g44ai101651168h7gw8nr1ci2acb0bfr5qcpdc7g8d";
      };
      packageRequires = [
        dash
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-visual-mark-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil-visualstar = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-visualstar";
      ename = "evil-visualstar";
      version = "0.2.0.0.20160222.194815";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-visualstar-0.2.0.0.20160222.194815.tar";
        sha256 = "1577xx0fblnf7n28brfi959kw3hw85498vza1dsh6r5nhalawhg7";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-visualstar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  exec-path-from-shell = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "exec-path-from-shell";
      ename = "exec-path-from-shell";
      version = "2.2.0.20241107.71915";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/exec-path-from-shell-2.2.0.20241107.71915.tar";
        sha256 = "17wyy2agi9j7vny0wdi5mxp1nz7zpzi6ayx55ls1cdxwd7v2jyvf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/exec-path-from-shell.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flx = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flx";
      ename = "flx";
      version = "0.6.2.0.20240204.195634";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flx-0.6.2.0.20240204.195634.tar";
        sha256 = "0k2irlx6v1mn23qvpsq1p6mdy8a78sx9xbnvy9ah1hnsq2z9x4ay";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flx.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flx-ido = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      flx,
      lib,
    }:
    elpaBuild {
      pname = "flx-ido";
      ename = "flx-ido";
      version = "0.6.2.0.20240204.195634";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flx-ido-0.6.2.0.20240204.195634.tar";
        sha256 = "1d9hg8pryf30bz9rnpb081vhw2axvbk62i9wiyfq0n0zwi23dwhj";
      };
      packageRequires = [
        cl-lib
        flx
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flx-ido.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flycheck = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flycheck";
      ename = "flycheck";
      version = "35.0snapshot0.20241130.150233";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flycheck-35.0snapshot0.20241130.150233.tar";
        sha256 = "08viqbba50alfj3783ykymjqwpi08si6bi411sm29gagga1cjxr6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flycheck.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-guile = callPackage (
    {
      elpaBuild,
      fetchurl,
      flymake ? null,
      lib,
    }:
    elpaBuild {
      pname = "flymake-guile";
      ename = "flymake-guile";
      version = "0.5.0.20230905.194410";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flymake-guile-0.5.0.20230905.194410.tar";
        sha256 = "1zxyz5nsx8dsg0x8ad6vkqs34pca62avswcvvkpgrcapxqvah9dq";
      };
      packageRequires = [ flymake ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flymake-guile.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-kondor = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-kondor";
      ename = "flymake-kondor";
      version = "0.1.3.0.20211026.50126";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flymake-kondor-0.1.3.0.20211026.50126.tar";
        sha256 = "0b64x7rziyzr0db0hgfcccy3gw95588q6bs77v4d9gyjl32yz8jn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flymake-kondor.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  flymake-popon = callPackage (
    {
      elpaBuild,
      fetchurl,
      flymake ? null,
      lib,
      popon,
      posframe,
    }:
    elpaBuild {
      pname = "flymake-popon";
      ename = "flymake-popon";
      version = "0.5.1.0.20230208.145056";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flymake-popon-0.5.1.0.20230208.145056.tar";
        sha256 = "0afkz6izdxzizip48ggnr1cdcfxkrj7ww1lb7jvd0cbpsx7lc126";
      };
      packageRequires = [
        flymake
        popon
        posframe
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flymake-popon.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  focus = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "focus";
      ename = "focus";
      version = "1.0.1.0.20241029.150652";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/focus-1.0.1.0.20241029.150652.tar";
        sha256 = "08ryv68xfvlgbsyq80r9bycj4d9dbdz0v7ipdgjxnxfkp3di2s01";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/focus.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  forth-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "forth-mode";
      ename = "forth-mode";
      version = "0.2.0.20231206.112722";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/forth-mode-0.2.0.20231206.112722.tar";
        sha256 = "0vx3ic6xjpw6xfxb42n7fipkrxfbn1z86hngzg1yz77mig0fvw3n";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/forth-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  free-keys = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "free-keys";
      ename = "free-keys";
      version = "1.0.0.20211116.150106";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/free-keys-1.0.0.20211116.150106.tar";
        sha256 = "08z5w5xxaz577lnwfmvrbh7485rbra7rl6b77m54vjxi24m75jhv";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/free-keys.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gc-buffers = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gc-buffers";
      ename = "gc-buffers";
      version = "1.0.0.20221128.50935";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gc-buffers-1.0.0.20221128.50935.tar";
        sha256 = "0c7pwhpk4qmw6jdryabr051vwm5k0r9p1snwl1117wavcbdf3psx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gc-buffers.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "geiser";
      ename = "geiser";
      version = "0.31.1.0.20240907.224131";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-0.31.1.0.20240907.224131.tar";
        sha256 = "1h8ifdccg72rfj1hgp8lshaklnql1vhgdi9i35057z76zwivsxn2";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-chez = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-chez";
      ename = "geiser-chez";
      version = "0.18.0.20230707.93440";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-chez-0.18.0.20230707.93440.tar";
        sha256 = "1rl6qazqjjcwzyanx4bra3xmw9fjrpa6dkz36kfcvj8i8z7hsmcq";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-chez.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-chibi = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-chibi";
      ename = "geiser-chibi";
      version = "0.17.0.20240521.155242";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-chibi-0.17.0.20240521.155242.tar";
        sha256 = "0xiaikj274ypfj546snxpi6h30jlc9hifhnw8ljj1zxsafr1wzqq";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-chibi.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-chicken = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-chicken";
      ename = "geiser-chicken";
      version = "0.17.0.20241204.11932";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-chicken-0.17.0.20241204.11932.tar";
        sha256 = "1l95d72wl74mlfa50m9m999skj993vqdmm13qm42n0lp0y9ndvyf";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-chicken.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-gambit = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-gambit";
      ename = "geiser-gambit";
      version = "0.18.1.0.20220208.135610";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-gambit-0.18.1.0.20220208.135610.tar";
        sha256 = "07m1n1m8n869wdmwvfjimd8yamxp6hbx40mz07fcm826m553v670";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-gambit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-gauche = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-gauche";
      ename = "geiser-gauche";
      version = "0.0.2.0.20220503.170006";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-gauche-0.0.2.0.20220503.170006.tar";
        sha256 = "159wlbsv6wr0wpp4y0a5y2dm7bk4rpzkvc7phl9ry3a60r10h8yc";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-gauche.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-guile = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "geiser-guile";
      ename = "geiser-guile";
      version = "0.28.3.0.20240920.3540";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-guile-0.28.3.0.20240920.3540.tar";
        sha256 = "1ijrhz86nva194qsdch2zm9v4bzdppcg3vslnh03ss4f6qkcrfzz";
      };
      packageRequires = [
        geiser
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-guile.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-kawa = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-kawa";
      ename = "geiser-kawa";
      version = "0.0.1.0.20210920.160740";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-kawa-0.0.1.0.20210920.160740.tar";
        sha256 = "1qbdmzv81gn3y3rgm10yadhw86a0p9lmxq8da4865x9gkccf2wa6";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-kawa.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-mit = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-mit";
      ename = "geiser-mit";
      version = "0.15.0.20240909.114537";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-mit-0.15.0.20240909.114537.tar";
        sha256 = "1a0j47f6qmn0p5zfv7gylgz8q9iax4xl6a7y9xq76cs2x6mi5883";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-mit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-racket = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-racket";
      ename = "geiser-racket";
      version = "0.16.0.20210421.12547";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-racket-0.16.0.20210421.12547.tar";
        sha256 = "0vqs61ga54mj241p7l5mly9pn8m819znm2dvw3hnlw3p6xp89fgq";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-racket.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  geiser-stklos = callPackage (
    {
      elpaBuild,
      fetchurl,
      geiser,
      lib,
    }:
    elpaBuild {
      pname = "geiser-stklos";
      ename = "geiser-stklos";
      version = "1.8.0.20240521.161150";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-stklos-1.8.0.20240521.161150.tar";
        sha256 = "13y0p8iqm4lrjg5ksb8d3rgpmjs0kwak7zicdq5m7sx1x511znd7";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/geiser-stklos.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  git-commit = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      seq,
      transient,
      with-editor,
    }:
    elpaBuild {
      pname = "git-commit";
      ename = "git-commit";
      version = "4.0.0.0.20240822.173501";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/git-commit-4.0.0.0.20240822.173501.tar";
        sha256 = "0k3bd17112xvgiykybb5sffk2vywz56zgm2h56bykhqq35sdcww8";
      };
      packageRequires = [
        compat
        seq
        transient
        with-editor
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/git-commit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  git-modes = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "git-modes";
      ename = "git-modes";
      version = "1.4.4.0.20240805.132007";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/git-modes-1.4.4.0.20240805.132007.tar";
        sha256 = "0gbgjdk6gi1898nbxj2wbiifbmld42v4s2zsckgqv4r5pxdwc6ai";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/git-modes.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnosis = callPackage (
    {
      compat,
      elpaBuild,
      emacsql,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "gnosis";
      ename = "gnosis";
      version = "0.4.8.0.20241115.104152";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnosis-0.4.8.0.20241115.104152.tar";
        sha256 = "143pmwp5g2wzmmhmbwc1q6hhf86j1cywi8x2hzvlq0p5mhkkilr1";
      };
      packageRequires = [
        compat
        emacsql
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gnosis.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnu-apl-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnu-apl-mode";
      ename = "gnu-apl-mode";
      version = "1.5.1.0.20220404.34102";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnu-apl-mode-1.5.1.0.20220404.34102.tar";
        sha256 = "1da6vl1pr0k1id04fgw9pm5zcf5dkbwnx7xjgymg3n6yvm54f9kg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gnu-apl-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnu-indent = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnu-indent";
      ename = "gnu-indent";
      version = "1.0.0.20221127.211255";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnu-indent-1.0.0.20221127.211255.tar";
        sha256 = "1vfiwcw6cdl1861pjyc40r8wvagl9szqbk2icl4knl35jakxh6vl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gnu-indent.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gnuplot = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnuplot";
      ename = "gnuplot";
      version = "0.8.1.0.20240914.153054";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnuplot-0.8.1.0.20240914.153054.tar";
        sha256 = "0pv7ql14d7srb98nidw6fr4mwgssqyv95yskflz27dbbwjlycmn6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gnuplot.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  go-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "go-mode";
      ename = "go-mode";
      version = "1.6.0.0.20240630.202407";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/go-mode-1.6.0.0.20240630.202407.tar";
        sha256 = "0l99vsah7j79pfz0wnvpw4c7i9fw3miipfi7givgxanjrnyra859";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/go-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  golden-ratio = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "golden-ratio";
      ename = "golden-ratio";
      version = "1.0.1.0.20230912.112557";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/golden-ratio-1.0.1.0.20230912.112557.tar";
        sha256 = "1gwa5f9fclhky7kvpd1pwfrvx11jqjn3iqhxis4na6syh7ypk8vm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/golden-ratio.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gotham-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gotham-theme";
      ename = "gotham-theme";
      version = "1.1.9.0.20220107.173034";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gotham-theme-1.1.9.0.20220107.173034.tar";
        sha256 = "0zx9c4vh5sc6yl3m4fxpd5x77qvqqirpzkv2hwshxprhs5g9f4c8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gotham-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  goto-chg = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "goto-chg";
      ename = "goto-chg";
      version = "1.7.5.0.20240407.111017";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/goto-chg-1.7.5.0.20240407.111017.tar";
        sha256 = "0pg8k9idb59wp2h51b50dplw454caqa9gn9bcpvfil1fi7hg17h2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/goto-chg.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gptel = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "gptel";
      ename = "gptel";
      version = "0.9.6.0.20241202.163036";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gptel-0.9.6.0.20241202.163036.tar";
        sha256 = "0zlfrnp01hb6syrkgkwfi1hjxm9l4j9sqrwn7a8nmk5wlw4bi6xm";
      };
      packageRequires = [
        compat
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gptel.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  graphql-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "graphql-mode";
      ename = "graphql-mode";
      version = "1.0.0.0.20241020.75405";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/graphql-mode-1.0.0.0.20241020.75405.tar";
        sha256 = "0bds1zv0syg1jfdak2hk3kank4c532r6ki095wamxy06rwdbm2il";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/graphql-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gruber-darker-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gruber-darker-theme";
      ename = "gruber-darker-theme";
      version = "0.7.0.20231026.203102";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gruber-darker-theme-0.7.0.20231026.203102.tar";
        sha256 = "1hr2p575kz15yh4n68jymdm2i0kn7adynlnpqmcqqp8l4pr83v1f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gruber-darker-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  gruvbox-theme = callPackage (
    {
      autothemer,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gruvbox-theme";
      ename = "gruvbox-theme";
      version = "1.30.1.0.20240615.43214";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gruvbox-theme-1.30.1.0.20240615.43214.tar";
        sha256 = "0fvhcilfkhwm544z3f16vssxc7fda1klib8fidnylaqj477pfigz";
      };
      packageRequires = [ autothemer ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/gruvbox-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  guru-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "guru-mode";
      ename = "guru-mode";
      version = "1.0.0.20211025.115715";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/guru-mode-1.0.0.20211025.115715.tar";
        sha256 = "0xs41855s581xbps3clx1s1wd0rhjxm0dnlhillnqbw409phzhs5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/guru-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  haml-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "haml-mode";
      ename = "haml-mode";
      version = "3.2.1.0.20231110.173413";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haml-mode-3.2.1.0.20231110.173413.tar";
        sha256 = "0fb5mi0cqwi8186j8cqbzy1zhragj6kwxw779rkhx410vcarl4zi";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/haml-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  haskell-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "haskell-mode";
      ename = "haskell-mode";
      version = "17.5.0.20241111.151419";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-mode-17.5.0.20241111.151419.tar";
        sha256 = "1pshx7i45smkwg09w2am9q87iqawfds2nn48jczdyxh6bnk558zz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/haskell-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  haskell-tng-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      popup,
    }:
    elpaBuild {
      pname = "haskell-tng-mode";
      ename = "haskell-tng-mode";
      version = "0.0.1.0.20230522.221126";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-tng-mode-0.0.1.0.20230522.221126.tar";
        sha256 = "0744xvrnjvn30vwbfdnndmb1x1ynmz87wvdb94syd1blfkdi9f6j";
      };
      packageRequires = [ popup ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/haskell-tng-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  haskell-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "haskell-ts-mode";
      ename = "haskell-ts-mode";
      version = "1.0.20241108.150811";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-ts-mode-1.0.20241108.150811.tar";
        sha256 = "1ycbcwhj9j77jgpb3ag7hy8474qdj4rzzg7z5z79f0fqvlnv94m7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/haskell-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  helm = callPackage (
    {
      elpaBuild,
      fetchurl,
      helm-core,
      lib,
      wfnames,
    }:
    elpaBuild {
      pname = "helm";
      ename = "helm";
      version = "4.0.0.20241204.51511";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-4.0.0.20241204.51511.tar";
        sha256 = "1dzc1jg6p9r589mzwdzhlhj58239ssy85mz27kwr7yyg36cz3m3l";
      };
      packageRequires = [
        helm-core
        wfnames
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/helm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  helm-core = callPackage (
    {
      async,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "helm-core";
      ename = "helm-core";
      version = "4.0.0.20241204.51511";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-core-4.0.0.20241204.51511.tar";
        sha256 = "1xvx1x6p7r1ak40n3740q9iyah2d1npqg7aw1zybshcrai5bm9jm";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/helm-core.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hideshowvis = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hideshowvis";
      ename = "hideshowvis";
      version = "0.8.0.20240529.112833";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hideshowvis-0.8.0.20240529.112833.tar";
        sha256 = "0wb1i3p79wf39svgbvdjlhivbyankm4xklf1r63i5vlaxz5fc6di";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/hideshowvis.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  highlight-parentheses = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "highlight-parentheses";
      ename = "highlight-parentheses";
      version = "2.2.2.0.20240408.112634";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/highlight-parentheses-2.2.2.0.20240408.112634.tar";
        sha256 = "0by35fba69xnvq7jglr62i168s4jpy8jqs76gk29z92jcwk1brig";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/highlight-parentheses.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hl-block-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hl-block-mode";
      ename = "hl-block-mode";
      version = "0.2.0.20240422.12652";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hl-block-mode-0.2.0.20240422.12652.tar";
        sha256 = "1j3fp1p066j9b67hna6mh7pb96kld9nc0mkv8jl0qdwi95aah81q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/hl-block-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hl-column = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "hl-column";
      ename = "hl-column";
      version = "1.0.0.20221128.50752";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hl-column-1.0.0.20221128.50752.tar";
        sha256 = "1zvfj0271pphl8h1d9mjmicrc81s3v0jq6p9ca4cnwdk6h9x1igg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/hl-column.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  htmlize = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "htmlize";
      ename = "htmlize";
      version = "1.58.0.20240915.165713";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/htmlize-1.58.0.20240915.165713.tar";
        sha256 = "1i2gp0m2qy7rknymn3ps1ss1vsbrx0zkxb6ya1ymc5vlqblqfwya";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/htmlize.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hyperdrive = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      map,
      org,
      persist,
      plz,
      taxy-magit-section,
      transient,
    }:
    elpaBuild {
      pname = "hyperdrive";
      ename = "hyperdrive";
      version = "0.5pre0.20241106.231359";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hyperdrive-0.5pre0.20241106.231359.tar";
        sha256 = "11b3dvwzrsgg2nj3kasgrz5bwhd2i3ig4v9blzlzhyybw6wy0i1f";
      };
      packageRequires = [
        compat
        map
        org
        persist
        plz
        taxy-magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/hyperdrive.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  hyperdrive-org-transclusion = callPackage (
    {
      elpaBuild,
      fetchurl,
      hyperdrive,
      lib,
      org-transclusion,
    }:
    elpaBuild {
      pname = "hyperdrive-org-transclusion";
      ename = "hyperdrive-org-transclusion";
      version = "0.3.1.0.20241027.212737";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hyperdrive-org-transclusion-0.3.1.0.20241027.212737.tar";
        sha256 = "1lwiqhjlanxkbv556m6f8xfp63b5xk66zhmg2zazw4sx0zy97s75";
      };
      packageRequires = [
        hyperdrive
        org-transclusion
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/hyperdrive-org-transclusion.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  idle-highlight-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "idle-highlight-mode";
      ename = "idle-highlight-mode";
      version = "1.1.4.0.20240421.64727";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/idle-highlight-mode-1.1.4.0.20240421.64727.tar";
        sha256 = "0wdzvy6zhxsr4i7s0169s8pl0bd3sms2xjqlvppkyqfmvwiggqkm";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/idle-highlight-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  idris-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      prop-menu,
    }:
    elpaBuild {
      pname = "idris-mode";
      ename = "idris-mode";
      version = "1.1.0.0.20240704.133442";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/idris-mode-1.1.0.0.20240704.133442.tar";
        sha256 = "0rbgv5gkm6q3a6l8yqmgn3mn6ic9jr1w80vrl4gvkfpklwys9y5f";
      };
      packageRequires = [
        cl-lib
        prop-menu
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/idris-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  iedit = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "iedit";
      ename = "iedit";
      version = "0.9.9.9.9.0.20220216.75011";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/iedit-0.9.9.9.9.0.20220216.75011.tar";
        sha256 = "0q31dfsh3ay2ls7f4i2f52zzjz62glwnccqmxww938hayn23lfg2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/iedit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  inf-clojure = callPackage (
    {
      clojure-mode,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "inf-clojure";
      ename = "inf-clojure";
      version = "3.2.1.0.20230909.44557";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-clojure-3.2.1.0.20230909.44557.tar";
        sha256 = "0ncdqbz8z8wrcf3s1y3n1b11b7k3mwxdk4w5v7pr0j6jn3yfnbby";
      };
      packageRequires = [ clojure-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/inf-clojure.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  inf-ruby = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "inf-ruby";
      ename = "inf-ruby";
      version = "2.8.1.0.20240925.4944";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-ruby-2.8.1.0.20240925.4944.tar";
        sha256 = "1wl5nzrbafvmvvvq477lsvc14pvlmq8x9j1cqbd0cj11lvn4k1qb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/inf-ruby.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  inkpot-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "inkpot-theme";
      ename = "inkpot-theme";
      version = "0.1.0.20240610.140611";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inkpot-theme-0.1.0.20240610.140611.tar";
        sha256 = "1291cwg6vk9y8an6a1pfbv05g2yqcswwry25c9ingsyb4ql0pr6k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/inkpot-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  iwindow = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "iwindow";
      ename = "iwindow";
      version = "1.1.0.20230920.203903";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/iwindow-1.1.0.20230920.203903.tar";
        sha256 = "0xjwignqff11y92lcscs0ssg19jh7pgap5i7kdx50nwp7g1wz57h";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/iwindow.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  j-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "j-mode";
      ename = "j-mode";
      version = "2.0.1.0.20240920.120622";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/j-mode-2.0.1.0.20240920.120622.tar";
        sha256 = "1v0qffz9qd943fmxny0ik5vrgrfskmf6rv9mgxp7xz6wz3v38ypd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/j-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jade-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jade-mode";
      ename = "jade-mode";
      version = "1.0.1.0.20211019.161323";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/jade-mode-1.0.1.0.20211019.161323.tar";
        sha256 = "11b7wkp3pszc90f04sq0jkb83vgjkx0hdv4fylv6q2hyxpfn08r2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/jade-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  jinja2-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "jinja2-mode";
      ename = "jinja2-mode";
      version = "0.3.0.20220117.80711";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/jinja2-mode-0.3.0.20220117.80711.tar";
        sha256 = "05riwy4pn9i1jn5kr75hkb82n3jf0l3nsnzbwljbxvl362929x7m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/jinja2-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  julia-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "julia-mode";
      ename = "julia-mode";
      version = "1.0.1.0.20241120.85729";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/julia-mode-1.0.1.0.20241120.85729.tar";
        sha256 = "0a6xi5zcq1nfbsjqk84x6avlrzbjdh6fbq1h6jkqcczy7mm5rg5h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/julia-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  keycast = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "keycast";
      ename = "keycast";
      version = "1.4.1.0.20240805.132239";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/keycast-1.4.1.0.20240805.132239.tar";
        sha256 = "1afmj52zcr8sdh2ijw0xhxv5p713mw85f4q9rizrpbcx3pw0xmbj";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/keycast.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  kotlin-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "kotlin-mode";
      ename = "kotlin-mode";
      version = "2.0.0.0.20230123.105957";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/kotlin-mode-2.0.0.0.20230123.105957.tar";
        sha256 = "1jri3r3f6c09zf4x06a693r5izsdhijq2y279y764if2b3a8bwq2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/kotlin-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lorem-ipsum = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lorem-ipsum";
      ename = "lorem-ipsum";
      version = "0.4.0.20221214.105746";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/lorem-ipsum-0.4.0.20221214.105746.tar";
        sha256 = "1wwynsvpcing7rrmacxrmnib044dajawbdqxhhcwniqrxyw883c0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/lorem-ipsum.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  lua-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "lua-mode";
      ename = "lua-mode";
      version = "20221027.0.20231023.94721";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/lua-mode-20221027.0.20231023.94721.tar";
        sha256 = "1zlllyj2w8am1fv3iia8yrqhwsk2pi9kkw8ml6qc2lamfa09y65p";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/lua-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  macrostep = callPackage (
    {
      cl-lib ? null,
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "macrostep";
      ename = "macrostep";
      version = "0.9.4.0.20241025.145629";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/macrostep-0.9.4.0.20241025.145629.tar";
        sha256 = "1xbi45ymsqc2vbhl1s3wphirgqz5ky9880fzr949bhd0ff18bw6x";
      };
      packageRequires = [
        cl-lib
        compat
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/macrostep.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  magit = callPackage (
    {
      compat,
      dash,
      elpaBuild,
      fetchurl,
      lib,
      magit-section,
      seq,
      transient,
      with-editor,
    }:
    elpaBuild {
      pname = "magit";
      ename = "magit";
      version = "4.1.2.0.20241102.130025";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-4.1.2.0.20241102.130025.tar";
        sha256 = "1y3fr2qj8a1h7hkrh47zshbmrcfxhw6i8wiqcrrba7ypnas53gcg";
      };
      packageRequires = [
        compat
        dash
        magit-section
        seq
        transient
        with-editor
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/magit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  magit-section = callPackage (
    {
      compat,
      dash,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "magit-section";
      ename = "magit-section";
      version = "4.1.2.0.20241102.130025";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-section-4.1.2.0.20241102.130025.tar";
        sha256 = "1cnpklpsvbsi1wsmfbp5m8379cbr6jdifxm07zj4hnvi8lyr49vn";
      };
      packageRequires = [
        compat
        dash
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/magit-section.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  markdown-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "markdown-mode";
      ename = "markdown-mode";
      version = "2.7alpha0.20241203.113852";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/markdown-mode-2.7alpha0.20241203.113852.tar";
        sha256 = "14kkg7wj6qkq84jsa5cdwc7i7lqvilx21nb9lyddqxqxm8h7sld8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/markdown-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mastodon = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      persist,
      request,
      tp,
    }:
    elpaBuild {
      pname = "mastodon";
      ename = "mastodon";
      version = "1.1.7.0.20241202.183936";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/mastodon-1.1.7.0.20241202.183936.tar";
        sha256 = "08683fah6xkfzgxi6si4qgl4mxccczj4dcaivif1qlhfrc3bh66f";
      };
      packageRequires = [
        persist
        request
        tp
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/mastodon.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  material-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "material-theme";
      ename = "material-theme";
      version = "2015.0.20210904.122621";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/material-theme-2015.0.20210904.122621.tar";
        sha256 = "15wn2372p6zsbpbrvhd1lyyh736zhjzgw2fp62wpsyf8hncdmzb3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/material-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mentor = callPackage (
    {
      async,
      elpaBuild,
      fetchurl,
      lib,
      seq,
      url-scgi,
      xml-rpc,
    }:
    elpaBuild {
      pname = "mentor";
      ename = "mentor";
      version = "0.5.0.20231009.93430";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/mentor-0.5.0.20231009.93430.tar";
        sha256 = "159ng3vq4swbn79im0nss5wddhn0hkd7fsrz4y6d71hbvx406bjz";
      };
      packageRequires = [
        async
        seq
        url-scgi
        xml-rpc
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/mentor.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  meow = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "meow";
      ename = "meow";
      version = "1.5.0.0.20241203.160407";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/meow-1.5.0.0.20241203.160407.tar";
        sha256 = "0a3zdx91j5q0mllm71951392hgnn5q9l960qs2lazs8plpv4pn9f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/meow.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  minibar = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "minibar";
      ename = "minibar";
      version = "0.3.0.20230414.114052";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/minibar-0.3.0.20230414.114052.tar";
        sha256 = "1qsz57bfbsq6d8p0wbvglbm3m7v6lsmvbg4hnmyxyinns98fwqig";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/minibar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  moe-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "moe-theme";
      ename = "moe-theme";
      version = "1.0.2.0.20240716.85432";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/moe-theme-1.0.2.0.20240716.85432.tar";
        sha256 = "0xcqpdw7p6mphgrjl93cv25zj63r8bi1zi8jzd65k5s6sxlvz7bs";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/moe-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  monokai-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "monokai-theme";
      ename = "monokai-theme";
      version = "3.5.3.0.20240911.104603";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/monokai-theme-3.5.3.0.20240911.104603.tar";
        sha256 = "0721jwpyzvnqhzjldjdp98j585ivg02240jnxlnmry3428vc37av";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/monokai-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mpv = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "mpv";
      ename = "mpv";
      version = "0.2.0.0.20241121.230837";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/mpv-0.2.0.0.20241121.230837.tar";
        sha256 = "1aynlwp90xrprri3m1v8yxa5zvbx6d12m662lsn9qdzvhl2dy5hk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/mpv.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  multiple-cursors = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "multiple-cursors";
      ename = "multiple-cursors";
      version = "1.4.0.0.20241202.163103";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/multiple-cursors-1.4.0.0.20241202.163103.tar";
        sha256 = "018f3fpv0ganvhcwykpb2rfw41nqlkj87dx1zfzkf7s9011grkfv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/multiple-cursors.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nasm-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nasm-mode";
      ename = "nasm-mode";
      version = "1.1.1.0.20240610.150504";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/nasm-mode-1.1.1.0.20240610.150504.tar";
        sha256 = "1kkv7r6j02472d6c91xsrg9qlfvl70iyi538w2mh3s2adfkh7ps9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/nasm-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nginx-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nginx-mode";
      ename = "nginx-mode";
      version = "1.1.10.0.20240412.40234";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/nginx-mode-1.1.10.0.20240412.40234.tar";
        sha256 = "1ni7bgbvgahdl0b0ki47av7i28059yyy2rld1wvdf2pkfk0r6cq1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/nginx-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  nix-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      magit-section,
      transient,
    }:
    elpaBuild {
      pname = "nix-mode";
      ename = "nix-mode";
      version = "1.5.0.0.20230421.153655";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/nix-mode-1.5.0.0.20230421.153655.tar";
        sha256 = "186c1xng3phn3m4jvazn114l1ch1jldfyjaihb32rb9c8bf3mfr9";
      };
      packageRequires = [
        magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/nix-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  oblivion-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "oblivion-theme";
      ename = "oblivion-theme";
      version = "0.1.0.20240320.115258";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/oblivion-theme-0.1.0.20240320.115258.tar";
        sha256 = "1m0r9laf3wk7pmw5p46cwh0k05lqs1p5806c1czqrqq35z29flwh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/oblivion-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  opam-switch-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "opam-switch-mode";
      ename = "opam-switch-mode";
      version = "1.8snapshot0.20230802.91729";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/opam-switch-mode-1.8snapshot0.20230802.91729.tar";
        sha256 = "01ccpzlanc42na9hdm8f8ys4b1lsxqx5f2ks3ya3f5yr580amy1w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/opam-switch-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-auto-tangle = callPackage (
    {
      async,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org-auto-tangle";
      ename = "org-auto-tangle";
      version = "0.6.0.0.20230201.195019";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-auto-tangle-0.6.0.0.20230201.195019.tar";
        sha256 = "1895wp7fajpz4mddp4qr136h30rp3ashn3zdb6zdrb2qfa275rri";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-auto-tangle.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-contrib = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-contrib";
      ename = "org-contrib";
      version = "0.6.0.20241029.204012";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-contrib-0.6.0.20241029.204012.tar";
        sha256 = "12pfmv5ns5igdvc06glcc8nxqcj7lwjqc3s86720ys57y4py566w";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-contrib.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-drill = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
      persist,
      seq,
    }:
    elpaBuild {
      pname = "org-drill";
      ename = "org-drill";
      version = "2.7.0.0.20210428.101221";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-drill-2.7.0.0.20210428.101221.tar";
        sha256 = "1mib43crqgb45gwcy0kmk598f259l3wsycpzw4795xxfw1kj5z3y";
      };
      packageRequires = [
        org
        persist
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-drill.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-journal = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-journal";
      ename = "org-journal";
      version = "2.2.0.0.20240225.201950";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-journal-2.2.0.0.20240225.201950.tar";
        sha256 = "013yyxalngcl55z0z23qgjz0gwgjp5px0hd2ykibflw2vlqkl97p";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-journal.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-mime = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org-mime";
      ename = "org-mime";
      version = "0.3.4.0.20241001.42820";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-mime-0.3.4.0.20241001.42820.tar";
        sha256 = "1xcdk15z18s073q3hlg7dck8p5ssgap35a6m0f6cbmd5dbd3r05f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-mime.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-present = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-present";
      ename = "org-present";
      version = "0.1.0.20220806.144744";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-present-0.1.0.20220806.144744.tar";
        sha256 = "0k71hhl9gac0qvxmrjlf0cj60490m563ngbkr510vbkylri8rmdz";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-present.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-superstar = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org,
    }:
    elpaBuild {
      pname = "org-superstar";
      ename = "org-superstar";
      version = "1.5.1.0.20230116.151025";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-superstar-1.5.1.0.20230116.151025.tar";
        sha256 = "02f3lzb8k51rhf13a2warvhg8ib11wagw1zrfaknni7ssiwdj3x6";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-superstar.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-transclusion-http = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      org-transclusion,
      plz,
    }:
    elpaBuild {
      pname = "org-transclusion-http";
      ename = "org-transclusion-http";
      version = "0.5pre0.20240630.140904";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-transclusion-http-0.5pre0.20240630.140904.tar";
        sha256 = "1gkh5flmbj0gah8vbw6ghqagak220ljym8rsgpwmpxmqzwjhp5kp";
      };
      packageRequires = [
        org-transclusion
        plz
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-transclusion-http.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  org-tree-slide = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "org-tree-slide";
      ename = "org-tree-slide";
      version = "2.8.22.0.20230826.132200";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-tree-slide-2.8.22.0.20230826.132200.tar";
        sha256 = "0hr237z10zpy3p37d0aa3dxcw61zqfpkip4z6h20kqvnclr65rx0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/org-tree-slide.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  orgit = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      magit,
      org,
    }:
    elpaBuild {
      pname = "orgit";
      ename = "orgit";
      version = "2.0.0.0.20240808.194549";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/orgit-2.0.0.0.20240808.194549.tar";
        sha256 = "14ql24z977myihyn5hv4ivayzfpj580dhr7rgwwb6yqzj8j1bz4l";
      };
      packageRequires = [
        compat
        magit
        org
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/orgit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  p4-16-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "p4-16-mode";
      ename = "p4-16-mode";
      version = "0.3.0.20231118.161633";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/p4-16-mode-0.3.0.20231118.161633.tar";
        sha256 = "1fkpj2l3pd0vjrxl56jsg3ahkz2j1d48gghraq5ccdfalpmwmg75";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/p4-16-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  package-lint = callPackage (
    {
      elpaBuild,
      fetchurl,
      let-alist,
      lib,
    }:
    elpaBuild {
      pname = "package-lint";
      ename = "package-lint";
      version = "0.24.0.20241127.182614";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/package-lint-0.24.0.20241127.182614.tar";
        sha256 = "0wlz1hc387jcbh75hqjkxmydlsl0ai2adiam2axmqfdfn5p68llq";
      };
      packageRequires = [ let-alist ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/package-lint.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pacmacs = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pacmacs";
      ename = "pacmacs";
      version = "0.1.1.0.20220411.143014";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pacmacs-0.1.1.0.20220411.143014.tar";
        sha256 = "1h542y8hnqvkp7i8fd08rplamlivipa99mnxkzh8xkd8d19hn95k";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/pacmacs.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  page-break-lines = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "page-break-lines";
      ename = "page-break-lines";
      version = "0.15.0.20241107.72714";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/page-break-lines-0.15.0.20241107.72714.tar";
        sha256 = "0661kz0f8rippn1pi0jdzxa000vvakqv0s4y5f7f6vg41vhcna54";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/page-break-lines.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  paredit = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "paredit";
      ename = "paredit";
      version = "27beta0.20241103.213959";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/paredit-27beta0.20241103.213959.tar";
        sha256 = "00xb4lzkbfsz7f7pnsjfzbhigp4r2piimj7cplq7fxjl80j39lka";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/paredit.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  parseclj = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "parseclj";
      ename = "parseclj";
      version = "1.1.1.0.20231203.190509";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/parseclj-1.1.1.0.20231203.190509.tar";
        sha256 = "1h0lfy17613s7ls55ca77nqmc87v3kdwz1cvymzf2jp4xckgcsvw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/parseclj.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  parseedn = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      map,
      parseclj,
    }:
    elpaBuild {
      pname = "parseedn";
      ename = "parseedn";
      version = "1.2.1.0.20231203.190947";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/parseedn-1.2.1.0.20231203.190947.tar";
        sha256 = "0l8w1qr2nqngpcdcw1052dpx8q69xyz20mr2vvqayr5jmsgbvaad";
      };
      packageRequires = [
        map
        parseclj
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/parseedn.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pcmpl-args = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pcmpl-args";
      ename = "pcmpl-args";
      version = "0.1.3.0.20220510.145627";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pcmpl-args-0.1.3.0.20220510.145627.tar";
        sha256 = "1j1imsxbmpbxwywpl399panwgh071f9bpz3s4yf0mzcb4slpyxsq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/pcmpl-args.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pcre2el = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "pcre2el";
      ename = "pcre2el";
      version = "1.12.0.20240629.162214";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pcre2el-1.12.0.20240629.162214.tar";
        sha256 = "1lcpxjq2qzjk4xzl5ndshkfga4j1jy1i296h3kc3y20ksjml92x4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/pcre2el.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  pdf-tools = callPackage (
    {
      elpaBuild,
      fetchurl,
      let-alist,
      lib,
      tablist,
    }:
    elpaBuild {
      pname = "pdf-tools";
      ename = "pdf-tools";
      version = "1.1.0.0.20240429.40722";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pdf-tools-1.1.0.0.20240429.40722.tar";
        sha256 = "1799picrndkixcwhvvs0r1hkbjiw1hm2bq9wyj40ryx2a4y900n8";
      };
      packageRequires = [
        let-alist
        tablist
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/pdf-tools.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  php-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "php-mode";
      ename = "php-mode";
      version = "1.26.1.0.20241024.124149";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/php-mode-1.26.1.0.20241024.124149.tar";
        sha256 = "0h5lzvsssk0nf3g408a7jg25crglsjkhcfp1ckjnzpgiwf59i6w8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/php-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  popon = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "popon";
      ename = "popon";
      version = "0.13.0.20230703.82713";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/popon-0.13.0.20230703.82713.tar";
        sha256 = "10zlzlzjgmg29qmnk5skp1sf378wsavzpgpxx5590fy4gj5xwqbj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/popon.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  popup = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "popup";
      ename = "popup";
      version = "0.5.9.0.20240721.5155";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/popup-0.5.9.0.20240721.5155.tar";
        sha256 = "11ay4yknbc6dy7c08dcaz4sy1ly98m0ghchif0m2mm72s2hgw7g7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/popup.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  projectile = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "projectile";
      ename = "projectile";
      version = "2.9.0snapshot0.20241113.45011";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/projectile-2.9.0snapshot0.20241113.45011.tar";
        sha256 = "1hnyq1rfldda4csmdykwsngh317cxgj0bmlqy8xjbfqpy4876gar";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/projectile.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  proof-general = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "proof-general";
      ename = "proof-general";
      version = "4.6snapshot0.20241126.3245";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/proof-general-4.6snapshot0.20241126.3245.tar";
        sha256 = "12py1s85wrvxqiha2bfbdmszy4dl9wh8pbbhfx2q7qds2hd9c3wc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/proof-general.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  prop-menu = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "prop-menu";
      ename = "prop-menu";
      version = "0.1.2.0.20150728.51803";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/prop-menu-0.1.2.0.20150728.51803.tar";
        sha256 = "04qvjlq0kra1j3all8mh5appbpwwc2pkzkjrpwdsa85hkd18ls38";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/prop-menu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  racket-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "racket-mode";
      ename = "racket-mode";
      version = "1.0.20241129.85359";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/racket-mode-1.0.20241129.85359.tar";
        sha256 = "0j6hs2wpaknzprcm18y1ayqjcr2sl0z22fhw1yla5rv74lyqzglx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/racket-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rainbow-delimiters = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rainbow-delimiters";
      ename = "rainbow-delimiters";
      version = "2.1.5.0.20230830.160022";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rainbow-delimiters-2.1.5.0.20230830.160022.tar";
        sha256 = "1nkc02b6agkcig5gfc7rh4k203q67ss11l0yxr1fa83w7jd0gdkk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rainbow-delimiters.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  raku-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "raku-mode";
      ename = "raku-mode";
      version = "0.2.1.0.20240429.100744";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/raku-mode-0.2.1.0.20240429.100744.tar";
        sha256 = "0nz5gp98m5cl6l0agk2chz7llqldzkl7swkcmka5i4r1m7qx39rr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/raku-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  recomplete = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "recomplete";
      ename = "recomplete";
      version = "0.2.0.20240616.234552";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/recomplete-0.2.0.20240616.234552.tar";
        sha256 = "0gkd3g1p6i4l7s6gqjsdj20m3y8n75wlcfw6xii0ka7n8j8dmrz4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/recomplete.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  reformatter = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "reformatter";
      ename = "reformatter";
      version = "0.8.0.20241106.203153";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/reformatter-0.8.0.20241106.203153.tar";
        sha256 = "1gni5f8x8d6m063k9bgaqah80w2hnb12d7qwdw1ai0xg7jb92vp7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/reformatter.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  request = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "request";
      ename = "request";
      version = "0.3.3.0.20230126.231738";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/request-0.3.3.0.20230126.231738.tar";
        sha256 = "1fsyi1g65am1ln72hmxi216g95l29v9xdx9hrhky7i3j96fflnf6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/request.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rfc-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rfc-mode";
      ename = "rfc-mode";
      version = "1.4.2.0.20231013.135347";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rfc-mode-1.4.2.0.20231013.135347.tar";
        sha256 = "0jp5xamraan313nsgy8w7c91jjvqrxphzsm2wg8sgnj00zpr3jfb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rfc-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rubocop = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rubocop";
      ename = "rubocop";
      version = "0.7.0snapshot0.20210309.124149";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rubocop-0.7.0snapshot0.20210309.124149.tar";
        sha256 = "110rfww9kl2f8mj45nf1irwmwj4bfgla6glc52dhqi2ibvpik1h5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rubocop.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rust-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rust-mode";
      ename = "rust-mode";
      version = "1.0.6.0.20241112.43839";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rust-mode-1.0.6.0.20241112.43839.tar";
        sha256 = "1jmby08vp18qr2cx3k6skw9mar7vb7wr5ph9q2g95wx8836g6mbp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rust-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sass-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      haml-mode,
      lib,
    }:
    elpaBuild {
      pname = "sass-mode";
      ename = "sass-mode";
      version = "3.0.16.0.20190502.5315";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sass-mode-3.0.16.0.20190502.5315.tar";
        sha256 = "1699icjrlliwr949g3933614idyzvk8g9srl346g0s9jfd2llxb8";
      };
      packageRequires = [
        cl-lib
        haml-mode
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sass-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scad-mode = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scad-mode";
      ename = "scad-mode";
      version = "94.0.0.20240926.92457";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scad-mode-94.0.0.20240926.92457.tar";
        sha256 = "09hgnzzfi6wdy3p0nfl6a00npxpsdy30dyc89m1h087wlhkjjyci";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/scad-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scala-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scala-mode";
      ename = "scala-mode";
      version = "1.1.0.0.20240729.42046";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scala-mode-1.1.0.0.20240729.42046.tar";
        sha256 = "0981n96zx633iypwyz2f6af7r1lzx0lick7zv0azqglrwgnly35r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/scala-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scroll-on-drag = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scroll-on-drag";
      ename = "scroll-on-drag";
      version = "0.1.0.20240421.80350";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scroll-on-drag-0.1.0.20240421.80350.tar";
        sha256 = "0yvz2349ii06r69q2a40qw7grxviqfj9bpm36pjb7wzc46bywl23";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/scroll-on-drag.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  scroll-on-jump = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "scroll-on-jump";
      ename = "scroll-on-jump";
      version = "0.2.0.20240421.90558";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scroll-on-jump-0.2.0.20240421.90558.tar";
        sha256 = "0wfdq7myzywqq1nl5f0mz43xiqmpl8vq3p87z7222szi0mm9r6ra";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/scroll-on-jump.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sesman = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sesman";
      ename = "sesman";
      version = "0.3.3snapshot0.20240417.172323";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sesman-0.3.3snapshot0.20240417.172323.tar";
        sha256 = "1d4c3ymxas4xsjbkg7yj80x6lgly5rch7fvyvi495yvk3mzd9yzk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sesman.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  shellcop = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "shellcop";
      ename = "shellcop";
      version = "0.1.0.0.20220728.132914";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/shellcop-0.1.0.0.20220728.132914.tar";
        sha256 = "0jdh00gw99gm33sviqp9rba6551qpp7pmdfdjd8gqzfk3ziwfdw0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/shellcop.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  slime = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      macrostep,
    }:
    elpaBuild {
      pname = "slime";
      ename = "slime";
      version = "2.31.0.20241201.210325";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/slime-2.31.0.20241201.210325.tar";
        sha256 = "05skikmrfcwbahph8z50kf1zh5vps7459zw7l1bipgyvhfvpq9fn";
      };
      packageRequires = [ macrostep ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/slime.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sly = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sly";
      ename = "sly";
      version = "1.0.43.0.20240809.211904";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sly-1.0.43.0.20240809.211904.tar";
        sha256 = "1np4rciwcijr6bv13s5vvl95wl28ad60snr6wdbjh7ya922x37rv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sly.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  smartparens = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "smartparens";
      ename = "smartparens";
      version = "1.11.0.0.20240713.100215";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/smartparens-1.11.0.0.20240713.100215.tar";
        sha256 = "0479n363cz4izdxdl2420fcmngbfjp7a5xv9xlxyab62aph63f0w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/smartparens.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  solarized-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "solarized-theme";
      ename = "solarized-theme";
      version = "2.0.1.0.20240725.161711";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/solarized-theme-2.0.1.0.20240725.161711.tar";
        sha256 = "1d3m6h00awq2az6vkal631k9l1jpqm2qxr1067rzd1q2qdlaf2ji";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/solarized-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  spacemacs-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "spacemacs-theme";
      ename = "spacemacs-theme";
      version = "0.2.0.20241101.103011";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spacemacs-theme-0.2.0.20241101.103011.tar";
        sha256 = "1sxj7xghkkayvpa1qb4d3ws81931r8s737wk3akwhayh50czh3fi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/spacemacs-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  spell-fu = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "spell-fu";
      ename = "spell-fu";
      version = "0.3.0.20241011.20613";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spell-fu-0.3.0.20241011.20613.tar";
        sha256 = "1v9qzc7hqq0scs9vsgp88pp8hihxlsa8mcq5hmcz4g3p1ffhc1lb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/spell-fu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sqlite3 = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sqlite3";
      ename = "sqlite3";
      version = "0.17.0.20231124.132621";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sqlite3-0.17.0.20231124.132621.tar";
        sha256 = "10mgf69dvvglf067n59w3dy08jc245rhbqqjbfr27ff9xjrklvfh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sqlite3.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  stylus-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "stylus-mode";
      ename = "stylus-mode";
      version = "1.0.1.0.20211019.161323";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/stylus-mode-1.0.1.0.20211019.161323.tar";
        sha256 = "17hnlylbmk0a3sdcz61crj3ky8224jawlsdzqcvhjbnbmnflvd3z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/stylus-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  subatomic-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "subatomic-theme";
      ename = "subatomic-theme";
      version = "1.8.2.0.20220128.161518";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/subatomic-theme-1.8.2.0.20220128.161518.tar";
        sha256 = "1h4rr2g6lhn186df2nk026xk1x6yhh441d6mjcdrfkii17n15552";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/subatomic-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  subed = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "subed";
      ename = "subed";
      version = "1.2.21.0.20241117.83905";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/subed-1.2.21.0.20241117.83905.tar";
        sha256 = "0v95g129yp9s3kknbw1fp4iqn0f0g65bhvw4433v3dbinw9l3k74";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/subed.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sweeprolog = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "sweeprolog";
      ename = "sweeprolog";
      version = "0.27.6.0.20241107.191437";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sweeprolog-0.27.6.0.20241107.191437.tar";
        sha256 = "0y543svzd7sqqb2izlflvmv0mdyfwwzjgli107ra89w5jl6jxawh";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sweeprolog.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  swift-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "swift-mode";
      ename = "swift-mode";
      version = "9.2.0.0.20240921.44423";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/swift-mode-9.2.0.0.20240921.44423.tar";
        sha256 = "113gx8yrb5b75fca04k1335pfqwm5mhy5ns7wa9115wagdksfkj8";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/swift-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  symbol-overlay = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "symbol-overlay";
      ename = "symbol-overlay";
      version = "4.3.0.20240913.162400";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/symbol-overlay-4.3.0.20240913.162400.tar";
        sha256 = "0i5rs6cqfjl1c6m8wf0wwlzbsc7zvw9x0b8g8rds9n5c23b7gv15";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/symbol-overlay.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  systemd = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "systemd";
      ename = "systemd";
      version = "1.6.1.0.20230131.220207";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/systemd-1.6.1.0.20230131.220207.tar";
        sha256 = "0q7yz96vp1p424whfap7iaxbxa7ydj50v32y3q85lwicfy5838gj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/systemd.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tablist = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tablist";
      ename = "tablist";
      version = "1.0.0.20200427.220558";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tablist-1.0.0.20200427.220558.tar";
        sha256 = "12wfryycv3vrrmwj41r8l3rc0w0dy4b7ay0a86q5kah22az38q4x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/tablist.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tangotango-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tangotango-theme";
      ename = "tangotango-theme";
      version = "0.0.7.0.20241117.114955";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tangotango-theme-0.0.7.0.20241117.114955.tar";
        sha256 = "1p9j3pqgp0nzsypqdx9bc1qhkgyc3s3p9rbm3la356yfc3d3wxa3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/tangotango-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  telephone-line = callPackage (
    {
      cl-generic,
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      seq,
    }:
    elpaBuild {
      pname = "telephone-line";
      ename = "telephone-line";
      version = "0.5.0.20240109.152108";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/telephone-line-0.5.0.20240109.152108.tar";
        sha256 = "18sgw1q80wxi38n815rv70146yiwr2dq5c1a7saabs1y6zmq3fdq";
      };
      packageRequires = [
        cl-generic
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/telephone-line.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  testcover-mark-line = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "testcover-mark-line";
      ename = "testcover-mark-line";
      version = "0.3.0.20221128.191350";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/testcover-mark-line-0.3.0.20221128.191350.tar";
        sha256 = "1199bd15bxyb661b74nqixq9f39j87lijw105il0fslc3dw7hi5n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/testcover-mark-line.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  textile-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "textile-mode";
      ename = "textile-mode";
      version = "1.0.0.0.20240212.175553";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/textile-mode-1.0.0.0.20240212.175553.tar";
        sha256 = "1kiy4zh7x79igi8x872rjmliik1m0iyfkwng2i64llqf3yiasmwj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/textile-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  toc-org = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "toc-org";
      ename = "toc-org";
      version = "1.1.0.20230831.75249";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/toc-org-1.1.0.20230831.75249.tar";
        sha256 = "1kscz2s87l8a8w0d4s3g8ilspd63p0ij2vgncvzvb8hjld4pdcfh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/toc-org.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  totp-auth = callPackage (
    {
      base32,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "totp-auth";
      ename = "totp-auth";
      version = "1.0.0.20240227.184114";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/totp-auth-1.0.0.20240227.184114.tar";
        sha256 = "1yqvn30qc1vdhshcss4znzily08rbv77mf8hrhmy5zayq4n23nca";
      };
      packageRequires = [ base32 ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/totp-auth.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tp = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      transient,
    }:
    elpaBuild {
      pname = "tp";
      ename = "tp";
      version = "0.6.0.20241031.72940";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tp-0.6.0.20241031.72940.tar";
        sha256 = "1m8qhar75cglg8qjh3sbgwkzkhfp3640nm73nddxrshnajn978bf";
      };
      packageRequires = [ transient ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/tp.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  treesit-fold = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "treesit-fold";
      ename = "treesit-fold";
      version = "0.1.0.0.20240630.204821";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/treesit-fold-0.1.0.0.20240630.204821.tar";
        sha256 = "1h99gh11xhmzs7ix94y609sijdchz692ixkxxsmnxbrniybpfcsv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/treesit-fold.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  treeview = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "treeview";
      ename = "treeview";
      version = "1.3.1.0.20241101.11503";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/treeview-1.3.1.0.20241101.11503.tar";
        sha256 = "0hf893bhnqg4ixfvs16h3rdiizkd14gsiq0cfg63cz077vp9bskh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/treeview.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  tuareg = callPackage (
    {
      caml,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "tuareg";
      ename = "tuareg";
      version = "3.0.2snapshot0.20231009.174342";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tuareg-3.0.2snapshot0.20231009.174342.tar";
        sha256 = "10ijh4h8srm810b74jb0bqb8zxca91bsbhlb85fyyscbsvhms2f1";
      };
      packageRequires = [ caml ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/tuareg.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  typescript-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "typescript-mode";
      ename = "typescript-mode";
      version = "0.4.0.20241119.194738";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/typescript-mode-0.4.0.20241119.194738.tar";
        sha256 = "0yndbfnalj22bp2bzmrsa24a0v4cbk85b5yiqcg2diknrvsxkg2c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/typescript-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ujelly-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ujelly-theme";
      ename = "ujelly-theme";
      version = "1.3.6.0.20241111.2243";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/ujelly-theme-1.3.6.0.20241111.2243.tar";
        sha256 = "16q5n2854x9km0kd4vfr0wskbkw66pd1rf1qy34v1yacq2phb77b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/ujelly-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  undo-fu = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "undo-fu";
      ename = "undo-fu";
      version = "0.5.0.20240707.141050";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-0.5.0.20240707.141050.tar";
        sha256 = "0glgy1manfv9rykkxhafc969mhazd119zgrkm5fg9shcyb7q629a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/undo-fu.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  undo-fu-session = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "undo-fu-session";
      ename = "undo-fu-session";
      version = "0.7.0.20240713.142701";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-session-0.7.0.20240713.142701.tar";
        sha256 = "1c70cvf9f1x96l8gxfl4qpljwsqsqjcn745srsf9w9mcz520fyaa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/undo-fu-session.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vc-fossil = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vc-fossil";
      ename = "vc-fossil";
      version = "20230504.0.20230504.162626";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/vc-fossil-20230504.0.20230504.162626.tar";
        sha256 = "1w6vi3cflbyrw6109s0w4dbr0axid1abi3s2jvgjikjcggxwrk5f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/vc-fossil.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vcomplete = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "vcomplete";
      ename = "vcomplete";
      version = "2.0.0.20230227.132830";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/vcomplete-2.0.0.20230227.132830.tar";
        sha256 = "0klfc9x2wn91q1v3056hv5kmyzpl1jkigsdw9yjf9623z2fa1s5v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/vcomplete.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  visual-fill-column = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "visual-fill-column";
      ename = "visual-fill-column";
      version = "2.6.3.0.20241109.231059";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/visual-fill-column-2.6.3.0.20241109.231059.tar";
        sha256 = "1k6ih7fw0xmbm6m249cdinyx8g5k3gpdglla8242w64bqrxxcpr8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/visual-fill-column.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  vm = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "vm";
      ename = "vm";
      version = "8.3.0snapshot0.20241026.45603";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/vm-8.3.0snapshot0.20241026.45603.tar";
        sha256 = "1ipasfr8g64n2i5yn992yw8aikkjzqw1lshlai90sxrdd1s3vlgm";
      };
      packageRequires = [
        cl-lib
        nadvice
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/vm.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  web-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "web-mode";
      ename = "web-mode";
      version = "17.3.20.0.20240804.82110";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/web-mode-17.3.20.0.20240804.82110.tar";
        sha256 = "17r0jhcgxnc1k42yxaw1i7wwyb0sp311a1gz8bdjax0zn05ki4xc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/web-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  webpaste = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
      request,
    }:
    elpaBuild {
      pname = "webpaste";
      ename = "webpaste";
      version = "3.2.2.0.20241125.141806";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/webpaste-3.2.2.0.20241125.141806.tar";
        sha256 = "0356h3x2l0iaqk04zyp870r7bd1kzsldlqgdfn61x32krwml3iif";
      };
      packageRequires = [
        cl-lib
        request
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/webpaste.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wfnames = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wfnames";
      ename = "wfnames";
      version = "1.2.0.20240822.162149";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/wfnames-1.2.0.20240822.162149.tar";
        sha256 = "0wcnw48gpf0frx9fdhz4f4cxisb4v7dwbhd9q3i7j1ivdd07diwg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/wfnames.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  wgrep = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "wgrep";
      ename = "wgrep";
      version = "3.0.0.0.20231216.120954";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/wgrep-3.0.0.0.20231216.120954.tar";
        sha256 = "1qadyl29a70d9m5z32s0r18rjxg0jdmbpjr47zgvppl807mfni85";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/wgrep.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  why-this = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "why-this";
      ename = "why-this";
      version = "2.0.4.0.20221129.81751";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/why-this-2.0.4.0.20221129.81751.tar";
        sha256 = "1qvywhi3nibq1sr8fc1msnnjrdf70j308bp69sl9cirsd61p62bw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/why-this.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  with-editor = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "with-editor";
      ename = "with-editor";
      version = "3.4.3.0.20241201.141907";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/with-editor-3.4.3.0.20241201.141907.tar";
        sha256 = "1srqg86809lb1b0dj421gb6n522cx19snhvhvxb4nxkk98afiywp";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/with-editor.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  with-simulated-input = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "with-simulated-input";
      ename = "with-simulated-input";
      version = "3.0.0.20210602.224623";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/with-simulated-input-3.0.0.20210602.224623.tar";
        sha256 = "17rshlrz09kxzqb2z54xhmqz2kjj717jkw4bv1inz3vvxi25ndca";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/with-simulated-input.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  workroom = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      project,
    }:
    elpaBuild {
      pname = "workroom";
      ename = "workroom";
      version = "2.3.1.0.20230926.163128";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/workroom-2.3.1.0.20230926.163128.tar";
        sha256 = "0jmjck89xrsv9l386aayirnbb2ambkfria3jirp09zz7fx582936";
      };
      packageRequires = [
        compat
        project
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/workroom.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  writegood-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "writegood-mode";
      ename = "writegood-mode";
      version = "2.2.0.0.20220511.170949";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/writegood-mode-2.2.0.0.20220511.170949.tar";
        sha256 = "06rx9ak2wfcnd81a9hj310m22r7gpc2fnpy0hn1qcrfalsnp2kf1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/writegood-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  ws-butler = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "ws-butler";
      ename = "ws-butler";
      version = "0.7.0.20241107.1911";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/ws-butler-0.7.0.20241107.1911.tar";
        sha256 = "1571dns6zdvdqvz5mnca207jpbijm9aiaf6x4iy69w91hszsdda0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/ws-butler.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xah-fly-keys = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xah-fly-keys";
      ename = "xah-fly-keys";
      version = "26.8.20241118173945.0.20241118.174137";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xah-fly-keys-26.8.20241118173945.0.20241118.174137.tar";
        sha256 = "196hv8hjzp87b8y9k65w2zag46bx2jhmah1w9mdjxwkfbq6bjcmq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/xah-fly-keys.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xkcd = callPackage (
    {
      elpaBuild,
      fetchurl,
      json ? null,
      lib,
    }:
    elpaBuild {
      pname = "xkcd";
      ename = "xkcd";
      version = "1.1.0.20220503.110939";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xkcd-1.1.0.20220503.110939.tar";
        sha256 = "1rn5g8m1zd6jajasq4mi3jq1jgk8xw2jykzwd0hjmaz77psqb6af";
      };
      packageRequires = [ json ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/xkcd.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  xml-rpc = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "xml-rpc";
      ename = "xml-rpc";
      version = "1.6.17.0.20231009.103222";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xml-rpc-1.6.17.0.20231009.103222.tar";
        sha256 = "19invp04068pzyjbbbscc7vlqh76r8n3f9d4mxacbvi5bhvrc2p0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/xml-rpc.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  yaml-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "yaml-mode";
      ename = "yaml-mode";
      version = "0.0.16.0.20241003.15333";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/yaml-mode-0.0.16.0.20241003.15333.tar";
        sha256 = "1c6lid3iwxa911zk579rvy1dq8azq6xmp0s6lahchkcq40dvbjl5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/yaml-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  yasnippet-snippets = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      yasnippet,
    }:
    elpaBuild {
      pname = "yasnippet-snippets";
      ename = "yasnippet-snippets";
      version = "1.0.0.20241014.94920";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/yasnippet-snippets-1.0.0.20241014.94920.tar";
        sha256 = "065wcvb295dhyi6jvb80vagzb8idqycchqgy32pj0fr6vcxx7y88";
      };
      packageRequires = [ yasnippet ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/yasnippet-snippets.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  zenburn-theme = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "zenburn-theme";
      ename = "zenburn-theme";
      version = "2.9.0snapshot0.20240926.61928";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zenburn-theme-2.9.0snapshot0.20240926.61928.tar";
        sha256 = "029ip7ar11vif0c7qazsizp8600z7j0yznwl3j6wywpi6dzx4sii";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/zenburn-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  zig-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      reformatter,
    }:
    elpaBuild {
      pname = "zig-mode";
      ename = "zig-mode";
      version = "0.0.8.0.20241104.162434";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zig-mode-0.0.8.0.20241104.162434.tar";
        sha256 = "01g51mvsg578hcnr8kbda8pbgy7yrk57p9djy3bn1rp4vwjh2f46";
      };
      packageRequires = [ reformatter ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/zig-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
