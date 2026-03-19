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
      version = "0.8.0.0.20260221.220754";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/adoc-mode-0.8.0.0.20260221.220754.tar";
        sha256 = "19cn5vm963pygzi42r7zw0n7g1adipa0k8f8chwlwibhzwmx3vyz";
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
  age = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "age";
      ename = "age";
      version = "0.1.9.0.20250806.132339";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/age-0.1.9.0.20250806.132339.tar";
        sha256 = "1n7lvx7bcniwylsq339pyxs26ragcq4wy7lz3xzvry54bha3jxfn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/age.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  aidermacs = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      markdown-mode,
      transient,
    }:
    elpaBuild {
      pname = "aidermacs";
      ename = "aidermacs";
      version = "1.6.0.20251203.181819";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/aidermacs-1.6.0.20251203.181819.tar";
        sha256 = "0kyy5fw8397hcahm4wlvl51ch2fbrlw2r8arvcxflssngy7cbbaa";
      };
      packageRequires = [
        compat
        markdown-mode
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/aidermacs.html";
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
      version = "0.11.0.20251205.150325";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/alect-themes-0.11.0.20251205.150325.tar";
        sha256 = "1wxs6spxm4ic21is3mg7s0kda8fac0whkizlsa1634arrb6dpr8z";
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
      version = "2.4.5.0.20251111.163545";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/annotate-2.4.5.0.20251111.163545.tar";
        sha256 = "09jghlf5bjiiah1qqvr1s3lkjqzywf9cxrfzpfq192ms1hzs1wmd";
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
      version = "2.2.0.0.20251120.174624";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apache-mode-2.2.0.0.20251120.174624.tar";
        sha256 = "0f536bc064ykjajsgyxcbdjxch14wi2kkxhva9szi802l78zkdhh";
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
      version = "0.2.0.0.20251009.212150";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apropospriate-theme-0.2.0.0.20251009.212150.tar";
        sha256 = "0nz35vvlysqpsvghkkf4ysw8dich809ag2brdlz9jcw52j2haxyi";
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
      version = "2.2.1.0.20250116.140242";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/auto-dim-other-buffers-2.2.1.0.20250116.140242.tar";
        sha256 = "07v5n7d3whk79by6xwd1gak1m73k4zpcscwfminfidj3f6rmkj92";
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
      version = "0.2.18.0.20251114.41509";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/autothemer-0.2.18.0.20251114.41509.tar";
        sha256 = "0ix8byl6fa2qpcjvcf93afbsk2f9frnsbq9mcnhxmx17l48fzl06";
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
      version = "1.0.0.20250312.200047";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/base32-1.0.0.20250312.200047.tar";
        sha256 = "0l6mshnk25iadh1wymdxzfx4g5pvlh4q1hr1x9xfg5xbimiwfkki";
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
      version = "3.2.1snapshot0.20260206.145951";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bash-completion-3.2.1snapshot0.20260206.145951.tar";
        sha256 = "08ffm5d4b9d553q49zgnp00wf5a3cvzshwqv3kqfgb9wp29wqpja";
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
      version = "0.9.0.0.20251027.80859";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/beancount-0.9.0.0.20251027.80859.tar";
        sha256 = "19lklnmqpxzxgwdjb3wzaarkklxqswnl9ff11pg854rr7kivlmwl";
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
      version = "1.1.2.0.20251118.210127";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bind-map-1.1.2.0.20251118.210127.tar";
        sha256 = "1qwbyg84a6xkbzk5wzjd26ih3kypdivb4isvyx8hb6cc9q276m7w";
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
      version = "0.0.3.0.20260110.82453";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/blueprint-ts-mode-0.0.3.0.20260110.82453.tar";
        sha256 = "1j0cx4w8ps6bmp0yybzj1db2aw12pgkv5pb0vcnsplwcp552rzd0";
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
      version = "1.38.0.20250801.138";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/buttercup-1.38.0.20250801.138.tar";
        sha256 = "1hcwlymmhbcrgz501gjx7d337x1cy4gzz6nbg0xq4yjxp0l0pq5c";
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
      version = "4.10snapshot0.20250227.123439";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/caml-4.10snapshot0.20250227.123439.tar";
        sha256 = "1bg8vf7sh6f7s7jghfyqhb5da38kr8f3bbizzy7xfim2jy1i4ci7";
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
      compat,
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
      version = "1.22.0snapshot0.20260221.61239";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cider-1.22.0snapshot0.20260221.61239.tar";
        sha256 = "03sazabqwy7hizs3dj6vwarkhl4l6jqil1dg5w77pv4f250sk3z8";
      };
      packageRequires = [
        clojure-mode
        compat
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
      version = "5.21.0.0.20260220.185145";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-mode-5.21.0.0.20260220.185145.tar";
        sha256 = "0vzi5bd60wz6my44yiq5g8xdgk6rv09nr034gf0qgql3ww34ggsy";
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
      version = "0.6.0.0.20260223.181343";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-ts-mode-0.6.0.0.20260223.181343.tar";
        sha256 = "0yrbddm4qv5xdn9vj3k9h0j62v5rv7l1yrdl0idw9094ln25k418";
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
  cond-let = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "cond-let";
      ename = "cond-let";
      version = "0.2.2.0.20260201.150042";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cond-let-0.2.2.0.20260201.150042.tar";
        sha256 = "0fy4kji48wj5v1jf78kmd011v5v4q5b5n32mhhixv83243hng2fb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/cond-let.html";
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
      version = "1.1.0.20260117.165420";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/consult-flycheck-1.1.0.20260117.165420.tar";
        sha256 = "0jv0kdy91gynlv292qy86n33b2hnryhmyzyk5c5n0vmik3zijyay";
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
      version = "0.6.0snapshot0.20250525.163240";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/crux-0.6.0snapshot0.20250525.163240.tar";
        sha256 = "07rdz5ns0bh8qgndz7q0xqymcpyvcgl3c1h4f2hajr2jqjbhhdv2";
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
      version = "1.5.4.0.20250417.171625";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/csv2ledger-1.5.4.0.20250417.171625.tar";
        sha256 = "1m72znfi5hd9pwavc99g8amxwc0jdyly7gsww2aq0fw4q971kiaf";
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
      version = "0.2.0.20260111.124011";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cycle-at-point-0.2.0.20260111.124011.tar";
        sha256 = "0jnd8r1xpyyklbpvy18mxz3slcl0jz6zi41vymzgmv9a6xig5cvs";
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
      version = "202408131340.0.20241225.185152";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/d-mode-202408131340.0.20241225.185152.tar";
        sha256 = "08wlsp1mzsn0xprslwmnhxzj58yy35vjy09l70dxz5pyxk3vg2vd";
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
      version = "1.0.7.0.20251203.195437";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dart-mode-1.0.7.0.20251203.195437.tar";
        sha256 = "1l4p4ybw69ni2vx016bi2nz3kjqziy6nk3vv1nr9gjbslpmkck5k";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/dart-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  datetime = callPackage (
    {
      elpaBuild,
      extmap,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "datetime";
      ename = "datetime";
      version = "0.10.3snapshot0.20250203.204701";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/datetime-0.10.3snapshot0.20250203.204701.tar";
        sha256 = "0l9z5bqbxbn456rin27x4zfa5pjvqjr2vhzxpgssrndm7bprm614";
      };
      packageRequires = [ extmap ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/datetime.html";
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
      version = "0.2.0.20260108.151229";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/diff-ansi-0.2.0.20260108.151229.tar";
        sha256 = "0b1i031fyjszinpngz804di4fng6i71pcmckq05z75p3gjjfyx2j";
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
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "dirvish";
      ename = "dirvish";
      version = "2.3.0.0.20250504.80741";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dirvish-2.3.0.0.20250504.80741.tar";
        sha256 = "0h8ap8bnqy2czvgkc71l49ms3kwk8lciz0ydzi2yy5xgh5pvs71k";
      };
      packageRequires = [ compat ];
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
      version = "0.1.0.20260108.134251";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/doc-show-inline-0.1.0.20260108.134251.tar";
        sha256 = "0i8npz6a4zyxy1w0kksflamn6w6r3wfv977s6hvprax4ajasmhzk";
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
      version = "1.9.0.20251221.114459";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dockerfile-mode-1.9.0.20251221.114459.tar";
        sha256 = "1dydyvvcmi74pxq3nvjla05i3aayxhpjzkcz6dv2pxl7fh557h78";
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
      version = "1.8.3.0.20260224.145537";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dracula-theme-1.8.3.0.20260224.145537.tar";
        sha256 = "0g83cgcackysjh5x35j0vniqyysk1lgijk0mhmgnwnhm2fji1b74";
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
      version = "0.6.2.0.20250102.81901";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dslide-0.6.2.0.20250102.81901.tar";
        sha256 = "18ggnfj9adlrhni2mb6f1ygc0mf7q8xm99729cbvp2k6l7yidxxc";
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
      version = "0.9.4.0.20250206.4447";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/eat-0.9.4.0.20250206.4447.tar";
        sha256 = "1fhj3bi2hdgclgb4b74yqzhxw77k30nrnww4phgzkngyxwp11xcm";
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
      version = "0.11.0.0.20260122.182806";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/editorconfig-0.11.0.0.20260122.182806.tar";
        sha256 = "0vncm8w0vcqzjh28fglf6s7ryxa0kgfy5n3kkxkyksbczyndwprj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/editorconfig.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eglot-inactive-regions = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "eglot-inactive-regions";
      ename = "eglot-inactive-regions";
      version = "0.6.5.0.20250326.53650";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/eglot-inactive-regions-0.6.5.0.20250326.53650.tar";
        sha256 = "0xj16f49mjm1i3zdd6cpd9sjir6dwvh3s3lqs6fpp0sknpj0i5in";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/eglot-inactive-regions.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eldoc-diffstat = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "eldoc-diffstat";
      ename = "eldoc-diffstat";
      version = "1.0.0.20241214.213403";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/eldoc-diffstat-1.0.0.20241214.213403.tar";
        sha256 = "10rjz33lhsp61pjdj64k0y9wh9nlfnz1w89xck0gfp2p42kya87n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/eldoc-diffstat.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  eldoc-mouse = callPackage (
    {
      eglot,
      elpaBuild,
      fetchurl,
      lib,
      posframe,
    }:
    elpaBuild {
      pname = "eldoc-mouse";
      ename = "eldoc-mouse";
      version = "3.0.3.0.20260130.135227";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/eldoc-mouse-3.0.3.0.20260130.135227.tar";
        sha256 = "0damazadfsr04q3vwgll2mfh67nixbfkf40ix213k45dlf399gqb";
      };
      packageRequires = [
        eglot
        posframe
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/eldoc-mouse.html";
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
      version = "3.7.0.0.20260221.92032";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/elpher-3.7.0.0.20260221.92032.tar";
        sha256 = "0s9akzwg59v97895kn941iqiqvw5p6mnqg3fxjydklssg7691ng5";
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
      version = "4.3.5.0.20260201.151238";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/emacsql-4.3.5.0.20260201.151238.tar";
        sha256 = "0fb7538qanp4dr8mgm17x0vvyyzn9dy50ymphhj21zy9almjrlsj";
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
  esxml = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "esxml";
      ename = "esxml";
      version = "0.3.8.0.20250421.163204";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/esxml-0.3.8.0.20250421.163204.tar";
        sha256 = "15yqrpnw8nd3ksmqwmsq1b0z39df4c3vqxsl7cyzwyjmrh4djfk6";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/esxml.html";
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
      version = "1.15.0.0.20251108.13841";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-1.15.0.0.20251108.13841.tar";
        sha256 = "0vh9pmwsapdg2pn1cnp03jv9y35ddi57niwacrikn12g7niwh8jn";
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
      version = "0.2.0.20250316.121704";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-anzu-0.2.0.20250316.121704.tar";
        sha256 = "0wr47dx4axy2xvnn1y354scvwka2mh8z9kgdclgnfvnhhdqzi2h0";
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
  evil-emacs-cursor-model-mode = callPackage (
    {
      elpaBuild,
      evil,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil-emacs-cursor-model-mode";
      ename = "evil-emacs-cursor-model-mode";
      version = "0.1.3.0.20260225.15950";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-emacs-cursor-model-mode-0.1.3.0.20260225.15950.tar";
        sha256 = "0xx8vzkmggvvhanxq9xyrsrqiby0054agwpjmflqgvkvyrfvxzyc";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/evil-emacs-cursor-model-mode.html";
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
      version = "3.16.0.20241212.131839";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-escape-3.16.0.20241212.131839.tar";
        sha256 = "18j653kymcvxdr0n0vibl091p2zwdzgqymw3g778visshxgk11mb";
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
      version = "4.0.1.0.20251212.125614";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-matchit-4.0.1.0.20251212.125614.tar";
        sha256 = "07wrcs33jz9lj4n2f75zz601vrsajfclicxbqqyih9hh4k73jqq5";
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
      version = "0.7.0.20260102.82951";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-numbers-0.7.0.20260102.82951.tar";
        sha256 = "03nxzdaxnlfmn6w3sgwixmqqv275rskxkjc93zwac55i9h3xn0kb";
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
      version = "2.2.0.20251113.132402";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/exec-path-from-shell-2.2.0.20251113.132402.tar";
        sha256 = "0brfbnxa36rvql03l7pq8wja520yjzmayhfxzh94sirs4f3s5yhl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/exec-path-from-shell.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  extmap = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "extmap";
      ename = "extmap";
      version = "1.3.1snapshot0.20250203.193959";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/extmap-1.3.1snapshot0.20250203.193959.tar";
        sha256 = "16sfa2zv0g7dz1zflg848dh643c8vfrb93blqvnd1vmlmf3bsyqy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/extmap.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  fedi = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      markdown-mode,
    }:
    elpaBuild {
      pname = "fedi";
      ename = "fedi";
      version = "0.3.0.20260223.132625";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/fedi-0.3.0.20260223.132625.tar";
        sha256 = "15cvwfyvixac3vvfjnmz0fvfzk5iq9sndnryzi3zlp3njjjds0wv";
      };
      packageRequires = [ markdown-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/fedi.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  fj = callPackage (
    {
      elpaBuild,
      fedi,
      fetchurl,
      lib,
      magit,
      tp,
      transient,
    }:
    elpaBuild {
      pname = "fj";
      ename = "fj";
      version = "0.32.0.20260225.163009";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/fj-0.32.0.20260225.163009.tar";
        sha256 = "0vjqihc0bj0zizl3mjzsrvj09pzkv6lpp83157ppb6vfirs1vv4g";
      };
      packageRequires = [
        fedi
        magit
        tp
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/fj.html";
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
      seq,
    }:
    elpaBuild {
      pname = "flycheck";
      ename = "flycheck";
      version = "36.0.0.20260224.192350";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flycheck-36.0.0.20260224.192350.tar";
        sha256 = "1lcly3ip5n788q0a64yzd0gnlndxnqqg7dbwf0ypq04zjnakwr3x";
      };
      packageRequires = [ seq ];
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
  flymake-pyrefly = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-pyrefly";
      ename = "flymake-pyrefly";
      version = "0.1.8.0.20251120.306";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flymake-pyrefly-0.1.8.0.20251120.306.tar";
        sha256 = "0mjgy6x6z9i471krijd2f00rsyjg5yrakyvzv9w5xaqk7bjzhzhy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/flymake-pyrefly.html";
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
      version = "1.0.1.0.20250311.185538";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/focus-1.0.1.0.20250311.185538.tar";
        sha256 = "1n5ph519fl0snfi2xvj7zhby2bscjlw7gfxjcs1acwhvn3ywwchd";
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
      version = "0.2.0.20251027.73009";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/forth-mode-0.2.0.20251027.73009.tar";
        sha256 = "1h7vvigb98z1bj9s6j34jw8kwlg71agi92plxsbk89cpdx8w9xki";
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
      version = "1.0.0.20250512.152751";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/free-keys-1.0.0.20250512.152751.tar";
        sha256 = "0nf29341jhwbpiqqzfi66yn9gw8m7y8cnd6afb0bixci1hnhaz1n";
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
      version = "0.32.0.20251220.230156";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-0.32.0.20251220.230156.tar";
        sha256 = "1a6l6b659h9mf0dqc6yvq2pc75x3rw3ysn6k9ap5pyrsdz7286f5";
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
      version = "0.17.0.20250803.172103";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-chicken-0.17.0.20250803.172103.tar";
        sha256 = "0zhwlyhykm7ys0nv6fc9qhrmnbsmr8lbprfzj6zm4h1k173n30r4";
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
      version = "0.0.2.0.20251213.115937";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-gauche-0.0.2.0.20251213.115937.tar";
        sha256 = "02dxms1hwfq9fd2y9kbic2cvjalr05wxlk0dbph46zgw8q7xg3f3";
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
      version = "1.4.8.0.20260101.183425";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/git-modes-1.4.8.0.20260101.183425.tar";
        sha256 = "1lw8cwrg66gw4pxbf6kwzglddc9jszz55nw1z0hpaiaz24yi17lg";
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
      org-gnosis,
      transient,
    }:
    elpaBuild {
      pname = "gnosis";
      ename = "gnosis";
      version = "0.7.0.0.20260224.120212";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnosis-0.7.0.0.20260224.120212.tar";
        sha256 = "1znf3ilss269f9h8l5bh3yfhm7kyyqb83ia296vw4n728gmy7bb7";
      };
      packageRequires = [
        compat
        emacsql
        org-gnosis
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
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "gnuplot";
      ename = "gnuplot";
      version = "0.11.0.20260122.130054";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnuplot-0.11.0.20260122.130054.tar";
        sha256 = "1qprpdry88b318774l26z7qddmnbf9nidzmc0bnhdgcxrbz3hnnk";
      };
      packageRequires = [ compat ];
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
      version = "1.6.0.0.20250311.20239";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/go-mode-1.6.0.0.20250311.20239.tar";
        sha256 = "1viwxqbp6jdhbmapjgcgrjyrzn4m2r68b5vb0814y3w4gi55rzgq";
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
      version = "0.9.9.4.0.20260221.172046";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gptel-0.9.9.4.0.20260221.172046.tar";
        sha256 = "0hnnr6idzw1x990ggnj35rmw20316v2q5jxb1ymgsi88ii20i074";
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
      version = "1.0.0.0.20260214.124443";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/graphql-mode-1.0.0.0.20260214.124443.tar";
        sha256 = "141z96ax3kqy2b046v2c7k5sb2mw27hr5x7zi58r1yfyhqi4x3a9";
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
      version = "1.30.1.0.20250117.22202";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gruvbox-theme-1.30.1.0.20250117.22202.tar";
        sha256 = "17cqq6yazkaclqa2p45ihrap2399vymbnaisi7c1syqxpyayz431";
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
      version = "3.2.1.0.20250714.144103";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haml-mode-3.2.1.0.20250714.144103.tar";
        sha256 = "0sawdjl7kgqqcn01kgcr7wyf875ix4hlqizaryg9akvgl8869nq2";
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
      version = "17.5.0.20260206.105045";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-mode-17.5.0.20260206.105045.tar";
        sha256 = "012w356crya0ik9p16xlkykk1xv9yk4w3k029xrmjhjw1jqvkybd";
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
      version = "1.3.5.0.20251204.182222";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-ts-mode-1.3.5.0.20251204.182222.tar";
        sha256 = "0rlng6z7g6bbsrcjbggyms8sd06729dyb9qir7s2i1r2adrscwb5";
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
      version = "4.0.6.0.20260214.143216";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-4.0.6.0.20260214.143216.tar";
        sha256 = "0v1j7vvpw5m6cjrbmzbjssw8n7r4ipxkzwl13z351lqx81q27p9b";
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
      version = "4.0.6.0.20260214.143216";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-core-4.0.6.0.20260214.143216.tar";
        sha256 = "09rmliclxhzbai5cgy3f1bg1y9nk6a3xig79iz6yxfc26qs1kkh2";
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
      version = "0.9.0.20251119.95800";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hideshowvis-0.9.0.20251119.95800.tar";
        sha256 = "0x31p9ilpr60l9shddarimms3r7znipnic2aahd165xfx33h3jnf";
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
      version = "0.2.0.20251230.73140";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hl-block-mode-0.2.0.20251230.73140.tar";
        sha256 = "0dzp8yqh6s1gy9hj0sri46zsl0zjdsbrhxgvg65lnfd86rv2ln9z";
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
      version = "1.59.0.20251130.194901";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/htmlize-1.59.0.20251130.194901.tar";
        sha256 = "12hq8b0q0m010j5ag3rhajnxrm70wq4jg8z0v9c8mfxqi6haxf6k";
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
      version = "0.6pre0.20251120.145618";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hyperdrive-0.6pre0.20251120.145618.tar";
        sha256 = "1s57c6m6fh593b9ax5skc5v1k3l0w983iq6mp3vx2a6g276qa44l";
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
      version = "1.1.5.0.20260108.131100";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/idle-highlight-mode-1.1.5.0.20260108.131100.tar";
        sha256 = "0s1snfinjjhfp08ilwf1f6p6w55k95b79ymz8y0rp6dc7drlk59h";
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
      version = "1.1.0.0.20260209.110723";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/idris-mode-1.1.0.0.20260209.110723.tar";
        sha256 = "19rw6k40qkn4b11vhr95w71rdfqdmrr27ga8vdj7imb812wcdqyy";
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
      version = "0.9.9.9.9.0.20251013.114841";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/iedit-0.9.9.9.9.0.20251013.114841.tar";
        sha256 = "1kczx43d3f63bhgyw6xsyd0spf7jgw424sncaiqxgnmcfhabrc03";
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
      version = "3.4.0snapshot0.20260220.143715";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-clojure-3.4.0snapshot0.20260220.143715.tar";
        sha256 = "1m0jah1rfd6csqafiqq44d8l3g97d51a1gwyhr8pxc7d82ng8sfn";
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
      version = "2.9.0.0.20251224.21617";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-ruby-2.9.0.0.20251224.21617.tar";
        sha256 = "0km80n6bfhdfr3cq9lw8aq63z8931s4yxd40vqxjqcvp1py9c01b";
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
      version = "0.1.0.20260106.3820";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inkpot-theme-0.1.0.20260106.3820.tar";
        sha256 = "17770z3r4ayjfj6l1dc21vmdwmzfw87dggsrln9p7l3b972xif3a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/inkpot-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  isl = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "isl";
      ename = "isl";
      version = "1.6.0.20260225.43822";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/isl-1.6.0.20260225.43822.tar";
        sha256 = "05fq6l8c8w4bkfkh2cmmmdnjwa6hmfpv00avkp6r5fz4v9fnkvwq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/isl.html";
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
      version = "2.0.2.0.20251003.80527";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/j-mode-2.0.2.0.20251003.80527.tar";
        sha256 = "1nzfxdx2ngkndrig2bbqh5y3459gslh9s00r4p9kwwvc5m0wrj47";
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
  javelin = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "javelin";
      ename = "javelin";
      version = "0.2.3.0.20260215.104721";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/javelin-0.2.3.0.20260215.104721.tar";
        sha256 = "18w050yhf4avkmynyd80gf39bg5bhj7r8p09cflsaa16zni5169y";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/javelin.html";
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
      version = "1.1.0.0.20260204.80729";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/julia-mode-1.1.0.0.20260204.80729.tar";
        sha256 = "1xx4vc8j2s0d3l6jby164kwwm90pxk3igd9xcbxblgdqspd5g5cw";
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
      version = "1.4.7.0.20260101.183551";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/keycast-1.4.7.0.20260101.183551.tar";
        sha256 = "1p0kzw0ciygp5xgyv2c7z9byn7x1x8zdrd7x3mlizjh3mpmwyl3k";
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
  lem = callPackage (
    {
      elpaBuild,
      fedi,
      fetchurl,
      lib,
      markdown-mode,
    }:
    elpaBuild {
      pname = "lem";
      ename = "lem";
      version = "0.24.0.20250806.92416";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/lem-0.24.0.20250806.92416.tar";
        sha256 = "0hamh1xvwir0dhf91vn0fch39hxs7k443q4x9anfv44006fsgd3f";
      };
      packageRequires = [
        fedi
        markdown-mode
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/lem.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  llama = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "llama";
      ename = "llama";
      version = "1.0.3.0.20260217.210434";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/llama-1.0.3.0.20260217.210434.tar";
        sha256 = "072q29wxq1jnhbiva7sw4kxi2j5rsbpp1zsyii9phk28h6hwb2h4";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/llama.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  logview = callPackage (
    {
      compat,
      datetime,
      elpaBuild,
      extmap,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "logview";
      ename = "logview";
      version = "0.19.4snapshot0.20260218.201306";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/logview-0.19.4snapshot0.20260218.201306.tar";
        sha256 = "1f49zs4w4wmn7famsc3ay8n7834c8zk2z3xmw74sk3744ygrc8d3";
      };
      packageRequires = [
        compat
        datetime
        extmap
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/logview.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  loopy = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
      map,
      seq,
      stream,
    }:
    elpaBuild {
      pname = "loopy";
      ename = "loopy";
      version = "0.15.0.0.20260222.160925";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/loopy-0.15.0.0.20260222.160925.tar";
        sha256 = "11cwl779qgv9r3l5ajpki0zy3zycspdnlgjdvynpq9mqqqgsx3rx";
      };
      packageRequires = [
        compat
        map
        seq
        stream
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/loopy.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  loopy-dash = callPackage (
    {
      dash,
      elpaBuild,
      fetchurl,
      lib,
      loopy,
    }:
    elpaBuild {
      pname = "loopy-dash";
      ename = "loopy-dash";
      version = "0.13.0.0.20251226.203150";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/loopy-dash-0.13.0.0.20251226.203150.tar";
        sha256 = "1xcda0jnbprs09d9yxfrqcapk2s5kz83nkl321yi9bnk9j1vsi6k";
      };
      packageRequires = [
        dash
        loopy
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/loopy-dash.html";
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
      version = "20221027.0.20250310.115056";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/lua-mode-20221027.0.20250310.115056.tar";
        sha256 = "0k1cgb6ld0bgy0bzir2v743ddxp15ng95j0k4sgcdzj5cyzj46kj";
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
      version = "0.9.5.0.20250202.220532";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/macrostep-0.9.5.0.20250202.220532.tar";
        sha256 = "089kw24sl8dm1dk45r0gj2h2y0pxazwcp7z5z0pvmnln98mgy4i1";
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
      cond-let,
      elpaBuild,
      fetchurl,
      lib,
      llama,
      magit-section,
      seq,
      transient,
      with-editor,
    }:
    elpaBuild {
      pname = "magit";
      ename = "magit";
      version = "4.5.0.0.20260221.163408";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-4.5.0.0.20260221.163408.tar";
        sha256 = "0w75prlzii0adc9ha3dia8g1x35nhg1g8v0mi34alclbimwmnxyg";
      };
      packageRequires = [
        compat
        cond-let
        llama
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
      cond-let,
      elpaBuild,
      fetchurl,
      lib,
      llama,
      seq,
    }:
    elpaBuild {
      pname = "magit-section";
      ename = "magit-section";
      version = "4.5.0.0.20260221.163408";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-section-4.5.0.0.20260221.163408.tar";
        sha256 = "108l2sgfximlcmp8m70qpmgzqhhj7njc2rz2dvw34ll88n6wpf57";
      };
      packageRequires = [
        compat
        cond-let
        llama
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
      version = "2.8alpha0.20260209.45942";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/markdown-mode-2.8alpha0.20260209.45942.tar";
        sha256 = "1n26jwk0qfzw3gzb2h0f3c7606x6bj30l7gk3q71zxnvzzzd40rk";
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
      tp,
    }:
    elpaBuild {
      pname = "mastodon";
      ename = "mastodon";
      version = "2.0.8.0.20251201.155309";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/mastodon-2.0.8.0.20251201.155309.tar";
        sha256 = "1zj5nmrxn99pp19fcxh1klph5xqp2g3x7xlybqg6dkl95id97qk2";
      };
      packageRequires = [
        persist
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
      version = "1.5.0.0.20250914.165407";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/meow-1.5.0.0.20250914.165407.tar";
        sha256 = "02wq0az10vqa7m55mga89aipjfqdwbw83rrf0xdyzc1f1r8841bm";
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
      version = "1.1.0.0.20260211.61732";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/moe-theme-1.1.0.0.20260211.61732.tar";
        sha256 = "0ids4skv6cyk36qww44kmds347l78kppaj96ra2d59ni2wl4jdbz";
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
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "multiple-cursors";
      ename = "multiple-cursors";
      version = "1.5.0.0.20260117.123334";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/multiple-cursors-1.5.0.0.20260117.123334.tar";
        sha256 = "1qnn3zx296zjvs9y10gq9a7n9ja68ipsvk0qbh48ib6z8n0b4sgh";
      };
      packageRequires = [ cl-lib ];
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
      version = "1.1.1.0.20250320.164627";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/nasm-mode-1.1.1.0.20250320.164627.tar";
        sha256 = "0dm1zg15q18v9y4mx2p8hdqvql4dikw8chkj3i3jb1jp9d0v2rf3";
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
  nov = callPackage (
    {
      elpaBuild,
      esxml,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "nov";
      ename = "nov";
      version = "0.5.0.0.20251213.150137";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/nov-0.5.0.0.20251213.150137.tar";
        sha256 = "1wmbxiw06xcc2gg7cyxn6519bmla20vi7plhhlfn3wlw00wjll9r";
      };
      packageRequires = [ esxml ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/nov.html";
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
      version = "0.1.0.20260108.134901";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/oblivion-theme-0.1.0.20260108.134901.tar";
        sha256 = "0qzb511qjbisywf29x29qg47dzh4gpxnxz776rq14h61w6jb1n9a";
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
      version = "0.6.0.0.20251230.141613";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-auto-tangle-0.6.0.0.20251230.141613.tar";
        sha256 = "18fq0wapd636lph3gm1ji4smp95mizcmvwk4j3ac7mk362wy4aab";
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
      version = "0.8.0.20260221.192041";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-contrib-0.8.0.20260221.192041.tar";
        sha256 = "15mrdfmj4nxqh7ayyc2nyhxak5ymfsa9ym8dl8gwjsc8xym9jidd";
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
      version = "2.2.0.0.20251203.115702";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-journal-2.2.0.0.20251203.115702.tar";
        sha256 = "1rdrkfhk9rj7a7r520x1n7i3ddpd122gknvw7bi1ab76rnq95zyl";
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
      version = "0.3.4.0.20251201.24527";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-mime-0.3.4.0.20251201.24527.tar";
        sha256 = "01lqq0rczcf721d0ndf5mqmbj24gz24j5ah6nam7xwhdwmcp1dc0";
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
      version = "1.7.0.0.20250914.130856";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-superstar-1.7.0.0.20250914.130856.tar";
        sha256 = "0j2yxmsikpv75asbn8n15fkp1r79ca59in3gfipwnsh1yb5bmc4z";
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
      cond-let,
      elpaBuild,
      fetchurl,
      lib,
      magit,
      org,
    }:
    elpaBuild {
      pname = "orgit";
      ename = "orgit";
      version = "2.1.1.0.20260201.145846";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/orgit-2.1.1.0.20260201.145846.tar";
        sha256 = "0wgvhkfq0x876pw2lad9bq5xh5mla604wzvrh3l4zklqif18y7m4";
      };
      packageRequires = [
        compat
        cond-let
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
      version = "0.26.0.20251205.172019";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/package-lint-0.26.0.20251205.172019.tar";
        sha256 = "1b8pdsy3ym66vcf7f98prlr9hia710zxksyjsnf6r9mnddk2hry4";
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
      version = "0.15.0.20251121.212752";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/page-break-lines-0.15.0.20251121.212752.tar";
        sha256 = "0jzga42sd4p4nibbypi0f6427pfibdmpdjrcxnygvj8rc3wk1qv6";
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
      version = "0.1.3.0.20250216.224206";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pcmpl-args-0.1.3.0.20250216.224206.tar";
        sha256 = "11alsr3b2liinvsvh5nd2nkkqd08pvrpkbla2xnfmbr4i2rg93r7";
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
      version = "1.3.0.0.20260108.170248";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pdf-tools-1.3.0.0.20260108.170248.tar";
        sha256 = "01q2sbvzhm9m00j542rgbfhinimxavnz4lflf66ccqpcmajzya24";
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
  pg = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      peg,
    }:
    elpaBuild {
      pname = "pg";
      ename = "pg";
      version = "0.63.0.20260208.141935";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pg-0.63.0.20260208.141935.tar";
        sha256 = "1jkddkiv4izp64ad4gl4a335znds8vak9mly9vx00arzs9cg255r";
      };
      packageRequires = [ peg ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/pg.html";
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
      version = "1.26.1.0.20251112.64638";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/php-mode-1.26.1.0.20251112.64638.tar";
        sha256 = "1vh7ynpbpps46jw5g9qwzzhyb4kll0dpppj5493kpjj3d87xclir";
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
      version = "0.5.9.0.20251231.162233";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/popup-0.5.9.0.20251231.162233.tar";
        sha256 = "0w6f04gx4k3das0p8hdx178ldvwwx8jbzns1n1kwwgc1i5x8fl51";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/popup.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  powershell = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "powershell";
      ename = "powershell";
      version = "0.4.0.20251122.143018";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/powershell-0.4.0.20251122.143018.tar";
        sha256 = "1zd7cywmgsz59k80jkgnzhazpfijv26fx81l3nfnlkznfy0zgmxd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/powershell.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  projectile = callPackage (
    {
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "projectile";
      ename = "projectile";
      version = "2.10.0snapshot0.20260216.65235";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/projectile-2.10.0snapshot0.20260216.65235.tar";
        sha256 = "0a79a85scyrpvrcbqb4n2cjjjgbhf61qm2ilkwk8mspym4g0b41v";
      };
      packageRequires = [ compat ];
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
      version = "4.6snapshot0.20260124.135141";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/proof-general-4.6snapshot0.20260124.135141.tar";
        sha256 = "0wjjip6pph8s8j613md5j6f5ba40cl88v44i88s6s11ixrmd73sl";
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
      compat,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "racket-mode";
      ename = "racket-mode";
      version = "1.0.20260117.121353";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/racket-mode-1.0.20260117.121353.tar";
        sha256 = "0zycibkfrckgmqc5ss0fv1kz3yin9xldg1bx13rvj59m7qp6fkaj";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/racket-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  radio = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "radio";
      ename = "radio";
      version = "0.4.3.0.20260212.144358";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/radio-0.4.3.0.20260212.144358.tar";
        sha256 = "0bjxl75zi9fkz0wqx2b70rjkv5mngx5g7az4zx5jgim85qs2cpyg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/radio.html";
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
      version = "0.2.1.0.20250930.115108";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/raku-mode-0.2.1.0.20250930.115108.tar";
        sha256 = "1qvsib5w75n31ya153ixiyfklwqxgmrvv2a7zfqqn5ivzlc14ynk";
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
      version = "0.2.0.20260108.132129";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/recomplete-0.2.0.20260108.132129.tar";
        sha256 = "1vr39dvac87ikgf07r492yrmxnsfmdz816gyygb3rrj8fpjxp80f";
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
      version = "0.8.0.20251121.93526";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/reformatter-0.8.0.20251121.93526.tar";
        sha256 = "11s23mply7aaa68y6miwzn6bld5m1rynk19l5jj2i1mwjk2plrlk";
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
      version = "0.3.3.0.20250219.185201";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/request-0.3.3.0.20250219.185201.tar";
        sha256 = "0r2rzkgfw8ka31v7hyrsymnra3v40g2sdwvz7s34fgxx9fkryihb";
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
      version = "1.4.2.0.20260127.180740";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rfc-mode-1.4.2.0.20260127.180740.tar";
        sha256 = "1i01x9k208zasil586q1jz28hdl5hpx964a6bgb6wwgf9ya79xlx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rfc-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  rpm-spec-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "rpm-spec-mode";
      ename = "rpm-spec-mode";
      version = "0.16.0.20250329.13938";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rpm-spec-mode-0.16.0.20250329.13938.tar";
        sha256 = "1gmqnv1ckypns7aiz4w5kb3l8m66bfxlw8z19i3ag5im8rlpc9lp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/rpm-spec-mode.html";
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
      version = "1.0.6.0.20260207.42454";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rust-mode-1.0.6.0.20260207.42454.tar";
        sha256 = "106pv49x0ivmxal1zn9raacrbnyncg2x7a3sf52g6ij5rdcixi18";
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
      version = "98.0.0.20260117.165324";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scad-mode-98.0.0.20260117.165324.tar";
        sha256 = "0b3327x1vx2mr538kghga9hmv1jn1i8zbnj2879wh4abhahdc0fw";
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
      version = "1.1.1.0.20260118.94206";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scala-mode-1.1.1.0.20260118.94206.tar";
        sha256 = "172vfh3a91angf9xj17x5kw8gpinhmk08g3jpwwzq02m6y6ipkn9";
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
      version = "0.1.0.20260108.131616";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scroll-on-drag-0.1.0.20260108.131616.tar";
        sha256 = "0hzpppp25wd9cli833gyw73nbkb8rs9pi2ivdgxnwj5ca9bwp8vw";
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
      version = "0.3.0.20260108.130950";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scroll-on-jump-0.3.0.20260108.130950.tar";
        sha256 = "1jwsiqrn5q7vldbajyn76w4h2pffmgcv2hakgzsyjbfafvrzvqpj";
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
      version = "2.32snapshot0.20260224.183432";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/slime-2.32snapshot0.20260224.183432.tar";
        sha256 = "1vad3zbjskfaypisby9fj2sy02ifva2bjsfy9ix0rw0mpq8ggnpb";
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
      version = "1.0.43.0.20251212.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sly-1.0.43.0.20251212.7.tar";
        sha256 = "0pbkdxdw9a3cxbhm2p2s1w077sj237v1gr06cw8q75qb1vjhhdrk";
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
      dash,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "smartparens";
      ename = "smartparens";
      version = "1.11.0.0.20260129.121419";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/smartparens-1.11.0.0.20260129.121419.tar";
        sha256 = "0c7cy08dk67d2fw3z24m9g598rqcf82ziwnkjgh45ywgbrrz52x1";
      };
      packageRequires = [ dash ];
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
      version = "2.0.4.0.20250913.45124";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/solarized-theme-2.0.4.0.20250913.45124.tar";
        sha256 = "0cjsz6a14d0zz4r93653d5imvgwpl9xchvr5snbkr8s359fs5icx";
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
      version = "0.2.0.20251221.165628";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spacemacs-theme-0.2.0.20251221.165628.tar";
        sha256 = "16d4g4cyjij8s7pzf0g0pnbsfxzxw8lwdamwaq4whmn5g320yb28";
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
      version = "0.3.0.20260108.133641";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spell-fu-0.3.0.20260108.133641.tar";
        sha256 = "1yrv1a3k6nk92bhs4gsqpb1gc7x55gpp365ykpx6zj0hiapfhq80";
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
      version = "0.17.0.20251014.53705";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sqlite3-0.17.0.20251014.53705.tar";
        sha256 = "0q849fac1h7vci1mclh3l0w7zg6150w95fbzfk0aq7nldir6mizy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/sqlite3.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  standard-keys-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "standard-keys-mode";
      ename = "standard-keys-mode";
      version = "1.0.0.0.20260105.112114";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/standard-keys-mode-1.0.0.0.20260105.112114.tar";
        sha256 = "0haqds9h15rk61rnwrs0a37gwhm1gm4j6fj9a9i7fkvca2qfyb3d";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/standard-keys-mode.html";
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
      version = "1.8.2.0.20260216.82619";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/subatomic-theme-1.8.2.0.20260216.82619.tar";
        sha256 = "0v5jv362kicjrygyf7dkjjg8sfczwx4g783h7l4ndxn5r1l7smb6";
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
      version = "1.4.1.0.20260216.184548";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/subed-1.4.1.0.20260216.184548.tar";
        sha256 = "0fjnfxinr7lvhzd71xcvcpgq23fd57yawqhs40qy02mpq7d7h3ai";
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
      version = "0.27.6.0.20250624.64526";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sweeprolog-0.27.6.0.20250624.64526.tar";
        sha256 = "1ywcwm4r7hd21bayilvmw530axa2gc8f689fr5swxfyig49qjqz5";
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
    }:
    elpaBuild {
      pname = "swift-mode";
      ename = "swift-mode";
      version = "9.4.0.0.20251122.85713";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/swift-mode-9.4.0.0.20251122.85713.tar";
        sha256 = "1sn7lm6srrlnbxfdjpqdr503plkml61bz79ivwgz9rs9fqkbrvgg";
      };
      packageRequires = [ ];
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
  teco = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "teco";
      ename = "teco";
      version = "9.0.20200801.144333";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/teco-9.0.20200801.144333.tar";
        sha256 = "0j3wzsyr28qf8pcb73nim54rmw00p45gfh2s6dnlvpfbcg96r83v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/teco.html";
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
      version = "1.0.0.20250312.200047";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/totp-auth-1.0.0.20250312.200047.tar";
        sha256 = "1qi0svqdbk389kzlm4i7ghrrp01nc87vvqzjgynd56bw5nalibcr";
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
      version = "0.8.0.20260219.143500";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tp-0.8.0.20260219.143500.tar";
        sha256 = "15szb0li4ibsaja39699rc85nvk2s466g303dp0si62h9ipha68w";
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
      version = "0.2.1.0.20260117.211549";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/treesit-fold-0.2.1.0.20260117.211549.tar";
        sha256 = "1zznirq9lvrhqhm3xc6sf0ap157dl16ybcncighl6p641zb292b5";
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
      version = "3.0.2snapshot0.20250910.140516";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tuareg-3.0.2snapshot0.20250910.140516.tar";
        sha256 = "0m9xid4s6qqdw8vlpgzsf2lc877shf7dvfxk8b9bhiva56dhrqfw";
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
      version = "0.4.0.20251127.204054";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/typescript-mode-0.4.0.20251127.204054.tar";
        sha256 = "128xgfj0b5lxm06ddlhd1bl5mqy828yphgq07q2mgxprgv58c3xw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/typescript-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  typst-ts-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "typst-ts-mode";
      ename = "typst-ts-mode";
      version = "0.12.2.0.20260130.110553";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/typst-ts-mode-0.12.2.0.20260130.110553.tar";
        sha256 = "19v349nhr1km00w19rxv1g4vkhl2hk9sf0y9q0cg15682qc28jjz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/typst-ts-mode.html";
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
      version = "0.5.0.20260108.32351";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-0.5.0.20260108.32351.tar";
        sha256 = "16jc23g4xcalbdzjsynq9nw0h7jj0v9r3cxf8jbmrp85zdpyjzk0";
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
      version = "0.8.0.20260209.75408";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-session-0.8.0.20260209.75408.tar";
        sha256 = "1238b4i83sw5rylh73i4bd4qdm7g4hpwpas7ynyyq000zfj52jas";
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
      version = "2.7.1.0.20251110.104539";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/visual-fill-column-2.7.1.0.20251110.104539.tar";
        sha256 = "18gm23pmkn6h9jajn50mczip0680jcx6v72mhi99lmnvjbvwbxb8";
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
      elpaBuild,
      fetchurl,
      lib,
      vcard,
    }:
    elpaBuild {
      pname = "vm";
      ename = "vm";
      version = "8.3.3snapshot0.20260225.71602";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/vm-8.3.3snapshot0.20260225.71602.tar";
        sha256 = "1w6p8cygsvwzzci2fjjy4rysb6n888frsa1ay99p66x8kq5s7n50";
      };
      packageRequires = [ vcard ];
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
      version = "17.3.22.0.20251214.172854";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/web-mode-17.3.22.0.20251214.172854.tar";
        sha256 = "1hjmq7w59s4p3qr331r0dz4j5s685cr82ma1q30hdpy0rhxiqh6i";
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
      version = "1.2.0.20260105.45812";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/wfnames-1.2.0.20260105.45812.tar";
        sha256 = "116d5j1sqb0fbqlfaxxiaraw8c6mg69nw5mn412zwrvbq4vgpp4c";
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
      version = "3.0.0.0.20241206.130617";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/wgrep-3.0.0.0.20241206.130617.tar";
        sha256 = "1ihwqz865wcdb83aw6nmzhnkrf7rnxqkcncmz7rvzddsrg19hahr";
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
      version = "3.4.8.0.20260104.4109";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/with-editor-3.4.8.0.20260104.4109.tar";
        sha256 = "1688qk4i4r131w0m2iss3p9yjlqs2a5r2nw9kfw7ziypqkmc6pp5";
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
      version = "1.3.0.20250612.214058";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/ws-butler-1.3.0.20250612.214058.tar";
        sha256 = "0w580p3p2b3jmmfr46qzgg4zqxc8dg17b8808a9djjlz56v589w6";
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
      version = "28.11.20260215192642.0.20260215.201333";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xah-fly-keys-28.11.20260215192642.0.20260215.201333.tar";
        sha256 = "08pdqfglkl150pw43llm5z3a2mpzdil315a732i7fa4a27qwkxfn";
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
      version = "1.6.17.0.20251122.185743";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xml-rpc-1.6.17.0.20251122.185743.tar";
        sha256 = "1sshmzg6v27v8l0q3lq2apfvpbkkg71dyn7mk99a56qab4ajm6zs";
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
      version = "1.0.0.20251215.123158";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/yasnippet-snippets-1.0.0.20251215.123158.tar";
        sha256 = "1sqm4j3b5azb3h7173mc43iyqywyp083ybdk07ivv1dydj2mqswv";
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
      version = "2.9.0snapshot0.20251028.122652";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zenburn-theme-2.9.0snapshot0.20251028.122652.tar";
        sha256 = "00y5qix2znxz7c3g780h56ssmqjj801s7ig43gsk84rhr6h67wy5";
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
      version = "0.0.8.0.20251128.25646";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zig-mode-0.0.8.0.20251128.25646.tar";
        sha256 = "03nqzy5xyqsr7ax1m0sprk75ygkyspj824vixgkrflqnrhyj5b2s";
      };
      packageRequires = [ reformatter ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/zig-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
