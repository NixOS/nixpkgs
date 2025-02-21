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
      version = "0.7.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/adoc-mode-0.7.0.tar";
        sha256 = "1gdjgybpbw3qj9mfmq9ljx4xaam1f6rwyrav2y2f5fpv6z7w0i61";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/adoc-mode.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/afternoon-theme-0.1.tar";
        sha256 = "0xxvr3njpbdlm8iyyklwijjaysyknwpw51hq2443wq37bsxciils";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/afternoon-theme.html";
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
      version = "0.10";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/alect-themes-0.10.tar";
        sha256 = "0pagkf0bb85sr3mvg8z6h6akb9hjmvfqmpiaiz121ys0r92m6nb7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/alect-themes.html";
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
      version = "0.3.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/ample-theme-0.3.0.tar";
        sha256 = "12z8z6da1xfc642w2wc82sjlfj3ymlz3jwrg3ydc2fapis2d3ibi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/ample-theme.html";
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
      version = "2.2.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/annotate-2.2.2.tar";
        sha256 = "0hrb7kjzhgy46hxaa77rv5ilsdsv6zxpawnkx4viw5jq0v5s4fl6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/annotate.html";
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
      version = "2.5.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/anti-zenburn-theme-2.5.1.tar";
        sha256 = "121038d6mjdfis1c5v9277bd6kz656n0c25daxq85mfswvjlar0i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/anti-zenburn-theme.html";
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
      version = "0.64";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/anzu-0.64.tar";
        sha256 = "0mv4xiy3481d5r4rypmw7nn1hjmsvlfz5dhgmpn6cqbpzkgb6zjb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/anzu.html";
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
      version = "2.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/apache-mode-2.2.0.tar";
        sha256 = "10fgbgww7j60dik7b7mvnm1zwgv9y8p5wzggkrdk50dv3gjfxg8f";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/apache-mode.html";
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
      version = "0.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/apropospriate-theme-0.2.0.tar";
        sha256 = "1hsv26iqr0g6c3gy1df2qkd3ilwq6xaa89ch7pqh64737qrlw9db";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/apropospriate-theme.html";
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
      version = "1.3.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/arduino-mode-1.3.1.tar";
        sha256 = "1k42qx7kgm8svv70czzlkmm3c7cddf93bqvf6267hbkaihhyd21y";
      };
      packageRequires = [ spinner ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/arduino-mode.html";
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
      version = "2.1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/auto-dim-other-buffers-2.1.1.tar";
        sha256 = "0rgf0q66kdw9ind5bi01ydk84rclcd3kmlfzm9rfb429xnhqfzw8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/auto-dim-other-buffers.html";
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
      version = "0.2.18";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/autothemer-0.2.18.tar";
        sha256 = "1v6si9fh3rbka72r5jfd35bbvfbfaxr2kfi7jmsgj07fhx4bgl2d";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/autothemer.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/base32-1.0.tar";
        sha256 = "1k1n0zlks9dammpmr0875xh5vw5prmc7rr5kwd262xidscj19k6w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/base32.html";
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
      version = "3.1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/bash-completion-3.1.1.tar";
        sha256 = "1yc1a5cvmnp8dranrglpd7qjg35r6x4ndniinbmzinqr7dmydh62";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/bash-completion.html";
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
      version = "0.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/beancount-0.9.tar";
        sha256 = "1s0w17mq8kilkrd33pan78px6mz5z96d7gvdmy2shg3hvj1jbq09";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/beancount.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/better-jumper-1.0.1.tar";
        sha256 = "1jdmbp1jjip8vmmc66z2wgx95lzp1b92m66p160mdm4g3skl64c2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/better-jumper.html";
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
      version = "1.1.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/bind-map-1.1.2.tar";
        sha256 = "037xk912hx00ia62h6kdfa56g44dhd0628va22znxg251izvnqxq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/bind-map.html";
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
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/bison-mode-0.4.tar";
        sha256 = "0k0h96bpcndi3m9fdk74j0ynm50n6by508mv3ds9ala26dpdr7qa";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/bison-mode.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/blow-1.0.tar";
        sha256 = "009x0y86692ccj2v0cizr40ly6xdp72bnwj5pjayg3y0ph4iz0cj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/blow.html";
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
      version = "0.0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/blueprint-ts-mode-0.0.3.tar";
        sha256 = "0v1sk80dka2gdkwcbria12ih3jrna3866ngdswcskyqcnkxm7b7n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/blueprint-ts-mode.html";
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
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/boxquote-2.3.tar";
        sha256 = "0fsvfy5b4k0h6fxmvvdngxap5pfypm8iik0m1jq70za7n7g8qvmy";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/boxquote.html";
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
      version = "1.35";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/buttercup-1.35.tar";
        sha256 = "0b9dxbn7pni2203xdg289ymkmhf458898i2lh7aplppmh68bms2c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/buttercup.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/camera-0.3.tar";
        sha256 = "0r9b20li82qcc141p4blyaj0xng5f4xrghhl09wc15ffi0cmbq7d";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/camera.html";
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
      version = "4.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/caml-4.9.tar";
        sha256 = "1xzk83bds4d23rk170n975mijlmin5dh7crfc5swwvzh8w88qxmk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/caml.html";
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
      version = "4.18.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/cdlatex-4.18.4.tar";
        sha256 = "174i72z3pyxsbagqk7g8d84282fh3y3ipv0bcghrgqjznxdjx427";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/cdlatex.html";
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
      version = "1.15.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/cider-1.15.1.tar";
        sha256 = "0qfh98hrlxpr71jqgsghmv687sp90iaffcgb7q5candcq8dscfb6";
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
        homepage = "https://elpa.nongnu.org/nongnu/cider.html";
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
      version = "5.19.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/clojure-mode-5.19.0.tar";
        sha256 = "10dpdi4yc7bbga2mllk46jfy58ppj8vlhs37zd9vlk9rnfc54r99";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/clojure-mode.html";
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
      version = "0.2.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/clojure-ts-mode-0.2.2.tar";
        sha256 = "14s3gawx2lazzd5ziz2plhl6k1qik8gfjka7fijgxb55ls9bvgrp";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/clojure-ts-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  coffee-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "coffee-mode";
      ename = "coffee-mode";
      version = "0.6.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/coffee-mode-0.6.3.tar";
        sha256 = "1anywqp2b99dmilfnajxgf4msc0viw6ndl0lxpgaa7d2b3mzx9nq";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/coffee-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  color-theme-tangotango = callPackage (
    {
      color-theme,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "color-theme-tangotango";
      ename = "color-theme-tangotango";
      version = "0.0.6";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/color-theme-tangotango-0.0.6.tar";
        sha256 = "0lfr3xg9xvfjb12kcw80d35a1ayn4f5w1dkd2b0kx0wxkq0bykim";
      };
      packageRequires = [ color-theme ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/color-theme-tangotango.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/consult-flycheck-1.0.tar";
        sha256 = "17kc7v50zq69l4803nh8sjnqwi59p09wjzqkwka6g4dapya3h2xy";
      };
      packageRequires = [
        consult
        flycheck
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/consult-flycheck.html";
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
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/corfu-terminal-0.7.tar";
        sha256 = "0a41hfma4iiinq2cgvwqqwxhrwjn5c7igl5sgvgx0mbjki2n6sll";
      };
      packageRequires = [
        corfu
        popon
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/corfu-terminal.html";
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
      version = "0.5.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/crux-0.5.0.tar";
        sha256 = "0cykjwwhl6r02fsyam4vnmlxiyq8b8qsgncb1hjnz4gj7mxc9gg4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/crux.html";
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
      version = "1.5.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/csv2ledger-1.5.4.tar";
        sha256 = "1h935g97fjrs1q0yz0q071zp91bhsb3yg13zqpp8il5gif20qqls";
      };
      packageRequires = [ csv-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/csv2ledger.html";
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
      version = "1.22";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/cyberpunk-theme-1.22.tar";
        sha256 = "1kgkgpb07d4kh2rf88pfgyji42qv80443i67nzha2fx01zbd5swb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/cyberpunk-theme.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/cycle-at-point-0.2.tar";
        sha256 = "1q3gylksr754s0pl8x1hdk0q4p0vz6lnasswgsqpx44nmnbsrw6z";
      };
      packageRequires = [ recomplete ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/cycle-at-point.html";
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
      version = "202408131340";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/d-mode-202408131340.tar";
        sha256 = "19dgc0yd2fmc9xbrajc1l98p7p2wiwg43ajq4gssxdshb5vi5mn9";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/d-mode.html";
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
      version = "1.0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/dart-mode-1.0.7.tar";
        sha256 = "1k9pn7nqskz39m3zwi9jhd1a2q440jgrla1a37qip73mwrdril1i";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/dart-mode.html";
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
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/denote-refs-0.1.2.tar";
        sha256 = "0jq14adxpx9bxddkj3a4bahyr3yarjn85iplhhy9yk7k9wy7wis0";
      };
      packageRequires = [ denote ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/denote-refs.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/devhelp-1.0.tar";
        sha256 = "14x1990yr3qqzv9dqn7xg69hqgpmgjsi68f2fg07v670lk7hs8xb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/devhelp.html";
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
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/devil-0.6.0.tar";
        sha256 = "01n552pvr598igmd2q6w9kgjrwgzrgrb4w59mxpsylcv6wy2v2h5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/devil.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/diff-ansi-0.2.tar";
        sha256 = "0i1216mw0zgy3jdhhxsn5wpjqgxv5als1lljb1ddqjl21y6z74nw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/diff-ansi.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/doc-show-inline-0.1.tar";
        sha256 = "13y7k4zp8x8fcyidw0jy6zf92af660zwb7qpps91l2dh7zwjsl2v";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/doc-show-inline.html";
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
      version = "1.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/dockerfile-mode-1.7.tar";
        sha256 = "1rpgjhbb2vzz6fqcqksvx27a1mj8p3bgmjh00433qd8g7hghc9v7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/dockerfile-mode.html";
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
      version = "1.8.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/dracula-theme-1.8.2.tar";
        sha256 = "04r7cn4n8n4fiwblmfsa23d1qh11mqfz0cghq6ss72flp5awj46g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/dracula-theme.html";
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
      version = "0.8.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/drupal-mode-0.8.1.tar";
        sha256 = "0f3dd2647g964grzq95d73iznhpmrr9w7fmkifjk3ivz0rgdgjsq";
      };
      packageRequires = [ php-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/drupal-mode.html";
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
      version = "0.5.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/dslide-0.5.3.tar";
        sha256 = "11q807jp90y37s1njmr6qlnqi9pk371gj8mwg57kgjvc55qdyas5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/dslide.html";
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
      version = "0.9.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/eat-0.9.4.tar";
        sha256 = "0jn5rzyg1abjsb18brr1ha4vmhvxpkp8pxvaxfa0g0phcb2iz5ql";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/eat.html";
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
      version = "0.1.13";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/edit-indirect-0.1.13.tar";
        sha256 = "10zshywbp0f00k2d4f5bc44ynvw3f0626vl35lbah1kwmgzrrjdd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/edit-indirect.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  editorconfig = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
      nadvice,
    }:
    elpaBuild {
      pname = "editorconfig";
      ename = "editorconfig";
      version = "0.11.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/editorconfig-0.11.0.tar";
        sha256 = "0adzm6fhx5vgg20qy9f7cqpnx938mp1ls91y5cw71pjm9ihs2cyv";
      };
      packageRequires = [ nadvice ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/editorconfig.html";
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
      version = "2.5.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/elixir-mode-2.5.0.tar";
        sha256 = "1x6aral441mv9443h21lnaymbpazwii22wcqvk2jfqjmyl1xj1yz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/elixir-mode.html";
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
      version = "3.6.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/elpher-3.6.2.tar";
        sha256 = "168cyhkp2q57k26r961c3g521qf8gj2b5rl8k1fg4z60y63s1rpk";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/elpher.html";
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
      version = "4.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/emacsql-4.0.1.tar";
        sha256 = "0098ixlx70vx4mxlcyddkij9aj4sgcf7p699cii0pz51lg9bymc0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/emacsql.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  engine-mode = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "engine-mode";
      ename = "engine-mode";
      version = "2.2.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/engine-mode-2.2.4.tar";
        sha256 = "0gp1mnf0yaq4w91pj989dzlxpbpcqqj0yls23wf2ly53kbaarzv9";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/engine-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  evil = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "evil";
      ename = "evil";
      version = "1.15.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-1.15.0.tar";
        sha256 = "0ciglddlq0z91jyggp86d9g3gwfzjp55xhldqpxpq39a2xkwqh0q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-anzu-0.2.tar";
        sha256 = "1vn61aj0bnvkj2l3cd8m8q3n7kn09hdp6d13wc58w9pw8nrg0vq5";
      };
      packageRequires = [
        anzu
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-anzu.html";
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
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-args-1.1.tar";
        sha256 = "0fv30wny2f4mg8l9jrjgxisz6nbmn84980yszbrcbkqi81dzzlyi";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-args.html";
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
      version = "3.16";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-escape-3.16.tar";
        sha256 = "0vv6k3zaaw4ckk6qjiw1n41815w1g4qgy2hfgsj1vm7xc9i9zjzp";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-escape.html";
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
      version = "0.41";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-exchange-0.41.tar";
        sha256 = "1yk7zdxl7c8c2ic37l0rsaynnpcrhdbblk2frl5m8phf54g82d8i";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-exchange.html";
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
      version = "0.0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-goggles-0.0.2.tar";
        sha256 = "0nipk8r7l5c50n9zry5264cfilx730l68ssldw3hyj14ybdf6dch";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-goggles.html";
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
      version = "1.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-iedit-state-1.3.tar";
        sha256 = "1955bci018rpbdvixlw0gxay10g0vgg2xwsfmfyxcblk5glrv5cp";
      };
      packageRequires = [
        evil
        iedit
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-iedit-state.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-indent-plus-1.0.1.tar";
        sha256 = "1kzlvi8xgfxy26w1m31nyh6vrq787vchkmk4r1xaphk9wn9bw1pq";
      };
      packageRequires = [
        cl-lib
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-indent-plus.html";
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
      version = "8.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-lisp-state-8.2.tar";
        sha256 = "14v1nv797b4rxxxnvzwy6pp10g3mmvifb919iv7nx96sbn919w0p";
      };
      packageRequires = [
        bind-map
        evil
        smartparens
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-lisp-state.html";
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
      version = "3.0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-matchit-3.0.4.tar";
        sha256 = "1ib2xlz7ciaszw2j5184mf6560jmap93vh515sk8dmkkahdwsjgz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-matchit.html";
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
      version = "3.6.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-nerd-commenter-3.6.1.tar";
        sha256 = "1nzqwqp2gq3wka2x782yqz5d8bw3wglra42907kylkqwqbxryh0w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-nerd-commenter.html";
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
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-numbers-0.7.tar";
        sha256 = "1k5vrh8bj9kldqq8kxn1qi3k82i7k4v4h6nkk9hng8p90zhac02i";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-numbers.html";
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
      version = "1.0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-surround-1.0.4.tar";
        sha256 = "1fzhqg2zrfl1yvhf96s5m0b9793cysciqbxiihxzrnnf2rnrlls2";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-surround.html";
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
      version = "0.0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-visual-mark-mode-0.0.5.tar";
        sha256 = "0hjg9jmyhhc6a6zzjicwy62m9bh7wlw6hc4cf2g6g416c0ri2d18";
      };
      packageRequires = [
        dash
        evil
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-visual-mark-mode.html";
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
      version = "0.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/evil-visualstar-0.2.0.tar";
        sha256 = "03liavxxpawvlgwdsihzz3z08yv227zjjqyll1cbmbk0678kbl7m";
      };
      packageRequires = [ evil ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/evil-visualstar.html";
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
      version = "2.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/exec-path-from-shell-2.2.tar";
        sha256 = "14nzk04aypqminpqs181nh3di23nnw64z0ir940ajs9bx5pv9s1w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/exec-path-from-shell.html";
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
      version = "0.6.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flx-0.6.2.tar";
        sha256 = "00d3q238grxcvnx6pshb7ajbz559gfp00pqaq56r2n5xqrvrxfnc";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flx.html";
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
      version = "0.6.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flx-ido-0.6.2.tar";
        sha256 = "1933d3dcwynzs5qnv3pl4xdybj5gg0sa8zb58j0ld9hyiacm6zn5";
      };
      packageRequires = [
        cl-lib
        flx
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flx-ido.html";
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
      version = "34.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flycheck-34.1.tar";
        sha256 = "1jj1c4gq39ik8fihsz13wp4c26fm2m6kyr7ir22ql0d007zm3173";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flycheck.html";
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
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flymake-guile-0.5.tar";
        sha256 = "0gfblb49l52j7iq3y6fxx1jpr72z61pwxsxfknvfi4y05znxnf0k";
      };
      packageRequires = [ flymake ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flymake-guile.html";
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
      version = "0.1.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flymake-kondor-0.1.3.tar";
        sha256 = "0y5qnlk3q0fjch12d4vwni7v6rk0h5056s5lzjgns71x36xd1i21";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flymake-kondor.html";
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
      version = "0.5.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/flymake-popon-0.5.1.tar";
        sha256 = "0a9p0mnp1n4znb9xgi5ldjv8x1khhdr5idb8vcd444nd03q0lj6s";
      };
      packageRequires = [
        flymake
        popon
        posframe
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/flymake-popon.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/focus-1.0.1.tar";
        sha256 = "164xlxc5x2i955rfjdhlxp5ch55bh79gr7mzfychkjx0x088hcaa";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/focus.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  forth-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "forth-mode";
      ename = "forth-mode";
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/forth-mode-0.2.tar";
        sha256 = "04xcvjzvl4pgx48l2pzil7s2iqqbf86z57wv76ahp4sd1xigpfqc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/forth-mode.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/free-keys-1.0.tar";
        sha256 = "04x4hmia5rx6bd8pkp5b9g4mn081r14vyk1jbdygdzr5w5rhifx3";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/free-keys.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gc-buffers-1.0.tar";
        sha256 = "00204vanfabyf6cgbn64xgqhqz8mlppizsgi31xg6id1qgrj37p3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gc-buffers.html";
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
      version = "0.31";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-0.31.tar";
        sha256 = "0szyasza76ak4qny9v9i3sk1m3mahlxcvvsk078q8rp9cms5lzkv";
      };
      packageRequires = [ project ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser.html";
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
      version = "0.18";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-chez-0.18.tar";
        sha256 = "14l2a7njx3bzxj1qpc1m5mx4prm3ixgsiii3k484brbn4vim4j58";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-chez.html";
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
      version = "0.17";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-chibi-0.17.tar";
        sha256 = "17kkgs0z2xwbbwn7s49lnha6pmri1h7jnnhh5qvxif5xyvyy8bih";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-chibi.html";
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
      version = "0.17";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-chicken-0.17.tar";
        sha256 = "1l0x0b5gcmc6v2gd2jhrz4zz2630rggq8w7ffzhsf8b8hr4d1ixy";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-chicken.html";
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
      version = "0.18.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-gambit-0.18.1.tar";
        sha256 = "1pqify8vqxzpm202zz9q92hp65yhs624z6qc2hgp9c1zms56jkqs";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-gambit.html";
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
      version = "0.0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-gauche-0.0.2.tar";
        sha256 = "189addy5xvx62j91ihi23i8dh5msm0wlwxyi8n07f4m2garrn14l";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-gauche.html";
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
      version = "0.28.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-guile-0.28.2.tar";
        sha256 = "02s44dj6cr6fmiby6yljil7cgp00h31h3fs1a428lr3v51z1i38m";
      };
      packageRequires = [
        geiser
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-guile.html";
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
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-kawa-0.0.1.tar";
        sha256 = "1qh4qr406ahk4k8g46nzkiic1fidhni0a5zv4i84cdypv1c4473p";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-kawa.html";
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
      version = "0.15";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-mit-0.15.tar";
        sha256 = "12wimv5x2k64ww9x147dlx2gfygmgz96hqcdhkbidi1smhfz11gk";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-mit.html";
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
      version = "0.16";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-racket-0.16.tar";
        sha256 = "08sn32ams88ism6k24kq7s54vrdblkn15x9lldyqg4zapbllr1ny";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-racket.html";
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
      version = "1.8";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/geiser-stklos-1.8.tar";
        sha256 = "1525n49igcnwr2wsjv4a74yk1gbjvv1l9rmkcpafyxyykvi94j6s";
      };
      packageRequires = [ geiser ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/geiser-stklos.html";
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
      version = "4.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/git-commit-4.0.0.tar";
        sha256 = "10fh8i3l07qxsfw23q2mkb7rxgc7n2chirzdjd9bnlqrxybrayli";
      };
      packageRequires = [
        compat
        seq
        transient
        with-editor
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/git-commit.html";
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
      version = "1.4.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/git-modes-1.4.4.tar";
        sha256 = "161n8anh3i7aj9995nry879kkfvawm1dkzlxdqfwmzl85g8yqx58";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/git-modes.html";
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
      version = "0.4.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gnosis-0.4.1.tar";
        sha256 = "1iqpssf3gxv54gig718529y3cfjybvvjcvndzhjsiyw5b33pkbby";
      };
      packageRequires = [
        compat
        emacsql
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gnosis.html";
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
      version = "1.5.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gnu-apl-mode-1.5.1.tar";
        sha256 = "0hzdmrhrcnq49cklpmbx1sq7d9qd2q6pprgshhhjx45mnn1q24v0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gnu-apl-mode.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gnu-indent-1.0.tar";
        sha256 = "1aj8si93ig1qbdqgq3f4jwnsws63drkfwfzxlq0i3qqfhsni0a15";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gnu-indent.html";
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
      version = "0.8.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gnuplot-0.8.1.tar";
        sha256 = "1y364j5gr8cnkndxd088kaxd2ah0nd7176gfjligm3ngpgg6ndyx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gnuplot.html";
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
      version = "1.6.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/go-mode-1.6.0.tar";
        sha256 = "0ilvkl7iv47v0xyha07gfyv1a4c50ifw57bp7rx8ai77v30f3a2a";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/go-mode.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/golden-ratio-1.0.1.tar";
        sha256 = "169jl82906k03vifks0zs4sk5gcxax5jii6nysh6y6ns2h656cqx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/golden-ratio.html";
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
      version = "1.1.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gotham-theme-1.1.9.tar";
        sha256 = "195r8idq2ak6wpmgifpgvx52hljb8i7p9wx6ii1kh0baaqk31qq2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gotham-theme.html";
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
      version = "1.7.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/goto-chg-1.7.5.tar";
        sha256 = "1j5vk8vc1v865fc8gdy0p5lpp2kkl0yn9f75npiva3ay6mwvnvay";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/goto-chg.html";
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
      version = "0.9.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gptel-0.9.0.tar";
        sha256 = "1crcng1h6i64h6l3pha96k3hy2hga73pp0wy4i9gdrc1ra0dbjf4";
      };
      packageRequires = [
        compat
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gptel.html";
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
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/graphql-mode-1.0.0.tar";
        sha256 = "0pfyznfndc8g2g3a3pxzcjsh3cah3amhz5124flrja5fqdgdmpjz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/graphql-mode.html";
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
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gruber-darker-theme-0.7.tar";
        sha256 = "1ib9ad120g39fbkj41am6khglv1p6g3a9hk2jj2kl0c6czr1il2r";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gruber-darker-theme.html";
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
      version = "1.30.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/gruvbox-theme-1.30.1.tar";
        sha256 = "1y30aahdxzdfmj021vbrz4zmdq6lr9k08hna9i1a8g4cywgbz8ri";
      };
      packageRequires = [ autothemer ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/gruvbox-theme.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/guru-mode-1.0.tar";
        sha256 = "0kmbllzvp8qzj8ck2azq2wfw66ywc80zicncja62bi6zsh2l622z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/guru-mode.html";
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
      version = "3.2.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/haml-mode-3.2.1.tar";
        sha256 = "0hhra7bryk3n649s3byzq6vv5ywd4bqkfppya7bswqkj3bakiyil";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/haml-mode.html";
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
      version = "17.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/haskell-mode-17.5.tar";
        sha256 = "1yjy0cvgs5cnq5d9sv24p1p66z83r9rhbgn0nsccc12rn2gm3hyn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/haskell-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  haskell-tng-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "haskell-tng-mode";
      ename = "haskell-tng-mode";
      version = "0.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/haskell-tng-mode-0.0.1.tar";
        sha256 = "0l6rs93322la2fn8wyvxshl6f967ngamw2m1hnm2j6hvmqph5cpj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/haskell-tng-mode.html";
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
      version = "3.9.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/helm-3.9.9.tar";
        sha256 = "1k3jq2miivj881h0mpl68zgd229kj50axynsgxizdddg56nfsdm0";
      };
      packageRequires = [
        helm-core
        wfnames
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/helm.html";
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
      version = "3.9.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/helm-core-3.9.9.tar";
        sha256 = "067x4g19w032671545bfah4262xyhgnwxkaw8pdk4fqd5znw0yck";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/helm-core.html";
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
      version = "0.8";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/hideshowvis-0.8.tar";
        sha256 = "0xx2jjv95r1nhlf729y0zplfpjlh46nfnixmd3f5jc3z2pc6zf5b";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/hideshowvis.html";
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
      version = "2.2.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/highlight-parentheses-2.2.2.tar";
        sha256 = "13686dkgpn30di3kkc60l3dhrrjdknqkmvgjnl97mrbikxfma7w2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/highlight-parentheses.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/hl-block-mode-0.2.tar";
        sha256 = "0anv7bvrwylp504l3g42jcbcfmibv9jzs2kbkny46xd9vfb3kyrl";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/hl-block-mode.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/hl-column-1.0.tar";
        sha256 = "11d7xplpjx0b6ppcjv4giazrla1qcaaf2i6s5g0j5zxb1m60kkfz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/hl-column.html";
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
      version = "1.56";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/htmlize-1.56.tar";
        sha256 = "0s4k5q8b4grx3zyrryxcqahixkpzcni2qqnmm07axfxpgcqcnk9c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/htmlize.html";
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
      persist,
      plz,
      taxy-magit-section,
      transient,
    }:
    elpaBuild {
      pname = "hyperdrive";
      ename = "hyperdrive";
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/hyperdrive-0.3.tar";
        sha256 = "03r5qx3a0w1ll4ql7nrjgp19cnk7rrf7ibvj8gd57gqqihkdmqqw";
      };
      packageRequires = [
        compat
        map
        persist
        plz
        taxy-magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/hyperdrive.html";
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
      version = "1.1.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/idle-highlight-mode-1.1.4.tar";
        sha256 = "0vp45ww8bxacrwzv0jqzs782symxysmpvawd29pa1yci1qp2pvm5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/idle-highlight-mode.html";
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
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/idris-mode-1.1.0.tar";
        sha256 = "1vlm7gshrkwp9lfm5jcp1rnsjxwzqknrjhl3q5ifwmicyvqkqwsv";
      };
      packageRequires = [
        cl-lib
        prop-menu
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/idris-mode.html";
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
      version = "0.9.9.9.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/iedit-0.9.9.9.9.tar";
        sha256 = "12s71yj8ycrls2fl97qs3igk5y06ksbmfq2idz0a2zrdggndg0b6";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/iedit.html";
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
      version = "3.2.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/inf-clojure-3.2.1.tar";
        sha256 = "1pvngj87hqr0qzc62cgq294rllxbmn7803pnqqr8ah1qxy65a1wb";
      };
      packageRequires = [ clojure-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/inf-clojure.html";
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
      version = "2.8.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/inf-ruby-2.8.1.tar";
        sha256 = "1iisxgrw7lkrcl86mj3s3578qxnx1cn615swsmnch2ilwjqdrdza";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/inf-ruby.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/inkpot-theme-0.1.tar";
        sha256 = "0ik7vkwqlsgxmdckd154kh82zg8jr41vwc0a200x9920l5mnfjq2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/inkpot-theme.html";
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
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/iwindow-1.1.tar";
        sha256 = "04d5dxqazxfx8ap9vmhj643x7lmpa0wmzcm9w9mlvsk2kaz0j19i";
      };
      packageRequires = [
        compat
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/iwindow.html";
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
      version = "2.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/j-mode-2.0.1.tar";
        sha256 = "0kk29s3xqad72jxvzzbl4b4z8b4l7xx1vyfcbsj8ns8hv8cip3l3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/j-mode.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/jade-mode-1.0.1.tar";
        sha256 = "0pv0n9vharda92avggd91q8i98yjim9ccnz5m5c5xw12hxcsfj17";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/jade-mode.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/jinja2-mode-0.3.tar";
        sha256 = "0dg1zn7mghclnxsmcl5nq5jqibm18sja23058q9lk6nph4fvz5dq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/jinja2-mode.html";
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
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/julia-mode-0.4.tar";
        sha256 = "15x63nwq6rh1yxwwd8hf0a8nznws8gzxqiw45n6pv8vp8h2v3fsi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/julia-mode.html";
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
      version = "1.4.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/keycast-1.4.1.tar";
        sha256 = "0xpdz6fqvmx6ha20c957r4psz393r0ag7ml971x21v035r3gfx8r";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/keycast.html";
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
      version = "2.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/kotlin-mode-2.0.0.tar";
        sha256 = "0d247kxbrhkbmgldmalywmx6fqiz35ifvjbv20lyrmnbyhx1zr97";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/kotlin-mode.html";
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
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/lorem-ipsum-0.4.tar";
        sha256 = "0d1c6zalnqhyn88dbbi8wqzvp0ppswhqv656hbj129jwp4iida4x";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/lorem-ipsum.html";
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
      version = "20221027";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/lua-mode-20221027.tar";
        sha256 = "0mg4fjprrcwqfrzxh6wpl92r3ywpj3586444c6yvq1rs56z5wvj5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/lua-mode.html";
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
      version = "0.9.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/macrostep-0.9.4.tar";
        sha256 = "01n3qhxfjd9vg93ddrhnm275v24ih5qczkphc232m0csswxghpdk";
      };
      packageRequires = [
        cl-lib
        compat
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/macrostep.html";
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
      git-commit,
      lib,
      magit-section,
      seq,
      transient,
      with-editor,
    }:
    elpaBuild {
      pname = "magit";
      ename = "magit";
      version = "4.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/magit-4.0.0.tar";
        sha256 = "0sii8gr69j29fzvcdyabnabldkvi6r5dpiamfs3bsmh66vf8wvjh";
      };
      packageRequires = [
        compat
        dash
        git-commit
        magit-section
        seq
        transient
        with-editor
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/magit.html";
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
      version = "4.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/magit-section-4.0.0.tar";
        sha256 = "1dyw275qfnpz7fs1s952b9fl9vgfzfk8aiclznfhhl43nvxxglb7";
      };
      packageRequires = [
        compat
        dash
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/magit-section.html";
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
      version = "2.6";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/markdown-mode-2.6.tar";
        sha256 = "15s8snzfvzzfk7wfizz5r8aksywq7s9h6xbb2y5dqjkpqg951va2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/markdown-mode.html";
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
    }:
    elpaBuild {
      pname = "mastodon";
      ename = "mastodon";
      version = "1.0.26";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/mastodon-1.0.26.tar";
        sha256 = "1p4nzgw8rf7zx4z17nn7bdh106qdhb54m20dkkz43wr4dgqp61bn";
      };
      packageRequires = [
        persist
        request
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/mastodon.html";
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
      version = "2015";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/material-theme-2015.tar";
        sha256 = "117ismd3p577cr59b6995byyq90zn4nd81dlf4pm8p0iiziryyji";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/material-theme.html";
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
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/mentor-0.5.tar";
        sha256 = "1sqdwdbanrdvrr8qqn23ylcyc98jcjc7yq1g1d963v8d9wfbailv";
      };
      packageRequires = [
        async
        seq
        url-scgi
        xml-rpc
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/mentor.html";
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
      version = "1.4.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/meow-1.4.5.tar";
        sha256 = "1d63mw88vq97rq3a7qhkxid2xaag5dp21ijisw9s3fk972kcks3s";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/meow.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/minibar-0.3.tar";
        sha256 = "0vxjw485bja8h3gmqmvg9541f21ricwcw6ydlhv9174as5cmwx5j";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/minibar.html";
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
      version = "1.0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/moe-theme-1.0.2.tar";
        sha256 = "13c4rj0c9fi4nipzsrmvgb8ddvk3dckijga07yxp71x5ba6mrp2n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/moe-theme.html";
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
      version = "3.5.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/monokai-theme-3.5.3.tar";
        sha256 = "14ylizbhfj2hlc52gi2fs70avz39s46wnr96dbbq4l8vmhxs7il5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/monokai-theme.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  mpv = callPackage (
    {
      cl-lib ? null,
      elpaBuild,
      fetchurl,
      json ? null,
      lib,
      org,
    }:
    elpaBuild {
      pname = "mpv";
      ename = "mpv";
      version = "0.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/mpv-0.2.0.tar";
        sha256 = "183alhd5fvmlhhfm0wl7b50axs01pgiwv735c43bfzdi2ny4szcm";
      };
      packageRequires = [
        cl-lib
        json
        org
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/mpv.html";
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
      version = "1.4.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/multiple-cursors-1.4.0.tar";
        sha256 = "0452wrbwg8hyvsri99h71g04dll5w65na265pp9whphq6l06ikrx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/multiple-cursors.html";
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
      version = "1.1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/nasm-mode-1.1.1.tar";
        sha256 = "19k0gwwx2fz779yli6pcl0a7grhsbhwyisq76lmnnclw0gkf686l";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/nasm-mode.html";
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
      version = "1.1.10";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/nginx-mode-1.1.10.tar";
        sha256 = "0c6biqxbwpkrbqi639ifgv8jkfadssyznjkq6hxvqgjh3nnyrlx3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/nginx-mode.html";
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
      version = "1.5.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/nix-mode-1.5.0.tar";
        sha256 = "0hansrsyzx8j31rk45y8zs9hbfjgbv9sf3r37s2a2adz48n9k86g";
      };
      packageRequires = [
        magit-section
        transient
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/nix-mode.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/oblivion-theme-0.1.tar";
        sha256 = "0njm7znh84drqwkp4jjsr8by6q9xd65r8l7xaqahzhk78167q6s4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/oblivion-theme.html";
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
      version = "1.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/opam-switch-mode-1.7.tar";
        sha256 = "1gpc1syb51am2gkb3cgfb28rhh6ik41c1gx9gjf1h8m6zxb75433";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/opam-switch-mode.html";
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
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-auto-tangle-0.6.0.tar";
        sha256 = "1vh3k283h90v3qilyx1n30k4ny5rkry6x9s6778s0sm6f6hwdggd";
      };
      packageRequires = [ async ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-auto-tangle.html";
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
      version = "0.4.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-contrib-0.4.2.tar";
        sha256 = "1v1g359dqyq8h4y5rjhllc93dq1vysnfk23lqn3smdvdi3ba9zlr";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-contrib.html";
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
      version = "2.7.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-drill-2.7.0.tar";
        sha256 = "0118vdd0gv2ipgfljkda4388gdly45c5vg0yfn3z4p0p8mjd15lg";
      };
      packageRequires = [
        org
        persist
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-drill.html";
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
      version = "2.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-journal-2.2.0.tar";
        sha256 = "12mvi8x8rsm93s55z8ns1an00l2p545swc0gzmx38ff57m7jb1mj";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-journal.html";
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
      version = "0.3.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-mime-0.3.3.tar";
        sha256 = "1ylsdfifa4ykrf5vncnnj6v2bgc3ixlskgxb1v7qggmkb5mzy2yv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-mime.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-present-0.1.tar";
        sha256 = "18zrvrd9aih57gj14qmxv9rf5j859vkvxcni3fkdbj84y5pq2fpy";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-present.html";
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
      version = "1.5.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-superstar-1.5.1.tar";
        sha256 = "1v6v7a0frgxlywfq6g4mdl6sz448k2ql7j4j4f1wrll33mr7gx8g";
      };
      packageRequires = [ org ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-superstar.html";
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
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-transclusion-http-0.4.tar";
        sha256 = "1k57672w0dcw63dp1a6m5fc0pkm8p5la9811m16r440i7wqq0kmr";
      };
      packageRequires = [
        org-transclusion
        plz
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-transclusion-http.html";
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
      version = "2.8.22";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/org-tree-slide-2.8.22.tar";
        sha256 = "1wqc5d2nxs4s6p2ap6sdalxnyigpxini8ck6jikaarmfqcghnx2m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/org-tree-slide.html";
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
      version = "2.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/orgit-2.0.0.tar";
        sha256 = "16i702ziy5z9zrmgz55bky0nar2hy55mkllswf7pgk8x4aihlda0";
      };
      packageRequires = [
        compat
        magit
        org
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/orgit.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/p4-16-mode-0.3.tar";
        sha256 = "1kwfqs7ikfjkkpv3m440ak40mjyf493gqygmc4hac8phlf9ns6dv";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/p4-16-mode.html";
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
      version = "0.23";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/package-lint-0.23.tar";
        sha256 = "116kc7j0g2r8fzyb07b7xb767wzjqnigi504r0rb7cc93b44c4gg";
      };
      packageRequires = [ let-alist ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/package-lint.html";
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
      version = "0.1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/pacmacs-0.1.1.tar";
        sha256 = "02ahl0608xmmlkb014gqvv6f45l5lrkm3s4l6m5p5r98rwmlj3q9";
      };
      packageRequires = [ dash ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/pacmacs.html";
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
      version = "0.15";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/page-break-lines-0.15.tar";
        sha256 = "018mn6h6nmkkgv1hsk0k8fjyg38wpg2f0cvqlv9p392sapca59ay";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/page-break-lines.html";
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
      version = "26";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/paredit-26.tar";
        sha256 = "1sk8nhsysa3y8fvds67cbwwzivzxlyw8d81y7f7pqc5lflidjrpc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/paredit.html";
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
      version = "1.1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/parseclj-1.1.1.tar";
        sha256 = "0kkg5fdjbf2dm8jmirm86sjbqnzyhy72iml4qwwnshxjfhz1f0yi";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/parseclj.html";
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
      version = "1.2.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/parseedn-1.2.1.tar";
        sha256 = "0q6wkcjxwqf81pvrcjbga91lr4ml6adbhmc7j71f53awrpc980ak";
      };
      packageRequires = [
        map
        parseclj
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/parseedn.html";
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
      version = "0.1.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/pcmpl-args-0.1.3.tar";
        sha256 = "1lycckmwhp9l0pcrzx6c11iqwaw94h00334pzagkcfay7lz3hcgd";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/pcmpl-args.html";
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
      version = "1.12";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/pcre2el-1.12.tar";
        sha256 = "1p0fgqm5342698gadnvziwbvv2kxj953975sp92cx7ddcyv2xr3c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/pcre2el.html";
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
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/pdf-tools-1.1.0.tar";
        sha256 = "0shlpdy07pk9qj5a7d7yivpvgp5bh65psm0g9wkrvyhpkc93aylc";
      };
      packageRequires = [
        let-alist
        tablist
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/pdf-tools.html";
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
      version = "1.25.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/php-mode-1.25.1.tar";
        sha256 = "1cfk7nq5x2p4adcf6q9igsh2jm0sdmsaf5l2sqx4idda28vp3gwc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/php-mode.html";
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
      version = "0.13";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/popon-0.13.tar";
        sha256 = "0z0m7j30pdfw58cxxkmw5pkfpy8y1ax00wm4820rkqxz1f5sbkdb";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/popon.html";
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
      version = "0.5.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/popup-0.5.9.tar";
        sha256 = "06q31bv6nsdkdgyg6x0zzjnlq007zhqw2ssjmj44izl6h6fkr26m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/popup.html";
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
      version = "2.8.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/projectile-2.8.0.tar";
        sha256 = "05llvm3xw3dbjdnfhy2kk6z3pysrsc9f6i7dm4glw5j1k7vig306";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/projectile.html";
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
      version = "4.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/proof-general-4.5.tar";
        sha256 = "0mlmh7z93f7ypjlh6mxrxgcn47ysvi8qg8869qfxjgmskbfdvx2w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/proof-general.html";
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
      version = "0.1.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/prop-menu-0.1.2.tar";
        sha256 = "1cbps617k2nfi5jcv7y1zip4v64mi17r3rhw9w3n4r5hbl4sjwmw";
      };
      packageRequires = [ cl-lib ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/prop-menu.html";
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
      version = "1.0.20240813.124142";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/racket-mode-1.0.20240813.124142.tar";
        sha256 = "0arsrq5lp8a6s6gh2dwc4m43f7gmhrwlpgxn6xsglscpvhlrair8";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/racket-mode.html";
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
      version = "2.1.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/rainbow-delimiters-2.1.5.tar";
        sha256 = "0f4zhz92z5qk3p9ips2d76qi64xv6y8jrxh5nvbq46ivj5c0hnw2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/rainbow-delimiters.html";
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
      version = "0.2.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/raku-mode-0.2.1.tar";
        sha256 = "00iwkp4hwjdiymzbwm41m27avrn3n63hnwd9amyx0nsa0kdhrfyx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/raku-mode.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/recomplete-0.2.tar";
        sha256 = "1jhyqgww8wawrxxd2zjb7scpamkbcp98hak9qmbn6ckgzdadks64";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/recomplete.html";
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
      version = "0.8";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/reformatter-0.8.tar";
        sha256 = "0bv0fbw3ach6jgnv67xjzxdzaghqa1rhgkmfsmkkbyz8ncbybj87";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/reformatter.html";
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
      version = "0.3.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/request-0.3.3.tar";
        sha256 = "02j24v8jdjsvi3v3asydb1zfiarzaxrpsshvgf62nhgk6x08845z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/request.html";
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
      version = "1.4.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/rfc-mode-1.4.2.tar";
        sha256 = "0lhs8wa4sr387xyibqqskkqgyhhhy48qp5wbjs8r5p68j1s1q86m";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/rfc-mode.html";
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
      version = "0.6.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/rubocop-0.6.0.tar";
        sha256 = "026cna402hg9lsrf88kmb2as667fgaianj2qd3ik9y89ps4xyzxf";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/rubocop.html";
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
      version = "1.0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/rust-mode-1.0.5.tar";
        sha256 = "1cilbf4yw4723bn1vh9ww79875fxh0r1j2c7wxjqfjk5xnx4s6q4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/rust-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  sass-mode = callPackage (
    {
      elpaBuild,
      fetchurl,
      haml-mode,
      lib,
    }:
    elpaBuild {
      pname = "sass-mode";
      ename = "sass-mode";
      version = "3.0.16";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/sass-mode-3.0.16.tar";
        sha256 = "0ag7qi9dq4j23ywbwni7pblp6l1ik95vjhclxm82s1911a8m7pj2";
      };
      packageRequires = [ haml-mode ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/sass-mode.html";
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
      version = "94.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/scad-mode-94.0.tar";
        sha256 = "1cqai7qb9m17rf7llkn9vbxddgn0ixcf3dbnsjk1aflvj8mq9nr3";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/scad-mode.html";
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
      version = "1.1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/scala-mode-1.1.0.tar";
        sha256 = "1x3vw4fzy1z6gavnbsm4lnwzkp47zd8gasvxxvfk57qn09hpwixh";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/scala-mode.html";
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
      version = "0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/scroll-on-drag-0.1.tar";
        sha256 = "0ga8w9px2x9a2ams0lm7ganbixylgpx8g2m3jrwfih0ib3z26kqc";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/scroll-on-drag.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/scroll-on-jump-0.2.tar";
        sha256 = "1gg5lpr21v9bjzjy33j8ziyhh5a1sad509c7rjkdlqda2z3xfrhr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/scroll-on-jump.html";
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
      version = "0.3.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/sesman-0.3.2.tar";
        sha256 = "1mrv32cp87dhzpcv55v4zv4nq37lrsprsdhhjb2q0msqab3b0r31";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/sesman.html";
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
      version = "0.1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/shellcop-0.1.0.tar";
        sha256 = "1gj178fm0jj8dbfy0crwcjidih4r6g9dl9lprzpxzgswvma32g0w";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/shellcop.html";
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
      version = "2.30";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/slime-2.30.tar";
        sha256 = "0gzgwrx6llj35kga21m3m4vp0g7f7dypim7pdnhy9sxrvl0k8v5f";
      };
      packageRequires = [ macrostep ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/slime.html";
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
      version = "1.0.43";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/sly-1.0.43.tar";
        sha256 = "1c7kzbpcrij4z09bxfa1rq5w23jw9h8v4s6fa6ihr13x67gsif84";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/sly.html";
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
      version = "1.11.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/smartparens-1.11.0.tar";
        sha256 = "0kvlyx2bhw4q6k79wf5cm4srlmfncsbii4spdgafwmv8j7vw6ya3";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/smartparens.html";
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
      version = "2.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/solarized-theme-2.0.1.tar";
        sha256 = "1lk1g8v2chjrbbxplw3pd7yn3syjgywxkbdc7dbd76x168qz54qx";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/solarized-theme.html";
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
      version = "0.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/spacemacs-theme-0.2.tar";
        sha256 = "07lkaj6gm5iz503p5l6sm1y62mc5wk13nrwzv81f899jw99jcgml";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/spacemacs-theme.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/spell-fu-0.3.tar";
        sha256 = "11a5361xjap02s0mm2sylhxqqrv64v72d70cg1vzch7iwfi18l9c";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/spell-fu.html";
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
      version = "0.17";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/sqlite3-0.17.tar";
        sha256 = "17fx2bnzajqjzd9jgwvn6pjwshgirign975rrsc1m47cwniz0bnq";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/sqlite3.html";
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
      version = "1.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/stylus-mode-1.0.1.tar";
        sha256 = "0vihp241msg8f0ph8w3w9fkad9b12pmpwg0q5la8nbw7gfy41mz5";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/stylus-mode.html";
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
      version = "1.8.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/subatomic-theme-1.8.2.tar";
        sha256 = "0vpaswm5mdyb8cir160mb8ffgzaz7kbq3gvc2zrnh531zb994mqg";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/subatomic-theme.html";
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
      version = "1.2.14";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/subed-1.2.14.tar";
        sha256 = "0kzb054radxq9hqviadmbr4cln39yp7yz4inq4ip52rd3qdm8vy4";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/subed.html";
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
      version = "0.27.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/sweeprolog-0.27.5.tar";
        sha256 = "0mw8fddzcbn9h5l55v12n4nmickqdxc3y7y0xfzm6m42cvqkzdzf";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/sweeprolog.html";
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
      version = "9.1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/swift-mode-9.1.0.tar";
        sha256 = "1h7fbrgp2jsn0nk6c84vzvipm86macxf2975l0av8gxv0kpzcaiv";
      };
      packageRequires = [ seq ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/swift-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  swsw = callPackage (
    {
      elpaBuild,
      emacs,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "swsw";
      ename = "swsw";
      version = "2.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/swsw-2.3.tar";
        sha256 = "0qwdv174bh9k1bpd5szzmhk7hw89xf7rz2i2hzdrmlpvcs3ps653";
      };
      packageRequires = [ emacs ];
      meta = {
        homepage = "https://elpa.gnu.org/packages/swsw.html";
        license = lib.licenses.free;
      };
    }
  ) { };
  symbol-overlay = callPackage (
    {
      elpaBuild,
      fetchurl,
      lib,
    }:
    elpaBuild {
      pname = "symbol-overlay";
      ename = "symbol-overlay";
      version = "4.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/symbol-overlay-4.1.tar";
        sha256 = "0l877zm8fbf6qqcg7zx26w32x885axcj01l4y1m98jzryjhszfgn";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/symbol-overlay.html";
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
      version = "1.6.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/systemd-1.6.1.tar";
        sha256 = "0b0l70271kalicaix4p1ipr5vrj401cj8zvsi3243q1hp04k1m2g";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/systemd.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/tablist-1.0.tar";
        sha256 = "0z05va5fq054xysvhnpblxk5x0v6k4ian0hby6vryfxg9828gy57";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/tablist.html";
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
      version = "0.0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/tangotango-theme-0.0.7.tar";
        sha256 = "1w287p8lpmkm80qy1di2xmd71k051qmg89cn7s21kgi4br3hbbph";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/tangotango-theme.html";
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
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/telephone-line-0.5.tar";
        sha256 = "0pmn1r2g639c8g3rw5q2d5cgdz79d4ipr3r4dzwx2mgff3ri1ylm";
      };
      packageRequires = [
        cl-generic
        cl-lib
        seq
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/telephone-line.html";
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
      version = "0.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/testcover-mark-line-0.3.tar";
        sha256 = "1p1dmxqdyk82qbcmggmzn15nz4jm98j5bjivy56vimgncqfbaf4h";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/testcover-mark-line.html";
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
      version = "1.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/textile-mode-1.0.0.tar";
        sha256 = "02nc3wijsb626631m09f2ygpmimkbl46x5hi8yk0wl18y66yq972";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/textile-mode.html";
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
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/toc-org-1.1.tar";
        sha256 = "0qhkn1a4j1q5gflqlyha2534sms8xsx03i7dizrckhl368yznwan";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/toc-org.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/totp-auth-1.0.tar";
        sha256 = "0hzj0p1r18q8vkhkbxbfakvmgld9y8n5hzza5zir0cpalv5590r5";
      };
      packageRequires = [ base32 ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/totp-auth.html";
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
      version = "1.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/treeview-1.2.0.tar";
        sha256 = "1dmix7hn5yl69r987f0g2m00p866ln8412dm7fj399pmn1kdfsvy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/treeview.html";
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
      version = "3.0.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/tuareg-3.0.1.tar";
        sha256 = "04lb71cafg4bqicx3q3rb9jpxbq6hmdrzw88f52sjqxq5c4cqdkj";
      };
      packageRequires = [ caml ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/tuareg.html";
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
      version = "0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/typescript-mode-0.4.tar";
        sha256 = "1fs369h8ysrx1d8qzvz75izmlx4gzl619g7yjp9ck2wjv50wx95q";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/typescript-mode.html";
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
      version = "1.2.9";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/ujelly-theme-1.2.9.tar";
        sha256 = "1yyjsdcwprynwk86phpqfifv6xkmn49yrj6fkh5s57w5sbby4fp0";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/ujelly-theme.html";
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
      version = "0.5";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/undo-fu-0.5.tar";
        sha256 = "00pgvmks1nvdimsac534qny5vpq8sgcfgybiz3ck3mgfklj4kshj";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/undo-fu.html";
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
      version = "0.7";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/undo-fu-session-0.7.tar";
        sha256 = "1gly9fl8kvfssh2h90j9qcqvxvmnckn0x1wfm4qbz9ax57xvms23";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/undo-fu-session.html";
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
      version = "20230504";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/vc-fossil-20230504.tar";
        sha256 = "1q78xcfzpvvrlr9b9yh57asrlks2n0nhxhxl8dyfwad6gm0yr948";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/vc-fossil.html";
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
      version = "2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/vcomplete-2.0.tar";
        sha256 = "03f60ncrf994pc4q15m0p2admmy4gpg5c51nbr3xycqp16pq8dz1";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/vcomplete.html";
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
      version = "2.6.3";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/visual-fill-column-2.6.3.tar";
        sha256 = "0agxixxlv3lnsng8jk7y6x1kzzvx3sw5m3mhl8gr4i1didgxc37n";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/visual-fill-column.html";
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
      version = "17.3.20";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/web-mode-17.3.20.tar";
        sha256 = "1l4bmvc53ma2n3y143k86ip0w4am65zwxnl36lzqavs1hr55qvb2";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/web-mode.html";
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
      version = "3.2.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/webpaste-3.2.2.tar";
        sha256 = "04156iwgbc49l3b6s5vzbffw1xrkansvczi6q29d5waxwi6a2nfc";
      };
      packageRequires = [
        cl-lib
        request
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/webpaste.html";
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
      version = "1.2";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/wfnames-1.2.tar";
        sha256 = "1yy034fx86wn6yv4671fybc4zn5g619zcnnfvryq6zpwibj6fikz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/wfnames.html";
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
      version = "3.0.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/wgrep-3.0.0.tar";
        sha256 = "18j94y6xrjdmy5sk83mh5zaz4vqpi97pcjila387c0d84j1v2wzz";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/wgrep.html";
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
      version = "2.0.4";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/why-this-2.0.4.tar";
        sha256 = "1swidi6z6rhhy2zvas84vmkj41zaqpdxfssg6x6lvzzq34cgq0ph";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/why-this.html";
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
      version = "3.4.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/with-editor-3.4.1.tar";
        sha256 = "0nhlr2qjn351p0vd8vdnrwsb6wi2klh5ny84k90m8kzwcmvglhfd";
      };
      packageRequires = [ compat ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/with-editor.html";
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
      version = "3.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/with-simulated-input-3.0.tar";
        sha256 = "0a2kqrv3q399n1y21v7m4c9ivm56j28kasb466rq704jccvzblfr";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/with-simulated-input.html";
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
      version = "2.3.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/workroom-2.3.1.tar";
        sha256 = "0k0npmcs3cdkfds0r8p0gm8xa42bzdjiciilh65jka15fqknx486";
      };
      packageRequires = [
        compat
        project
      ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/workroom.html";
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
      version = "2.2.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/writegood-mode-2.2.0.tar";
        sha256 = "00phrzbd03gzc5y2ybizyp9smd6ybmmx2j7jf6hg5cmfyjmq8ahw";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/writegood-mode.html";
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
      version = "0.6";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/ws-butler-0.6.tar";
        sha256 = "1jzlwj2pqan3bj0mipvh8vzvmgynrxf1dqphix7g86ppjv1ivmfy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/ws-butler.html";
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
      version = "25.9.20240725161125";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/xah-fly-keys-25.9.20240725161125.tar";
        sha256 = "1kkis9qrfks40dlibkn4f75al0h61ixdw30a45ql09nsg4n5rzky";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/xah-fly-keys.html";
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
      version = "1.1";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/xkcd-1.1.tar";
        sha256 = "1qs4jv6h2i8g7s214xr4s6jgykdbac4lfc5hd0gmylkwlvs3pzcp";
      };
      packageRequires = [ json ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/xkcd.html";
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
      version = "1.6.17";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/xml-rpc-1.6.17.tar";
        sha256 = "1r8j87xddv80dx6lxzr2kq6czwk2l22bfxmplnma9fc2bsf1k2wy";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/xml-rpc.html";
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
      version = "0.0.16";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/yaml-mode-0.0.16.tar";
        sha256 = "0bhflv50z379p6ysdq89bdszkxp8zdmlb8plj1bm2nqsgc39hdm7";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/yaml-mode.html";
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
      version = "1.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/yasnippet-snippets-1.0.tar";
        sha256 = "0si61d0niabh18vbgdz6w5zirpxpp7c4mrcn5x1n3r5vnhv3n7m2";
      };
      packageRequires = [ yasnippet ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/yasnippet-snippets.html";
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
      version = "2.8.0";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/zenburn-theme-2.8.0.tar";
        sha256 = "0z733svsjsads655jgmc0b33icmygwaahxa27qi32s1pq84zqb4z";
      };
      packageRequires = [ ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/zenburn-theme.html";
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
      version = "0.0.8";
      src = fetchurl {
        url = "https://elpa.nongnu.org/nongnu/zig-mode-0.0.8.tar";
        sha256 = "1085lxm6k7b91c0q8jmmir59hzaqi8jgspbs89bvia2vq5x9xd87";
      };
      packageRequires = [ reformatter ];
      meta = {
        homepage = "https://elpa.nongnu.org/nongnu/zig-mode.html";
        license = lib.licenses.free;
      };
    }
  ) { };
}
