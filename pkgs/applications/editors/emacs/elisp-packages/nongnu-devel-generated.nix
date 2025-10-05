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
      version = "0.8.0snapshot0.20250206.83825";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/adoc-mode-0.8.0snapshot0.20250206.83825.tar";
        sha256 = "0b9lbxk5q0hr7j86wpxrkbg626srkc9jhycqi7qb3yqsn1pr4khc";
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
      version = "1.5.0.20250818.124701";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/aidermacs-1.5.0.20250818.124701.tar";
        sha256 = "0y32fj69y0vvk3gcf7lrpwcmqk7y55gxrpl59l1wc9rwq42rsv90";
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
      version = "2.4.2.0.20250515.142850";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/annotate-2.4.2.0.20250515.142850.tar";
        sha256 = "0g30jcpb44vdb43msn93w8j4f2zk0zm7n3l2ghndvm31qc3qr1k8";
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
      version = "2.2.0.0.20250811.194318";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apache-mode-2.2.0.0.20250811.194318.tar";
        sha256 = "16hpfjy2998i289gd95f61fj95g798z99kwlv3mh8a57sj1da0fz";
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
      version = "0.2.0.0.20250724.72226";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/apropospriate-theme-0.2.0.0.20250724.72226.tar";
        sha256 = "10z6ifrfg0dxjjvk8lhw7a2w041wbfvfik9jvz8m7sl6k6pl8bsi";
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
      version = "0.2.18.0.20250421.72550";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/autothemer-0.2.18.0.20250421.72550.tar";
        sha256 = "0y6k0ysy4z7am8zapp1gynr3rjm9vwggi8syc1a19niaqvzm80c4";
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
      version = "3.2.1snapshot0.20250721.202603";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bash-completion-3.2.1snapshot0.20250721.202603.tar";
        sha256 = "0vx9d3216n3p39fkch1z3kmsbszqcdhf1j4wiqp15y034j2g5gk1";
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
      version = "0.9.0.0.20250616.105101";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/beancount-0.9.0.0.20250616.105101.tar";
        sha256 = "1h1hy46xqm70nilqx1z5v4a81y59j7ywikckw2xslilkrniw6wj5";
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
      version = "1.1.2.0.20250308.71029";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/bind-map-1.1.2.0.20250308.71029.tar";
        sha256 = "0z0dzlxj011nggzgzk5g4dwc1c2z78264pggj8li0h15216yq3ll";
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
      version = "0.0.3.0.20250702.131748";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/blueprint-ts-mode-0.0.3.0.20250702.131748.tar";
        sha256 = "1w0annw8qrf6pik02i4f7nq469spninjzjgfvkkk56h2cabxf29n";
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
      version = "1.20.0snapshot0.20250806.194437";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cider-1.20.0snapshot0.20250806.194437.tar";
        sha256 = "1z7v7f8pal8z4pgr6qzmh1g8ir1rdwshx2hifzngkp33lqmvd15x";
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
      version = "5.20.0.0.20250528.61040";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-mode-5.20.0.0.20250528.61040.tar";
        sha256 = "071zs4y4ishjkzwr0dsmd3280vpl92vdpy8f1hwa85lz6i4kyr4r";
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
      version = "0.6.0snapshot0.20250815.44110";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/clojure-ts-mode-0.6.0snapshot0.20250815.44110.tar";
        sha256 = "1nn9bg4lpv5vxwvmxhlfbkk4zdg8sk52lk6mhpx5679jbgc8kx7q";
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
      version = "1.0.0.20250804.224423";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/consult-flycheck-1.0.0.20250804.224423.tar";
        sha256 = "1xjin3rf75l8id6yc5h4whqwsaarvmhy5fjm7adl4xikq6i2cbm4";
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
      version = "0.2.0.20250611.32851";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/cycle-at-point-0.2.0.20250611.32851.tar";
        sha256 = "17pw2g8nh1byp42qb06568lrir0b6msbqhvkw45dwp89dd7nkrc4";
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
      version = "1.0.7.0.20250811.110356";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dart-mode-1.0.7.0.20250811.110356.tar";
        sha256 = "0xispkk8chgahkw4pgn70scx0nnsrlnvvskrgfisr9ih5rlbhvi1";
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
      version = "0.2.0.20250611.51010";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/diff-ansi-0.2.0.20250611.51010.tar";
        sha256 = "1i7x02ccvsbaayvzv9sbi09a6vfzpqhnaqkzcqjbkff538v6kcy1";
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
      version = "0.1.0.20250209.60743";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/doc-show-inline-0.1.0.20250209.60743.tar";
        sha256 = "172shyhapbfllc2pv5wrbp58qxfp10gmz49ny5av4yf3ayqd6cm5";
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
      version = "1.9.0.20250315.102635";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dockerfile-mode-1.9.0.20250315.102635.tar";
        sha256 = "057drkn59pq5m68900lxy2nzsf3qnqhc6vglx8zl4yc32vhqa2w4";
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
      version = "1.8.3.0.20250626.195550";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/dracula-theme-1.8.3.0.20250626.195550.tar";
        sha256 = "14zlkirydnlydivmccg5129amnjmy6238m1b8b7gq68qz95spjxz";
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
      version = "0.11.0.0.20250808.184702";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/editorconfig-0.11.0.0.20250808.184702.tar";
        sha256 = "1j2zspg9i7r0rnjy79c7032cd3nxir9r1j7img0bwwc1sv7az32y";
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
      version = "3.6.5.0.20250306.150410";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/elpher-3.6.5.0.20250306.150410.tar";
        sha256 = "1ah1vsbigz7ip7iz7f53w0bnmwf7dhfzyn1dx1dkfp4lkpr8gc7g";
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
      version = "4.3.1.0.20250811.210334";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/emacsql-4.3.1.0.20250811.210334.tar";
        sha256 = "1c76h1l5d2yjyy4xxk65scmivfp5qshngjy653fcqh8zhn4as6vx";
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
      version = "1.15.0.0.20250812.102316";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-1.15.0.0.20250812.102316.tar";
        sha256 = "05wx37b8vnjxx4swcpzmi0lf3g2b82dswd9j49xcphmqc0br4a6x";
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
      version = "4.0.1.0.20241205.72440";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-matchit-4.0.1.0.20241205.72440.tar";
        sha256 = "0hi6p25pbn2xh7jzglmpvs5nvrlzi7b4gjm37q1vbyiji9k5xfci";
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
      version = "0.7.0.20250823.61659";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/evil-numbers-0.7.0.20250823.61659.tar";
        sha256 = "0snfxd5nkaliz7l33vdflk0sj683klcwa1gzc758rc32byzwmhd6";
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
      version = "35.0.0.20250814.121325";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flycheck-35.0.0.20250814.121325.tar";
        sha256 = "1w2hzzdz4bb982dj1632lg1fhi69hxy2244nmc5g19qk799cvgwc";
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
  flymake-pyrefly = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "flymake-pyrefly";
      ename = "flymake-pyrefly";
      version = "0.1.6.0.20250805.190746";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/flymake-pyrefly-0.1.6.0.20250805.190746.tar";
        sha256 = "10r5f7zqnwwcp5ds9bh6d3hlfkp0wa614iknw7dgzhbg83v2c6r8";
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
      version = "0.32.0.20250810.134607";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-0.32.0.20250810.134607.tar";
        sha256 = "0gwwdnpfhn37xk8dmw3izxr4w0ky37yv7va64m90ibzblrbgvfcf";
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
      version = "0.0.2.0.20250311.73546";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/geiser-gauche-0.0.2.0.20250311.73546.tar";
        sha256 = "1fw2fxbzl2mjvm2pj7fzdqlz3l76j8xd76kz0719vb7m6fnf1kwg";
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
      version = "1.4.5.0.20250531.221751";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/git-modes-1.4.5.0.20250531.221751.tar";
        sha256 = "16h7v25rrd818lcnrdh7x6nq4v4q2qb9iisfh4vaya28jysj5wda";
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
      version = "0.5.5.0.20250815.134629";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnosis-0.5.5.0.20250815.134629.tar";
        sha256 = "0ricm6spfgybd5z6k6si868rb00s34ci9cmbdlh439q6n1w0i3j3";
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
      version = "0.11.0.20250724.153116";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gnuplot-0.11.0.20250724.153116.tar";
        sha256 = "0fynfi8yzvmn63awmq0hikf2qwch6l5d1crbc4xzgdz5a132w8c7";
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
      version = "0.9.8.5.0.20250823.231025";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/gptel-0.9.8.5.0.20250823.231025.tar";
        sha256 = "0lrydk1lby15iz4z9h1w23mhi4h6vfm6xdcan72qphg9d33xc33y";
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
      version = "1.0.0.0.20241206.72535";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/graphql-mode-1.0.0.0.20241206.72535.tar";
        sha256 = "06pn5rk0mkswrx2sd589hbqir1wkczjwy453ssk0az4z49g85ks9";
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
      version = "17.5.0.20250812.135807";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-mode-17.5.0.20250812.135807.tar";
        sha256 = "17nbn2dl75v3bvzk4c1yag27ji2mrlhfpc3js0kldcz999sxn52w";
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
      version = "1.3.2.0.20250629.84650";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/haskell-ts-mode-1.3.2.0.20250629.84650.tar";
        sha256 = "09n25ag4pjxyx5k6ffwpny6cdgblrg9v9kw64v6ili4zni0bvf6k";
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
      version = "4.0.5.0.20250823.30001";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-4.0.5.0.20250823.30001.tar";
        sha256 = "180qb00slqj3iswdns8lhb6fj04qrypfxskzsdlmrbywn7g7gprz";
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
      version = "4.0.5.0.20250823.30001";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/helm-core-4.0.5.0.20250823.30001.tar";
        sha256 = "183z699pn0bdy4qfygnfmi0qaik5pmly8cl16b5zm39qabph4nrs";
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
      version = "0.8.0.20250225.175051";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hideshowvis-0.8.0.20250225.175051.tar";
        sha256 = "1f0p5ir99n5m41habjkhy2c2nj7infianp6zy0d6i8493gxcxay4";
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
      version = "0.2.0.20250113.124218";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hl-block-mode-0.2.0.20250113.124218.tar";
        sha256 = "00xs4cdcwyggccvlsv7l0q58hv4qhbyv0fyl3js8hqs9091qyv70";
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
      version = "1.59.0.20250724.170327";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/htmlize-1.59.0.20250724.170327.tar";
        sha256 = "16ysry86hyvgjpdws8h96zs02djvclj6cbdmif6vpsywn3q01mzn";
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
      version = "0.6pre0.20250406.152517";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/hyperdrive-0.6pre0.20250406.152517.tar";
        sha256 = "190cj2hflahfg592w6g9h24m5pa62dn7jc38lrf5qabgpbrk5ksb";
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
      version = "1.1.0.0.20250825.75833";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/idris-mode-1.1.0.0.20250825.75833.tar";
        sha256 = "0ifxj3na8i0xhrkkh5j5xlassjxjv9snaybkaqd8ah5khj4y8cq9";
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
      version = "3.3.0.0.20250525.205532";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-clojure-3.3.0.0.20250525.205532.tar";
        sha256 = "1q4cibg107pcg1cirqmmzhvbyyzlm76aqfyqad8m6ds76jv3kkcg";
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
      version = "2.9.0.0.20250212.2927";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inf-ruby-2.9.0.0.20250212.2927.tar";
        sha256 = "0hnwrybc89fdpkn3l1ff4x3vf5c2d6rgjjxbwyikk67b6p405zm7";
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
      version = "0.1.0.20250303.103930";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/inkpot-theme-0.1.0.20250303.103930.tar";
        sha256 = "02lkb9yl83bkad0jj6im6yhv160fsk0zf02zi9y9fzqx4p4qrn1g";
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
      version = "1.0.2.0.20250428.81943";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/julia-mode-1.0.2.0.20250428.81943.tar";
        sha256 = "05sx6pwwrvxwrpd1fskhqnr8yvzav7yafk7im5iscxic061xggpv";
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
      version = "1.4.4.0.20250531.221920";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/keycast-1.4.4.0.20250531.221920.tar";
        sha256 = "03v4xsg22b86wbbf2cb9cgrid4c1mh5hrj6v7vmwg2f14rdqhl7q";
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
      version = "1.0.0.0.20250812.133610";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/llama-1.0.0.0.20250812.133610.tar";
        sha256 = "0ybk2b9nq9sm88376j3ighbzhkklvlga78zl4rim8llafk8yjsi9";
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
      version = "0.19.3snapshot0.20250401.172309";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/logview-0.19.3snapshot0.20250401.172309.tar";
        sha256 = "0vr34ixpidz1lp6y87axlvi0pac11lfkm5g0d310wphihnjmyssr";
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
      version = "0.14.0.0.20250810.194832";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/loopy-0.14.0.0.20250810.194832.tar";
        sha256 = "0s07913f6y63vwrm4zpb4k1wx6sl75vpmfawczyzxgldkjjslnpq";
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
      version = "0.13.0.0.20250114.23438";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/loopy-dash-0.13.0.0.20250114.23438.tar";
        sha256 = "1gbhs3agzf5pg6x3c87ccwxwfppg27jh6zpjc12hv9fgj5pajir3";
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
      version = "4.3.8.0.20250704.230026";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-4.3.8.0.20250704.230026.tar";
        sha256 = "0bardjnsk52yjz5yd10yv1grzr6rsgzc30v7azmp64hki175xakl";
      };
      packageRequires = [
        compat
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
      elpaBuild,
      fetchurl,
      lib,
      llama,
      seq,
    }:
    elpaBuild {
      pname = "magit-section";
      ename = "magit-section";
      version = "4.3.8.0.20250704.230026";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/magit-section-4.3.8.0.20250704.230026.tar";
        sha256 = "057npc4k3yxccjd2qwl7fr3zcms1q9n02nmjym1ysak3q16kkynm";
      };
      packageRequires = [
        compat
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
      version = "2.8alpha0.20250812.42301";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/markdown-mode-2.8alpha0.20250812.42301.tar";
        sha256 = "1ckl1ykijnahld1fwd6mp04j1hwdq1acdbi9wrnwzizizrfisbjp";
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
      version = "2.0.2.0.20250801.103236";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/mastodon-2.0.2.0.20250801.103236.tar";
        sha256 = "0wgx53vlg2ifajmr298a3hrz8fy08sgdx909jfbm44kbf4myhm2m";
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
      version = "1.5.0.0.20250803.54141";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/meow-1.5.0.0.20250803.54141.tar";
        sha256 = "1yjr5bc90f93vwwnb1gj8ni1i0h8mh5sl51vafyh24dnd49rw9c3";
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
      version = "1.1.0.0.20250527.61144";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/moe-theme-1.1.0.0.20250527.61144.tar";
        sha256 = "056w9sg4nq75rbcl73l86l79s9qzjp9kdiqrmcydicpdk40dm115";
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
      version = "1.5.0.0.20250210.181349";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/multiple-cursors-1.5.0.0.20250210.181349.tar";
        sha256 = "072vlw8cb1f1mbzlx68lg8yrmyc7ca2f2iyxmvjy5nn3lx7v6lkd";
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
      version = "0.6.0.0.20250429.50000";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-auto-tangle-0.6.0.0.20250429.50000.tar";
        sha256 = "0sbvkj1b8ibjq95ahhbw9qp488da3s3v5m4dfp6l8p4hdlz0xi4h";
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
      version = "0.6.0.20250227.181559";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-contrib-0.6.0.20250227.181559.tar";
        sha256 = "15cc87skz34cw9zrg055jmqnjqpbwl06mfvqblzg3x5irjgghkfi";
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
      version = "2.2.0.0.20250525.35745";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-journal-2.2.0.0.20250525.35745.tar";
        sha256 = "0b00a6sn1ykqzz4f9zqi3z0n586n6q9swf92af3kxc9157av9wq5";
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
      version = "0.3.4.0.20250318.215555";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/org-mime-0.3.4.0.20250318.215555.tar";
        sha256 = "0plqmcyszpc1x35v691zlgxmnbga80yxxcjyb5mvxdri45z4458d";
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
      version = "2.0.3.0.20250823.203621";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/orgit-2.0.3.0.20250823.203621.tar";
        sha256 = "0zdblah0hz8lcmvgq035djl79np57bb01ynm2kksflnpz6bsmhsk";
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
      version = "0.26.0.20250819.130417";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/package-lint-0.26.0.20250819.130417.tar";
        sha256 = "0fsjd3sry469xrpkfabid2bh7f3p50ddhwj6c9vabg9fad3yykyd";
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
      version = "0.15.0.20250812.113016";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/page-break-lines-0.15.0.20250812.113016.tar";
        sha256 = "08v3pdy4p4qw8dcss4246r7lajcabs37ah4vngyniip331qnf8ja";
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
      version = "0.58.0.20250823.202123";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/pg-0.58.0.20250823.202123.tar";
        sha256 = "0ddi6025ydm9dzacnnkiry72pc3lwdjb0gljslar15cl9ks2bi0x";
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
      version = "1.26.1.0.20250602.130847";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/php-mode-1.26.1.0.20250602.130847.tar";
        sha256 = "0bhwg683jk5sjlq9kvp0318cgp1w7yvi7cfl5svr5qd3d44j7mgk";
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
      version = "0.5.9.0.20250812.70240";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/popup-0.5.9.0.20250812.70240.tar";
        sha256 = "1csszznlk47jxzbsw2rayf0mwnxk4r2abc95sb7nzf30bibgwymg";
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
      version = "2.9.1.0.20250716.140530";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/projectile-2.9.1.0.20250716.140530.tar";
        sha256 = "0y4vk9jb1knblzfaj28rvqkpgqwp58lhbgwab8p0nnnfjh269y4z";
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
      version = "4.6snapshot0.20250811.112700";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/proof-general-4.6snapshot0.20250811.112700.tar";
        sha256 = "1gwdwq8lb22b03fq8a046dqyy4kgdbaf7lhiah64pndhl8649xhq";
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
      version = "1.0.20250711.83643";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/racket-mode-1.0.20250711.83643.tar";
        sha256 = "0fz97vmiwlqbgvbzp0zaa5jy5pbpdbhzg16db1rg01f101x5368h";
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
      version = "0.4.1.0.20250305.101402";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/radio-0.4.1.0.20250305.101402.tar";
        sha256 = "0l71sgr2a3xpmq3s6ilzk89psjl2zymc15v2la3zd0iw1xbd97x6";
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
      version = "0.2.0.20250528.3825";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/recomplete-0.2.0.20250528.3825.tar";
        sha256 = "1cip3dy8klcy1hsw2w3wx9lhzpf6inya430japh798drn0k3vi7j";
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
      version = "0.8.0.20250812.113040";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/reformatter-0.8.0.20250812.113040.tar";
        sha256 = "1x8n1i974cnmjccz4142nr4p8yic9szfpsmnxm9gg4mnvrlnjzwv";
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
      version = "1.0.6.0.20250816.40724";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/rust-mode-1.0.6.0.20250816.40724.tar";
        sha256 = "1w45rp9ppw8sr2pprzfy2bglmd2x47frhz5kfmf07ch3prdbynp7";
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
      version = "97.0.0.20250728.23846";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scad-mode-97.0.0.20250728.23846.tar";
        sha256 = "1jvhzhvs0zfx3ygzrm9ixw10wmdv0fy9s3g236kbdrlkc94lddrc";
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
      version = "1.1.1.0.20241231.83915";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scala-mode-1.1.1.0.20241231.83915.tar";
        sha256 = "079w6awnk36h33fz4gsqcnc3llsfmv1pmwzqyy8vv27x65i9fxjs";
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
      version = "0.2.0.20250712.131709";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/scroll-on-jump-0.2.0.20250712.131709.tar";
        sha256 = "1x38322dlcfjyj1jy1gmyvc6wwp6idnc802mjc3a4g3yzqjb64iq";
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
      version = "2.31snapshot0.20250817.234725";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/slime-2.31snapshot0.20250817.234725.tar";
        sha256 = "12jaqyly9y0yvamvm26qgzcx3pqrais581dd50jc4vkfs2s2x0ig";
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
      version = "1.0.43.0.20250522.230625";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/sly-1.0.43.0.20250522.230625.tar";
        sha256 = "13y1h93bf4bmz0mwrwhk6nd4skvcpjw9x0jl1ga2xx1ja6wf81s5";
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
      version = "1.11.0.0.20250612.105020";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/smartparens-1.11.0.0.20250612.105020.tar";
        sha256 = "1cdicjah7mbkcg43zm5la75zb7cgg15gxf9178zhd2qd71gqfl8m";
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
      version = "2.0.4.0.20250222.142943";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/solarized-theme-2.0.4.0.20250222.142943.tar";
        sha256 = "0m8wxvm9a501w4pfc1an4i99h0wv6hpfk1yizh8yjw0y3y8fz606";
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
      version = "0.2.0.20250613.211345";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spacemacs-theme-0.2.0.20250613.211345.tar";
        sha256 = "0a2rf7kdwjnz8y90018f3ajmy9pd1iz5aq36s74l10fzd08ccqpj";
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
      version = "0.3.0.20250712.131907";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/spell-fu-0.3.0.20250712.131907.tar";
        sha256 = "1v9ahhwapqg4a7v82ipx2rcfk9ibrbrsapqk3b3md552j4fdrwzp";
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
      version = "1.2.25.0.20250128.122549";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/subed-1.2.25.0.20250128.122549.tar";
        sha256 = "0h53z43vxyn03sa621ajig637akyjijbby3nrkjibhz47gc2nyyn";
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
      seq,
    }:
    elpaBuild {
      pname = "swift-mode";
      ename = "swift-mode";
      version = "9.4.0.0.20250615.100102";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/swift-mode-9.4.0.0.20250615.100102.tar";
        sha256 = "13b7vbkhb8zw4x3inpfpdhaakgvp6msm1p377dmhpjddz3ngf3l5";
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
      version = "0.7.0.20250206.81229";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tp-0.7.0.20250206.81229.tar";
        sha256 = "14zhky7jf0afmsxrhkyvgzqh4k2yf1p829j77ryw741swj75z3av";
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
      version = "0.2.1.0.20250816.45809";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/treesit-fold-0.2.1.0.20250816.45809.tar";
        sha256 = "03j1lcrsx14qm4m7k6h56aka7r94gzp7c97jpm404fwnn9zdrib8";
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
      version = "3.0.2snapshot0.20250227.215734";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/tuareg-3.0.2snapshot0.20250227.215734.tar";
        sha256 = "1ngkjn7dr2k61w5vv8qjgjj8wwc9674px7w1hc8539f7nplf7i71";
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
      version = "0.4.0.20250118.205614";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/typescript-mode-0.4.0.20250118.205614.tar";
        sha256 = "0aj776mj89brr0210ilwiaj40x834a1r39fg9f4gy3a7immkpisd";
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
      version = "0.12.2.0.20250807.11325";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/typst-ts-mode-0.12.2.0.20250807.11325.tar";
        sha256 = "1j28vzijhn7aqr3h8pjslixbz38j97zgvx3f86myi2ag5l8k615g";
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
      version = "0.5.0.20250611.233145";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-0.5.0.20250611.233145.tar";
        sha256 = "043c0lswp9684naqka6j3jmqygrki2ylr4q7b3x8r8bi9xmdspb0";
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
      version = "0.7.0.20250611.33234";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/undo-fu-session-0.7.0.20250611.33234.tar";
        sha256 = "0nzm5y4diim3di2kyaxamgbibni0vrd59d92f3fi7wyxcwb0v8dw";
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
      version = "2.6.3.0.20250505.230743";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/visual-fill-column-2.6.3.0.20250505.230743.tar";
        sha256 = "1cl39911k73cz5qbllyy82jw7hhbd6dly3s4p0kfnmav461b3qcp";
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
      version = "8.3.0snapshot0.20250629.80737";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/vm-8.3.0snapshot0.20250629.80737.tar";
        sha256 = "0vv7chilnsrig15asv0iy916vmvksbyhxasvlldykq9z3w4r6abi";
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
      version = "17.3.21.0.20250714.65721";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/web-mode-17.3.21.0.20250714.65721.tar";
        sha256 = "0v4jcv0lcm4gds8m086f79wpbd0d64i0y1cf8z5rvrx8psf93wpc";
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
      version = "3.4.5.0.20250811.205345";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/with-editor-3.4.5.0.20250811.205345.tar";
        sha256 = "0y4gm4dw0nwcq7m2n68ysk4sqrr2bbn4m8skgl6m66iag9av58j0";
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
      version = "28.4.20250825201039.0.20250825.201812";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xah-fly-keys-28.4.20250825201039.0.20250825.201812.tar";
        sha256 = "12z8ygjsyw1faa3b2j9s0fsnkil5rzik35k3k4dwyvzvdrmm8m5n";
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
      version = "1.6.17.0.20250812.100619";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/xml-rpc-1.6.17.0.20250812.100619.tar";
        sha256 = "0l4amp36zazwgnm7gvlyqfqjycj3c9vbdr1hdhf8jxyrikr9p12a";
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
      version = "1.0.0.20250808.81958";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/yasnippet-snippets-1.0.0.20250808.81958.tar";
        sha256 = "067jidwz1xn13fxcnwdrh0bnr93bndwjs1yznn483xdw9fcgyz05";
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
      version = "2.9.0snapshot0.20250213.141810";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zenburn-theme-2.9.0snapshot0.20250213.141810.tar";
        sha256 = "165sy1df0cil2m63nnsxnmvvp7v2yh31lxzpdbzz6vwx6br4nl84";
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
      version = "0.0.8.0.20250812.82048";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu-devel/zig-mode-0.0.8.0.20250812.82048.tar";
        sha256 = "0wdcd7v40zgzh5zh5y17vzkwh028grzq93w65hhr42qq2g85rqy8";
      };
      packageRequires = [ reformatter ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu-devel/zig-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
