{ buildVscodeMarketplaceExtension, lib }:
{
  attilabuti.brainfuck-syntax = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "attilabuti";
      name = "brainfuck-syntax";
      version = "0.0.1";
      sha256 = "10dif892p04f2nqxv6cnmhzfqlbw412ns5p3msg80smnhqg6bik5";
    };
    meta.license = [ lib.licenses.mit ];
  };
  chenglou92.rescript-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "chenglou92";
      name = "rescript-vscode";
      version = "1.3.0";
      sha256 = "0y9icaxhfwlg8gl3wlx5g3ipxmk5f0warki3gg7ga8x9acabn22a";
    };
    meta.license = [ lib.licenses.mit ];
  };
  foxundermoon.shell-format = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "foxundermoon";
      name = "shell-format";
      version = "7.2.2";
      sha256 = "00wc0y2wpdjs2pbxm6wj9ghhfsvxyzhw1vjvrnn1jfyl4wh3krvi";
    };
  };
  freebroccolo.reasonml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "freebroccolo";
      name = "reasonml";
      version = "1.0.38";
      sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  gencer.html-slim-scss-css-class-completion = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "gencer";
      name = "html-slim-scss-css-class-completion";
      version = "1.7.8";
      sha256 = "18qws35qvnl0ahk5sxh4mzkw0ib788y1l97ijmpjszs0cd4bfsa6";
    };
  };
  gitlab.gitlab-workflow = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "gitlab";
      name = "gitlab-workflow";
      version = "3.47.2";
      sha256 = "1nzaj7sxhbr3hliy7pixhy3xv5pjhha0yix67pa82d6syz5ggqjm";
    };
    meta.license = [ lib.licenses.mit ];
  };
  grapecity.gc-excelviewer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "grapecity";
      name = "gc-excelviewer";
      version = "4.2.55";
      sha256 = "0wavsr1jmi8fli0839livcvl04sj0gc657kcm8nf2a4865jplyf8";
    };
  };
  humao.rest-client = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "humao";
      name = "rest-client";
      version = "0.25.0";
      sha256 = "1j2gzagl5hyy7ry4nn595z0xzr7wbaq9qrm32p0fj1bgk3r6ib5z";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jkillian.custom-local-formatters = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jkillian";
      name = "custom-local-formatters";
      version = "0.0.6";
      sha256 = "1xvz4kxws7d7snd6diidrsmz0c5mm9iz8ihiw1vg65r2x8xf900m";
    };
    meta.license = [ lib.licenses.mit ];
  };
  kamikillerto.vscode-colorize = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kamikillerto";
      name = "vscode-colorize";
      version = "0.11.1";
      sha256 = "1h82b1jz86k2qznprng5066afinkrd7j3738a56idqr3vvvqnbsm";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  github.copilot = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "github";
      name = "copilot";
      version = "1.31.6194";
      sha256 = "1305l7alabs8bw6yj7m3pcvihbrag1gmmmg80pb0qxzgj7g2xdd1";
    };
  };
  github.github-vscode-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "github";
      name = "github-vscode-theme";
      version = "6.0.0";
      sha256 = "1vakkwnw43my74j7yjp30kfmmbc37jmr3qia5lvg8sbws3fq40jj";
    };
    meta.license = [ lib.licenses.mit ];
  };
  github.vscode-pull-request-github = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "github";
      name = "vscode-pull-request-github";
      version = "0.45.2022063009";
      sha256 = "1q69l1m9m4jkb809ivmdd63r3c4rfq7zjsj7qmr0sxvks5ypcvyj";
    };
    meta.license = [ lib.licenses.mit ];
  };
  golang.go = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "golang";
      name = "go";
      version = "0.34.1";
      sha256 = "0q0xgmv7g77rnx8mzvaws5lh6za98h9hks06yhyzbc98ylba3gff";
    };
    meta.license = [ lib.licenses.mit ];
  };
  graphql.vscode-graphql = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "graphql";
      name = "vscode-graphql";
      version = "0.4.13";
      sha256 = "19cym6cbhh25xxvj7fa1qrrq78wwac6ah4vlbh6pp0rbsjy2hc8l";
    };
    meta.license = [ lib.licenses.mit ];
  };
  gruntfuggly.todo-tree = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "gruntfuggly";
      name = "todo-tree";
      version = "0.0.215";
      sha256 = "0lyaijsvi1gqidpn8mnnfc0qsnd7an8qg5p2m7l24c767gllkbsq";
    };
    meta.license = [ lib.licenses.mit ];
  };
  haskell.haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "haskell";
      name = "haskell";
      version = "2.2.0";
      sha256 = "0qgp93m5d5kz7bxlnvlshcd8ms5ag48nk5hb37x02giqcavg4qv0";
    };
    meta.license = [ lib.licenses.mit ];
  };
  hashicorp.terraform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "hashicorp";
      name = "terraform";
      version = "2.23.0";
      sha256 = "1vgrchpgp3g69rynjvbv0a4p4rwsbgifvr3pi76xw4fwzw8s3zfy";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  hookyqr.beautify = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "hookyqr";
      name = "beautify";
      version = "1.5.0";
      sha256 = "1c0kfavdwgwham92xrh0gnyxkrl9qlkpv39l1yhrldn8vd10fj5i";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ibm.output-colorizer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ibm";
      name = "output-colorizer";
      version = "0.1.2";
      sha256 = "0i9kpnlk3naycc7k8gmcxas3s06d67wxr3nnyv5hxmsnsx5sfvb7";
    };
    meta.license = [ lib.licenses.mit ];
  };
  iciclesoft.workspacesort = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "iciclesoft";
      name = "workspacesort";
      version = "1.6.2";
      sha256 = "0skv1wvj65qw595mwqm5g4y2kg3lbcmzh9s9bf8b3q7bhj1c3j36";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ionide";
      name = "ionide-fsharp";
      version = "6.0.6";
      sha256 = "1x2v1k10a58n3lh7mszwmgj9pqhlisa88mrbrykmabrsai1sy1c9";
    };
    meta.license = [ lib.licenses.mit ];
  };
  JakeBecker.elixir-ls = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "JakeBecker";
      name = "elixir-ls";
      version = "0.10.0";
      sha256 = "0klvw14jg3hrb4xcdsp0zrjbqrygrbhphqzb9hx1qa7anp2d8wwb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  influxdata.flux = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "influxdata";
      name = "flux";
      version = "1.0.4";
      sha256 = "102aqijsxpm8h24afv921rb0slfxmigq5b0psm9c18p44wxr30i8";
    };
    meta.license = [ lib.licenses.mit ];
  };
  irongeek.vscode-env = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "irongeek";
      name = "vscode-env";
      version = "0.1.0";
      sha256 = "1ygfx1p38dqpk032n3x0591i274a63axh992gn6z1d45ag9bs6ji";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jakebecker.elixir-ls = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jakebecker";
      name = "elixir-ls";
      version = "0.10.0";
      sha256 = "0klvw14jg3hrb4xcdsp0zrjbqrygrbhphqzb9hx1qa7anp2d8wwb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  james-yu.latex-workshop = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "james-yu";
      name = "latex-workshop";
      version = "8.27.2";
      sha256 = "1aq98sqmfsglr0mi1ls4xp7fikhq61ammq9awg3bfcp5r3lx7jxi";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jdinhlife";
      name = "gruvbox";
      version = "1.7.0";
      sha256 = "176q9zbsxhvk5bxwd7pza1xv6vcrdksx9559mxp22ik2sdxp460v";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jnoortheen";
      name = "nix-ide";
      version = "0.1.20";
      sha256 = "16mmivdssjky11gmih7zp99d41m09r0ii43n17d4i6xwivagi9a3";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jock.svg = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jock";
      name = "svg";
      version = "1.4.18";
      sha256 = "09mximd6c843nclk8yi6brg3kkpyxz96ln0mnmgplw34lfqwm0rh";
    };
    meta.license = [ lib.licenses.mit ];
  };
  johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "johnpapa";
      name = "vscode-peacock";
      version = "4.0.1";
      sha256 = "1ckm0i8hkfh6zd7bmw1k0fbr3ynn148nbzpxm88whsdhm4wxi1d1";
    };
  };
  styled-components.vscode-styled-components = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "styled-components";
      name = "vscode-styled-components";
      version = "1.7.4";
      sha256 = "0qx1mvvw0bqa0psm35yxv9lvzw40bp8syjx4sp13502hg63r4h7n";
    };
    meta.license = [ lib.licenses.mit ];
  };
  justusadam.language-haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "justusadam";
      name = "language-haskell";
      version = "3.6.0";
      sha256 = "115y86w6n2bi33g1xh6ipz92jz5797d3d00mr4k8dv5fz76d35dd";
    };
    meta.license = [ lib.licenses.bsd3 ];
  };
}
