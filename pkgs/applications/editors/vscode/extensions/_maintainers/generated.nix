{ buildVscodeMarketplaceExtension, lib }:
{
  _4ops.terraform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "4ops";
      name = "terraform";
      version = "0.2.2";
      sha256 = "1f62sck05gvjp7bb6zv34mdbk57y0c9h1av9kp62vjfqggv4zdpf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  Arjun.swagger-viewer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "Arjun";
      name = "swagger-viewer";
      version = "3.1.2";
      sha256 = "1cjvc99x1q5w3i2vnbxrsl5a1dr9gb3s6s9lnwn6mq5db6iz1nlm";
    };
  };
  WakaTime.vscode-wakatime = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "WakaTime";
      name = "vscode-wakatime";
      version = "18.0.6";
      sha256 = "127w3150qgm5wbjrpi4fvs5a3jwhv7kbr3sfm8wf9274zv91mlvs";
    };
    meta.license = [ lib.licenses.bsd3 ];
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
  alefragnani.project-manager = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alefragnani";
      name = "project-manager";
      version = "12.5.0";
      sha256 = "0v2zckwqyl33jwpzjr8i3p3v1xldkindsyip8v7rs1pcmqmpv1dq";
    };
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
      version = "13.2.3";
      sha256 = "1pj0am6z97sbyqgg8l2yxai7g5k99lx3anjgz8mjm5nmp5svpwgm";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antfu.icons-carbon = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antfu";
      name = "icons-carbon";
      version = "0.2.4";
      sha256 = "0q04bkj36ccv4x2dg2k9wfwhik9611h9qv4vmamq4zzjfa5rdb8w";
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
      version = "1.19.9";
      sha256 = "16i3fv9fr77vzqh38v21x5fqm8xpkpk5w2wxw7mbfhiflws776l8";
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
  arrterian.nix-env-selector = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "arrterian";
      name = "nix-env-selector";
      version = "1.0.7";
      sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  asciidoctor.asciidoctor-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "asciidoctor";
      name = "asciidoctor-vscode";
      version = "2.9.5";
      sha256 = "14xlxw1cpi54faix3dai7m3zl9akd202cqc8vs9prf3ddqd2dani";
    };
    meta.license = [ lib.licenses.mit ];
  };
  asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "asvetliakov";
      name = "vscode-neovim";
      version = "0.0.83";
      sha256 = "1giybf12p0h0fm950w9bwvzdk77771zfkylrqs9h0lhbdzr92qbl";
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
      version = "0.2.0";
      sha256 = "0xbikwlrascmn9nzyl4fxb2ql1dczd00ragp30a3yv8bax173bnz";
    };
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
      version = "0.3.0";
      sha256 = "1x80s8l8djchg17553aiwaf4b49hf6awiayk49wyii0i26hlpjk1";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  betterthantomorrow.calva = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "betterthantomorrow";
      name = "calva";
      version = "2.0.243";
      sha256 = "1kcrf95fgk9jppaal9sxwcwi0sws2kbyhdif55gka8s9mqzw9yc0";
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
  bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bradlc";
      name = "vscode-tailwindcss";
      version = "0.7.7";
      sha256 = "08ghx6y5rxfnzxlpb623gb70qhiwa3dqgmy8zac1ywh4nwmi64x9";
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
      version = "1.2.1";
      sha256 = "0n2xd2rm5i5slnn9sh9rsd73ij5bdddncaqy05h6iqa9mf81mxpg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "christian-kohler";
      name = "path-intellisense";
      version = "2.8.0";
      sha256 = "04vardis9k6yzaha5hhhv16c3z6np48adih46xj88y83ipvg5z2l";
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
      version = "0.2.2";
      sha256 = "0zcbs7h801agfs2cggk1cz8m8j0i2ypmgznkgw17lcx3zisll9ad";
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
      version = "4.6.0";
      sha256 = "0s18zzm6b16fa4mgyvc88crikxnfhg7gacni26cxmcr7w9dwmc5p";
    };
  };
  davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "davidanson";
      name = "vscode-markdownlint";
      version = "0.46.0";
      sha256 = "1jgdw548in4vnqqqzvhkxwz9ph28r8r3cy0bs18znr77lzxw8nyq";
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
  dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dbaeumer";
      name = "vscode-eslint";
      version = "2.2.3";
      sha256 = "0sl9d85wbac3h79a5y5mcv0rhcz8azcamyiiyix0b7klcr80v56d";
    };
    meta.license = [ lib.licenses.mit ];
  };
  denoland.vscode-deno = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "denoland";
      name = "vscode-deno";
      version = "3.10.1";
      sha256 = "0cxz75190a3z59lvkmghcbkyvlj86xjr0hqlhx1yl886zjsv9gwa";
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
      version = "0.0.2";
      sha256 = "0rdh7b5s7ynsyfrq1r1170g65q9vvvfl3qbfvbh1b38ndvj2f0yq";
    };
  };
  divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "divyanshuagrawal";
      name = "competitive-programming-helper";
      version = "5.9.1";
      sha256 = "00pj8ldv84g020z7gsaxj9gxpja1m8vl9yxhxr7w587cbz3wg1gk";
    };
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
      version = "2.24.1";
      sha256 = "1lg038s2y3vygwcs47y37gp9dxd8zfvy6yfxi85zzl0lf8iynl1b";
    };
    meta.license = [ lib.licenses.mit ];
  };
  eamodio.gitlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "eamodio";
      name = "gitlens";
      version = "11.7.0";
      sha256 = "0apjjlfdwljqih394ggz2d8m599pyyjrb0b4cfcz83601b7hk3x6";
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
      version = "0.3.24";
      sha256 = "1wj7wz81i26qrdh5jnbq85lwllkqg32qf500h7n0ar9jwwnlq1sy";
    };
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
      version = "2.1.82";
      sha256 = "1pvsf6mscmi1zi0ak71wwbqxkcfrdhdadg78yznxc0vlwa3hs11x";
    };
    meta.license = [ lib.licenses.mit ];
  };
  esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "esbenp";
      name = "prettier-vscode";
      version = "9.2.0";
      sha256 = "1ci17xm6mpxsbdazh0qgqk8c7h2v8ajy45d2mcslcc8gcgbkgqj4";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ethansk.restore-terminals = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ethansk";
      name = "restore-terminals";
      version = "1.1.6";
      sha256 = "1j58sia9s89p43rgcnjic6lygihs452ahzw4wjygq9y82nk32a2w";
    };
  };
  evzen-wybitul.magic-racket = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "evzen-wybitul";
      name = "magic-racket";
      version = "0.6.3";
      sha256 = "0jzkcr7pg98kzcvfknka1pbnpd2z4x8w2ijc7icx5g539zjwa5bf";
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
      version = "0.17.4";
      sha256 = "11jhx4hm10i3drap7n2v24j1y0r5ihzvb8dd5s802nfc49i1fg3k";
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
      version = "0.11.7";
      sha256 = "0a0sha6qml6fqnaaba6qmp58rvr82v5jfjlqwhh1cyadbjaz3cjn";
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
  github.copilot = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "github";
      name = "copilot";
      version = "1.7.5067";
      sha256 = "0w776r53dr2gvy2rics992lb0ql2nml7a1z9vb6s716cv4a7gzy4";
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
      version = "0.37.2022021709";
      sha256 = "0jc4nmy18wnlsrkvqzgp33rmls84g2d734cbh2rw373h0zi9hmfs";
    };
    meta.license = [ lib.licenses.mit ];
  };
  golang.go = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "golang";
      name = "go";
      version = "0.31.1";
      sha256 = "1x25x2dxcmi7h1q19qjxgnvdfzhsicq6sf6qig8jc0wg98g0gxry";
    };
    meta.license = [ lib.licenses.mit ];
  };
  graphql.vscode-graphql = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "graphql";
      name = "vscode-graphql";
      version = "0.3.50";
      sha256 = "1yf6v2vsgmq86ysb6vxzbg2gh6vz03fsz0d0rhpvpghayrjlk5az";
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
  hashicorp.terraform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "hashicorp";
      name = "terraform";
      version = "2.19.0";
      sha256 = "0imyddsk2hv68xqasbj1mprp66rpzarlmbq8jcqksbw4kc8drxwk";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  haskell.haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "haskell";
      name = "haskell";
      version = "1.8.0";
      sha256 = "0yzcibigxlvh6ilba1jpri2irsjnvyy74vzn3rydcywfc17ifkzs";
    };
    meta.license = [ lib.licenses.mit ];
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
  humao.rest-client = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "humao";
      name = "rest-client";
      version = "0.24.6";
      sha256 = "196pm7gv0488bpv1lklh8hpwmdqc4yimz389gad6nsna368m4m43";
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
  influxdata.flux = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "influxdata";
      name = "flux";
      version = "1.0.1";
      sha256 = "0bqkf1mp0294q8p2qakbqshqxfc6l7f1c2y0nzy1c42sddgd64y2";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ionide";
      name = "ionide-fsharp";
      version = "5.11.0";
      sha256 = "1z1xq3w43vj0rwrg2awn1gcn1w703g65408yfy47m7ic9pc0c4ih";
    };
  };
  jakebecker.elixir-ls = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jakebecker";
      name = "elixir-ls";
      version = "0.9.0";
      sha256 = "1qz8jxpzanaccd5v68z4v1344kw0iy671ksi1bmpyavinlxdkmr8";
    };
    meta.license = [ lib.licenses.mit ];
  };
  james-yu.latex-workshop = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "james-yu";
      name = "latex-workshop";
      version = "8.23.0";
      sha256 = "1rlw3ys6kwq46jc26iirpriwvrkmxs62mxi2arcn1y72wh1fqwi0";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jdinhlife";
      name = "gruvbox";
      version = "1.5.1";
      sha256 = "0bxwkqf73y0mlb59gy3rfps0k5fyj1yqhifidjvdaswn9z84226j";
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
  jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jnoortheen";
      name = "nix-ide";
      version = "0.1.19";
      sha256 = "1ms96ij6z4bysdhqgdaxx2znvczyhzx57iifbqws50m1c3m7pkx7";
    };
    meta.license = [ lib.licenses.mit ];
  };
  jock.svg = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jock";
      name = "svg";
      version = "1.4.17";
      sha256 = "1qlmcd8qrkpdabbrwq1l50f363awig63jakfqhf6l33jhkyn2g08";
    };
    meta.license = [ lib.licenses.mit ];
  };
  johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "johnpapa";
      name = "vscode-peacock";
      version = "4.0.0";
      sha256 = "1i65w70f0kikah1cx7m0bji6qd800jabfci0xisdqxyzaksg7ysz";
    };
  };
  justusadam.language-haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "justusadam";
      name = "language-haskell";
      version = "3.4.0";
      sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
    };
    meta.license = [ lib.licenses.bsd3 ];
  };
  kahole.magit = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kahole";
      name = "magit";
      version = "0.6.26";
      sha256 = "1ianzapb9jyhhwx6w5czqg41l6q3cb2jijg8bpnv7a2rbb3v54m1";
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
  kamikillerto.vscode-colorize = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kamikillerto";
      name = "vscode-colorize";
      version = "0.11.1";
      sha256 = "1h82b1jz86k2qznprng5066afinkrd7j3738a56idqr3vvvqnbsm";
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
      version = "0.1.15";
      sha256 = "0skasnc490wp0l5xzpdmwdzjr4qiy63kg2qi27060m5yqkq3h8xn";
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
      version = "1.11.0";
      sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
    };
    meta.license = [ lib.licenses.mit ];
  };
  matklad.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "matklad";
      name = "rust-analyzer";
      version = "0.3.939";
      sha256 = "19sk7bsrm5apfdji7gv5irzv404mh3v3jync41ka1dm0jh726zi8";
    };
    meta.license = [ lib.licenses.mit lib.licenses.asl20 ];
  };
  mechatroner.rainbow-csv = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mechatroner";
      name = "rainbow-csv";
      version = "2.0.0";
      sha256 = "0wjlp6lah9jb0646sbi6x305idfgydb6a51pgw4wdnni02gipbrs";
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
  ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-azuretools";
      name = "vscode-docker";
      version = "1.19.0";
      sha256 = "0qg4k5ivwa54i9f5ls1a0wl7blpymaq03dakdvvzallarip01qkf";
    };
  };
  ms-ceintl.vscode-language-pack-cs = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-cs";
      version = "1.64.7";
      sha256 = "1p1xxsa8cif3zqlwymbqyrfyc2gnihczagr44jdcl5ml0lfhmcx0";
    };
  };
  ms-ceintl.vscode-language-pack-de = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-de";
      version = "1.64.7";
      sha256 = "0cdg4q1xl3958s09jgz1yw89df5n5h10p1w1m1f1198sh1v44jy1";
    };
  };
  ms-ceintl.vscode-language-pack-es = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-es";
      version = "1.64.7";
      sha256 = "0gl1bk1dffhb38p5a0i6pyqliiclxhp1aj0wp5zsdijx5jbs5rdi";
    };
  };
  ms-ceintl.vscode-language-pack-fr = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-fr";
      version = "1.64.7";
      sha256 = "1wrlxpdqcp07ib31jbihiq6f3hcnh1aa9gkn9z9h0l74g9zljcps";
    };
  };
  ms-ceintl.vscode-language-pack-it = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-it";
      version = "1.64.7";
      sha256 = "103n16drjdn1inf9rbvhg45sys701l66qb6qryqs8d8sfx1i34rg";
    };
  };
  ms-ceintl.vscode-language-pack-ja = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-ja";
      version = "1.64.7";
      sha256 = "0ws7al9xvgk8zy8yqgkqmrqigs4x52syb59y1jsdjjll15khzz6x";
    };
  };
  ms-ceintl.vscode-language-pack-ko = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-ko";
      version = "1.64.7";
      sha256 = "03c221inbd7dzj219yv6g42akx5ylk77461lihcq4rmk4zb46aa7";
    };
  };
  ms-ceintl.vscode-language-pack-pt-br = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-pt-br";
      version = "1.64.7";
      sha256 = "1jbgi4215crqnngp6wjwwa99kinqpnhcz8z0qhyd4dh5bqcxcj10";
    };
  };
  ms-ceintl.vscode-language-pack-qps-ploc = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-qps-ploc";
      version = "1.64.7";
      sha256 = "0kbzvjkgidnk1k4y98b6zzbxj3n72f8damghyxyskcp6lngc8ndc";
    };
  };
  ms-ceintl.vscode-language-pack-ru = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-ru";
      version = "1.64.7";
      sha256 = "1ykxi8jclfcp31hy2s6ryy9qm5m4cmqns37yw6vafnp771ybpyv4";
    };
  };
  ms-ceintl.vscode-language-pack-tr = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-tr";
      version = "1.64.7";
      sha256 = "038lp9974r0k43ghv1i0jilaafjlihby4z6fphwwmlw6spl12rxc";
    };
  };
  ms-ceintl.vscode-language-pack-zh-hans = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-zh-hans";
      version = "1.64.7";
      sha256 = "0mrkkg9b69ramj4vfx45f318xn3iq205rk3h0hivycqyqc9mln5a";
    };
  };
  ms-ceintl.vscode-language-pack-zh-hant = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-ceintl";
      name = "vscode-language-pack-zh-hant";
      version = "1.64.7";
      sha256 = "016xz4dw6jw973dd3wxdj70vdjkpan5a6qf89991qv71q0hpwkkv";
    };
  };
  ms-dotnettools.csharp = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-dotnettools";
      name = "csharp";
      version = "1.24.0";
      sha256 = "07jnj05cjfs6yq28vf107r2iq9xz1y7hi83nm4x481l6nmn4nbx9";
    };
  };
  ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-kubernetes-tools";
      name = "vscode-kubernetes-tools";
      version = "1.3.6";
      sha256 = "0rdjh9hyjdwivnqkqdhxrpma5b41094acw1bk4bsidl9jnagggii";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-pyright.pyright = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-pyright";
      name = "pyright";
      version = "1.1.222";
      sha256 = "0wfm4aa1cm3hf7grg423ni32zc9pmz4q7vjsqnsp24h3mi4zzia0";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-python.python = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-python";
      name = "python";
      version = "2022.0.1814523869";
      sha256 = "0nc5s7xg8gl7b4llz3jy9xj2mg0qvcb9ldshp138y3llqfcs4di4";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-python";
      name = "vscode-pylance";
      version = "2022.2.3";
      sha256 = "01csiyr4wc0z4ppfnn0k5higzamg5rmkfxhk5ip4id966ipbfbdl";
    };
  };
  ms-toolsai.jupyter = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-toolsai";
      name = "jupyter";
      version = "2022.2.1010501003";
      sha256 = "0q90yvc8z2y1sslm41yyp1vmkn4cb4ckhk5bm8xb21102xzvc48k";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-toolsai";
      name = "jupyter-renderers";
      version = "1.0.6";
      sha256 = "0sb3ngpl4skylbmz7zbj7s79xala29wrgn1c3m4agp00ixz451fq";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-vscode-remote.remote-ssh = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode-remote";
      name = "remote-ssh";
      version = "0.75.2022021903";
      sha256 = "1kxkkbyjw9b3999fq561c230ymfv7k8i46ccy8gyzz2lpq0nzyib";
    };
  };
  ms-vscode.anycode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode";
      name = "anycode";
      version = "0.0.57";
      sha256 = "0fwhnp0xkg8p62xhizh7s8rvmfjirvbna0wjqyrrwr7hxcizn0jz";
    };
  };
  ms-vscode.cpptools = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vscode";
      name = "cpptools";
      version = "1.9.0";
      sha256 = "09xzb01z7nbz9sdh1433vkga4sh18dbyz77yis4xbh6msv5b2qh2";
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
  ms-vsliveshare.vsliveshare = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vsliveshare";
      name = "vsliveshare";
      version = "1.0.5330";
      sha256 = "18sdbd1df09q0b6b5nn8vbh2qaa17ngplgq2rbns11lw11m98jyn";
    };
  };
  msjsdiag.debugger-for-chrome = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "msjsdiag";
      name = "debugger-for-chrome";
      version = "4.13.0";
      sha256 = "0r6l804dyinqfk012bmaynv73f07kgnvvxf74nc83pw61vvk5jk9";
    };
  };
  mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mskelton";
      name = "one-dark-theme";
      version = "1.14.2";
      sha256 = "1bsk9qxvln17imy9g1j3cfghcq9g762d529iskr91fysyq81ywpa";
    };
  };
  mvllow.rose-pine = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mvllow";
      name = "rose-pine";
      version = "2.0.0";
      sha256 = "1wq1i6gmczgrjdgy7s1gmby8kyvnj7ck0ig2hfrar91fwk3acngq";
    };
    meta.license = [ lib.licenses.mit ];
  };
  naumovs.color-highlight = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "naumovs";
      name = "color-highlight";
      version = "2.5.0";
      sha256 = "0ri1rylg0r9r1kdc67815gjlq5fwnb26xpyziva6a40brrbh70vm";
    };
  };
  ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ocamllabs";
      name = "ocaml-platform";
      version = "1.9.3";
      sha256 = "1aynga6xm2ri2rlry1dxdzhg513yaykmv3cdqm82z3nbj3bnh1jg";
    };
    meta.license = [ lib.licenses.mit ];
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
      version = "8.2.2";
      sha256 = "1xxljwh66f21fzmhw8icrmxxmfww1s67kf5ja65a8qb1x1rhjjgf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  pkief.material-icon-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-icon-theme";
      version = "4.13.0";
      sha256 = "0b5z08v34q10xlbjbb5sn3zdwq6bflhd96z3dqsiakywhrsxi0jm";
    };
  };
  pkief.material-product-icons = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-product-icons";
      version = "1.1.2";
      sha256 = "1g2m75mzfd8rdv5r17wy61598vrhr55wh4y9vd8al5fpx55kiar8";
    };
  };
  redhat.java = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "java";
      version = "1.3.0";
      sha256 = "1ybd52za6gaqdry9r9c189iahwicwbkmhl14diqc21mx3bylz633";
    };
    meta.license = [ lib.licenses.epl20 ];
  };
  redhat.vscode-yaml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "vscode-yaml";
      version = "1.4.0";
      sha256 = "19a7ii4zrwcqb331jx78h7qpz8a4ar1w77k7nw43mcczx9gkb7sa";
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
  ritwickdey.liveserver = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ritwickdey";
      name = "liveserver";
      version = "5.7.4";
      sha256 = "18xggd12fq6yyfd5827c0a73j4mq8fd7npbv3ycdf9cr3gbgljby";
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
  rubymaniac.vscode-paste-and-indent = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rubymaniac";
      name = "vscode-paste-and-indent";
      version = "0.0.8";
      sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
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
      version = "1.12.25";
      sha256 = "0hvqkq0wggckglnirlix9wvbd76d2aa0qxzy8gcfc777agrzw4dw";
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
      version = "17.7.0";
      sha256 = "1k3jd01zd6my1nnn3a05rw9vmcz0y1drx7mb6nyw315szifyzx6q";
    };
  };
  streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "streetsidesoftware";
      name = "code-spell-checker";
      version = "2.1.7";
      sha256 = "11lfc87h76bk2z8n9jrrnl4mfl4ajih1cnp1y53m4ay1h06dhj0b";
    };
  };
  styled-components.vscode-styled-components = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "styled-components";
      name = "vscode-styled-components";
      version = "1.7.2";
      sha256 = "184d3bjncrgkqf6d5n33xx7chlllwxwp5ysh6pw9mi0daky6fk22";
    };
    meta.license = [ lib.licenses.mit ];
  };
  svelte.svelte-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "svelte";
      name = "svelte-vscode";
      version = "105.12.1";
      sha256 = "0w2qpg5v0hxdb8v20lhbnn2mkrin2p02pia6hi3kxzxz5df7gghq";
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
      version = "3.5.25";
      sha256 = "14rxlbxqzz9sg1737lhddiy5ii0yr4q68lmknrgvx3any6m7n3lc";
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
      version = "0.14.2";
      sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
    };
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
      version = "0.18.8";
      sha256 = "1r67rd8cxrf43z25f7wpp85jdmkpgki61kxp5r5dcpnrp51a3lvd";
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
      version = "0.39.0";
      sha256 = "09whzp8qhha3l67vamvhs0j76jy1c6mjhw1ccqwsllavhn3rbwig";
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
      version = "3.4.1";
      sha256 = "1mr8si7jglpjw8qzl4af1k7r68vz03fpal1dr8i0iy4ly26pz7bh";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vadimcn.vscode-lldb = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vadimcn";
      name = "vscode-lldb";
      version = "1.6.10";
      sha256 = "1q3d99l57spkln4cgwx28300d9711kc77mkyp4y968g3zyrmar88";
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
  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vscodevim";
      name = "vim";
      version = "1.22.2";
      sha256 = "1d85dwlnfgn7d32ivza0bv1zf9bh36fx7gbi586dligkw202blkn";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vspacecode.vspacecode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vspacecode";
      name = "vspacecode";
      version = "0.10.7";
      sha256 = "1m2fjnid355n5y6bj4x4k0hk9wkl00fac0xiwr6kr8dpw2jpf5qf";
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
  wholroyd.jinja = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wholroyd";
      name = "jinja";
      version = "0.0.8";
      sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
    };
    meta.license = [ lib.licenses.mit ];
  };
  wix.vscode-import-cost = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wix";
      name = "vscode-import-cost";
      version = "2.15.0";
      sha256 = "0d3b6654cdck1syn74vmmd1jmgkrw5v4c4cyrhdxbhggkip732bc";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xadillax.viml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xadillax";
      name = "viml";
      version = "1.0.1";
      sha256 = "0zc0pi68f7lsir1jzzdr914w0ybzv9j2lwn8il7niglv2hygcdwv";
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
      version = "3.4.0";
      sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "zhuangtongfa";
      name = "material-theme";
      version = "3.13.20";
      sha256 = "0jmw8f012mqzbaivz219l4k879sishjac5475fxi93j5gip3sa80";
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
