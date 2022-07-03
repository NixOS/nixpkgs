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
  kahole.magit = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kahole";
      name = "magit";
      version = "0.6.29";
      sha256 = "04nf98c1z384zsxkydxv6lvcwzymp7g0x69h8csmpaa3pfydw208";
    };
    meta.license = [ lib.licenses.mit ];
  };
  kamadorueda.alejandra = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kamadorueda";
      name = "alejandra";
      version = "1.0.0";
      sha256 = "1ncjzhrc27c3cwl2cblfjvfg23hdajasx8zkbnwx5wk6m2649s88";
    };
    meta.license = [ lib.licenses.unlicense ];
  };
  kddejong.vscode-cfn-lint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kddejong";
      name = "vscode-cfn-lint";
      version = "0.21.0";
      sha256 = "1x7w97a34mbjx5pndlil7dhicjv2w0n58b60g5ibpvxlvy49grr2";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  kubukoz.nickel-syntax = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kubukoz";
      name = "nickel-syntax";
      version = "0.0.1";
      sha256 = "010zn58j9kdb2jpxmlfyyyais51pwn7v2c5cfi4051ayd02b9n3s";
    };
    meta.license = [ lib.licenses.mit ];
  };
  llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "llvm-vs-code-extensions";
      name = "vscode-clangd";
      version = "0.1.17";
      sha256 = "1vgk4xsdbx0v6sy09wkb63qz6i64n6qcmpiy49qgh2xybskrrzvf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  lokalise.i18n-ally = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "lokalise";
      name = "i18n-ally";
      version = "2.8.1";
      sha256 = "0m2r3rflb6yx1y8gh9r8b7j8ia6iswhq2q4kxn7z6v8f6y5bndd0";
    };
  };
  mads-hartmann.bash-ide-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mads-hartmann";
      name = "bash-ide-vscode";
      version = "1.14.0";
      sha256 = "058z0fil0xpbnay6b5hgd31bgd3k4x3rnfyb8n0a0m198sxrpd5z";
    };
    meta.license = [ lib.licenses.mit ];
  };
  mattn.lisp = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mattn";
      name = "lisp";
      version = "0.1.12";
      sha256 = "0k10d77ffl6ybmk7mrpmlsawzwppp87aix2a2i24jq7lqnnqb9n7";
    };
    meta.license = [ lib.licenses.mit ];
  };
  mhutchie.git-graph = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mhutchie";
      name = "git-graph";
      version = "1.30.0";
      sha256 = "000zhgzijf3h6abhv4p3cz99ykj6489wfn81j0s691prr8q9lxxh";
    };
  };
  marp-team.marp-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "marp-team";
      name = "marp-vscode";
      version = "2.1.0";
      sha256 = "0x0wssq2nmllxkw8zlbf2mfbhd5gpp7pwxw920kz2ai7x0kk8k3s";
    };
    meta.license = [ lib.licenses.mit ];
  };
  mikestead.dotenv = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mikestead";
      name = "dotenv";
      version = "1.0.1";
      sha256 = "0rs57csczwx6wrs99c442qpf6vllv2fby37f3a9rhwc8sg6849vn";
    };
    meta.license = [ lib.licenses.mit ];
  };
  mishkinf.goto-next-previous-member = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mishkinf";
      name = "goto-next-previous-member";
      version = "0.0.6";
      sha256 = "07rpnbkb51835gflf4fpr0v7fhj8hgbhsgcz2wpag8wdzdxc3025";
    };
  };
  mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mskelton";
      name = "one-dark-theme";
      version = "1.14.2";
      sha256 = "1bsk9qxvln17imy9g1j3cfghcq9g762d529iskr91fysyq81ywpa";
    };
    meta.license = [ lib.licenses.isc ];
  };
  mechatroner.rainbow-csv = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mechatroner";
      name = "rainbow-csv";
      version = "2.4.0";
      sha256 = "0idl63rfn068zamyx5mw3524k3pb98gv32dfbrszxyrrx4kbh1fd";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-azuretools";
      name = "vscode-docker";
      version = "1.22.0";
      sha256 = "12qfwfqaa6nxm6gg2g7g4m001lh57bbhhbpyawxqk81qnjw3vipr";
    };
  };
  ms-dotnettools.csharp = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-dotnettools";
      name = "csharp";
      version = "1.25.0";
      sha256 = "1majiy1y2rynpmxgfa4j7c6l7pw1i24mbridp4ral7pmk9n06kjq";
    };
  };
  ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-kubernetes-tools";
      name = "vscode-kubernetes-tools";
      version = "1.3.10";
      sha256 = "0jxscmgvpsm36zjdy99y218dj7wv19jsrqap8h0saks0l0k44via";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-vscode.cpptools = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode";
      name = "cpptools";
      version = "1.11.0";
      sha256 = "0vdqx2vvk038rd8jk5wl0wxqjipp4mff5v741ncybv3ly3cifs14";
    };
  };
  ms-vscode-remote.remote-ssh = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode-remote";
      name = "remote-ssh";
      version = "0.83.2022062315";
      sha256 = "1k2b2pzg7nsiig6vdag61qgjnxzkb77628cc3sli7d35gq7hqmkf";
    };
  };
  ms-vscode.theme-tomorrowkit = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode";
      name = "theme-tomorrowkit";
      version = "0.1.4";
      sha256 = "0rrfpwsf2v8mra102b9wjg3wzwpxjlsk0p75g748my54cqjk1ad9";
    };
  };
  ms-pyright.pyright = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-pyright";
      name = "pyright";
      version = "1.1.257";
      sha256 = "0ipxy4n0xfzd9p8cgwi0g6njsyfr1nmbl36hsdfqyfpjvbacfpgc";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-python.python = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-python";
      name = "python";
      version = "2022.9.11821004";
      sha256 = "07k1rnshcd0dlbm9zv6qmm3wi22xyk6rb4sk7g6kcid21axnvwap";
    };
    meta.license = [ lib.licenses.mit ];
  };
  msjsdiag.debugger-for-chrome = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "msjsdiag";
      name = "debugger-for-chrome";
      version = "4.13.0";
      sha256 = "0r6l804dyinqfk012bmaynv73f07kgnvvxf74nc83pw61vvk5jk9";
    };
  };
  ms-toolsai.jupyter = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-toolsai";
      name = "jupyter";
      version = "2022.7.1001841019";
      sha256 = "046j5rhp3d5j7i1m4qlbdmmnjf0bjdrbqbgvhw9z8j998q99kkwg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-toolsai";
      name = "jupyter-renderers";
      version = "1.0.8";
      sha256 = "0cci7lr947mzxdx4cf9l6v5diy4lnlr32zzg2svs41zfdmarbdni";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-vscode.anycode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode";
      name = "anycode";
      version = "0.0.68";
      sha256 = "13qhp7s5p8lb14kb5q3nrirxh7cz2bhak5nzf7bmh4har9kdjcgf";
    };
  };
  mvllow.rose-pine = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mvllow";
      name = "rose-pine";
      version = "2.3.0";
      sha256 = "08vnasx5b3yrwnxsxzkcdaw8w4ybr3mx2jrap3g7fsvqsvv2pqhd";
    };
    meta.license = [ lib.licenses.mit ];
  };
  njpwerner.autodocstring = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "njpwerner";
      name = "autodocstring";
      version = "0.6.1";
      sha256 = "11vsvr3pggr6xn7hnljins286x6f5am48lx4x8knyg8r7dp1r39l";
    };
  };
  octref.vetur = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "octref";
      name = "vetur";
      version = "0.35.0";
      sha256 = "1l1w83yix8ya7si2g3w64mczh0m992c0cp2q0262qp3y0gspnm2j";
    };
  };
}
