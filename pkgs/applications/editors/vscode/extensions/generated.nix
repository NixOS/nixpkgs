{ buildVscodeMarketplaceExtension, lib }:
{
  _1Password.op-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "1Password";
      name = "op-vscode";
      version = "1.0.0";
      sha256 = "1q4wp3gkgv6lb0kq8qqvd2bzx52w8ya790dwzs8jp3waflzr7qk5";
    };
    meta.license = [ lib.licenses.mit ];
  };
  _4ops.terraform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "4ops";
      name = "terraform";
      version = "0.2.5";
      sha256 = "0ciagyhxcxikfcvwi55bhj0gkg9p7p41na6imxid2mxw2a7yb4nb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "a5huynh";
      name = "vscode-ron";
      version = "0.9.0";
      sha256 = "0d3p50mhqp550fmj662d3xklj14gvzvhszm2hlqvx4h28v222z97";
    };
    meta.license = [ lib.licenses.mit ];
  };
  alanz.vscode-hie-server = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alanz";
      name = "vscode-hie-server";
      version = "0.2.1";
      sha256 = "1ql3ynar7fm1dhsf6kb44bw5d9pi1d8p9fmjv5p96iz8x7n3w47x";
    };
    meta.license = [ lib.licenses.mit ];
  };
  adpyke.codesnap = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "adpyke";
      name = "codesnap";
      version = "1.3.4";
      sha256 = "012sj4a65sr8014z4zpxqzb6bkj7pnhm4rls73xpwawk6hwal7km";
    };
    meta.license = [ lib.licenses.mit ];
  };
  alefragnani.bookmarks = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alefragnani";
      name = "bookmarks";
      version = "13.3.0";
      sha256 = "0mia2q1al9n0dj4icq0gcl07im7ix2090nj99q9jy5xwcavzpavj";
    };
    meta.license = [ lib.licenses.gpl3 ];
  };
  alefragnani.project-manager = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alefragnani";
      name = "project-manager";
      version = "12.6.0";
      sha256 = "1nln4dqqf8dwkga2ys2jyjjp3grf5kk2z8xvyhx4c4bq5ilwg5bg";
    };
    meta.license = [ lib.licenses.gpl3 ];
  };
  alexdima.copy-relative-path = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alexdima";
      name = "copy-relative-path";
      version = "0.0.2";
      sha256 = "06g601n9d6wyyiz659w60phgm011gn9jj5fy0gf5wpi2bljk3vcn";
    };
  };
  alygin.vscode-tlaplus = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alygin";
      name = "vscode-tlaplus";
      version = "1.5.4";
      sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  angular.ng-template = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "angular";
      name = "ng-template";
      version = "14.0.1";
      sha256 = "0a1k0yz4b6ivwwyl4sv9fpr4g91hpndz1s7pa9pg6bfy6njn5d4x";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antfu.icons-carbon = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antfu";
      name = "icons-carbon";
      version = "0.2.5";
      sha256 = "12bs9i8fj11irnfk1j5jxcly91xql3nspwxf0rpfgy7fx1dyanmx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antfu.slidev = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antfu";
      name = "slidev";
      version = "0.3.3";
      sha256 = "0pqiwcvn5c8kwqlmz4ribwwra69gbiqvz41ig4fh29hkyh078rfk";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antyos.openscad = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antyos";
      name = "openscad";
      version = "1.1.1";
      sha256 = "1adcw9jj3npk3l6lnlfgji2l529c4s5xp9jl748r9naiy3w3dpjv";
    };
  };
  apollographql.vscode-apollo = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "apollographql";
      name = "vscode-apollo";
      version = "1.19.11";
      sha256 = "1r9p82mf5xsh7bk58pjbf92vamib1d2gs490wzlhz2w97dy5wb0j";
    };
    meta.license = [ lib.licenses.mit ];
  };
  arcticicestudio.nord-visual-studio-code = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "arcticicestudio";
      name = "nord-visual-studio-code";
      version = "0.19.0";
      sha256 = "05bmzrmkw9syv2wxqlfddc3phjads6ql2grknws85fcqzqbfl1kb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  arjun.swagger-viewer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "arjun";
      name = "swagger-viewer";
      version = "3.1.2";
      sha256 = "1cjvc99x1q5w3i2vnbxrsl5a1dr9gb3s6s9lnwn6mq5db6iz1nlm";
    };
  };
  arrterian.nix-env-selector = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "arrterian";
      name = "nix-env-selector";
      version = "1.0.9";
      sha256 = "0kdfhkdkffr3cdxmj7llb9g3wqpm13ml75rpkwlg1y0pkxcnlk2f";
    };
    meta.license = [ lib.licenses.mit ];
  };
  asciidoctor.asciidoctor-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "asciidoctor";
      name = "asciidoctor-vscode";
      version = "2.9.8";
      sha256 = "0wj6gixg197wrhmryi0kxj53w0qngmhgpw5aklriq858ms4c0zf3";
    };
    meta.license = [ lib.licenses.mit ];
  };
  asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "asvetliakov";
      name = "vscode-neovim";
      version = "0.0.87";
      sha256 = "1glrkksd7ch5jrvh9fdz6hnq4kj9d5vcflx5x9cdqif3vi1381qm";
    };
  };
  attilabuti.brainfuck-syntax = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "attilabuti";
      name = "brainfuck-syntax";
      version = "0.0.1";
      sha256 = "10dif892p04f2nqxv6cnmhzfqlbw412ns5p3msg80smnhqg6bik5";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-python";
      name = "vscode-pylance";
      version = "2022.7.11";
      sha256 = "19nz01plcwh3b3b8qsj2rlbn5w39rldddjq80wljrvnfjlnn7ar5";
    };
  };
  b4dm4n.nixpkgs-fmt = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "b4dm4n";
      name = "nixpkgs-fmt";
      version = "0.0.1";
      sha256 = "1gvjqy54myss4w1x55lnyj2l887xcnxc141df85ikmw1gr9s8gdz";
    };
    meta.license = [ lib.licenses.mit ];
  };
  baccata.scaladex-search = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "baccata";
      name = "scaladex-search";
      version = "0.3.0";
      sha256 = "1ws22f5p4gf1vgpr0gwr2nzcz7lk7armvxxj2m8yzg5nr2kwmgis";
    };
  };
  badochov.ocaml-formatter = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "badochov";
      name = "ocaml-formatter";
      version = "2.0.5";
      sha256 = "1ch8x5wgbzlf9fmmrizpqql56ybcimfbz046jyzsk7dd3cj08khg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bbenoist.nix = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bbenoist";
      name = "nix";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };
  };
  benfradet.vscode-unison = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "benfradet";
      name = "vscode-unison";
      version = "0.4.0";
      sha256 = "06r212sxy3jc4qd583bibk6m40c4jczlxl8rsgv4fwnnwazkscr0";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  betterthantomorrow.calva = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "betterthantomorrow";
      name = "calva";
      version = "2.0.288";
      sha256 = "0pa6kqw13iisj8awf1w7ygxfkb56c777pnq55b8zy9n9xqphyjzg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bodil.file-browser = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bodil";
      name = "file-browser";
      version = "0.2.10";
      sha256 = "1gw46sq49nm85i0mnbrlnl0fg09qi72fqsl46wgd16zf86djyvj5";
    };
  };
  bierner.emojisense = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bierner";
      name = "emojisense";
      version = "0.9.1";
      sha256 = "1y5s4ciksd225rf6ms736xfmpnyha8ms395ah2j7ac5a5nd4iy3d";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bierner.markdown-checkbox = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bierner";
      name = "markdown-checkbox";
      version = "0.3.2";
      sha256 = "12mjacyy3ipinhmaz35972vn1dahrzwlbx16n1wjyvxsl8l4id0y";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bierner.markdown-emoji = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bierner";
      name = "markdown-emoji";
      version = "0.2.1";
      sha256 = "1lcg2b39jydl40wcfrbgshl2i1r58k92c7dipz0hl1fa1v23vj4v";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bierner.markdown-mermaid = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bierner";
      name = "markdown-mermaid";
      version = "1.14.2";
      sha256 = "0lfl53khp8zhyh8ncdbbxjm7yg61zvm2wrkdhv5nk2kpcxiq1725";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bradlc";
      name = "vscode-tailwindcss";
      version = "0.8.6";
      sha256 = "1qlmmfw9kw3758b0rd5kjb4j80v4aafhhaqamyn50q6y7nw4lpmz";
    };
    meta.license = [ lib.licenses.mit ];
  };
  brettm12345.nixfmt-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "brettm12345";
      name = "nixfmt-vscode";
      version = "0.0.1";
      sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
    };
    meta.license = [ lib.licenses.mit ];
  };
  bungcip.better-toml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bungcip";
      name = "better-toml";
      version = "0.3.2";
      sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
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
  christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "christian-kohler";
      name = "path-intellisense";
      version = "2.8.1";
      sha256 = "1j7q4mzj173sl6xl3zjw40hnqvyqsrsczakmv63066k4k0rb6clm";
    };
  };
  cmschuetz12.wal = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "cmschuetz12";
      name = "wal";
      version = "0.1.0";
      sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
    };
  };
  codezombiech.gitignore = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "codezombiech";
      name = "gitignore";
      version = "0.7.0";
      sha256 = "0fm4sxx1cb679vn4v85dw8dfp5x0p74m9p2b56gqkvdap0f2q351";
    };
    meta.license = [ lib.licenses.mit ];
  };
  coenraads.bracket-pair-colorizer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "coenraads";
      name = "bracket-pair-colorizer";
      version = "1.0.62";
      sha256 = "0zck9kzajfx0jl85mfaz4l92x8m1rkwq2vlz0w91kr2wq8im62lb";
    };
  };
  coenraads.bracket-pair-colorizer-2 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "coenraads";
      name = "bracket-pair-colorizer-2";
      version = "0.2.4";
      sha256 = "1vdd3l5khxacwsqnzd9a19h2i7xpp3hi7awgdfbwvvr8w5v8vkmk";
    };
  };
  coolbear.systemd-unit-file = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "coolbear";
      name = "systemd-unit-file";
      version = "1.0.6";
      sha256 = "0sc0zsdnxi4wfdlmaqwb6k2qc21dgwx6ipvri36x7agk7m8m4736";
    };
    meta.license = [ lib.licenses.mit ];
  };
  cweijan.vscode-database-client2 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "cweijan";
      name = "vscode-database-client2";
      version = "5.5.3";
      sha256 = "1aysb8adkjpx8xg3agkp2cpj4svmcv8iijhx2ayq3mn5561nbzk2";
    };
  };
  dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dbaeumer";
      name = "vscode-eslint";
      version = "2.2.5";
      sha256 = "1gwpj1xqx5r6z5hdlqw7rr5n1ml11bfhpl29rkf7pajhx5p4qpq8";
    };
    meta.license = [ lib.licenses.mit ];
  };
  daohong-emilio.yash = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "daohong-emilio";
      name = "yash";
      version = "0.2.9";
      sha256 = "0a6liv8nwm9z0rpkln3cxphgbc1r7lkwjzrxij38lgjmpikzm5g4";
    };
    meta.license = [ lib.licenses.mit ];
  };
  davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "davidanson";
      name = "vscode-markdownlint";
      version = "0.47.0";
      sha256 = "0v50qcfs3jx0m2wqg4qbhw065qzdi57xrzcwnhcpjhg1raiwkl1a";
    };
    meta.license = [ lib.licenses.mit ];
  };
  davidlday.languagetool-linter = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "davidlday";
      name = "languagetool-linter";
      version = "0.19.0";
      sha256 = "0m8pylm306mjx9nr0xhd8n0w6s00vqcj0ky15z4h3kz96l4vmfkj";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  denoland.vscode-deno = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "denoland";
      name = "vscode-deno";
      version = "3.13.0";
      sha256 = "19rm6j52xwfkaxhsfplx2m7zfc9qzci72qxdpm7r855bkgab9mcs";
    };
    meta.license = [ lib.licenses.mit ];
  };
  dhall.dhall-lang = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dhall";
      name = "dhall-lang";
      version = "0.0.4";
      sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dhall";
      name = "vscode-dhall-lsp-server";
      version = "0.0.4";
      sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
    };
    meta.license = [ lib.licenses.mit ];
  };
  disneystreaming.smithy = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "disneystreaming";
      name = "smithy";
      version = "0.0.4";
      sha256 = "1nl73rg0nqzgp2r3sv968h4bcv2p4f3lj0pjar3s8jgm4jlln4qi";
    };
  };
  divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "divyanshuagrawal";
      name = "competitive-programming-helper";
      version = "5.9.2";
      sha256 = "09jcbph149nysp159plmpwsa70czml0zxs6752zidm26bia66ig6";
    };
    meta.license = [ lib.licenses.gpl3Plus ];
  };
  donjayamanne.githistory = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "donjayamanne";
      name = "githistory";
      version = "0.6.19";
      sha256 = "15s2mva9hg2pw499g890v3jycncdps2dmmrmrkj3rns8fkhjn8b3";
    };
    meta.license = [ lib.licenses.mit ];
  };
  dotjoshjohnson.xml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dotjoshjohnson";
      name = "xml";
      version = "2.5.1";
      sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
    };
  };
  dracula-theme.theme-dracula = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dracula-theme";
      name = "theme-dracula";
      version = "2.24.2";
      sha256 = "1bsq00h30x60rxhqfdmadps5p1vpbl2kkwgkk6yqs475ic89dnk0";
    };
    meta.license = [ lib.licenses.mit ];
  };
  eamodio.gitlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "eamodio";
      name = "gitlens";
      version = "12.1.1";
      sha256 = "0i1wxgc61rrf11zff0481dg9s2lmv1ngpwx8nb2ygf6lh0axr7cj";
    };
  };
  editorconfig.editorconfig = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "editorconfig";
      name = "editorconfig";
      version = "0.16.4";
      sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  edonet.vscode-command-runner = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "edonet";
      name = "vscode-command-runner";
      version = "0.0.122";
      sha256 = "1lvwvcs18azqhkzyvhf83ckfhfdgcqrw2gxb2myspqj59783hfpg";
    };
  };
  eg2.vscode-npm-script = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "eg2";
      name = "vscode-npm-script";
      version = "0.3.28";
      sha256 = "0wf5zn2mkvmyasli6nhqr5rpnmpv1aw7pqa6b2k3fw254by8ys35";
    };
    meta.license = [ lib.licenses.mit ];
  };
  elmtooling.elm-ls-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "elmtooling";
      name = "elm-ls-vscode";
      version = "2.4.1";
      sha256 = "1idhsrl9w8sc0qk58dvmyyjbmfznk3f4gz2zl6s9ksyz9d06vfrd";
    };
    meta.license = [ lib.licenses.mit ];
  };
  emmanuelbeziat.vscode-great-icons = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "emmanuelbeziat";
      name = "vscode-great-icons";
      version = "2.1.86";
      sha256 = "083bxadyis6h9l59hwfryv1xsqfkinaf5nd0alxxvzmnd3s36dbx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "esbenp";
      name = "prettier-vscode";
      version = "9.5.0";
      sha256 = "0h5g746ij36h22v1y2883bqaphds7h1ck8mg8bywn9r723mxdy1g";
    };
    meta.license = [ lib.licenses.mit ];
  };
  evzen-wybitul.magic-racket = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "evzen-wybitul";
      name = "magic-racket";
      version = "0.6.4";
      sha256 = "11azghqc0h9mndyq7ybbb2xqgwg17pwwjhrs1d4g4hmpz5abh5hz";
    };
  };
  faustinoaq.lex-flex-yacc-bison = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "faustinoaq";
      name = "lex-flex-yacc-bison";
      version = "0.0.3";
      sha256 = "0gfc4a3pdy9lwshk2lv2hkc1kk69q64aqdgigfp6wyfwawhzam32";
    };
    meta.license = [ lib.licenses.mit ];
  };
  file-icons.file-icons = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "file-icons";
      name = "file-icons";
      version = "1.0.29";
      sha256 = "05x45f9yaivsz8a1ahlv5m8gy2kkz71850dhdvwmgii0vljc8jc6";
    };
    meta.license = [ lib.licenses.mit ];
  };
  foam.foam-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "foam";
      name = "foam-vscode";
      version = "0.18.5";
      sha256 = "05ic1gnr950wqa0qg4267jwacsczcnryyg87bzpzxsckmh0qfbfx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  formulahendry.auto-close-tag = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "formulahendry";
      name = "auto-close-tag";
      version = "0.5.14";
      sha256 = "1k4ld30fyslj89bvjh2ihwgycb0i11mn266misccbjqkci5hg1jx";
    };
  };
  formulahendry.auto-rename-tag = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "formulahendry";
      name = "auto-rename-tag";
      version = "0.1.10";
      sha256 = "0nyilwfs2kbf8v3v9njx1s7ppdp1472yhimiaja0c3v7piwrcymr";
    };
    meta.license = [ lib.licenses.mit ];
  };
  formulahendry.code-runner = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "formulahendry";
      name = "code-runner";
      version = "0.11.8";
      sha256 = "1h95zpl7sr4kdjwymyk5ambxa5gmzpnyj63ixyjiy6kffh9s872x";
    };
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
      sha256 = "1mjw7aab7xk8hzy7s3iswmmdgnaknmpwp53ib8khwcb35cy8ism2";
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
  oderwat.indent-rainbow = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "oderwat";
      name = "indent-rainbow";
      version = "8.3.1";
      sha256 = "0iwd6y2x2nx52hd3bsav3rrhr7dnl4n79ln09picmnh1mp4rrs3l";
    };
    meta.license = [ lib.licenses.mit ];
  };
  phoenixframework.phoenix = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "phoenixframework";
      name = "phoenix";
      version = "0.1.1";
      sha256 = "0pd1s6f1lm96y1q9d9aj7sa8n0vc0cjrggiyyh1azwa5h59v1w01";
    };
    meta.license = [ lib.licenses.mit ];
  };
  redhat.java = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "java";
      version = "1.9.2022070104";
      sha256 = "182dr8rziddkmmiv5jvgr7ybilrh83wrfqj8ykwzgsybymks1a2b";
    };
    meta.license = [ lib.licenses.epl20 ];
  };
  redhat.vscode-yaml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "vscode-yaml";
      version = "1.8.0";
      sha256 = "1djd4mxnfrrlgiyrqjrrchza3q229sy57d71dggvf6f5k2wnj1qv";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rioj7.commandOnAllFiles = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rioj7";
      name = "commandOnAllFiles";
      version = "0.3.0";
      sha256 = "04f1sb5rxjwkmidpymhqanv8wvp04pnw66098836dns906p4gldl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rubymaniac.vscode-paste-and-indent = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rubymaniac";
      name = "vscode-paste-and-indent";
      version = "0.0.8";
      sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rust-lang.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rust-lang";
      name = "rust-analyzer";
      version = "0.4.1113";
      sha256 = "0gsr58iy6m4gl6xz8s7nyj0jbmprv8hzw1xda2nal4yanh75395v";
    };
    meta.license = [ lib.licenses.mit lib.licenses.asl20 ];
  };
  ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ocamllabs";
      name = "ocaml-platform";
      version = "1.10.7";
      sha256 = "1vbazbgdk5g3sa72wk0vd4i354bw3kagdmp0bzr56v4jwspnw587";
    };
    meta.license = [ lib.licenses.mit ];
  };
  pkief.material-icon-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-icon-theme";
      version = "4.19.0";
      sha256 = "1azkkp4bnd7n8v0m4325hfrr6p6ikid88xbxaanypji25pnyq5a4";
    };
  };
  pkief.material-product-icons = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-product-icons";
      version = "1.3.0";
      sha256 = "1my2rvyvvrn61jl1g2hnjgpsma1c7czr6ip4y1006d9ghqsc9h3k";
    };
  };
  prisma.prisma = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "prisma";
      name = "prisma";
      version = "4.0.0";
      sha256 = "14w7ikqannkxg3ck690ix8pdzrbggiq75vgy8ag97dqkvm0lvg8l";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  richie5um2.snake-trail = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "richie5um2";
      name = "snake-trail";
      version = "0.6.0";
      sha256 = "0wkpq9f48hplrgabb0v1ij6fc4sb8h4a93dagw4biprhnnm3qx49";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ritwickdey.liveserver = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ritwickdey";
      name = "liveserver";
      version = "5.7.5";
      sha256 = "0afjp8jr1s0f3ag0q8kw5d8cyd5fh6vzkfx2wdqq4pihm7ivp9xc";
    };
    meta.license = [ lib.licenses.mit ];
  };
  roman.ayu-next = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "roman";
      name = "ayu-next";
      version = "1.2.9";
      sha256 = "10kb9i86f6pl6q9aqjzdqf1kiwpagd6rskxg6spcm66iy6m6f1mg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rubbersheep.gi = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rubbersheep";
      name = "gi";
      version = "0.2.11";
      sha256 = "0j9k6wm959sziky7fh55awspzidxrrxsdbpz1d79s5lr5r19rs6j";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ryu1kn.partial-diff = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ryu1kn";
      name = "partial-diff";
      version = "1.4.3";
      sha256 = "0x3lkvna4dagr7s99yykji3x517cxk5kp7ydmqa6jb4bzzsv1s6h";
    };
  };
  scala-lang.scala = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "scala-lang";
      name = "scala";
      version = "0.5.5";
      sha256 = "1gqgamm97sq09za8iyb06jf7hpqa2mlkycbx6zpqwvlwd3a92qr1";
    };
  };
  scalameta.metals = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "scalameta";
      name = "metals";
      version = "1.17.10";
      sha256 = "0vi51l1g26y027g0ag989ygb4rcn11kmxmgb2b9kwbc328s31n3x";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  serayuzgur.crates = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "serayuzgur";
      name = "crates";
      version = "0.5.10";
      sha256 = "1dbhd6xbawbnf9p090lpmn8i5gg1f7y8xk2whc9zhg4432kdv3vd";
    };
  };
  shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "shardulm94";
      name = "trailing-spaces";
      version = "0.3.1";
      sha256 = "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8";
    };
    meta.license = [ lib.licenses.mit ];
  };
  shyykoserhiy.vscode-spotify = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "shyykoserhiy";
      name = "vscode-spotify";
      version = "3.2.1";
      sha256 = "14d68rcnjx4a20r0ps9g2aycv5myyhks5lpfz0syr2rxr4kd1vh6";
    };
    meta.license = [ lib.licenses.mit ];
  };
  silvenon.mdx = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "silvenon";
      name = "mdx";
      version = "0.1.0";
      sha256 = "1mzsqgv0zdlj886kh1yx1zr966yc8hqwmiqrb1532xbmgyy6adz3";
    };
  };
  skellock.just = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "skellock";
      name = "just";
      version = "2.0.0";
      sha256 = "1ph869zl757a11f8iq643f79h8gry7650a9i03mlxyxlqmspzshl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  skyapps.fish-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "skyapps";
      name = "fish-vscode";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    };
  };
  slevesque.vscode-multiclip = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "slevesque";
      name = "vscode-multiclip";
      version = "0.1.5";
      sha256 = "1cg8dqj7f10fj9i0g6mi3jbyk61rs6rvg9aq28575rr52yfjc9f9";
    };
  };
  spywhere.guides = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "spywhere";
      name = "guides";
      version = "0.9.3";
      sha256 = "1kvsj085w1xax6fg0kvsj1cizqh86i0pkzpwi0sbfvmcq21i6ghn";
    };
    meta.license = [ lib.licenses.mit ];
  };
  stefanjarina.vscode-eex-snippets = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stefanjarina";
      name = "vscode-eex-snippets";
      version = "0.0.8";
      sha256 = "0j8pmrs1lk138vhqx594pzxvrma4yl3jh7ihqm2kgh0cwnkbj36m";
    };
    meta.license = [ lib.licenses.mit ];
  };
  stephlin.vscode-tmux-keybinding = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stephlin";
      name = "vscode-tmux-keybinding";
      version = "0.0.7";
      sha256 = "01ma6f1sk4xmp92n3p4mqzm96arghd410r6av9a0hy7hi76b9d9j";
    };
  };
  stkb.rewrap = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stkb";
      name = "rewrap";
      version = "17.8.0";
      sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
    };
  };
  streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "streetsidesoftware";
      name = "code-spell-checker";
      version = "2.2.5";
      sha256 = "0ayhlzh3b2mcdx6mdj00y4qxvv6mirfpnp8q5zvidm6sv3vwlcj0";
    };
    meta.license = [ lib.licenses.gpl3Plus ];
  };
  svelte.svelte-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "svelte";
      name = "svelte-vscode";
      version = "105.18.1";
      sha256 = "0fa9k4j73n76fx06xr6003pn7mfapvpjjqddl5pn9i02m5q975aj";
    };
    meta.license = [ lib.licenses.mit ];
  };
  svsool.markdown-memo = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "svsool";
      name = "markdown-memo";
      version = "0.3.18";
      sha256 = "024v54qqv8kgxv2bm8wfi64aci5xm4cry2b0z8xr322mgma2m5na";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tabnine.tabnine-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tabnine";
      name = "tabnine-vscode";
      version = "3.5.60";
      sha256 = "082dv68axp5pspf539jjvxfy16fk1smwjlai1w7kfk36yhhs97s8";
    };
  };
  takayama.vscode-qq = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "takayama";
      name = "vscode-qq";
      version = "1.4.2";
      sha256 = "1n6hxf604nws5569zw3m8hjbnsgblqy0v4b022ygh8q5flas51wj";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tamasfe";
      name = "even-better-toml";
      version = "0.16.4";
      sha256 = "0pxrky5v9d9zxbfya7cyv8m2y260x9dmlinm4ybpxnw9j9v5xvfh";
    };
  };
  theangryepicbanana.language-pascal = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "theangryepicbanana";
      name = "language-pascal";
      version = "0.1.6";
      sha256 = "096wwmwpas21f03pbbz40rvc792xzpl5qqddzbry41glxpzywy6b";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tiehuis.zig = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tiehuis";
      name = "zig";
      version = "0.2.5";
      sha256 = "1vmng7h7fwwgak32djlkxxdr5br0dx9w97bvgr9whxdd8fkrxi1z";
    };
    meta.license = [ lib.licenses.mit ];
  };
  timonwong.shellcheck = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "timonwong";
      name = "shellcheck";
      version = "0.19.5";
      sha256 = "1v6z0qzcqhb458pf6dwx35xk2iw3j3swx8dhys4qpzi3cpqvd6p1";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tobiasalthoff.atom-material-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tobiasalthoff";
      name = "atom-material-theme";
      version = "1.10.8";
      sha256 = "0i31a0id7f48qm7gypspcrasm6d4rfy7r2yl04qvg2kpwp858fs4";
    };
  };
  tomoki1207.pdf = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tomoki1207";
      name = "pdf";
      version = "1.2.0";
      sha256 = "1bcj546bp0w4yndd0qxwr8grhiwjd1jvf33jgmpm0j96y34vcszz";
    };
  };
  tuttieee.emacs-mcx = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tuttieee";
      name = "emacs-mcx";
      version = "0.44.0";
      sha256 = "08xm6csswkwmv652sjvy623rbkhks1xc4vd7v69g2vy3ydcgjn73";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tyriar.sort-lines = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tyriar";
      name = "sort-lines";
      version = "1.9.1";
      sha256 = "0dds99j6awdxb0ipm15g543a5b6f0hr00q9rz961n0zkyawgdlcb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  usernamehw.errorlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "usernamehw";
      name = "errorlens";
      version = "3.5.1";
      sha256 = "17xbbr5hjrs67yazicb9qillbkp3wnaccjpnl1jlp07s0n7q4f8f";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vadimcn.vscode-lldb = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vadimcn";
      name = "vscode-lldb";
      version = "1.7.0";
      sha256 = "0sdy261fkccff13i0s6kiykkwisinasxy1n23m0xmw72i9w31rhf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  valentjn.vscode-ltex = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "valentjn";
      name = "vscode-ltex";
      version = "13.1.0";
      sha256 = "15qm97i9l65v3x0zxl1895ilazz2jk2wmizbj7kmds613jz7d46c";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  viktorqvarfordt.vscode-pitch-black-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "viktorqvarfordt";
      name = "vscode-pitch-black-theme";
      version = "1.3.0";
      sha256 = "124bnbr8x929gx0fiyqfgf6ym2qc7y1iqv03srd0qnwdqpyyd46l";
    };
  };
  vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vincaslt";
      name = "highlight-matching-tag";
      version = "0.10.1";
      sha256 = "0b9jpwiyxax783gyr9zhx7sgrdl9wffq34fi7y67vd68q9183jw1";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-vsliveshare.vsliveshare = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vsliveshare";
      name = "vsliveshare";
      version = "1.0.5625";
      sha256 = "09dwcrfjxpsx7sclmn5fkgm89g6l6z2ik9wp1acaffsfkay4cg05";
    };
  };
  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vscodevim";
      name = "vim";
      version = "1.23.1";
      sha256 = "131fnicsknw4kkz299l9mdq1b0lx05ssr8sszk1apgmxxngzfz4k";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vspacecode.vspacecode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vspacecode";
      name = "vspacecode";
      version = "0.10.9";
      sha256 = "01d43dcd5293nlp6vskdv85h0qr8xlq8j9vdzn0vjqr133c05anp";
    };
  };
  vspacecode.whichkey = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vspacecode";
      name = "whichkey";
      version = "0.11.3";
      sha256 = "0zix87vl2rig8wn3f6f3n6zdi0c61za3lw7xgm28sjhwwb08wxiy";
    };
  };
  wix.vscode-import-cost = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wix";
      name = "vscode-import-cost";
      version = "3.3.0";
      sha256 = "0wl8vl8n0avd6nbfmis0lnlqlyh4yp3cca6kvjzgw5xxdc5bl38r";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xadillax.viml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xadillax";
      name = "viml";
      version = "2.1.2";
      sha256 = "0w4br37fb2w4aqlfgvrg2ffzad7ssm3bfr3phbxvi9v9aj7m3pcz";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xaver.clang-format = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xaver";
      name = "clang-format";
      version = "1.9.0";
      sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xyz.local-history = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xyz";
      name = "local-history";
      version = "1.8.1";
      sha256 = "1mfmnbdv76nvwg4xs3rgsqbxk8hw9zr1b61har9c3pbk9r4cay7v";
    };
  };
  yzhang.markdown-all-in-one = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "yzhang";
      name = "markdown-all-in-one";
      version = "3.4.3";
      sha256 = "0z0sdb5vmx1waln5k9fk6s6lj1pzpcm3hwm4xc47jz62iq8930m3";
    };
    meta.license = [ lib.licenses.mit ];
  };
  zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "zhuangtongfa";
      name = "material-theme";
      version = "3.15.2";
      sha256 = "058md25509l9nlgicab59rv13alyksbnf6gm55b8yhkbxx6pm079";
    };
    meta.license = [ lib.licenses.mit ];
  };
  WakaTime.vscode-wakatime = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "WakaTime";
      name = "vscode-wakatime";
      version = "18.1.6";
      sha256 = "15ldc9774jgwqlw5qfrdmpmgdyvps2rkn2lh7v2f0w457x9h52lx";
    };
    meta.license = [ lib.licenses.bsd3 ];
  };
  wholroyd.jinja = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wholroyd";
      name = "jinja";
      version = "0.0.8";
      sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
    };
    meta.license = [ lib.licenses.mit ];
  };
  zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "zxh404";
      name = "vscode-proto3";
      version = "0.5.5";
      sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
    };
  };
}
